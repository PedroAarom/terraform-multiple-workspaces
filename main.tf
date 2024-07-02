provider "aws" {
  region = "us-east-1"
}

locals {
  environment = terraform.workspace
  bucket_name = terraform.workspace == "prod" ? "prod-example-bucket" : "dev-example-bucket"
  instance_type = terraform.workspace == "prod" ? "t2.small" : "t2.micro"
  instance_class = terraform.workspace == "prod" ? "db.t4g.micro" : "db.t3.micro"
}

resource "aws_instance" "example" {
  ami           = "ami-01b799c439fd5516a"  # Amazon Linux 2 AMI
  instance_type = local.instance_type

  tags = {
    Name        = "${local.environment}-example-instance"
    Environment = local.environment
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = local.instance_class
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  identifier           = "${local.environment}-example-db"
}

# terraform {
#  backend "s3" {
#  bucket = "mybucket2121345"
#  key = "path/to/terraform.tfstate"
#  region = "us-east-1"
#  }
# }