output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets_publicas" {
  value = module.vpc.public_subnets
}

output "subnets_privadas" {
  value = module.vpc.private_subnets
}

output "bucket_logs" {
  value = module.bucket_logs.id
}
