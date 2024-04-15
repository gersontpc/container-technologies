data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Amazon Linux 2 Images: https://docs.aws.amazon.com/linux/al2023/ug/ec2.html
# RHEL Images: https://access.redhat.com/solutions/15356#us_west_1_rhel9
# Ubuntu Images: https://cloud-images.ubuntu.com/locator/ec2/
