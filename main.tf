terraform {
  required_version = ">= 0.11.11"
}

provider "google" {
  credentials = "${file("file.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

resource "google_container_cluster" "k8sexample" {
  name               = "tf-k8s-cluster"
  description        = "example k8s cluster"
  zone               = "${var.gcp_zone}"
  initial_node_count = "${var.initial_node_count}"
  enable_kubernetes_alpha = "true"
  enable_legacy_abac = "true"

  master_auth {
    username = "${var.master_username}"
    password = "${var.master_password}"

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  node_config {
    machine_type = "${var.node_machine_type}"
    disk_size_gb = "${var.node_disk_size}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}

resource "kubernetes_service_account" "helm_account" {
  depends_on = [
    "google_container_cluster.data-dome-cluster",
  ]
  metadata {
    name      = "${var.helm_account_name}"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "helm_role_binding" {
  metadata {
    name = "${kubernetes_service_account.helm_account.metadata.0.name}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.helm_account.metadata.0.name}"
    namespace = "kube-system"
  }
  provisioner "local-exec" {
    command = "sleep 15"
  }
}

provider "helm" {
  service_account = "${kubernetes_service_account.helm_account.metadata.0.name}"
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.helm_version}"
  #install_tiller = false # Temporary

  kubernetes {
    host                   = "${google_container_cluster.data-dome-cluster.endpoint}"
    token                  = "${data.google_client_config.current.access_token}"

    client_certificate     = "${base64decode(google_container_cluster.data-dome-cluster.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.data-dome-cluster.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.data-dome-cluster.master_auth.0.cluster_ca_certificate)}"
  }
}
