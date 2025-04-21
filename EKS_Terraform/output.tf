output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.devopsshack_aks.id
}

output "aks_kube_config" {
  description = "Kube config to connect to the AKS cluster"
  value       = azurerm_kubernetes_cluster.devopsshack_aks.kube_config_raw
  sensitive   = true
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.devopsshack_rg.name
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.devopsshack_vnet.id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = [for subnet in azurerm_subnet.devopsshack_subnet : subnet.id]
}

