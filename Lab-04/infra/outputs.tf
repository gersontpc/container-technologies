output "manager_private_ips" {
  description = "Lista de IPs privados dos managers"
  value = [
    for instance in aws_instance.swarm :
    instance.private_ip if index(aws_instance.swarm.*.id, instance.id) < var.cluster["manager"]
  ]
}

output "worker_private_ips" {
  description = "Lista de IPs privados dos workers"
  value = [
    for instance in aws_instance.swarm :
    instance.private_ip if index(aws_instance.swarm.*.id, instance.id) >= var.cluster["manager"]
  ]
}

output "manager_urls" {
  description = "URLs acessíveis no IP público do primeiro manager"
  value = {
    Portainer = format("http://%s:9000", aws_instance.swarm[0].public_ip)
    2048       = format("http://%s:8080", aws_instance.swarm[0].public_ip)
  }
}