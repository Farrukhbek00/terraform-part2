module "networking" {
  source = "./modules/networking"
}

module "sg" {
  source         = "./modules/sg"
  vpc            = module.networking.vpc
  subnet_private = module.networking.subnet_private
}

module "ec2" {
  source             = "./modules/ec2"
  region             = var.region
  ami                = var.ami
  subnet_public_id   = module.networking.subnet_public_id
  subnet_private_id  = module.networking.subnet_private_id
  subnet_database_id = module.networking.subnet_database_id
  sg_bastion_id      = module.sg.sg_bastion_id
  sg_public_id       = module.sg.sg_public_id
  sg_private_id      = module.sg.sg_private_id
  sg_database_id     = module.sg.sg_database_id
}

