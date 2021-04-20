provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "test" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "test" {
  name               = "bukky_test"
  assume_role_policy = data.aws_iam_policy_document.test.json

}


resource "aws_iam_instance_profile" "test" {
  name = "bukky_ndtsncr"
  role = aws_iam_role.test.name
}

module "ec2_instance" {
  source = "../NEWTERRAFORM/modules"

  vpc_id                      = var.vpc_id
  subnet                      = var.subnets_id
  security_groups             = var.security_group
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  security_group_rules        = var.security_group_rules
  instance_profile_name      = "testing"
  ami_id ="ami-737366363636"
#   ami_filter_name = "amazon"
#   ami_filter_owner-alias =""
#   ami_filter_virtualization_type= ""
  role_path =var.role_path
  instance_count = var.instance_count
  role_name = var.role_name
}