# ------------------------------------------------------------------------------
# Attach to the ProvisionAccount role the IAM policy that allows
# provisioning of the networking layer in the User Services account.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "provisionnetworking_policy_attachment" {
  provider = aws.userservicesprovisionaccount

  policy_arn = aws_iam_policy.provisionnetworking_policy.arn
  role       = data.terraform_remote_state.userservices.outputs.provisionaccount_role.name
}
