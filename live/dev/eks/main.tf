module "eks"{
    source = "../../../modules/eks"
}
terraform {
  backend "s3" {
    bucket         = "rr-s3-bucket-ms6-tfstate"
    key            = "live/dev/eks/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "student-rr-radaur_ms5_l"
  }
}

provider "aws" {
    region = "eu-central-1"
}