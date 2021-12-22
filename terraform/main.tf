/*variables.tf*/
provider "azurerm" {
  features{}
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

variable "subscription_id" {
    description = "Enter Subscription ID"
    default = "dbe857d8-f7ea-4c79-bb59-b4e5bc080426"
}

variable "client_id" {
    description = "Enter Client ID"
    default = "f84e6eb2-23ca-4e10-9cab-6fbb719ceb6b"
}

variable "client_secret" {
    description = "Enter Client Secret"
    default = "JemNYaVD5vYL.jUUgb4ADFrT.jJ~Qz9YTe"
}

variable "tenant_id" {
    description = "Enter Tenant ID"
    default = "0b3fc178-b730-4e8b-9843-e81259237b77"
}


/*main.tf*/
resource "azurerm_resource_group" "resource_gp" {
  name     = "Terraform-Assignment"
  location = "eastus"

  tags = {
      Owner = "Alex"
  }
}

resource "azurerm_app_service_plan" "app_service_plan1" {
  name                = "assignment-appserviceplan"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "webapp" {
  name                = "assignment-webapp"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan1.id
  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}

/*output.tf*/
output "resource_group" {
  value = azurerm_resource_group.resource_gp.name
}

output "azurerm_app_service_plan" {
  value = azurerm_app_service_plan.app_service_plan1.name
 
}

output "azurerm_app_service" {
  value = azurerm_app_service.webapp.name
 
}

terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform-Demo"
    storage_account_name = "tfstatestoragedemo123"
    container_name       = "tfdemocontainer"
    key                  = "demotf.terraform.tfstate"
  }
}