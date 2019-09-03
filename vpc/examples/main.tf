provider aws {
  region  = "ap-southeast-2"
  version = "~> 2.26"
}

module vpc {
  source = "../"

  vpc_cidr = "10.69.0.0/20"

  public_subnets_cidr  = ["10.69.0.0/24"]
  private_subnets_cidr = ["10.69.2.0/24"]

  availability_zones = ["ap-southeast-2a"]
}
