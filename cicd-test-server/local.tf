locals {
  myip = "${chomp(data.http.myip.body)}/32"
}
