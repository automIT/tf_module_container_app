# Feste Trainings-Registry: Die Identity <resource_group_name>-uami legt der Trainer
# vorab an (tf-container_apps/infra) und berechtigt sie mit AcrPull auf der Registry.
locals {
  registry_server        = "automittraincapp.azurecr.io"
  registry_identity_name = "${var.resource_group_name}-uami"
}

data "azurerm_user_assigned_identity" "acr_pull" {
  name                = local.registry_identity_name
  resource_group_name = var.resource_group_name
}
