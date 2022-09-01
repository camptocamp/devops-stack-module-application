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
  description = "Argo CD Project and Application name"
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
  default     = "null"
}

# TODO Add variables to customize the cluster whitelist and namespace blacklist