output "endpoint" {
  description = "The endpoint of the Elastic Cache cluster"
  value       = aws_elasticache_serverless_cache.example.endpoint.address
}
