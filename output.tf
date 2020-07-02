output "global_ip" {
  value = "http://${ibm_compute_vm_instance.vm.ipv4_address}"
}

#output "block_storage_credentials" {
#  value = ibm_storage_block.block_storage.allowed_host_info
#}
