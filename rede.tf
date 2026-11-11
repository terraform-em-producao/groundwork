# ---------------------------------------------------------------------------
# VPC compartilhada da conta, usando o módulo OFICIAL da comunidade.
# Regra da org: não reescrevemos o que a comunidade já mantém bem.
# Pinado em versão exata — atualizar é PR com plan revisado.
# ---------------------------------------------------------------------------
data "aws_availability_zones" "disponiveis" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.disponiveis.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  name = "compartilhada"
  cidr = var.cidr_vpc
  azs  = local.azs

  public_subnets  = [for i, _ in local.azs : cidrsubnet(var.cidr_vpc, 8, i)]
  private_subnets = [for i, _ in local.azs : cidrsubnet(var.cidr_vpc, 8, i + 10)]

  # NAT custa ~US$ 32/mês por AZ. Ligue quando houver workload privado.
  enable_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  # Outras stacks encontram a rede por tag (data "aws_subnets"),
  # sem ler o state do groundwork.
  public_subnet_tags  = { camada = "publica" }
  private_subnet_tags = { camada = "privada" }
}
