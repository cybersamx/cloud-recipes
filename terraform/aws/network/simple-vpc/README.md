# VPC

A simple recipe for creating a VPC in AWS.

This recipe produces the following resources and functions:

* A custom VPC with default configurations.

**NOTE: This Terraform module creates resources on AWS, which you will be charged. Don't forget to remove the resources by running `terraform destroy` after you are done.**

## Setup
   
1. Create a `terraform.tfvars` and enter the pertinent values.

   ```bash
   $ vi terraform.tfvars
   ```   
   
1. Run Terraform.

   ```bash
   $ terraform init
   $ terraform apply
   ```

## Reference

* [Terraform: aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
