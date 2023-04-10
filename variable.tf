variable "cluster_name" {
  type        = string
  default     = "kevcolli"
  description = "ARO cluster name"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "test"
    owner       = "kevcolli@redhat.com"
  }
}

variable "vnet_role" {
  type        = string
  default = "ARO Network Private Role Kevcolli"
  description = "Azure Role for the VNET"
}

variable "rp_role" {
  type        = string
  default = "Contributor"
  description = "Azure Role for the resource provider"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  default     = "kevcolli-rg"
  description = "ARO resource group name"
}

variable "aro_virtual_network_cidr_block" {
  type        = string
  default     = "10.0.0.0/20"
  description = "cidr range for aro virtual network"
}

variable "aro_control_subnet_cidr_block" {
  type        = string
  default     = "10.0.0.0/23"
  description = "cidr range for aro control plane subnet"
}

variable "aro_machine_subnet_cidr_block" {
  type        = string
  default     = "10.0.2.0/23"
  description = "cidr range for aro machine subnet"
}


variable "api_server_profile" {
  type        = string
  description = <<EOF
  Api Server Profile Visibility - Public or Private
  Default "Public"
  EOF
  default     = "Private"
}

variable "ingress_profile" {
  type        = string
  description = <<EOF
  Ingress Controller Profile Visibility - Public or Private
  Default "Public"
  EOF
  default     = "Private"
}

variable "pull_secret_path" {
  type        = string
  default     = "~/Downloads/pull-secret.txt"
  description = <<EOF
  Pull Secret for the ARO cluster 
  Default "false"
  EOF
}

variable "aro_version" {
  type        = string
  description = <<EOF
  ARO version
  Default "4.11.26"
  EOF
  default     = "4.11.26"
}