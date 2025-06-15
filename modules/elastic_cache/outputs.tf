output "endpoint" {
  description = "The endpoint of the Elastic Cache cluster"
  value       = aws_elasticache_serverless_cache.example.endpoint
}
# output "address" {
#   description = "The address of the Elastic Cache cluster"
#   value       = aws_elasticache_serverless_cache.example[0].address
# }