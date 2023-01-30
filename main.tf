resource "null_resource" "dependencies" {
  triggers = var.dependency_ids
}

resource "argocd_repository" "private_https_repo" {
  # This count here is nothing more than a way to conditionally deploy this resource. Although there is no loop inside 
  # the resource, if the condition is true, the resource is deployed because there is exactly one iteration.
  count = (var.source_credentials_https.password != null && startswith(var.source_repo, "https://")) ? 1 : 0

  repo     = var.source_repo
  username = var.source_credentials_https.username
  password = var.source_credentials_https.password
  insecure = var.source_credentials_https.https_insecure
}

resource "argocd_repository" "private_ssh_repo" {
  # This count here is nothing more than a way to conditionally deploy this resource. Although there is no loop inside 
  # the resource, if the condition is true, the resource is deployed because there is exactly one iteration.
  count = (can(var.source_credentials_ssh_key) && startswith(var.source_repo, "git@")) ? 1 : 0

  repo            = var.source_repo
  username        = "git"
  ssh_private_key = var.source_credentials_ssh_key
}

resource "argocd_project" "this" {
  metadata {
    name      = var.name
    namespace = var.argocd_namespace
  }

  spec {
    description  = "${var.name} application project"
    source_repos = [var.source_repo] # This is a map because the definition of the project could accept multiple allowed repositories 

    destination {
      name      = "in-cluster"
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
    namespace = var.argocd_namespace
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
      target_revision = var.source_target_revision
      helm {
        values = data.utils_deep_merge_yaml.values.output
      }
    }

    destination {
      name      = "in-cluster"
      namespace = var.destination_namespace == null ? var.name : var.destination_namespace
    }

    sync_policy {
      automated = var.app_autosync

      retry {
        backoff = {
          duration     = ""
          max_duration = ""
        }
        limit = "0"
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
