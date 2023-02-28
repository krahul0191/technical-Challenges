variable "resource_group_name" {
  type = string
  //default = "provision-scripts"
  description = "please provide the resurce group name where vm is available"
}

variable "instance_name" {
  type = string
  //default = "vmtestdemo001"
  description = "please provide the vm name"
}

variable "api_provider" {
  type        = string
  default     = "Microsoft.Compute/virtualMachines@2021-03-01"
  description = "please provide the vm api"
}