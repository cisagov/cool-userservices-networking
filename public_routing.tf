#-------------------------------------------------------------------------------
# Set up routing in the VPC for the public subnets, which use the
# VPC's default routing table.
#
# The routing for the private subnets is configured in
# private_routing.tf.
# -------------------------------------------------------------------------------

# Default route table (used by public subnets)
resource "aws_default_route_table" "public" {
  provider = aws.userservicesprovisionaccount

  default_route_table_id = aws_vpc.userservices.default_route_table_id
}

# Route all non-local COOL (outside this VPC but inside the COOL)
# traffic through the transit gateway
resource "aws_route" "cool_route" {
  provider = aws.userservicesprovisionaccount

  route_table_id         = aws_default_route_table.public.id
  destination_cidr_block = var.cool_cidr_block
  transit_gateway_id     = local.transit_gateway_id
}

# Route all external (outside this VPC and outside the COOL) traffic
# through the internet gateway
resource "aws_route" "external_route" {
  provider = aws.userservicesprovisionaccount

  route_table_id         = aws_default_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.userservices.id
}
