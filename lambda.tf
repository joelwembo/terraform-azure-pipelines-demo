resource "aws_lambda_permission" "apigw_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:ap-southeast-1:059978233428:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.hello_world.http_method}${aws_api_gateway_resource.hello_world.path}"
  statement_id  = "AllowExecutionFromAPIGateway"
}

resource "aws_lambda_function" "lambda" {
  filename         = "${path.module}/lambda.zip"
  function_name    = "hello_world"
  role             = "${aws_iam_role.role.arn}"
  handler          = "lambda.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = "${filebase64sha256("${path.module}/lambda.zip")}"
}

resource "aws_iam_role" "role" {
  name = "LambdaRole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
