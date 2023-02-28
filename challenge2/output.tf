#output variables to get the instance information
output "instance_metadata" {
  value = module.vm_metadata.instance_metadata
}

output "instance_id" {
  value = module.vm_metadata.instance_id
}

output "instance_hardwareProfile" {
  value = module.vm_metadata.instance_hardwareProfile
}

output "instance_networkProfile" {
  value = module.vm_metadata.instance_networkProfile
}

output "instance_osProfile" {
  value = module.vm_metadata.instance_osProfile
}

output "instance_provisioningState" {
  value = module.vm_metadata.instance_provisioningState
}

output "instance_storageProfile" {
  value = module.vm_metadata.instance_storageProfile
}

output "instance_osType" {
  value = module.vm_metadata.instance_osType
}