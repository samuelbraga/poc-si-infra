terraform {
  backend "s3" {}
  required_providers {
    local = {
      version = "~> 2.5.1"
    }
    aws = {}
    kubernetes = { 
      version = "~> 2.29.0"
    }
  }
}