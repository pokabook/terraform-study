variable "name_prefix" {
  type = string
  default = "test"
}
variable "tag_prefix_list" {
  type    = list(string)
  default = ["v"]
}
variable "image_limit" {
  type    = number
  default = 3
}
