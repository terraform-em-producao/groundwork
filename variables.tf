variable "regiao" {
  type    = string
  default = "us-east-1"
}

variable "github_org" {
  type    = string
  default = "terraform-em-producao"
}

variable "assume_role_arn" {
  type    = string
  default = "arn:aws:iam::907079643427:role/terraform-exec-groundwork"
}

variable "cidr_vpc" {
  type    = string
  default = "10.0.0.0/16"
}

variable "orcamento_mensal_usd" {
  type    = number
  default = 100
}

variable "emails_alerta_custo" {
  description = "Quem recebe alerta de orçamento. Vazio = budget sem notificação."
  type        = list(string)
  default     = []
}
