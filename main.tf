locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service          = "devOps"
    Owner            = "elitesolutionsit"
    environment      = var.env
    ManagedWith      = "terraform"
    subcription_name = var.subcription_name
  }
}

data "azurerm_resource_group" "k8s" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  for_each = var.k8s

  name                = each.key
  location            = data.azurerm_resource_group.k8s.location
  resource_group_name = data.azurerm_resource_group.k8s.name
  dns_prefix          = each.value["dns_prefix"]

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = var.key_data
    }
  }

  default_node_pool {
    name       = var.agent_name
    node_count = var.agent_count
    vm_size    = var.vm_size
  }

  dynamic "service_principal" {
    for_each = var.service_principal
    content {
      client_id     = each.value["client_id"]
      client_secret = each.value["client_secret"]
    }
  }

  dynamic "network_profile" {
    for_each = var.network_profile
    content {
      load_balancer_sku = each.value["load_balancer_sku"]
      network_plugin    = each.value["network_plugin"]
    }
  }

  tags = local.common_tags
}
