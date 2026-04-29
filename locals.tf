# ------------------------------------------------------------------------------
# Retrieve the effective Account ID, User ID, and ARN in which Terraform is
# authorized.  This is used to calculate the session names for assumed roles.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# Retrieve the caller identity for the User Services provider in order to
# get the associated Account ID.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "userservices" {
  provider = aws.userservicesprovisionaccount
}

# ------------------------------------------------------------------------------
# Retrieve the information for all accounts in the organization.  This is used
# to lookup the Users account ID for use in the assume role policy.
# ------------------------------------------------------------------------------
data "aws_organizations_organization" "cool" {
  provider = aws.organizationsreadonly
}

# ------------------------------------------------------------------------------
# Evaluate expressions for use throughout this configuration.
# ------------------------------------------------------------------------------
locals {
  # Extract the user name of the current caller for use
  # as assume role session names.
  caller_user_name = split("/", data.aws_caller_identity.current.arn)[1]

  # The ID of the Transit Gateway in the Shared Services account.
  transit_gateway_id = data.terraform_remote_state.sharedservices_networking.outputs.transit_gateway.id

  # The User Services account ID
  userservices_account_id = data.aws_caller_identity.userservices.account_id

  # Regex to match dynamic assessment account names
  assessment_account_name_regex = "^env[[:digit:]]+$"

  # Build a map of dynamic assessment account IDs whose account names match our
  # regex
  env_accounts = {
    for account in data.aws_organizations_organization.cool.non_master_accounts :
    account.id => account.name
    if length(regexall(local.assessment_account_name_regex, account.name)) > 0
  }

  # Find the Users account by name.
  users_account_id = [
    for x in data.aws_organizations_organization.cool.accounts :
    x.id if x.name == "Users"
  ][0]
}
