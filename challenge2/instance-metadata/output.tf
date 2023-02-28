output "instance_metadata" {
  value = jsondecode(data.azapi_resource.instance_data.output)
}

output "instance_id" {
  value = jsondecode(data.azapi_resource.instance_data.output).properties.vmId
}

output "instance_hardwareProfile" {
  value = jsondecode(data.azapi_resource.instance_data.output).properties.hardwareProfile
}

output "instance_networkProfile" {
  value = jsondecode(data.azapi_resource.instance_data.output).properties.networkProfile
}

output "instance_osProfile" {
  value = jsondecode(data.azapi_resource.instance_data.output).properties.osProfile
}

output "instance_provisioningState" {
  value = jsondecode(data.azapi_resource.instance_data.output).properties.provisioningState
}

output "instance_storageProfile" {
  value = jsondecode(data.azapi_resource.instance_data.output).properties.storageProfile
}

output "instance_osType" {
  value = jsondecode(data.azapi_resource.instance_data.output).properties.storageProfile.osDisk.osType
}
