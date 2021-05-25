terraform {
    source = ""
}

  generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
provider "aws" {
  region              = "eu-west-2"
  profile = "lseg1"
}
EOF
}

remote_state {
  backend = "s3"
  config = {
      bucket = "lseg-shared-terraform-state"
      encrypt        = true
      key            = "${path_relative_to_include()}/file"
      region         = "eu-west-2"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


