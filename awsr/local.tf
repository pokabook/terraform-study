locals {
  azs = [
    "ap-northeast-2a",
    "ap-northeast-2c"
  ]
}

locals {
  http_port    = 80
  https_port   = 443
  mysql_port   = 3306
  any_port     = 0
  tcp_protocol = "tcp"
  any_protocol = "-1"
  all_ips      = ["0.0.0.0/0"]
  all_ipv6s    = ["::/0"]
}