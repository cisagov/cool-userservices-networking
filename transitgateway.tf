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
  transit_gateway_id = local.transit_gateway_id
  vpc_id             = aws_vpc.userservices.id
}

# Add route to User Services VPC to the route tables of other accounts
# that may require it
resource "aws_ec2_transit_gateway_route" "userservices_routes" {
  provider = aws.sharedservicesprovisionaccount

  for_each = merge(local.env_accounts_same_type, local.pca_account_same_type)

  destination_cidr_block         = aws_vpc.userservices.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.userservices.id
  transit_gateway_route_table_id = data.terraform_remote_state.sharedservices_networking.outputs.transit_gateway_attachment_route_tables[each.key].id
}
