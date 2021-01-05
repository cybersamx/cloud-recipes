variable "region" {
  description = "The GCE region."
  type        = string
  default     = "us-west1"
}

variable "project" {
  description = "The GCP project ID."
  type        = string
}

variable "zone" {
  description = "The zone where this GKE cluster is located."
  type        = string
}

variable "prefix" {
  description = "Name prefix for this module."
  type        = string
}

variable "env" {
  description = "The environment associated with this module."
  type        = string
  default     = ""
}

variable "machine_type" {
  description = "The machine type in this GKE cluster."
  type        = string
}

variable "disk_size" {
  description = "The size (GB) of the disk attached to each node."
  type        = number
}

variable "min_node_count" {
  description = "The minimum number of nodes in the pool."
  type        = number
}

variable "max_node_count" {
  description = "The maximum number of nodes in the pool."
  type        = number
}