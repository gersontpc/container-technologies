output "mamager_public_ip" {
  value = ["${aws_instance.manager.*.public_ip}"]
}

output "mamager_private_ip" {
  value = ["${aws_instance.manager.*.private_ip}"]
}

output "nodes_private_ip" {
  value = ["${aws_instance.nodes.*.private_ip}"]
}
