output "assume_read_terraform_state_role_policy" {
  value       = aws_iam_policy.assume_read_terraform_state_role
  description = "The policy that allows assumption of the role that allows read-only access to the cool-userservices-networking state in the Terraform state bucket."
}

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

output "read_terraform_state_role" {
  value       = aws_iam_role.read_terraform_state
  description = "The role that allows read-only access to the cool-userservices-networking state in the Terraform state bucket."
}

output "vpc" {
  value       = aws_vpc.userservices
  description = "The User Services VPC."
}
