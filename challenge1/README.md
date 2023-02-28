Challenge#1
=========

Create a 3-tier application resources in the azuzre cloud.

Getting started
---------------
mentioned Terraform modules will be used to perform above challenge.


Terraform modules.
-------------------------
1. azure-resource-group (to create the resurce group)

2. azure-vnet (to create azure virtual network and subnets)

3. azure-sql-database (to create the azure SQL Servers and SQL database with failover mechanism with the private endpoints)

4. azure-app-service (to create windows/linux app service plan and app services with vnet service endpoint and private endpoints.)

5. azure-traffic-manager (to create the azure traffic manager for the load balance)

Note
-------------------------
Terraform modules can be used to create azure resources separately or can be used all together. In order to use them all together please uncomment the module dependecies from the main.tf (at challenge root directory) file modules. 

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
2. Move to Challenge1 folder.
3. Authenticate with Azure via az login.
4. provide the variables values for the modules in the main.tf file.
5. Run terraform init command
6. Run terraform plan command
7. Run terraform apply command and confirm yes when it prompt for confirmation.


output
-------------------------
On successful execution of the above steps, it will provision the azure resource for the 3-tier application.
