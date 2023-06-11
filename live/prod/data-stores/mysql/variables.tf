variable "db_password" {
  type = string
  description = "The password for the database"
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_database_prod"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}