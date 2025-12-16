terraform {
  required_version = ">= 1.13.0"
  required_providers {
    datapower = {
      source  = "scottw514/datapower"
      version = ">= 0.16.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
