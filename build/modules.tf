module "vpc" {
  source = "../modules/VPC"

  cluster_name = var.cluster_name
  aws_region   = var.aws_region
}

module "elb" {
  source = "../modules/ELB"

  cluster_name = var.cluster_name
  cluster_vpc  = module.vpc.cluster_vpc

  public_subnet_1a = module.vpc.public_subnet_1a
  public_subnet_1c = module.vpc.public_subnet_1c

  allow_internet = module.vpc.allow_internet
  certificateSSL = var.certificateSSL

}

module "ecs" {
  source = "../modules/ECS"

  cluster_name      = var.cluster_name
  cluster_vpc       = module.vpc.cluster_vpc
  private_subnet_1a = module.vpc.private_subnet_1a
  private_subnet_1c = module.vpc.private_subnet_1c
  public_subnet_1a  = module.vpc.public_subnet_1a
  public_subnet_1c  = module.vpc.public_subnet_1c

  InstanceType = var.InstanceType
  key-name     = var.key-name


  auto_scale_options = var.auto_scale_options
  auto_scale_cpu     = var.auto_scale_cpu

  depends_on = [
    module.vpc, module.elb
  ]

}

module "pipeline" {

  source = "../modules/pipeline"

  ProjectName       = var.ProjectName
  cluster_name      = var.cluster_name
  aws_region        = var.aws_region
  cluster_vpc       = module.vpc.cluster_vpc
  private_subnet_1a = module.vpc.private_subnet_1a
  private_subnet_1c = module.vpc.private_subnet_1c
  elb-arn           = module.elb.elb-arn
  container_Port    = var.container_Port

  logs-name       = module.ecs.logs
  ecs-id          = module.ecs.ecs-id

  
  git_repository_owner  = var.git_repository_owner
  git_repository_name   = var.git_repository_name
  git_repository_branch = var.git_repository_branch
  git_token             = var.git_token

  security_groups_ids = module.elb.alb_sg


  depends_on = [
    module.elb, module.ecs
  ]

}