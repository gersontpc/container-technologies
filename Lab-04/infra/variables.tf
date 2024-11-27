variable "aws_region" {
  description = "AWS region on which we will setup the swarm cluster"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "vpc_id" {
  type        = string
  description = "Insert your VPC ID"
}

variable "key_name" {
  type        = string
  description = "Insert your key_name"
  default = "lab-04"
}

variable "cluster" {
  description = "Definição do cluster com contagem de managers e workers"
  type        = map(number)
  default = {
    manager = 1
    workers = 2
  }
}