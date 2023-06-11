module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  db_name = var.db_name
  db_password = var.db_password
  db_username = var.db_username
}