/******************
 * RESOURCE GROUP *
 ******************/
resource "azurerm_resource_group" "eliteclusterdemorg" {
  name     = "eliteclusterdemoaks"
  location = "eastu2"
}

/*********************
 * SERVICE PRINCIPAL *
 *********************/
resource "azuread_application" "eliteclusterdemodev" {
  display_name = "eliteclusterdemodev"
}

resource "azuread_service_principal" "eliteclusterdemodev-SP" {
  application_id = azuread_application.eliteclusterdemodev.application_id
}

resource "azuread_service_principal_password" "eliteclusterdemodev-SP" {
  service_principal_id = azuread_service_principal.eliteclusterdemodev-SP.id
}


module "aks" {
  source = "git::https://github.com/ArerepadeBenagha/elite-terraform-azurerm-aks.git?ref=main"

  k8s = {
    "eliteclusterdemodev" = { dns_prefix = "eliteclusterdns" }
  }

  subcription_name    = "EliteSolutionsIT-DEV"
  env                 = "dev"
  agent_name          = "devagent"
  agent_count         = "2"
  vm_size             = "Standard_D2_v2"
  admin_username      = "ubuntu"
  key_data            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL6wGT/0DGpqs2kco+A2ujK64PEHIO7Sw/wZc5GOiQlqx7lNYhHC+hJlcChb/g+Yzz/wVray/XR7uUadtYOk3PsUQx0gZykwx7oZHRSS6KFLwEtBl4vf84qMyOEM5EZ3CLcalE/MHwp8MJTUFqd239NfhJM6/40kTsB3TMIVEYfb1O3lbMB1qBD6yIskEPyZ1vc++S023m7O4X+ukzqmMG/oom+IpBN/pPO7Cp5yjGzzNtGbjCWtGMzE2J5Db+FlaAOEnLInHV76sUqPjsOIXLdCxDEFxzlbIjEDD6/JOmMgtKj48wehxRB4LjcU9XwanRwko4emYx+yf+IL7GpCstZRGENHkTeTxQ9vxuHi6q/hTHcc8AS5guZQK+JiCV5FOZIyM3FySzOJvCm4Z/lFiqcaYfhO5QZnqVQonZ4TA8XLAzXEB5ybmxedaZhcySe3CZAvo086bp4xtJpV0VhT9JAlPtYRdydK80CvWYMcyRtEwfOxsRuKj4bUQIEZdemQ8= lbena@LAPTOP-QB0DU4OG"
  resource_group_name = azurerm_resource_group.eliteclusterdemorg.name

  service_principal = [{
    client_id     = azuread_service_principal.eliteclusterdemodev-SP.application_id
    client_secret = azuread_service_principal_password.eliteclusterdemodev-SP.value
  }]

  network_profile = [{
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
  }]
}