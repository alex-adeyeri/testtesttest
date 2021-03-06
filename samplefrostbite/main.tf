# --- root/main.tf --- 

#Deploy Networking Resources

# module "networking" {
#   source           = "./networking"
#   vpc_cidr         = local.vpc_cidr
#   private_sn_count = 3
#   public_sn_count  = 2
#   private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
#   public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
#   max_subnets      = 20
#   access_ip        = var.access_ip
#   security_groups  = local.security_groups
#   db_subnet_group  = "true"
# }

# # module "database" {
#   source                 = "./database"
#   db_engine_version      = "5.7.22"
#   db_instance_class      = "db.t2.micro"
#   dbname                 = var.dbname
#   dbuser                 = var.dbuser
#   dbpassword             = var.dbpassword
#   db_identifier          = "sample-db"
#   skip_db_snapshot       = true
#   db_subnet_group_name   = module.networking.db_subnet_group_name[0]
#   vpc_security_group_ids = [module.networking.db_security_group]
# }

# module "loadbalancing" {
#   source                  = "./loadbalancing"
#   public_sg               = module.networking.public_sg
#   public_subnets          = module.networking.public_subnets
#   tg_port                 = 8000
#   tg_protocol             = "HTTP"
#   vpc_id                  = module.networking.vpc_id
#   elb_healthy_threshold   = 2
#   elb_unhealthy_threshold = 2
#   elb_timeout             = 3
#   elb_interval            = 30
#   listener_port           = 8000
#   listener_protocol       = "HTTP"
# }
module "ec2" {
    source = "../terraform.sampletemp/compute"


   countinstance_count                       = var.instance_count
  instance_type               = var.instance_type
  ami_id                        = var.ami_id
  user_data                   = var.user_data
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile
  availability_zone           = var.availability_zone

vpc_security_group_ids = [var.vpc_sg]
  subnet_id              = var.vpc_subnets[count.index]
  }