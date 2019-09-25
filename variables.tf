variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
  default = "us-east1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-b (which must be in gcp_region)"
  default = "us-east1-b"
}

variable "gcp_project" {
  description = "GCP project name"
  default = "model-choir-253913"
}

variable "initial_node_count" {
  description = "Number of worker VMs to initially create"
  default = 2
}

variable "master_username" {
  description = "Username for accessing the Kubernetes master endpoint"
  default = "k8smaster"
}

variable "master_password" {
  description = "Password for accessing the Kubernetes master endpoint"
  default = "k8smasterk8smaster"
}

variable "node_machine_type" {
  description = "GCE machine type"
  default = "n1-standard-1"
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  default = "10"
}

variable "environment" {
  description = "value passed to Environment tag and used in name of Vault auth backend later"
  default = "gke-dev"
}

variable "helm_version" {
  default = "v2.9.1"
}

variable "app_name" {
  default = "drupal"
}


variable "acme_url" {
  default = "https://acme-v01.api.letsencrypt.org/directory"
}