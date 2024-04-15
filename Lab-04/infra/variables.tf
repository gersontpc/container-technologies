module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["master", "worker-01", "worker-02"])

  name = "cluster-swarm-${each.key}"

  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = ["sg-0801507e2980afcb0"]
  subnet_id              = "subnet-07a60f5768a99d4a7"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}