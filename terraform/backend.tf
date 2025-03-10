terraform {
  backend "s3" {
    bucket = "kafka-one-click-01"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
