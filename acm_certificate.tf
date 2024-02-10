module "aws_acm_certificate" {
  source              = "terraform-aws-modules/acm/aws"
  version             = "~> v1.0"
  domain_name         = "toplivecommerce.com"
  zone_id             = "Z06625562WOVJG5T2CYVV"
  wait_for_validation = true
  # tags                = "${var.tags}"
}


resource "aws_acm_certificate" "cert" {
  domain_name       = "toplivecommerce.com"
  validation_method = "DNS"
  # zone_id             = "Z06625562WOVJG5T2CYVV"


  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}