variable "create_tgw" {
  description = "Controls if TGW should be created (it affects almost all resources)"
  type        = bool
  default     = true
}
variable "access_key" {
  default = "XXXXXXXXXXXXXXXX"
}

variable "secret_key" {
  default = "YYYYYYYYYYYYYYYYY"
}

variable "region" {
  default = "us-east-1"
}

variable "" {
  default = "eu-central-1a"
}

variable "az2" {
  default = "eu-central-1b"
}

variable "scenario" {
  default = "test-tgw"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1y...qd4hssndQ== rsa-key-20180518"
}
