output "global_ip" {
  value = "http://${ibm_network_public_ip.ip.ip_address}"
}
