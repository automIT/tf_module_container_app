# Modul: container_app

Legt eine Azure Container App mit Ingress an. Optional werden Dateien (z.B. eine `index.html`)
aus Terraform-Variablen in den Container gemountet.

Die Dateien werden als Secrets der App angelegt und über ein Secret-Volume an den angegebenen
Pfad gemountet. Ändert sich ein Dateiinhalt, erzeugt das Modul automatisch eine neue Revision.

Benötigt den Provider `azurerm` ab Version 4.18 (`volume_mounts.sub_path`).

## Verwendung

```hcl
module "containerapp_nginx" {
  source = "git::https://dev.azure.com/automITde/training/_git/tf_module_container_app?ref=1.0.1"

  ca_name                      = "autws15-nginx"
  resource_group_name          = data.azurerm_resource_group.rg.name
  container_app_environment_id = data.azurerm_container_app_environment.cae.id
  container_image              = "nginx:latest"

  mounted_files = [
    {
      path    = "/usr/share/nginx/html/index.html"
      content = var.welcome_html
    }
  ]
}
```

## Inputs

| Name | Typ | Default | Beschreibung |
|------|-----|---------|--------------|
| `ca_name` | string | – | Name der App (Kleinbuchstaben, Ziffern, `-`, max. 32 Zeichen) |
| `resource_group_name` | string | – | Resourcegruppe |
| `container_app_environment_id` | string | – | ID des Container App Environments |
| `container_image` | string | – | Container Image |
| `container_name` | string | `"main"` | Name des Containers |
| `cpu` | number | `0.25` | CPU pro Replica |
| `memory` | string | `"0.5Gi"` | Speicher pro Replica |
| `min_replicas` | number | `0` | Minimale Anzahl Replicas |
| `max_replicas` | number | `1` | Maximale Anzahl Replicas |
| `target_port` | number | `80` | Port des Containers |
| `external_enabled` | bool | `true` | Ingress aus dem Internet erreichbar |
| `env_vars` | list(object) | `[]` | `name` + `value` |
| `mounted_files` | list(object) | `[]` | `path` (Dateipfad im Container) + `content` |
| `tags` | map(string) | `{}` | Tags |

## Outputs

| Name | Beschreibung |
|------|--------------|
| `id` | ID der App |
| `name` | Name der App |
| `url` | URL der App |
