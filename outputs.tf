output "private_subnet_nat_gws" {
  value       = aws_nat_gateway.nat_gws
  description = "The NAT gateways used in the private subnets in the VPC."
}

output "private_subnets" {
  value       = module.private.subnets
  description = "The private subnets in the VPC."
}

output "public_subnets" {
  value       = module.public.subnets
  description = "The public subnets in the VPC."
}

output "vpc" {
  value       = aws_vpc.userservices
  description = "The User Services VPC."
}
