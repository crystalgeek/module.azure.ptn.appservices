#Resource Group
output "resource_group_name" {
  value       = module.ptn_appservices.resource_group_name
  description = "The Name of the Resource Group."
}
output "resource_group_id" {
  value       = module.ptn_appservices.resource_group_id
  description = "The ID of the Resource Group."
}