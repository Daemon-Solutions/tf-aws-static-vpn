output "cgw_id" {
  value = ["${aws_customer_gateway.cgw.*.id}"]
}

output "vpn_id" {
  value = ["${aws_vpn_connection.vpn.*.id}"]
}

output "vgw_id" {
  value = "${aws_vpn_gateway.vpngw.id}"
}

output "tunnel_ips" {
  value = ["${aws_vpn_connection.vpn.*.tunnel1_address},${aws_vpn_connection.vpn.*.tunnel2_address}"]
}
