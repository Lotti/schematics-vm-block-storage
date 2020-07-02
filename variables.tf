variable "ssh_label" {
  type = string
}
variable "ssh_public_key" {
  type = string
}
variable "ssh_private_key" {
  type = string
}
variable "vm_flavor" {
  type = string
  default = "C1_1X1X25"
}
variable "mount_path" {
  type = string
  default = "/storage"
}
variable "storage_iops" {
  type = number
  default = 0.25
}
variable "storage_capacity_GB" {
  type = number
  default = 20
}
variable "storage_type" {
  type = string
  default = "Endurance"
}
variable "snapshot_capacity" {
  type = number
  default = 5
}
variable "snapshot_schedule" {
  type = object({ schedule_type=string, retention_count=number, minute=number, hour=number, enable=bool })
  default = {
    schedule_type   = "DAILY"
    retention_count = 1
    minute          = 30
    hour            = 02
    enable          = true
  }
}