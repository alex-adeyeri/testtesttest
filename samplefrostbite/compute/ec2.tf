

# resource "random_id" "sample_node_id" {
#   byte_length = 2
#   count       = var.instance_count
# }


resource "aws_instance" "sample_node" {
  count                       = local.instance_count
  instance_type               = var.instance_type
  ami                         = var.ami_id
  user_data                   = var.user_data
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile
  availability_zone           = var.availability_zone
  vpc_security_group_ids       = [var.vpc_sg]
  subnet_id                    = var.vpc_subnets
  tags                        = module.this.tags

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.delete_on_termination
    encrypted             = var.root_block_device_encrypted
  }
  # resource "aws_kms_key" "a" {
  #   description             = "KMS key 1"
  #   deletion_window_in_days = 10
  # }
#  }

# output "" {
#   value = aws_instance.sample_node.private_ip
}
# resource "aws_security_group" "cmscloud-consolidated" {
#   name        = "cmscloud-access-sg"
#   vpc_id      = var.vpc_id

#   lifecycle { create_before_destroy = true }

#   ingress {
#     description = "cmscloud-access-sg-1"
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["10.0.0.0/16", "10.129.0.0/16"]
#   }

#   ingress {
#     description = "cmscloud-access-2"
#     protocol    = "tcp"
#     from_port   = 4118
#     to_port     = 4122
#     cidr_blocks = ["10.0.0.0/16", "10.0.0.0/16"]
#   }

#   egress {
#     protocol    = -1
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "data-zone-access" {
#   name        = "data-zone-access-sg"
#   vpc_id      = "{var.vpc_id}"

#   lifecycle { create_before_destroy = true }

#   ingress {
#     protocol    = "-1"
#   from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["10.0.0.0/16", "10.0.0.0/16"]
#   }
# }
resource "aws_kms_key" "ssmkey" {
  description             = "SSM Key"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = var.deletion_window_in_days
  policy                  = data.aws_iam_policy_document.kms_access.json
  tags                    = var.tags
}

resource "aws_kms_alias" "ssmkey" {
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.ssmkey.key_id
}

resource "aws_ssm_document" "session_manager_prefs" {
  name            = "SSM-SessionManagerRunShell"
content = {}
  document_type   = "Session"
  document_format = "JSON"
  tags            = var.tags
}
