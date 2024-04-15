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

resource "aws_instance" "manager" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name        = "vokey"

  connection {
    user     = "ubuntu"
    key_file = "ssh/key"
  }

  user_data = "${file("user-data.web")}"

  # provisioner "remote-exec" {
  #   inline = [

  #   ]
  # }

  # provisioner "file" {
  #   source      = "prod"
  #   destination = "/home/ubuntu/"
  # }

  tags = {
    Name = "swarm-master"
  }
}

resource "aws_instance" "nodes" {
  count           = 2
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name        = aws_key_pair.deployer.key_name
  connection {
    user     = "ubuntu"
    key_file = "ssh/key"
  }
  provisioner "file" {
    source      = "key.pem"
    destination = "/home/ubuntu/key.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apt-transport-https ca-certificates",
      "sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
      "sudo sh -c 'echo \"deb https://apt.dockerproject.org/repo ubuntu-trusty main\" > /etc/apt/sources.list.d/docker.list'",
      "sudo apt-get update",
      "sudo apt-get install -y docker-engine=1.12.0-0~trusty",
      "sudo chmod 400 /home/ubuntu/test.pem",
      "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i test.pem ubuntu@${aws_instance.master.private_ip}:/home/ubuntu/token .",
      "sudo docker swarm join --token $(cat /home/ubuntu/token) ${aws_instance.master.private_ip}:2377"
    ]
  }
  tags = {
    Name = "swarm-${count.index}"
  }
}