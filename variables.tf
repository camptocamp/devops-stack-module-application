#######################
## Standard variables
#######################

variable "argocd_namespace" {
  description = "Namespace used by Argo CD where the Application and AppProject resources should be created."
  type        = string
}

variable "helm_values" {
  description = "Helm values, passed as a list of HCL structures. These values are concatenated with the default ones and then passed to the application's charts."
  type        = any
  default     = []
}

variable "dependency_ids" {
  description = "IDs of the other modules on which this module depends on."
  type        = map(string)

  default = {}
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
  description = "Path for the application's chart in the source repository."
  type        = string
}

variable "source_target_revision" {
  description = "Git target revision for the application chart."
  type        = string
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
