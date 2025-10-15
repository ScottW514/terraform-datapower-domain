terraform {
  required_version = ">= 1.12.2"
  required_providers {
    datapower = {
      source  = "scottw514/datapower"
      version = ">= 0.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.7.2"
    }
  }
}

provider "datapower" {
  hostname = "datapower-dev"
  username = "admin"
  password = "admin"
  insecure = true
}
