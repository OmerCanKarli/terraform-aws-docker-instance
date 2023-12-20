output "instance_public_ip" {
  value = aws_instance.docker_instance.*.public_ip #corrected
}

output "security_group_id" {
  value = aws_security_group.docker_instance_sec_grp.id
}

output "instance_id" {
  value = aws_instance.docker_instance.*.id
}