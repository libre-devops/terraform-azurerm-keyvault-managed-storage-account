```hcl
module "rg" {
  source = "registry.terraform.io/libre-devops/rg/azurerm"

  rg_name  = "rg-${var.short}-${var.loc}-${terraform.workspace}-build" // rg-ldo-euw-dev-build
  location = local.location                                            // compares var.loc with the var.regions var to match a long-hand name, in this case, "euw", so "westeurope"
  tags     = local.tags

  #  lock_level = "CanNotDelete" // Do not set this value to skip lock
}

data "http" "user_ip" {
  url = "https://ipv4.icanhazip.com" // If running locally, running this block will fetch your outbound public IP of your home/office/ISP/VPN and add it.  It will add the hosted agent etc if running from Microsoft/GitLab
}

module "network" {
  source = "registry.terraform.io/libre-devops/network/azurerm"

  rg_name  = module.rg.rg_name // rg-ldo-euw-dev-build
  location = module.rg.rg_location
  tags     = local.tags

  vnet_name     = "vnet-${var.short}-${var.loc}-${terraform.workspace}-01" // vnet-ldo-euw-dev-01
  vnet_location = module.network.vnet_location

  address_space   = ["10.0.0.0/16"]
  subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names    = ["sn1-${module.network.vnet_name}", "sn2-${module.network.vnet_name}", "sn3-${module.network.vnet_name}"] //sn1-vnet-ldo-euw-dev-01
  subnet_service_endpoints = {
    "sn1-${module.network.vnet_name}" = ["Microsoft.Storage"]                   // Adds extra subnet endpoints to sn1-vnet-ldo-euw-dev-01
    "sn2-${module.network.vnet_name}" = ["Microsoft.Storage", "Microsoft.Sql"], // Adds extra subnet endpoints to sn2-vnet-ldo-euw-dev-01
    "sn3-${module.network.vnet_name}" = ["Microsoft.AzureActiveDirectory"]      // Adds extra subnet endpoints to sn3-vnet-ldo-euw-dev-01
  }
}

#tfsec:ignore:azure-keyvault-no-purge tfsec:ignore:azure-keyvault-specify-network-acl
module "kv_managed_sa" {
  source = "registry.terraform.io/libre-devops/keyvault-managed-storage-account/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  storage_account_name = "st${var.short}${var.loc}${terraform.workspace}01"
  access_tier          = "Hot"
  identity_type        = "SystemAssigned"

  kv_name                         = "kv-${var.short}-${var.loc}-${terraform.workspace}-01"
  use_current_client              = true
  give_current_client_full_access = true
  give_sa_full_access_to_kv       = true

  storage_account_properties = {

    // Set this block to enable network rules
    network_rules = {
      default_action = "Deny"
      bypass         = ["AzureServices", "Metrics", "Logging"]
      ip_rules       = [chomp(data.http.user_ip.body)]
      subnet_ids     = [element(values(module.network.subnets_ids), 0)]
    }

    blob_properties = {
      versioning_enabled       = false
      change_feed_enabled      = false
      default_service_version  = "2020-06-12"
      last_access_time_enabled = false

      deletion_retention_policies = {
        days = 10
      }

      container_delete_retention_policy = {
        days = 10
      }
    }

    routing = {
      publish_internet_endpoints  = false
      publish_microsoft_endpoints = true
      choice                      = "MicrosoftRouting"
    }
  }
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.client_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.sa_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_managed_storage_account.sa_kv_iam](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_managed_storage_account) | resource |
| [azurerm_role_assignment.sa_operator_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_client_config.current_client](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | The access tier for the storage account, e.g hot | `string` | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | The account tier of the storage account | `string` | `"Standard"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Whether nested blobs can be set to public from a private top level container | `bool` | `false` | no |
| <a name="input_azure_kv_object_id"></a> [azure\_kv\_object\_id](#input\_azure\_kv\_object\_id) | The object id for Azure Key Vault service in your tenant, the default for the Libre DevOps tenant is set as the default value, this may not be the same for you | `string` | `"2f52b87a-b032-421f-b0fb-3c8be030d053"` | no |
| <a name="input_container_delete_retention_policy"></a> [container\_delete\_retention\_policy](#input\_container\_delete\_retention\_policy) | Are container delete retention policies needed? set variable to with a non empty value to use | `map(any)` | `{}` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | Are customs domain needed? set variable to with a non empty value to use | `map(any)` | `{}` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | Are customer managed needed? set variable to with a non empty value to use | `map(any)` | `{}` | no |
| <a name="input_delete_retention_policy"></a> [delete\_retention\_policy](#input\_delete\_retention\_policy) | Are delete retention policies needed? set variable to with a non empty value to use | `map(any)` | `{}` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | Whether only HTTPS traffic is allowed | `bool` | `true` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Whether key vault access policy or Azure rbac is used, default is false as the key vault access policy is the default behavior for this module | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Enable this keyvault for template deployments access | `bool` | `true` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | If this keyvault is enabled for disk encryption | `bool` | `true` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | If this keyvault is enabled for ARM template deployments | `bool` | `true` | no |
| <a name="input_full_certificate_permissions"></a> [full\_certificate\_permissions](#input\_full\_certificate\_permissions) | All the available permissions for key access | `list(string)` | <pre>[<br>  "Backup",<br>  "Create",<br>  "Delete",<br>  "DeleteIssuers",<br>  "Get",<br>  "GetIssuers",<br>  "Import",<br>  "List",<br>  "ListIssuers",<br>  "ManageContacts",<br>  "ManageIssuers",<br>  "Purge",<br>  "Recover",<br>  "Restore",<br>  "SetIssuers",<br>  "Update"<br>]</pre> | no |
| <a name="input_full_key_permissions"></a> [full\_key\_permissions](#input\_full\_key\_permissions) | All the available permissions for key access | `list(string)` | <pre>[<br>  "Backup",<br>  "Create",<br>  "Decrypt",<br>  "Delete",<br>  "Encrypt",<br>  "Get",<br>  "Import",<br>  "List",<br>  "Purge",<br>  "Recover",<br>  "Restore",<br>  "Sign",<br>  "UnwrapKey",<br>  "Update",<br>  "Verify",<br>  "WrapKey"<br>]</pre> | no |
| <a name="input_full_secret_permissions"></a> [full\_secret\_permissions](#input\_full\_secret\_permissions) | All the available permissions for key access | `list(string)` | <pre>[<br>  "Backup",<br>  "Delete",<br>  "Get",<br>  "List",<br>  "Purge",<br>  "Recover",<br>  "Restore",<br>  "Set"<br>]</pre> | no |
| <a name="input_full_storage_permissions"></a> [full\_storage\_permissions](#input\_full\_storage\_permissions) | All the available permissions for key access | `list(string)` | <pre>[<br>  "Backup",<br>  "Delete",<br>  "DeleteSAS",<br>  "Get",<br>  "GetSAS",<br>  "List",<br>  "ListSAS",<br>  "Purge",<br>  "Recover",<br>  "RegenerateKey",<br>  "Restore",<br>  "Set",<br>  "SetSAS",<br>  "Update"<br>]</pre> | no |
| <a name="input_give_current_client_full_access"></a> [give\_current\_client\_full\_access](#input\_give\_current\_client\_full\_access) | If you use your current client as the tenant id, do you wish to give it full access to the keyvault? this aids automation, and is thus enable by default for this module.  Disable for better security by setting to false | `bool` | `true` | no |
| <a name="input_give_sa_full_access_to_kv"></a> [give\_sa\_full\_access\_to\_kv](#input\_give\_sa\_full\_access\_to\_kv) | If you are using a SystemAssigned identity on the storage account, do you want to give it full access to the key vault | `bool` | `true` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of user managed identity ids to be assigned to the VM. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The Managed Service Identity Type of this Virtual Machine. | `string` | `""` | no |
| <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled) | Whether infrastructure encryption is enabled, default is false | `bool` | `false` | no |
| <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled) | Whehter HNS is enabled or not, default is false | `bool` | `false` | no |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | The name of the keyvault | `string` | n/a | yes |
| <a name="input_large_file_share_enabled"></a> [large\_file\_share\_enabled](#input\_large\_file\_share\_enabled) | Whether large file transfers are enabled for storage account, default is false | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location for this resource to be put in | `string` | n/a | yes |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum TLS version for the storage account, default is TLS1\_2 | `string` | `"TLS1_2"` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | Are network rules needed? set variable to with a non empty value to use | `map(any)` | `{}` | no |
| <a name="input_nfsv3_enabled"></a> [nfsv3\_enabled](#input\_nfsv3\_enabled) | Whether nfsv3 is enabled, default is false | `bool` | `"false"` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | If purge protection is enabled, for automation, it is recomended to be disabled so you can delete it, but for security, it should be enabled.  defaults to false to | `bool` | `false` | no |
| <a name="input_queue_encryption_key_type"></a> [queue\_encryption\_key\_type](#input\_queue\_encryption\_key\_type) | The type of queue encryption key, default is Service | `string` | `"Service"` | no |
| <a name="input_regenerate_keys_automatically"></a> [regenerate\_keys\_automatically](#input\_regenerate\_keys\_automatically) | Whether storage keys should be regenerated automatically | `bool` | `true` | no |
| <a name="input_regeneration_period"></a> [regeneration\_period](#input\_regeneration\_period) | ISO 8601 time date format, default is every 30 days | `string` | `"P30D"` | no |
| <a name="input_replication_type"></a> [replication\_type](#input\_replication\_type) | The replication type for the storage account | `string` | `"LRS"` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | Are retention policy settings needed? set variable to with a non empty value to use | `map(any)` | `{}` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists | `string` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | A map used for the settings blocks | `any` | `{}` | no |
| <a name="input_share_properties"></a> [share\_properties](#input\_share\_properties) | Are share properties settings needed? set variable to with a non empty value to use | `map(any)` | `{}` | no |
| <a name="input_shared_access_keys_enabled"></a> [shared\_access\_keys\_enabled](#input\_shared\_access\_keys\_enabled) | Whether shared access keys a.k.a storage keys are enabled | `bool` | `true` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The sku of your keyvault, defaults to standard | `string` | `"Standard"` | no |
| <a name="input_smb"></a> [smb](#input\_smb) | Are smb settings needed? set variable to with a non empty value to use | `map(any)` | `{}` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days for soft delete, defaults to 7 the minimum | `number` | `7` | no |
| <a name="input_storage_account_key_to_regenerate"></a> [storage\_account\_key\_to\_regenerate](#input\_storage\_account\_key\_to\_regenerate) | The key to be regenerated, either key1 or key2 | `string` | `"key1"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the storage account | `string` | n/a | yes |
| <a name="input_storage_account_properties"></a> [storage\_account\_properties](#input\_storage\_account\_properties) | Variable used my module to export dynamic block values | `any` | n/a | yes |
| <a name="input_table_encryption_key_type"></a> [table\_encryption\_key\_type](#input\_table\_encryption\_key\_type) | The type of table encryption key, default is Service | `string` | `"Service"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of the tags to use on the resources that are deployed with this module. | `map(string)` | <pre>{<br>  "source": "terraform"<br>}</pre> | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | If you are not using current client\_config, set tenant id here | `string` | `null` | no |
| <a name="input_use_current_client"></a> [use\_current\_client](#input\_use\_current\_client) | If you wish to use the current client config or not | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_full_certificate_permissions"></a> [full\_certificate\_permissions](#output\_full\_certificate\_permissions) | Full permissions to the certificate permission set, used as a variable in the module |
| <a name="output_full_key_permissions"></a> [full\_key\_permissions](#output\_full\_key\_permissions) | Full permissions to the key permission set, used as a variable in the module |
| <a name="output_full_secret_permissions"></a> [full\_secret\_permissions](#output\_full\_secret\_permissions) | Full permissions to the secret permission set, used as a variable in the module |
| <a name="output_full_storage_permissions"></a> [full\_storage\_permissions](#output\_full\_storage\_permissions) | Full permissions to the storage permission set, used as a variable in the module |
| <a name="output_kv_id"></a> [kv\_id](#output\_kv\_id) | The id of the keyvault |
| <a name="output_kv_name"></a> [kv\_name](#output\_kv\_name) | The name of the keyvault |
| <a name="output_kv_tenant_id"></a> [kv\_tenant\_id](#output\_kv\_tenant\_id) | The keyvault tenant id |
| <a name="output_sa_id"></a> [sa\_id](#output\_sa\_id) | The ID of the storage account |
| <a name="output_sa_name"></a> [sa\_name](#output\_sa\_name) | The name of the storage account |
| <a name="output_sa_primary_access_key"></a> [sa\_primary\_access\_key](#output\_sa\_primary\_access\_key) | The primary access key of the storage account |
| <a name="output_sa_primary_blob_endpoint"></a> [sa\_primary\_blob\_endpoint](#output\_sa\_primary\_blob\_endpoint) | The primary blob endpoint of the storage account |
| <a name="output_sa_primary_connection_string"></a> [sa\_primary\_connection\_string](#output\_sa\_primary\_connection\_string) | The primary blob connection string of the storage account |
| <a name="output_sa_secondary_access_key"></a> [sa\_secondary\_access\_key](#output\_sa\_secondary\_access\_key) | The secondary access key of the storage account |
