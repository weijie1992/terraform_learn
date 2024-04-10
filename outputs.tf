output "public_ip" {
  description = "DNS of the application load balancer"
  sensitive   = false
  value       = aws_lb.weijieexample.dns_name
}
