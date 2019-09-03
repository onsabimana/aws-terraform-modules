variable vpc_cidr {
  description = "VPC's CIDR."
}

variable availability_zones {
  description = "List of avaailability zones to use in the VPC."
  type        = "list"
  default     = []
}
variable public_subnets_cidr {
  description = "List of CIDR block to use for the public subnets."
  type        = "list"
  default     = []
}

variable private_subnets_cidr {
  description = "List of CIDR blocks to use for the private subnets."
  type        = "list"
  default     = []
}

variable tags {
  description = "Tags to append to the resources created by this module."
  type        = "map"
  default     = {}
}
