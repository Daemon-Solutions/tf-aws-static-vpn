resource "aws_vpn_gateway" "vpngw" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-vgw"
  }
}

resource "aws_customer_gateway" "cgw" {
  count      = "${length(var.cgw_ip)}"
  bgp_asn    = "65000"
  ip_address = "${element(var.cgw_ip, count.index)}"
  type       = "ipsec.1"
  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-${element(var.vpn_desc, count.index)}-cgw"
  }
}

resource "aws_vpn_connection" "vpn" {
    count               = "${length(var.cgw_ip)}"
    vpn_gateway_id      = "${aws_vpn_gateway.vpngw.id}"
    customer_gateway_id = "${element(aws_customer_gateway.cgw.*.id, count.index)}"
    type                = "ipsec.1"
    static_routes_only  = true
    tags {
      Name = "${var.name}-${var.envtype}-${var.envname}-${element(var.vpn_desc, count.index)}-vpn"
    }
}

resource "aws_vpn_connection_route" "routes" {
    count                  = "${length(var.static_routes)}"
    destination_cidr_block = "${element(var.static_routes, count.index)}"
    vpn_connection_id      = "${element(aws_vpn_connection.vpn.*.id, count.index)}"
}
