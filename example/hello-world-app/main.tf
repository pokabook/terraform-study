module "hello_world_app" {
  source = "../../modules/services/hello-world-app"

  environment = var.environment
  ami    = data.aws_ami.ubuntu.id

  db_remote_state_bucket = "poka-terraform-state"
  db_remote_state_key = "examples/terraform.tfstate"

  mysql_config = var.mysql_config

  max_size = 2
  min_size = 2
  instance_type = var.instance_type
  enable_autoscaling = false
}
