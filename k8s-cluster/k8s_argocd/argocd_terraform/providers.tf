terraform {
  required_version = ">= 1.6.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"   # 2.x con soporte completo de atomic/cleanup_on_fail
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"   # 2.x estable
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
