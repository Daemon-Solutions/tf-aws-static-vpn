tf-aws-static-vpn
=================

VPN - Terraform Module

Usage
-----

```js
module "vpn" {
  source        = "git@gogs.bashton.net:Bashton-Terraform-Modules/tf-aws-static-vpn.git"
  name          = "Claranet"
  vpn_desc      = "London"
  envtype       = "prod"
  envname       = "ecomm"
  cgw_ip        = "81.143.135.67"
  vpc_id        = "vpc-4c001444"
  static_routes = ["192.168.0.1", "192.168.0.2"]
  az            = "eu-west-1b"
}
```

Variables
---------

 - `name` - customer name
 - `vpn_desc` - description of VPN
 - `envtype` - environment type
 - `envname` - environment name
 - `cgw_ip` - Customer Gateway public IP address
 - `vpc_id` - VPC ID
 - `static_routes` - VPN Connection static routes
 - `az` - VPN Gateway availability zone

Outputs
-------

 - `cgw_id` - Customer Gateway ID
 - `vpn_id` - VPN Connection ID
 - `vgw_id` - VPN Gateway ID
 - `tunnel_ips` - VPN Connection Tunnel IP addresses
