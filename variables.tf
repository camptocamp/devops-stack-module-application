#######################
## Standard variables
#######################

variable "helm_values" {
  description = "Helm values, passed as a list of HCL structures. These values are concatenated with the default ones and then passed to the application's charts."
  type        = any
  default     = []
}

variable "app_autosync" {
  description = "Automated sync options for the Argo CD Application resource."
  type = object({
    allow_empty = optional(bool)
    prune       = optional(bool)
    self_heal   = optional(bool)
  })
  default = {
    allow_empty = false
    prune       = true
    self_heal   = true
  }
}

variable "dependency_ids" {
  description = "IDs of the other modules on which this module depends on."
  type        = map(string)
  default     = {}
}

#######################
## Module variables
#######################

variable "name" {
  description = "Name to give the to the AppProject and Application."
  type        = string
}

variable "source_repo" {
  description = "Repository where to retrieve the application's chart."
  type        = string
}

variable "source_repo_path" {
  description = "Path for the application's chart in the source repository. Use this if the `source_repo` is a Git repository. If you are using a Helm repository, use `source_chart` instead."
  type        = string
  default     = null

  validation {
    condition     = (var.source_repo_path != null) != (var.source_chart != null)
    error_message = "You must provide either 'source_repo_path' or 'source_chart' variable (not both, not neither)."
  }
}

variable "source_chart" {
  description = "Name of the chart to use in the source repository. Use this if the `source_repo` is a Helm repository. If you are using a Git repository, use `source_repo_path` instead."
  type        = string
  default     = null

}

variable "source_target_revision" {
  description = "Git target revision for the application chart."
  type        = string
}

variable "project_dest_cluster_name" {
  description = "Allowed destination cluster *name* in the AppProject."
  type        = string
  default     = "in-cluster"
}

variable "project_dest_cluster_address" {
  description = "Allowed destination cluster *address* in the AppProject. If you define this variable, any value passed in the `project_dest_cluster_name` variable is ignored."
  type        = string
  default     = null
}

variable "destination_namespace" {
  description = "Namespace where the application will be deployed. By default it is the same as the application's name defined by `var.name`. We use a ternary operator to conditionally define the Namespace only if it is defined on the module's instantiation: `namespace = var.destination_namespace == null ? var.name : var.destination_namespace`."
  type        = string
  default     = null
}

variable "project_cluster_resource_whitelist" {
  description = "Cluster-scoped resources allowed to be deployed in the Argo CD AppProject created by the module. The *`group`* must be a Kubernetes API group such as `core` or `apps` and the *`kind`* must be a Kubernetes Kinds/Object Schemas such as `Namespace` or `ClusterRole` (note that only resources like these ones are compatible with this setting, the other resources are only Namespace-scoped). You can see the API Groups https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.25/#-strong-api-groups-strong[here]."
  type = list(object({
    group = string
    kind  = string
  }))
  default = [
    {
      group = "*"
      kind  = "*"
    }
  ]
}

variable "project_namespace_resource_whitelist" {
  description = "Namespace-scoped resources allowed to be deployed in the Argo CD AppProject created by the module. The *`group`* must be a Kubernetes API group such as `core` or `apps` and the *`kind`* must be a Kubernetes Kinds/Object Schemas such as `Pod`, `ConfigMap`, `DaemonSet`, `Deployment`, etc. You can see the API Groups https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.25/#-strong-api-groups-strong[here]."
  type = list(object({
    group = string
    kind  = string
  }))
  default = [
    {
      group = "*"
      kind  = "*"
    }
  ]
}

variable "source_credentials_https" {
  description = "Credentials to connect to a private repository. Use this variable when connecting through HTTPS. You'll need to provide the the `username` and `password` values. If the TLS certificate for the HTTPS connection is not issued by a qualified CA, you can set `https_insecure` as true."
  type = object({
    username       = string
    password       = string
    https_insecure = optional(bool, false)
  })
  default = null
}

variable "source_credentials_ssh_key" {
  description = "Credentials to connect to a private repository. Use this variable when connecting to a repository through SSH."
  type        = string
  default     = null
}
