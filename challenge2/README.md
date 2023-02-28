Challenge#2
=========

Get the Metadata of the Instance in the Azure

Getting started
---------------

Terraform module "instance-metadata" will be used to query the metadata of the azure instance.


## Prerequisites and Steps to use the module.

Prerequisites
-------------------------
1. Terraform cli
2. Azure CLI
3. Azure Cloud
4. Azure required permission 

-------------------------
Steps
-------------------------
1. Clone the git repo on your local system
2. Move to Challenge2 folder.
3. Authenticate with Azure via az Login.
4. provide the variables value in the main.tf file.
5. Run terraform init command
6. Run terraform plan command
7. Run terraform apply command and confirm yes when it prompt for confirmation.

output
-------------------------
On successful execution of the above steps, it will print the json output of the instance metadata.
Also a particular data key can be retrieved individually.
