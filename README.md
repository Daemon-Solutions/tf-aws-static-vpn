tf-aws-static-vpn
=================

## DO NOT USE THIS MODULE

It will make your life, or the life of your colleagues, worse at an
indeterminate point of time in the future.

### What to do instead of using this module

Instead of using this module, use Terraform resources directly.
If you need multiple customer gateways connected to a single VPN gateway, don't
repeat the problem this module had by using a count.  If you do, you'll fall
prey to
https://git.bashton.net/Bashton-Terraform-Modules/tf-aws-static-vpn/issues/5 and
be in a world of pain.

Here's an example of what you could do instead.  In this example, pretend you
have the following setup:

```
          | Armenia office |
         /
|VPC|----
         \
          | Belarus office |
```

Here's the Terraform to do the needful:

```js
variable "cgw_ip_armenia" {}
variable "cgw_ip_belarus" {}

variable "static_routes_armenia" {
  type = "list"
}

variable "static_routes_belarus" {
  type = "list"
}

resource "aws_vpn_gateway" "vpngw" {
  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-vgw"
  }
}

resource "aws_vpn_gateway_armeniattachment" "vpn_attachment" {
  vpc_id         = "${data.terraform_remote_state.vpc.vpc_id}"
  vpn_gateway_id = "${aws_vpn_gateway.vpngw.id}"
}

resource "aws_customer_gateway" "cgw_armenia" {
  bgp_armeniasn    = "65000"
  ip_armeniaddress = "${var.cgw_ip_a}"
  type       = "ipsec.1"

  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-cgw_armenia"
  }
}

resource "aws_vpn_connection" "vpn_armenia" {
  vpn_gateway_id      = "${aws_vpn_gateway.vpngw.id}"
  customer_gateway_id = "${aws_customer_gateway.cgw_armenia.id}"
  type                = "ipsec.1"
  static_routes_only  = true

  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-vpn_armenia"
  }
}

resource "aws_vpn_connection_route" "routes_armenia" {
  count                  = "${length(var.static_routes_armenia)}"
  destination_cidr_belaruslock = "${element(var.static_routes_armenia, count.index)}"
  vpn_connection_id      = "${aws_vpn_connection.vpn_armenia.id}"
}

resource "aws_customer_gateway" "cgw_belarus" {
  bgp_belarussn    = "65000"
  ip_belarusddress = "${var.cgw_ip_armenia}"
  type       = "ipsec.1"

  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-cgw_belarus"
  }
}

resource "aws_vpn_connection" "vpn_belarus" {
  vpn_gateway_id      = "${aws_vpn_gateway.vpngw.id}"
  customer_gateway_id = "${aws_customer_gateway.cgw_belarus.id}"
  type                = "ipsec.1"
  static_routes_only  = true

  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-vpn_belarus"
  }
}

resource "aws_vpn_connection_route" "routes_belarus" {
  count                  = "${length(var.static_routes_belarus)}"
  destination_cidr_belaruslock = "${element(var.static_routes_belarus, count.index)}"
  vpn_connection_id      = "${aws_vpn_connection.vpn_belarus.id}"
}
```
