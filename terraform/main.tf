provider "kind" {
}

resource "kind_cluster" "default" {
  name = "local-stack.dev"
  wait_for_ready = true

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      image = "kindest/node:v1.23.13"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }

    node {
      role = "worker"
      image = "kindest/node:v1.23.13"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.23.13"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.23.13"
    }
  }
}

data "kubectl_file_documents" "crds" {
  content = file("../olm/crds.yaml")
}

resource "kubectl_manifest" "crds_apply" {
  for_each  = data.kubectl_file_documents.crds.manifests
  yaml_body = each.value
  wait = true
  server_side_apply = true
}

data "kubectl_file_documents" "olm" {
  content = file("../olm/olm.yaml")
}

resource "kubectl_manifest" "olm_apply" {
  depends_on = [data.kubectl_file_documents.crds]
  for_each  = data.kubectl_file_documents.olm.manifests
  yaml_body = each.value
}

provider "kubectl" {
  host = "${kind_cluster.default.endpoint}"
  cluster_ca_certificate = "${kind_cluster.default.cluster_ca_certificate}"
  client_certificate = "${kind_cluster.default.client_certificate}"
  client_key = "${kind_cluster.default.client_key}"
}

provider "helm" {
  kubernetes {
    host = "${kind_cluster.default.endpoint}"
    cluster_ca_certificate = "${kind_cluster.default.cluster_ca_certificate}"
    client_certificate = "${kind_cluster.default.client_certificate}"
    client_key = "${kind_cluster.default.client_key}"
  }
}

resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.19.10"
  create_namespace = true

  values = [
    file("../argocd/application.yaml")
  ]
}
