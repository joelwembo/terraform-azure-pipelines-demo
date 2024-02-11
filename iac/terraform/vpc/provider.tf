terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }
  backend "s3" {
    # Bucket is commented because it has been configured in pipeline.
    # Bsaed on master/develop branch different buckets would be referenced.
    # bucket         = "terraform-fcom-euc1-dev"
    key    = "vpc/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}