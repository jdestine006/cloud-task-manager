variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "max_capacity" {
  type    = number
  default = 3
}

variable "cpu_target_value" {
  type    = number
  default = 70
}