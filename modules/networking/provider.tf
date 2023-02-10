provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket         = "farruh-tfstate-part2"
    key            = "networking.tf"
    region         = "eu-west-1"
  }

  required_version = "= 1.3.7"
}
