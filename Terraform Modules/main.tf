provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

module "module-1" {
  source = "./Module1"
}

module "module-2" {
  source = "./Module2"
}