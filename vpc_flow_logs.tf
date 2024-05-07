#-------------------------------------------------------------------------------
# Turn on flow logs for the VPC.
#-------------------------------------------------------------------------------
module "vpc_flow_logs" {
  source  = "trussworks/vpc-flow-logs/aws"
  version = "~>2.0"
  providers = {
    aws = aws.userservicesprovisionaccount
  }

  logs_retention = "365"
  vpc_id         = aws_vpc.userservices.id
  vpc_name       = "userservices"
}
