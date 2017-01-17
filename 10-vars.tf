variable "name"          {}
variable "envtype"       {}
variable "envname"       {}
variable "vpc_id"        {}
variable "cgw_ip"        { type = "list" }
variable "static_routes" { type = "list" }
variable "vpn_desc"      { type = "list" }
