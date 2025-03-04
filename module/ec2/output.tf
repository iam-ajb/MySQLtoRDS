output "ec2_sg" {

  description = "ec2 sg id"
  value       = aws_security_group.ec2_sg.id

}
