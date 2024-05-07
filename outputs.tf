output "private_subnet_nat_gws" {
  description = "The NAT gateways used in the private subnets in the VPC."
  value       = aws_nat_gateway.nat_gws
}

output "private_subnets" {
  description = "The private subnets in the VPC."
  value       = module.private.subnets
}

output "public_subnets" {
  description = "The public subnets in the VPC."
  value       = module.public.subnets
}

output "read_terraform_state" {
  description = "The IAM policies and role that allow read-only access to the cool-userservices-networking state in the Terraform state bucket."
  value       = module.read_terraform_state
}

output "vpc" {
  description = "The User Services VPC."
  value       = aws_vpc.userservices
}
