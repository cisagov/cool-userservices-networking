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
