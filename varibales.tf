variable "location" {}

variable "rg_name" {}

variable "vnet_name" {}
variable "subnet_name" {
  description = "Name of subnet for VM"
  type        = string
  default     = "vm"
}

variable "subnet" {
  description = "Subnet for VM"
}

variable "public_key" {
  description = "SSH public key to access VM"
  type = string
}

variable "tags" {
  description = "default tags to apply to resources"
  type        = map(any)
}

variable "vm_count" {
  description = "Number of VMs to deploy"
  type        = number
  default     = 1
}

variable "size" {
  description = "VM Size to deploy"
  type        = string
  default     = "Standard_B2ms"
}