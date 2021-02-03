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

  # Determine the env* accounts of the same type as this User Services account
  env_accounts_same_type = {
    for account in data.aws_organizations_organization.cool.accounts :
    account.id => account.name
    if length(regexall("env[0-9]+ \\((${local.userservices_account_type})\\)", account.name)) > 0
  }

  # Determine the PCA account of the same type as this User Services account
  pca_account_same_type = {
    for account in data.aws_organizations_organization.cool.accounts :
    account.id => account.name
    if length(regexall("PCA \\((${local.userservices_account_type})\\)", account.name)) > 0
  }

  # The User Services account ID
  userservices_account_id = data.aws_caller_identity.userservices.account_id

  # Look up User Services account name from AWS organizations
  # provider
  userservices_account_name = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.name
    if account.id == local.userservices_account_id
  ][0]

  # Determine User Services account type based on account name.
  #
  # The account name format is "ACCOUNT_NAME (ACCOUNT_TYPE)" - for
  # example, "User Services (Production)".
  userservices_account_type = length(regexall("\\(([^()]*)\\)", local.userservices_account_name)) == 1 ? regex("\\(([^()]*)\\)", local.userservices_account_name)[0] : "Unknown"
  workspace_type            = lower(local.userservices_account_type)

  # Find the Users account by name and email.
  users_account_id = [
    for x in data.aws_organizations_organization.cool.accounts :
    x.id if x.name == "Users" && length(regexall("2020", x.email)) > 0
  ][0]
}
