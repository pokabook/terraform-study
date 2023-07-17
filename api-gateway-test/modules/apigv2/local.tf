locals {
  route_keys = {
  for key, item in var.api_information : key => "${item.http_method} ${item.uri}"
  }
}
