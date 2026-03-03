output "instance_public_ip" {
  description = "The public IP of the web server"
  value       = aws_eip.web_ip.public_ip
}

output "instance_id" {
  description = "The EC2 instance ID"
  value       = aws_instance.web.id
}
