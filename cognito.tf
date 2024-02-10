resource "aws_cognito_user_pool" "user_pool" {
  name = "livestore"
  # tags = "${var.tags}"
}

resource "aws_cognito_resource_server" "resource_server" {
  name         = "livestore"
  identifier   = "https://api.prodxcloud.net"
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"

  scope {
    scope_name        = "all"
    scope_description = "Get access to all API Gateway endpoints."
  }
}

# resource "aws_acm_certificate" "cert" {
#   domain_name       = "prodxcloud.net"
#   validation_method = "DNS"
#   # zone_id             = "Z06625562WOVJG5T2CYVV"


#   tags = {
#     Environment = "test"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_cognito_user_pool_domain" "domain" {
  domain          = "api.prodxcloud.net"
  certificate_arn = "arn:aws:acm:us-east-1:059978233428:certificate/c09a0cc4-26fd-4d22-a471-664e267c6759"
  user_pool_id    = "${aws_cognito_user_pool.user_pool.id}"
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "livestore"
  user_pool_id                         = "${aws_cognito_user_pool.user_pool.id}"
  generate_secret                      = true
  allowed_oauth_flows                  = ["client_credentials"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "username"]

  depends_on = [
    "aws_cognito_user_pool.user_pool",
    "aws_cognito_resource_server.resource_server",
  ]
}
