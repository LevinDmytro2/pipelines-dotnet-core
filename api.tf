resource "aws_api_gateway_rest_api" "lseg-api01" {
  name = "lseg-api02"
}

resource "aws_api_gateway_resource" "example" {
  parent_id   = aws_api_gateway_rest_api.lseg-api01.root_resource_id
  path_part   = "api-path01"
  rest_api_id = aws_api_gateway_rest_api.lseg-api01.id
}

resource "aws_api_gateway_method" "lseg-api-method01" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.lseg-api01.id
}

resource "aws_api_gateway_integration" "example" {
  http_method = aws_api_gateway_method.lseg-api-method01.http_method
  resource_id = aws_api_gateway_resource.example.id
  rest_api_id = aws_api_gateway_rest_api.lseg-api01.id
  type        = "MOCK"
}