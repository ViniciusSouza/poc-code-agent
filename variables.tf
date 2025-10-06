variable "environment" {
  description = "The environment name (e.g., test, production)"
  type        = string
  default     = "test"
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
  default     = "eastus"
}
