module "sg" {
  source         = "./modules/sg"
  vpc            = data.terraform_remote_state.networking.outputs.vpc
  subnet_private = data.terraform_remote_state.networking.outputs.subnet_private
}

module "ec2" {
  source             = "./modules/ec2"
  region             = var.region
  ami                = var.ami
  subnet_public_id   = data.terraform_remote_state.networking.outputs.subnet_public_id
  subnet_private_id  = data.terraform_remote_state.networking.outputs.subnet_private_id
  subnet_database_id = data.terraform_remote_state.networking.outputs.subnet_database_id
  sg_bastion_id      = module.sg.sg_bastion_id
  sg_public_id       = module.sg.sg_public_id
  sg_private_id      = module.sg.sg_private_id
  sg_database_id     = module.sg.sg_database_id
  ec2_user           = var.EC2_USER
}

