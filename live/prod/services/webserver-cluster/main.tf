module "webserver_cluster" {
  source                 = "../../../../modules/services/hello-world-app"
  cluster_name           = "webserver-prod"
  db_remote_state_bucket = "poka-terraform-state"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10

  custom_tags = {
    Owner      = "team-poka"
    DeployedBy = "terraform"
  }
  enable_autoscaling = true
  ami                = data.aws_ami.ubuntu.id
  environment        = "poka"
}