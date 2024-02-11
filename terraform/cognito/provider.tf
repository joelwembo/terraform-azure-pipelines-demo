terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }
  

    backend "remote" {  
    hostname="app.terraform.io"  
    token = "kbrAiDdnwCKEYg.atlasv1.9COhLimGMbbyuQVLFk2ZT7ezuIZ63UfaXl6DsUCTtD9ISmWLHnDk02Vt68DcACPY7W4"
    organization = "prodxcloud" 
    workspaces {
      prefix = "prodxcloud-" 
    }
  }
  
}

provider "aws" {
  region = "ap-southeast-1"
}