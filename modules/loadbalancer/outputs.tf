output "dns_name " {
  description = "The DNS name of the load balancer"
  value       = aws_lb.test.dns_name
}