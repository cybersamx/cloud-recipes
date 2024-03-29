# ICMP Security Group

Sometimes you need to have this security group to allow incoming ICMP (ping) for testing. This example shows the settings.

This recipe produces the following resources and functions:

* A ICMP security group.

**NOTE: This Terraform module creates resources on AWS, which you will be charged. Don't forget to remove the resources by running `terraform destroy` after you are done.**

## Setup
   
1. Run Terraform.

   ```bash
   $ terraform init
   $ terraform apply
   ```

## Reference

* [Terraform: aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
* [ICMP Parameters](https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml)
