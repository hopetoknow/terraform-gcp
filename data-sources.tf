data "aws_route53_zone" "primary" {
  name = var.aws_parameters.zone_name
}
