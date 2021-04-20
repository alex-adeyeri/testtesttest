#  locals{
#    defaults_tags{
#      name = "test"
#      env  = "dev"
#    }
#  }
 
 
 data "aws_caller_identity" "default" {
}

data "aws_region" "default" {
}

# Find Amazon Linux AMI
# data "aws_ami" "this_ami" {
#   most_recent = true # Find and return the most recent match. \m/
#   owners = [var.ami_filter_owner-alias]

#   filter {
#     name = "name"
#     values = var.ami_filter_name
#   }
#   filter {
#     name = "virtualization-type"
#     values = var.ami_filter_virtualization_type
#   }
# }

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_instance_profile" "default" {
  
  name  = var.instance_profile_name
  role  = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role" "default" {
  name                 = var.role_name
  path                 = var.role_path
  assume_role_policy   = data.aws_iam_policy_document.instance-assume-role-policy.json
  permissions_boundary = var.permissions_boundary_arn

}

resource "aws_instance" "default" {
  count                       = var.instance_count
  ami                         = var.ami_id
  #availability_zone           = local.availability_zone
  instance_type               = var.instance_type
  ebs_optimized               = var.ebs_optimized
  disable_api_termination     = var.disable_api_termination
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  iam_instance_profile        = aws_iam_instance_profile.default.id
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.subnet
  monitoring                  = var.monitoring
  private_ip                  = var.private_ip
  source_dest_check           = var.source_dest_check
  tags                        = merge(
    {"name" = "testing",
     "environment"= "dev"}
  )

  vpc_security_group_ids =    var.security_groups


  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.delete_on_termination
    encrypted             = var.root_block_device_encrypted
  }
}

# data "null_data_source" "eip" {
#   inputs = {
#     public_dns = "ec2-${replace(join("", aws_eip.default.*.public_ip), ".", "-")}.${local.region == "us-east-1" ? "compute-1" : "${local.region}.compute"}.amazonaws.com"
#   }
# }

# resource "aws_ebs_volume" "default" {
#   count             = var.ebs_volume_count
#   availability_zone = local.availability_zone
#   size              = var.ebs_volume_size
#   iops              = local.ebs_iops
#   type              = var.ebs_volume_type
#   tags              = module.this.tags
#   encrypted         = var.ebs_volume_encrypted
#   kms_key_id        = var.kms_key_id
# }

# resource "aws_volume_attachment" "default" {
#   count       = var.ebs_volume_count
#   device_name = var.ebs_device_name[count.index]
#   volume_id   = aws_ebs_volume.default.*.id[count.index]
#   instance_id = join("", aws_instance.default.*.id)
# }