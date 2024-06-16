provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "base" {
  name             = "base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_version
  namespace        = "istio-system"
  lint             = true
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true

  values = [
      file("${path.module}/base/values.yaml")
  ]
}

resource "helm_release" "istiod" {
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = var.istio_version
  namespace        = "istio-system"
  lint             = true
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true

  values = [
      file("${path.module}/istiod/values.yaml")
  ]
}

resource "helm_release" "gateway" {
  name             = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = var.istio_version
  namespace        = "istio-system"
  timeout          = 900
  lint             = true
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true 

  values = [
      file("${path.module}/gateway/values.yaml")
  ]
}
