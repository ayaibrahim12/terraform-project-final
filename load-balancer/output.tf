output "lb-dns" {
  value = aws_alb.load-balancer.dns_name
}