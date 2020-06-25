resource "ibm_compute_ssh_key" "ssh_key" {
  label      = var.ssh_label
  public_key = var.ssh_public_key
}

resource "ibm_storage_block" "block_storage" {
  type = "Endurance"
  datacenter = var.iaas_datacenter
  capacity = 20
  iops = 0.25
  os_format_type = "Linux"
  hourly_billing = true
  snapshot_capacity = 5

  # Optional fields
  # allowed_virtual_guest_ids = [ 27699397 ]
  # allowed_ip_addresses = ["10.40.98.193", "10.40.98.200"]
}

resource "ibm_compute_vm_instance" "vm" {
  hostname = "valerio-schematics-test"
  domain = "ibm.com"
  os_reference_code = "UBUNTU_18_64"
  datacenter = var.iaas_datacenter
  network_speed = 10
  hourly_billing = true
  private_network_only = false
  flavor_key_name = "C1_1X1X25"
  transient = true
  local_disk = false

  block_storage_ids = [ibm_storage_block.block_storage.id]
  ssh_key_ids = [ibm_compute_ssh_key.ssh_key.id]

  user_metadata = "{\"value\":\"newvalue\"}"
  # public_vlan_id = 1391277
  # private_vlan_id  = "${ibm_network_vlan.privateVlan1.id}"
  # private_security_group_ids = [576973]
  # public_subnet = "50.97.46.160/28"
  # private_subnet = "10.56.109.128/26"
  provisioner "remote-exec" {
    script = "gip.sh"
  }
}

resource "ibm_network_public_ip" "ip" {
  routes_to = ibm_compute_vm_instance.vm.ipv4_address
}
