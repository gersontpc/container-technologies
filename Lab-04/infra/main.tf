resource "aws_instance" "manager" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = "vokey"
  user_data              = base64encode(file("${path.module}/templates/userdata.sh"))
  vpc_security_group_ids = ["${aws_security_group.swarm.id}"]

  tags = {
    Name = "swarm-master"
  }
}

resource "aws_instance" "nodes" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = "vokey"
  user_data              = base64encode(file("${path.module}/templates/userdata.sh"))
  vpc_security_group_ids = ["${aws_security_group.swarm.name}"]

  tags = {
    Name = "swarm-${count.index}"
  }
}