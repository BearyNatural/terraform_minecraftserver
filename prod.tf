module "prod" {
  source       = "."
  environment  = "prod"
  vpc_cidr     = "10.0.0.0/16"
  subnet_cidr  = "10.0.2.0/24"
  az           = "ap-southeast-2b"
  project_name = "minecraft_prod_server"
}
