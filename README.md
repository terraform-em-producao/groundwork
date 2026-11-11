# groundwork

A base compartilhada da conta: o que todo o resto usa e que muda pouco.

| Arquivo | O quê | Módulo |
|---|---|---|
| `rede.tf` | VPC `10.0.0.0/16`, 3 AZs, subnets públicas e privadas, sem NAT | **oficial** `terraform-aws-modules/vpc/aws` `6.7.3` |
| `logs.tf` | Bucket de logs compartilhado | **da org** `terraform-modules//modules/s3-bucket-seguro` `v1.0.0` |
| `guardrails.tf` | Bloqueio público de S3 na conta, EBS criptografado por padrão, orçamento | recursos diretos |

## Módulo oficial ou módulo da org?

- **Oficial** quando o problema é genérico e a comunidade mantém bem (VPC, EKS, RDS). Pine a versão exata.
- **Da org** quando o módulo carrega uma *decisão da empresa*: nome padrão, criptografia obrigatória, tags. É o lugar de codificar "o jeito certo".
- **Recurso direto** quando é um recurso só e não há decisão para reaproveitar.

## Como muda

Só por PR. O Atlantis faz o plan, roda as policies e aplica usando a role `terraform-exec-groundwork`, criada no `bootstrap` com permissão só de VPC, buckets `tep-shared-*`, budgets e configurações de conta.

## Como outras stacks usam a rede

Por tag, sem ler este state:

```hcl
data "aws_vpc" "compartilhada" {
  tags = { Name = "compartilhada" }
}

data "aws_subnets" "privadas" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.compartilhada.id]
  }
  tags = { camada = "privada" }
}
```

## Drift

`drift.yml` roda em dias úteis com a role `github-drift` (somente leitura) e abre uma issue com label `drift` se a conta divergir da `main`.
