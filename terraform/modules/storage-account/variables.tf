variable "name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the storage account should be created"
  type        = string
}

variable "account_tier" {
  description = "The tier to use for this storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The type of replication to use for this storage account"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "The kind of storage account"
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "The access tier for BlobStorage and StorageV2 accounts"
  type        = string
  default     = "Hot"
}

variable "container_name" {
  description = "The name of the storage container"
  type        = string
  default     = "test-container"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
