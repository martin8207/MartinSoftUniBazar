terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

resource "azurerm_resource_group" "martin8207terraformrg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
resource "azurerm_service_plan" "martin8207terraformsp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.martin8207terraformrg.name
  location            = azurerm_resource_group.martin8207terraformrg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "alwa" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.martin8207terraformrg.name
  location            = azurerm_service_plan.martin8207terraformsp.location
  service_plan_id     = azurerm_service_plan.martin8207terraformsp.id

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.dbserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};User ID=${azurerm_mssql_server.dbserver.administrator_login};Password=${azurerm_mssql_server.dbserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }

  site_config {
    application_stack {
      dotnet_version = "6.0"

    }
    always_on = false
  }
}

resource "azurerm_mssql_server" "dbserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.martin8207terraformrg.name
  location                     = azurerm_resource_group.martin8207terraformrg.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login_username
  administrator_login_password = var.sql_administrator_password
  minimum_tls_version          = "1.2"

}

resource "azurerm_mssql_database" "db" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.dbserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
 #read_scale     = true
  sku_name       = "S0"
  zone_redundant = false

}

resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.dbserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "aassc" {
  app_id                 = azurerm_linux_web_app.alwa.id
  repo_url               = var.repo_URL
  branch                 = "main"
  use_manual_integration = true
}




