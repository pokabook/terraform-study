data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_vpc" "default_vpc" {
  default = true
}
