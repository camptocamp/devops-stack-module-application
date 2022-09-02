#######################
## Standard variables
#######################

variable "argocd_namespace" {
  type = string
}

variable "helm_values" {
  description = "Helm values, passed as a list of HCL structures."
  type        = any
  default     = []
}

variable "dependency_ids" {
  type = map(string)

  default = {}
}

#######################
## Module variables
#######################

variable "name" {
  description = "Name to give the to the AppProject and Application"
  type        = string
}

variable "source_repo" {
  description = "Repository where the application chart is located"
  type        = string
}

variable "source_repo_path" {
  description = "Path for the application charts in the source repository"
  type        = string
}

variable "source_target_revision" {
  description = "Git target revision for the application"
  type        = string
}

variable "destination_namespace" {
  description = "Namespace where the application will be deployed"
  type        = string
  default     = null
}

variable "project_cluster_resource_whitelist" {
  description = "Cluster-scoped resources allowed to be managed by the project applications"
  type = list(object({
    group = string
    kind = string
  }))
  default = [
    {
      group = "*" # Kubernetes API groups such as /api/v1, /certificates.k8s.io/v1, /authentication.k8s.io/v1, etc.
      kind  = "*" # Kubernetes Kinds/Object Schemas such as Pod, ConfigMap, DaemonSet, etc.
    }
  ]
}

variable "project_namespace_resource_whitelist" {
  description = "Namespaced-scoped resources allowed to be managed by the project applications"
  type = list(object({
    group = string
    kind = string
  }))
  default = [
    {
      group = "*" # Kubernetes API groups such as /api/v1, /certificates.k8s.io/v1, /authentication.k8s.io/v1, etc.
      kind  = "*" # Kubernetes Kinds/Object Schemas such as Pod, ConfigMap, DaemonSet, etc.
    }
  ]
}
