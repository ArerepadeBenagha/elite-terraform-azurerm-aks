Utilize this module to create multiple aks cluster and cluster pool.

## Module Example Usage

```hcl
module "aks" {
  source = "git::https://github.com/ArerepadeBenagha/elite-terraform-azurerm-aks.git?ref=main"

  k8s = {
    "eliteclusterdemodev" = { dns_prefix = "eliteclusterdns",
      client_id     = azuread_service_principal.eliteclusterdemodev-SP.application_id,
      client_secret = azuread_service_principal_password.eliteclusterdemodev-SP.value,
      load_balancer_sku = "standard", network_plugin = "kubenet" }

    "eliteclusterdemodev2" = { dns_prefix = "eliteclusterdns",
      client_id     = azuread_service_principal.eliteclusterdemodev-SP.application_id,
      client_secret = azuread_service_principal_password.eliteclusterdemodev-SP.value,
      load_balancer_sku = "standard", network_plugin = "kubenet" }
  }

  cluster_node_pool = {
    "eliteclusterdemodev-pool" = { vm_size = "Standard_DS2_v2", node_count = "1" }
  }
  subcription_name    = "EliteSolutionsIT-DEV"
  env                 = "dev"
  agent_name          = "devagent"
  agent_count         = "2"
  vm_size             = "Standard_D2_v2"
  admin_username      = "ubuntu"
  key_data            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDePsvhlzQd5giUS6tNQD65JmChBToxgvfrTJDeytpURBRGBxidoGYDgjcukv3qb+MR3Fqskp8ajcjRpXRbWqgnda7hWSJjhGHQL1AhtyeTocvpYGfNLqisFJyfdYW/V3UGcN4OqcMoXaYvVTcJk6zPkThT3AaKVg6O822mK9UIn7pG/1GBcuzQL9r8C6inss+d/NGzJuhwgkos1XVMCaJ5wiqfmPi/BqprkFk1Yklt74b2pjfDttgFeQ/iAMfW8Pm1BEjO8a5M2k52QEO/hKsxAYGakgjPtnVhKiqbAxT27Tl4YLhZKnJqzhaztFPXyf3S6ce0ixp1QmGRzH5XWClspmASh/tmdHyN0frPfma5bcgUJmDMAUAv4Xc+BC2Qvj2feYJ5swN8Swsxe+9agw/6KtwN5QkaZC5hI19rUs2PIh0go4QhFayDQjHkO66RxZe9fbVjjC1OAvoWJTXAzoz7RSn8omxW976Us7UgmcVBEmJy++Xu4GVU5aMJIPDuoEc= lbena@LAPTOP-QB0DU4OG"
  resource_group_name = azurerm_resource_group.eliteclusterdemorg.name

  service_principal = [{
    client_id     = azuread_service_principal.eliteclusterdemodev-SP.application_id
    client_secret = azuread_service_principal_password.eliteclusterdemodev-SP.value
  }]

  network_profile = [{
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
  }]

  depends_on = [azurerm_resource_group.eliteclusterdemorg, azuread_service_principal.eliteclusterdemodev-SP, azuread_service_principal_password.eliteclusterdemodev-SP]
}
```

## Documentation Reference
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool