locals {
  # Jede Datei wird ein Secret, Secret-Namen duerfen nur a-z, 0-9 und '-' enthalten
  mounted_files = { for i, f in var.mounted_files : "file-${i}" => f }

  # Geaenderte Secrets landen erst mit einer neuen Revision im Container
  files_env_vars = length(var.mounted_files) > 0 ? [
    { name = "MOUNTED_FILES_MD5", value = md5(jsonencode(var.mounted_files)) }
  ] : []
}

resource "azurerm_container_app" "app" {
  name                         = var.ca_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  tags                         = var.tags

  dynamic "secret" {
    for_each = local.mounted_files
    content {
      name  = secret.key
      value = secret.value.content
    }
  }

  ingress {
    external_enabled = var.external_enabled
    target_port      = var.target_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    dynamic "volume" {
      for_each = length(local.mounted_files) > 0 ? [1] : []
      content {
        name         = "files"
        storage_type = "Secret"
      }
    }

    container {
      name   = var.container_name
      image  = var.container_image
      cpu    = var.cpu
      memory = var.memory

      dynamic "volume_mounts" {
        for_each = local.mounted_files
        content {
          name     = "files"
          path     = volume_mounts.value.path
          sub_path = volume_mounts.key
        }
      }

      dynamic "env" {
        for_each = concat(local.files_env_vars, var.env_vars)
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }
  }
}
