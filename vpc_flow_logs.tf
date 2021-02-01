#-------------------------------------------------------------------------------
# Turn on flow logs for the VPC.
#-------------------------------------------------------------------------------
module "vpc_flow_logs" {
  source = "trussworks/vpc-flow-logs/aws"
  providers = {
    aws = aws.userservicesprovisionaccount
  }

  vpc_name       = "userservices"
  vpc_id         = aws_vpc.userservices.id
  logs_retention = "365"
}
