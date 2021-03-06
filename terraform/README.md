# Terraform

A handy reference and recipes on Terraform.

## Recipes

* Basics
  * Collection
    * [Clean up a list](basics/collection/clean-up) - Use distinct and compact to clean up a list.
    * [List to string](basics/collection/list-to-string) - Convert a list of strings to a string of the objects delimited by a comma.
    * [Map](basics/collection/map) - Create maps using the `{}` operator and the `map` function.
    * [Operator \[\] vs Element](basics/collection/operator-element) - The difference between the `[]` operator and  the`element` function.
  * If-Else
    * [If-Else conditional](basics/if-else) - Sample code that demonstrates how if-else statements are implemented in Terraform.  
  * Loop
    * [Count vs for vs for_each](basics/loop) - The 3 constructs `count`, `for`, and `for_each` for looping in Terraform.
    * [Iterate a map](basics/loop/for-map) - Loop through a map.
  * String
    * [Append to a string](basics/string/append) - Append a string to a string, the Terraform way.
    * [Formatting and interpolation](basics/string/format-n-interpolation) - Terraform string formatting and interpolation.
    * [Regex](basics/string/regex) - Regular expression in Terraform.
    * [Reverse a string](basics/string/reverse) - Reverses the characters in a string.
    * [Trim a string](basics/string/trim) - Ways to remove characters from the start/end of a string.
  * Variables
    * [Declaration](basics/variables/declaration) - Examples of how to declare variables of the most common used types in Terraform.
    * [Conversion](basics/variables/conversion) - Examples of converting types in Terraform.
    * [Validation](basics/variables/validation) - Examples of validating the values of variables. 
  * Utilities
    * [Random password generator](basics/utils/password-generator) - Random password generator.
    * [Trigger on file change](basics/utils/null_resource) - Trigger whenever a file content changes.
    * [Templatefile function](basics/utils/templatefile) - Examples of using the templatefile function, including a trick to differentiating a Terraform template variable from a shell variable.
* Tools
  * [Makefile](tools/makefile) - A sample Makefile for a Terraform project.    
* AWS
  * Network
    * [Simple VPC](aws/network/simple-vpc) - A simple recipe to create a VPC.
    * [Secondary CIDR blocks](aws/network/secondary-cidr-blocks) - A recipe to extend VPC IP address range.
    * [Public and private subnets](aws/network/public-private-subnets) - A recipe to create public/private subnets.
    * [Bastion](aws/network/bastion) - A recipe to bastion to connect to the private subnet in a VPC.
  * Security Group
    * [Simple](aws/security-group/simple) - A simple recipe to create a security group.  
    * [Dynamic](aws/security-group/dynamic) - A recipe that creates multiple rules in a security group using the `dynamic` block and a list.
    * [ICMP](aws/security-group/icmp) - An example of a security group that allows incoming ICMP echo (ping).
  * ECR
    * [Simple](aws/ecr/simple) - A simple recipe to create an ECR repository.          
  * EC2
    * [Simple](aws/ec2/simple) - A simple recipe to create an EC2 instance.
    * [Production](aws/ec2/production) - A recipe to create an EC2 instance in production.
    * [Cluster](aws/ec2/cluster) - A recipe to create a cluster of multiple EC2 instances.
    * [User-data](aws/ec2/user-data) - A recipe that uses the `templatefile` function to inject a startup script to configure the EC2 instance further during its creation.
* GCP
  * Network
    * [Simple VPC](gcp/network/simple-vpc) - A simple recipe to create a VPC.
    * [Shared VPC](gcp/network/shared-vpc) - A recipe to create a shared VPC.
    * [VPC for GKE](gcp/network/gke-network) - A recipe to create a VPC for hosting GKE clusters.
  * GCB
    * [Full Cloud Build](gcp/gcb/full) - A recipe to create a Cloud Build (GCB) trigger and proper IAM bindings to Secret Manager (secrets injection) and GCR/GCS (artifact storage).
  * GCE
    * [Simple](gcp/gce/simple) - A simple recipe to create an GCE instance.
    * [Startup script](gcp/gce/startup-script) - A recipe that uses the `templatefile` function to inject a startup script to configure the GCE instance further during its creation.
  * [GCR](gcp/gcr) - Push/pull Docker images to the private container repository on GCP.
    * [GCR with Access Control](gcp/gcr/access-control) - Explicitly create a GCR and binding it with IAM members with roles for access.
  * GKE
    * [Default node pool](gcp/gke/default-node-pool) - A recipe that creates a network and GKE with 1 default node pool.
    * [Preemptible zonal cluster](gcp/gke/preemptible-zonal-cluster) - A recipe that creates a preemptible GKE cluster in a single zone to save big $$$.    

## Reference

* [Terraform: Up & Running](https://www.oreilly.com/library/view/terraform-up/9781492046899/) by Yevgeniy Birkman
* [Terraform homepage](https://www.terraform.io/)
