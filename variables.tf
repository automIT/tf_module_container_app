variable "ca_name" {
  description = "Name der Container App (nur Kleinbuchstaben, Ziffern und '-', max. 32 Zeichen)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}[a-z0-9]$", var.ca_name))
    error_message = "ca_name darf nur Kleinbuchstaben, Ziffern und '-' enthalten, muss mit einem Buchstaben beginnen und hoechstens 32 Zeichen lang sein."
  }
}

variable "resource_group_name" {
  description = "Resourcegruppe, in der die Container App angelegt wird"
  type        = string
}

variable "container_app_environment_id" {
  description = "ID des Container App Environments"
  type        = string
}

variable "container_image" {
  description = "Container Image, z.B. nginx:latest"
  type        = string
}

variable "container_name" {
  description = "Name des Containers"
  type        = string
  default     = "main"
}

variable "cpu" {
  description = "CPU-Kerne pro Replica"
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "Arbeitsspeicher pro Replica (muss zur CPU passen, z.B. 0.25 -> 0.5Gi)"
  type        = string
  default     = "0.5Gi"
}

variable "min_replicas" {
  type    = number
  default = 0
}

variable "max_replicas" {
  type    = number
  default = 1
}

variable "target_port" {
  description = "Port, auf dem der Container lauscht"
  type        = number
  default     = 80
}

variable "external_enabled" {
  description = "Ingress aus dem Internet erreichbar"
  type        = bool
  default     = true
}

variable "env_vars" {
  description = "Umgebungsvariablen"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "mounted_files" {
  description = "Dateien, die in den Container gemountet werden. path = absoluter Dateipfad im Container, content = Dateiinhalt"
  type = list(object({
    path    = string
    content = string
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
