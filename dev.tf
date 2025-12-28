module "dev" {
  source       = "."
  environment  = "dev"
  vpc_cidr     = "10.0.0.0/16"
  subnet_cidr  = "10.0.1.0/24"
  az           = "ap-southeast-2a"
  project_name = "minecraft_dev_server"
}
