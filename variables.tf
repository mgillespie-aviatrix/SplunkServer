variable "cloud_account" {
  description = "The account to use for provisioning"
  type        = string
}
variable "default_ssh_key" {
  type        = string
  description = "The default SSH key to use."
  default     = "AWSVMKey"
}
variable "splunk_vpc_id" {
  type = string
  description = "VPC to launch Splunk in"
}
variable "splunk_server_name" {
  type = string
  description = "Splunk Server Name"
}
variable "splunk_instance_size" {
  type = string
  description = "Splunk Instance Size"
}
variable "splunk_subnet_id" {
  type = string
  description = "Subnet to launch Splunk in"
}
