variable "environment" {
  description = "Deployment environment (e.g. dev, prd)"
  type        = string
  default     = "dev"
}

variable "workload_name" {
  description = "Name of the workload as defined in platform-workloads state"
  type        = string
  default     = "platform-registry"
}

variable "location" {
  description = "Primary Azure region for resources"
  type        = string
  default     = "uksouth"
}

variable "subscription_id" {
  description = "Subscription to deploy resources into"
  type        = string
}

variable "platform_workloads_state" {
  description = "Backend config for platform-workloads remote state"
  type = object({
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    key                  = string
    subscription_id      = string
    tenant_id            = string
  })
}

variable "acr_sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "acr_consumers" {
  description = "External consumers that need access to the container registry, resolved by managed identity display name."
  type = list(object({
    workload      = string
    identity_name = string
    role          = string
  }))
  default = []
}

variable "workload_acr_consumers" {
  description = "Identities granted repository-scoped access to the ABAC-enabled workload image registry."
  type = list(object({
    name          = string
    identity_name = string
    role          = string
    repository    = string
    match         = optional(string, "exact")
  }))
  default = []

  validation {
    condition = alltrue([
      for consumer in var.workload_acr_consumers :
      contains([
        "Container Registry Repository Reader",
        "Container Registry Repository Writer",
      ], consumer.role)
    ])
    error_message = "Workload registry consumers must use a repository reader or writer role."
  }

  validation {
    condition = alltrue([
      for consumer in var.workload_acr_consumers :
      contains(["exact", "prefix"], consumer.match)
    ])
    error_message = "Workload registry consumer matching must be exact or prefix."
  }

  validation {
    condition = alltrue([
      for consumer in var.workload_acr_consumers :
      can(regex("^[a-z0-9]+(?:[._-][a-z0-9]+)*(?:/[a-z0-9]+(?:[._-][a-z0-9]+)*)*/?$", consumer.repository))
    ])
    error_message = "Workload registry repositories must use lowercase ACR repository names or prefixes."
  }
}

variable "tags" {
  description = "Optional resource tags"
  type        = map(string)
  default     = {}
}
