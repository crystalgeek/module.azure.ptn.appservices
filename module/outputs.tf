#Resource Group
output "resource_group_name" {
  value       = module.resource_group.name
  description = "The Name of the Resource Group."
}
output "resource_group_id" {
  value       = module.resource_group.resource_id
  description = "The ID of the Resource Group."
}