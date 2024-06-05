variable "location" {
  default = "us-east-1"
}

variable "key" {
  default = "manish-cluster-key"
}

variable "instance-type" {
  default = "t2.micro"
}

variable "vpc-cidr" {
  default = "172.0.0.0/16"
}

variable "subnet1-cidr" {
  default = "172.0.1.0/24"

}
variable "subnet2-cidr" {
  default = "172.0.2.0/24"

}
variable "subnet_az-1" {
  default = "us-east-1a"
}
variable "subnet_az-2" {
  default = "us-east-1b"
}