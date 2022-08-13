variable "subcription_name" {
  type        = string
  description = "Main Subscription for deployments"

  validation {
    condition     = var.subcription_name == "EliteSolutionsIT-DEV"
    error_message = "Please choose a valid subscription."
  }
}

variable "env" {
  type        = string
  description = "Tier for deployments"

  validation {
    condition     = lower(var.env) == var.env
    error_message = "Please tiers must all be in lower case."
  }
}

variable "agent_name" {
  type = string
}

variable "agent_count" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "key_data" {
  type = string
}

variable "resource_group_name" {
  type = string
}


variable "service_principal" {
  type = list(object({
    client_id     = string
    client_secret = string
  }))
}

variable "network_profile" {
  type = list(object({
    load_balancer_sku = string
    network_plugin    = string
  }))
}