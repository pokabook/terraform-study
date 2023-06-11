module "webserver_cluster" {
  source                 = "../../../../modules/services/hello-world-app"
  cluster_name           = "webserver-stage"
  db_remote_state_bucket = "poka-terraform-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2

  custom_tags = {
    Owner      = "team-poka"
    DeployedBy = "terraform"
  }
  enable_autoscaling = fasle
  ami                = data.aws_ami.ubuntu.id
  environment        = "poka"
}