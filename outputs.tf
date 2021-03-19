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

output "read_terraform_state" {
  value       = module.read_terraform_state
  description = "The IAM policies and role that allow read-only access to the cool-userservices-networking state in the Terraform state bucket."
}

output "vpc" {
  value       = aws_vpc.userservices
  description = "The User Services VPC."
}
