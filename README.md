# cool-userservices-networking #

[![GitHub Build Status](https://github.com/cisagov/cool-userservices-networking/workflows/build/badge.svg)](https://github.com/cisagov/cool-userservices-networking/actions)

This is a Terraform deployment for creating the VPC, public subnets,
and private subnets for the COOL User Services account.

Until this project moves to Terraform 0.13, there is [no `depends_on`
support for modules](https://github.com/hashicorp/terraform/issues/17101),
and we have no way to ensure that the `ProvisionNetworking` policy is attached
to the `ProvisionAccount` role before Terraform attempts to instantiate
the subnet modules.  Therefore, in order to apply this Terraform code,
one must run a targeted apply before running a full apply:

```console
terraform apply -var-file=<workspace>.tfvars -target=aws_iam_role_policy_attachment.provisionnetworking_policy_attachment -target=aws_iam_policy.provisionnetworking_policy
```

At this point the `ProvisionNetworking` policy is attached to the
`ProvisionAccount` role and you can run a full `terraform apply`.

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system.
- An accessible AWS S3 bucket to store Terraform state
  (specified in [backend.tf](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified in [backend.tf](backend.tf)).
- Access to all of the Terraform remote states specified in
  [remote_states.tf](remote_states.tf).

## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 3.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| aws.organizationsreadonly | ~> 3.0 |
| aws.sharedservicesprovisionaccount | ~> 3.0 |
| aws.terraformprovisionaccount | ~> 3.0 |
| aws.users | ~> 3.0 |
| aws.userservicesprovisionaccount | ~> 3.0 |
| terraform | n/a |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| assume_read_terraform_state_policy_description | The description to associate with the IAM policy that allows assumption of the role that allows read-only access to Terraform state for cool-userservices-networking. | `string` | `Allow assumption of the ReadUserServicesNetworkingTerraformState role in the Terraform account.` | no |
| assume_read_terraform_state_policy_name | The name to assign the IAM policy that allows assumption of the role that allows read-only access to Terraform state for cool-userservices-networking. | `string` | `AssumeReadUserServicesNetworkingTerraformState` | no |
| aws_region | The AWS region to deploy into (e.g. us-east-1) | `string` | `us-east-1` | no |
| cool_cidr_block | The overall CIDR block associated with the COOL (e.g. "10.128.0.0/9"). | `string` | n/a | yes |
| private_subnet_cidr_blocks | The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  This list must be the same length as public_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| provisionnetworking_policy_description | The description to associate with the IAM policy that allows provisioning of the networking layer in the User Services account. | `string` | `Allows provisioning of the networking layer in the User Services account.` | no |
| provisionnetworking_policy_name | The name to assign the IAM policy that allows provisioning of the networking layer in the User Services account. | `string` | `ProvisionNetworking` | no |
| public_subnet_cidr_blocks | The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  This list must be the same length as private_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| read_terraform_state_role_description | The description to associate with the IAM role (as well as the corresponding policy) that allows read-only access to the cool-userservices-networking state in the S3 bucket where Terraform state is stored. | `string` | `Allows read-only access to the cool-userservices-networking state in the S3 bucket where Terraform state is stored.` | no |
| read_terraform_state_role_name | The name to assign the IAM role (as well as the corresponding policy) that allows read-only access to the cool-userservices-networking state in the S3 bucket where Terraform state is stored. | `string` | `ReadUserServicesNetworkingTerraformState` | no |
| tags | Tags to apply to all AWS resources created | `map(string)` | `{}` | no |
| vpc_cidr_block | The overall CIDR block to be associated with the VPC (e.g. "10.10.0.0/16"). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| assume_read_terraform_state_role_policy | The policy that allows assumption of the role that allows read-only access to the cool-userservices-networking state in the Terraform state bucket. |
| private_subnet_nat_gws | The NAT gateways used in the private subnets in the VPC. |
| private_subnets | The private subnets in the VPC. |
| public_subnets | The public subnets in the VPC. |
| read_terraform_state_role | The role that allows read-only access to the cool-userservices-networking state in the Terraform state bucket. |
| vpc | The User Services VPC. |

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, this is just the main directory.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
