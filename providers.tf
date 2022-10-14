terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "4.28.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      "Automated-Shutdown-Enabled" = "true",
      "ThroughputTesting"          = "true",
      "Environment"                = "splunk"
    }
  }
}