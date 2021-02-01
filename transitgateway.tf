# ------------------------------------------------------------------------------
# Attach VPC to the Transit Gateway in the Shared Services account
# (see https://github.com/cisagov/cool-sharedservices-networking).
#
# Note that this attachment will be automatically accepted as long
# as the Transit Gateway was set up with:
#  auto_accept_shared_attachments = "enable"
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_vpc_attachment" "userservices" {
  provider = aws.userservicesprovisionaccount

  subnet_ids         = [for subnet in module.private.subnets : subnet.id]
  tags               = var.tags
  transit_gateway_id = local.transit_gateway_id
  vpc_id             = aws_vpc.userservices.id
}

# Add a route to the User Services VPC in the TGW default route table
resource "aws_ec2_transit_gateway_route" "userservices_route" {
  provider = aws.sharedservicesprovisionaccount

  destination_cidr_block         = aws_vpc.userservices.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.userservices.id
  transit_gateway_route_table_id = local.transit_gateway_default_route_table_id
}
