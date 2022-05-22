variable "access_tier" {
  type        = string
  description = "The access tier for the storage account, e.g hot"
}

variable "account_tier" {
  type        = string
  description = "The account tier of the storage account"
  default     = "Standard"
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Whether nested blobs can be set to public from a private top level container"
  default     = false
}

variable "container_delete_retention_policy" {
  type        = map(any)
  description = "Are container delete retention policies needed? set variable to with a non empty value to use"
  default     = {}
}

variable "custom_domain" {
  type        = map(any)
  description = "Are customs domain needed? set variable to with a non empty value to use"
  default     = {}
}

variable "customer_managed_key" {
  type        = map(any)
  description = "Are customer managed needed? set variable to with a non empty value to use"
  default     = {}
}

variable "delete_retention_policy" {
  type        = map(any)
  description = "Are delete retention policies needed? set variable to with a non empty value to use"
  default     = {}
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Whether only HTTPS traffic is allowed"
  default     = true
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Whether key vault access policy or Azure rbac is used, default is false as the key vault access policy is the default behavior for this module"
  default     = false
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Enable this keyvault for template deployments access"
  default     = true
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "If this keyvault is enabled for disk encryption"
  default     = true
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "If this keyvault is enabled for ARM template deployments"
  default     = true
}

variable "full_certificate_permissions" {
  type        = list(string)
  description = "All the available permissions for key access"
  default = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]
}

variable "full_key_permissions" {
  type        = list(string)
  description = "All the available permissions for key access"
  default = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]
}

variable "full_secret_permissions" {
  type        = list(string)
  description = "All the available permissions for key access"
  default = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]
}

variable "full_storage_permissions" {
  type        = list(string)
  description = "All the available permissions for key access"
  default = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]
}

variable "give_current_client_full_access" {
  type        = bool
  description = "If you use your current client as the tenant id, do you wish to give it full access to the keyvault? this aids automation, and is thus enable by default for this module.  Disable for better security by setting to false"
  default     = true
}

variable "give_sa_full_access_to_kv" {
  type        = bool
  description = "If you are using a SystemAssigned identity on the storage account, do you want to give it full access to the key vault"
  default     = true
}

variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned to the VM."
  type        = list(string)
  default     = []
}

variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = ""
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "Whether infrastructure encryption is enabled, default is false"
  default     = false
}

variable "is_hns_enabled" {
  type        = bool
  description = "Whehter HNS is enabled or not, default is false"
  default     = false
}

variable "kv_name" {
  type        = string
  description = "The name of the keyvault"
}

variable "large_file_share_enabled" {
  type        = bool
  description = "Whether large file transfers are enabled for storage account, default is false"
  default     = false
}

variable "location" {
  description = "The location for this resource to be put in"
  type        = string
}

variable "min_tls_version" {
  type        = string
  description = "The minimum TLS version for the storage account, default is TLS1_2"
  default     = "TLS1_2"
}

variable "network_rules" {
  type        = map(any)
  description = "Are network rules needed? set variable to with a non empty value to use"
  default     = {}
}

variable "nfsv3_enabled" {
  type        = bool
  description = "Whether nfsv3 is enabled, default is false"
  default     = "false"
}

variable "purge_protection_enabled" {
  type        = bool
  description = "If purge protection is enabled, for automation, it is recomended to be disabled so you can delete it, but for security, it should be enabled.  defaults to false to"
  default     = false
}

variable "queue_encryption_key_type" {
  type        = string
  description = "The type of queue encryption key, default is Service"
  default     = "Service"
}

variable "regenerate_keys_automatically" {
  type        = bool
  description = "Whether storage keys should be regenerated automatically"
  default     = true
}

variable "regeneration_period" {
  type        = string
  description = "ISO 8601 time date format, default is every 30 days"
  default     = "P30D"
}

variable "replication_type" {
  type        = string
  description = "The replication type for the storage account"
  default     = "LRS"
}

variable "retention_policy" {
  type        = map(any)
  description = "Are retention policy settings needed? set variable to with a non empty value to use"
  default     = {}
}

variable "rg_name" {
  description = "The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists"
  type        = string
  validation {
    condition     = length(var.rg_name) > 1 && length(var.rg_name) <= 24
    error_message = "Resource group name is not valid."
  }
}

variable "settings" {
  type        = any
  description = "A map used for the settings blocks"
  default     = {}
}

variable "share_properties" {
  type        = map(any)
  description = "Are share properties settings needed? set variable to with a non empty value to use"
  default     = {}
}

variable "shared_access_keys_enabled" {
  type        = bool
  description = "Whether shared access keys a.k.a storage keys are enabled"
  default     = true
}

variable "sku_name" {
  type        = string
  description = "The sku of your keyvault, defaults to standard"
  default     = "Standard"
}

variable "smb" {
  type        = map(any)
  description = "Are smb settings needed? set variable to with a non empty value to use"
  default     = {}
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days for soft delete, defaults to 7 the minimum"
  default     = 7
}

variable "storage_account_key_to_regenerate" {
  type        = string
  description = "The key to be regenerated, either key1 or key2"
  default     = "key1"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"
}

variable "storage_account_properties" {
  type        = any
  description = "Variable used my module to export dynamic block values"
}

variable "table_encryption_key_type" {
  type        = string
  description = "The type of table encryption key, default is Service"
  default     = "Service"
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}

variable "tenant_id" {
  type        = string
  description = "If you are not using current client_config, set tenant id here"
  default     = null
}

variable "use_current_client" {
  type        = bool
  description = "If you wish to use the current client config or not"
}
