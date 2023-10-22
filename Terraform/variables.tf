variable "resource_group_name" {
  type = string
  description = "Resource group name"
}
variable "resource_group_location" {
  type = string
  description = "RG location"
}
variable "app_service_plan_name" {
    type = string
    description = "App service plan name"  
}
variable "app_service_name" {
  type = string
  description = "App service plan"
}
variable "sql_server_name" {
    type = string
    description = "Sql server name "
  }
variable "sql_database_name" {
    type = string
    description = "Sql database name"
  }
variable "sql_administrator_login_username" {
    type = string
    description = "SQL administrtaton username"
  
}
variable "sql_administrator_password" {
    type = string
    description = "SQL administrtaton pass"
  
}
variable "firewall_rule_name" {
    type = string
    description = "Firewall"
  
}
variable "repo_URL" {
    type = string
    description = "URL for app"
  
}
