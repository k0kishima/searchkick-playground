output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "opensearch_endpoint" {
  value = aws_opensearch_domain.this.endpoint
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}
