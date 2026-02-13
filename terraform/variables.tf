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

variable "tags" {
  description = "Optional resource tags"
  type        = map(string)
  default     = {}
}
