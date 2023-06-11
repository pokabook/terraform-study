terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "example" {
  triggers = {
    uuid = uuid()
  }
  provisioner "local-exec" {
    command = "echo \"Hello, World from $(uname -smp)\""
  }
}