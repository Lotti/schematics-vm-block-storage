resource "ibm_compute_ssh_key" "ssh_key" {
  label      = var.ssh_label
  public_key = var.ssh_public_key
}

/*
resource "ibm_storage_block" "block_storage" {
  type = "Endurance"
  datacenter = var.iaas_datacenter
  capacity = 5
  iops = 0.25
  os_format_type = "Linux"
  hourly_billing = true
  snapshot_capacity = 1

  # Optional fields
  # allowed_virtual_guest_ids  = [ibm_compute_vm_instance.vm.id]
  # allowed_ip_addresses = [ibm_compute_vm_instance.vm.ipv4_address_private]
}
*/

resource "ibm_storage_file" "file_storage" {
  type = var.storage_type
  datacenter = var.iaas_datacenter
  capacity = var.storage_capacity_GB
  iops = var.storage_iops
  hourly_billing = true
  snapshot_capacity = var.snapshot_capacity

  # Optional fields
  # allowed_virtual_guest_ids  = [ibm_compute_vm_instance.vm.id]
  # allowed_ip_addresses = [ibm_compute_vm_instance.vm.ipv4_address_private]
  snapshot_schedule {
    schedule_type   = var.snapshot_schedule.schedule_type
    retention_count = var.snapshot_schedule.retention_count
    minute          = var.snapshot_schedule.minute
    hour            = var.snapshot_schedule.hour
    enable          = var.snapshot_schedule.enable
  }
}

resource "ibm_compute_vm_instance" "vm" {
  hostname = "valerio-schematics-test"
  domain = "ibm.com"
  os_reference_code = "UBUNTU_18_64"
  datacenter = var.iaas_datacenter
  network_speed = 10
  hourly_billing = true
  private_network_only = false
  flavor_key_name = var.vm_flavor
  transient = true
  local_disk = false
  wait_time_minutes = 10

  # Optional fields
  ssh_key_ids = [ibm_compute_ssh_key.ssh_key.id]
  file_storage_ids = [ibm_storage_file.file_storage.id]
  # block_storage_ids = [ibm_storage_block.block_storage.id]
  user_metadata = "{\"createdBy\":\"cdextension\"}"
  provisioner "remote-exec" {
    connection {
      host = ibm_compute_vm_instance.vm.ipv4_address
      type = "ssh"
      port = 22
      user = "root"
      agent = "false"
      private_key = var.ssh_private_key
      # private_key = file("~/.ssh/id_rsa")
    }
    inline = [
      "apt-get update -y",
      "apt-get install -y nfs-common nfs-kernel-server",
      "mkdir -p ${var.mount_path}",
      "mount -t nfs -o nfsvers=3 ${ibm_storage_file.file_storage.mountpoint} ${var.mount_path}",
      "echo \"${ibm_storage_file.file_storage.mountpoint} ${var.mount_path} nfsvers=3 defaults 0 0\" >> /etc/fstab",
      "mount -fav",
      "df -h"
    ]
  }
  # post_install_script_uri = "https://raw.githubusercontent.com/Lotti/schematics-vm-block-storage/master/script.sh"
}
