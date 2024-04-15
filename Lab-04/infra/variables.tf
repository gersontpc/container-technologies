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