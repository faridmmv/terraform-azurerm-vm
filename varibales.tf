variable "location" {}

variable "rg_name" {}

variable "vnet_name" {}

variable "keys" {
  description = "Private key for wireguard peer. Run 'wg genkey' to generate"
  type        = list(any)
  default     = ["AAAAAAAAA", "BBBBBBBBB"]
}

variable "wgpub" {
  description = "Public key of wireguard remote peer"
  type        = string
}

variable "endpoint" {
  description = "Remote wireguard peer endpoint"
  type        = string
  default     = "example.com:51000"
}

variable "subnet_name" {
  description = "Name of subnet for VM"
  type        = string
  default     = "vm"
}

variable "subnet" {
  description = "Subnet for VM"
}

variable "public_key" {
  type = string
}

variable "tags" {
  description = "default tags to apply to resources"
  type        = map(any)
}

variable "count" {
  description = "Number of VMs to deploy"
  type        = number
  default     = 1
}