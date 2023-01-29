variable "kind_cluster_name" {
  description = "The name of the cluster"
  type = string
  default = "local-stack"
}

variable "kind_cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
  default     = "~/.kube/config"
}

variable "wait_for_ready" {
  description = "Wait for the cluster to be ready before proceeding"
  type = bool
  default = true
}

variable "k8s_namespaces" {
  type = map(list(string))
} # Declaring variable k8s_namespaces with type map and list of strings
