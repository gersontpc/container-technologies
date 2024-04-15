output "mamager_public_ip" {
  value = ["${aws_instance.manager.*.public_ip}"]
}

output "nodes_public_ip" {
  value = ["${aws_instance.nodes.*.public_ip}"]
}