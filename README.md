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
| terraform | ~> 0.13.0 |
| aws | ~> 3.38 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.38 |
| aws.organizationsreadonly | ~> 3.38 |
| aws.sharedservicesprovisionaccount | ~> 3.38 |
| aws.userservicesprovisionaccount | ~> 3.38 |
| terraform | n/a |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| private | github.com/cisagov/distributed-subnets-tf-module | n/a |
| public | github.com/cisagov/distributed-subnets-tf-module | n/a |
| read\_terraform\_state | github.com/cisagov/terraform-state-read-role-tf-module | n/a |
| vpc\_flow\_logs | trussworks/vpc-flow-logs/aws | >=2.0.0, <2.1.0 |

## Resources ##

| Name | Type |
|------|------|
| [aws_default_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_ec2_transit_gateway_route.userservices_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.userservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.nat_gw_eips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_policy.provisionnetworking_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.provisionnetworking_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.userservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.cool_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.cool_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.external_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.external_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_route_table_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_vpc.userservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.userservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.provisionnetworking_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.cool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sharedservices](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sharedservices_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.terraform](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.users](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.userservices](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region to deploy into (e.g. us-east-1). | `string` | `"us-east-1"` | no |
| cool\_cidr\_block | The overall CIDR block associated with the COOL (e.g. "10.128.0.0/9"). | `string` | n/a | yes |
| private\_subnet\_cidr\_blocks | The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  This list must be the same length as public\_subnet\_cidr\_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| provisionnetworking\_policy\_description | The description to associate with the IAM policy that allows provisioning of the networking layer in the User Services account. | `string` | `"Allows provisioning of the networking layer in the User Services account."` | no |
| provisionnetworking\_policy\_name | The name to assign the IAM policy that allows provisioning of the networking layer in the User Services account. | `string` | `"ProvisionNetworking"` | no |
| public\_subnet\_cidr\_blocks | The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  This list must be the same length as private\_subnet\_cidr\_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| read\_terraform\_state\_role\_name | The name to assign the IAM role (as well as the corresponding policy) that allows read-only access to the cool-userservices-networking state in the S3 bucket where Terraform state is stored. | `string` | `"ReadUserServicesNetworkingTerraformState"` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| vpc\_cidr\_block | The overall CIDR block to be associated with the VPC (e.g. "10.10.0.0/16"). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| private\_subnet\_nat\_gws | The NAT gateways used in the private subnets in the VPC. |
| private\_subnets | The private subnets in the VPC. |
| public\_subnets | The public subnets in the VPC. |
| read\_terraform\_state | The IAM policies and role that allow read-only access to the cool-userservices-networking state in the Terraform state bucket. |
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
