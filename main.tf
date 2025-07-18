resource "null_resource" "dependencies" {
  triggers = var.dependency_ids
}

resource "argocd_repository" "private_https_repo" {
  count = (var.source_credentials_https != null && startswith(var.source_repo, "https://")) ? 1 : 0

  repo     = var.source_repo
  username = var.source_credentials_https.username
  password = var.source_credentials_https.password
  insecure = var.source_credentials_https.https_insecure
}

resource "argocd_repository" "private_ssh_repo" {
  count = (var.source_credentials_ssh_key != null && startswith(var.source_repo, "git@")) ? 1 : 0

  repo            = var.source_repo
  username        = "git"
  ssh_private_key = var.source_credentials_ssh_key
}

resource "argocd_project" "this" {
  metadata {
    name      = var.name
    namespace = "argocd"
  }

  spec {
    description  = "${var.name} application project"
    source_repos = [var.source_repo] # This is a map because the definition of the project could accept multiple allowed repositories

    # The destination block does not support having both `name` and `server` defined at the same time. For that reason,
    # we added the ternary operator below to test if the user provided a `project_dest_cluster_address` variable.
    destination {
      name      = var.project_dest_cluster_address == null ? var.project_dest_cluster_name : null
      server    = var.project_dest_cluster_address == null ? null : var.project_dest_cluster_address
      namespace = var.destination_namespace == null ? var.name : var.destination_namespace
    }

    orphaned_resources {
      warn = true
    }

    dynamic "cluster_resource_whitelist" {
      for_each = var.project_cluster_resource_whitelist
      content {
        group = cluster_resource_whitelist.value["group"]
        kind  = cluster_resource_whitelist.value["kind"]
      }
    }

    dynamic "namespace_resource_whitelist" {
      for_each = var.project_namespace_resource_whitelist
      content {
        group = namespace_resource_whitelist.value["group"]
        kind  = namespace_resource_whitelist.value["kind"]
      }
    }
  }
}

data "utils_deep_merge_yaml" "values" {
  input = [for i in concat(local.helm_values, var.helm_values) : yamlencode(i)]
}

resource "argocd_application" "this" {
  metadata {
    name      = var.name
    namespace = "argocd"
  }

  timeouts {
    create = "15m"
    delete = "15m"
  }

  wait = var.app_autosync == { "allow_empty" = tobool(null), "prune" = tobool(null), "self_heal" = tobool(null) } ? false : true

  spec {
    project = argocd_project.this.metadata.0.name

    source {
      repo_url        = var.source_repo
      path            = var.source_repo_path
      chart           = var.source_chart
      target_revision = var.source_target_revision
      helm {
        values = data.utils_deep_merge_yaml.values.output
      }
    }

    # The destination block does not support having both `name` and `server` defined at the same time. For that reason,
    # we added the ternary operator below to test if the user provided a `project_dest_cluster_address` variable.
    destination {
      name      = var.project_dest_cluster_address == null ? var.project_dest_cluster_name : null
      server    = var.project_dest_cluster_address == null ? null : var.project_dest_cluster_address
      namespace = var.destination_namespace == null ? var.name : var.destination_namespace
    }

    sync_policy {
      dynamic "automated" {
        for_each = toset(var.app_autosync == { "allow_empty" = tobool(null), "prune" = tobool(null), "self_heal" = tobool(null) } ? [] : [var.app_autosync])
        content {
          prune       = automated.value.prune
          self_heal   = automated.value.self_heal
          allow_empty = automated.value.allow_empty
        }
      }

      retry {
        backoff {
          duration     = "20s"
          max_duration = "2m"
          factor       = "2"
        }
        limit = "5"
      }

      sync_options = [
        "CreateNamespace=true"
      ]
    }
  }

  depends_on = [
    resource.null_resource.dependencies,
  ]
}

resource "null_resource" "this" {
  depends_on = [
    resource.argocd_application.this,
  ]
}
