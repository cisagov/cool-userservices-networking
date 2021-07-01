#-------------------------------------------------------------------------------
# Create the User Services VPC.
#-------------------------------------------------------------------------------

resource "aws_vpc" "userservices" {
  provider = aws.userservicesprovisionaccount

  # We can't perform this action until our policy is in place, so we
  # need this dependency.  Since the other resources in this file
  # directly or indirectly depend on the VPC, making the VPC depend on
  # this resource should make the other resources in this file depend
  # on it as well.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
}

# The internet gateway for the VPC
resource "aws_internet_gateway" "userservices" {
  provider = aws.userservicesprovisionaccount

  vpc_id = aws_vpc.userservices.id
}
