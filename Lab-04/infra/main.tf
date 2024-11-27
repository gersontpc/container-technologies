resource "aws_instance" "swarm" {
  count = var.cluster["manager"] + var.cluster["workers"]

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data              = base64encode(file("${path.module}/templates/userdata.sh"))
  vpc_security_group_ids = ["${aws_security_group.swarm.id}"]

  tags = {
    Name = format(
      "swarm-%s-%02d",
      element(
        ["manager", "workers"],
        count.index >= var.cluster["manager"] ? 1 : 0
      ),
      count.index >= var.cluster["manager"]
      ? count.index - var.cluster["manager"] + 1
      : count.index + 1
    )
  }
}
