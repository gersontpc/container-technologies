data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Amazon Linux 2 Images: https://docs.aws.amazon.com/linux/al2023/ug/ec2.html
# RHEL Images: https://access.redhat.com/solutions/15356#us_west_1_rhel9
# Ubuntu Images: https://cloud-images.ubuntu.com/locator/ec2/
