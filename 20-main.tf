resource "aws_customer_gateway" "cgw" {
  bgp_asn    = "65000"
  ip_address = "${var.cgw_ip}"
  type       = "ipsec.1"
  tags {
    Name = "${var.project_prefix}-${var.envtype}-cgw-attune"
  }
}

resource "aws_vpn_connection" "vpn" {
    vpn_gateway_id      = "${var.vpngw_id}"
    customer_gateway_id = "${aws_customer_gateway.cgw.id}"
    type                = "ipsec.1"
    static_routes_only  = true
}

resource "aws_vpn_connection_route" "routes" {
    count                  = "${length(split(",", var.static_routes))}"
    destination_cidr_block = "${element(split(",", var.static_routes), count.index)}"
    vpn_connection_id      = "${aws_vpn_connection.vpn.id}"
}
