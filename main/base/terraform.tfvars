# ---------------------------------
#  Scope: local
# ---------------------------------
vpc_cidr_block_v4 = "10.0.0.0/16"

subnet_cidr_block_ingress = {
  "a" = "10.0.0.0/24"
  "c" = "10.0.1.0/24"
}
subnet_cidr_block_container = {
  "a" = "10.0.8.0/24"
  "c" = "10.0.9.0/24"
}

subnet_cidr_block_db = {
  "a" = "10.0.16.0/24"
  "c" = "10.0.17.0/24"
}

subnet_cidr_block_management = {
  "a" = "10.0.240.0/24"
  "c" = "10.0.241.0/24"
}

subnet_cidr_block_egress = {
  "a" = "10.0.248.0/24"
  "c" = "10.0.249.0/24"
}

waf_header_string = "8f856a61-e356-45c9-91b3-0fb8f0ebc47a"