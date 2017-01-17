resource "aws_vpn_gateway" "vpngw" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-vgw"
  }
}

resource "aws_customer_gateway" "cgw" {
  bgp_asn    = "65000"
  ip_address = "${var.cgw_ip}"
  type       = "ipsec.1"
  tags {
    Name = "${var.name}-${var.envtype}-${var.envname}-cgw"
  }
}

resource "aws_vpn_connection" "vpn" {
    vpn_gateway_id      = "${aws_vpn_gateway.vpngw.id}"
    customer_gateway_id = "${aws_customer_gateway.cgw.id}"
    type                = "ipsec.1"
    static_routes_only  = true
    tags {
      Name = "${var.name}-${var.envtype}-${var.envname}-vpn"
    }
}

resource "aws_vpn_connection_route" "routes" {
    count                  = "${length(var.static_routes)}"
    destination_cidr_block = "${element(var.static_routes, count.index)}"
    vpn_connection_id      = "${aws_vpn_connection.vpn.id}"
}
