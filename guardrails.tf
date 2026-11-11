# Configurações da CONTA, não de um recurso. Valem para tudo que for criado
# depois, por qualquer pessoa, com ou sem Terraform.

resource "aws_s3_account_public_access_block" "conta" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_ebs_encryption_by_default" "conta" {
  enabled = true
}

resource "aws_budgets_budget" "mensal" {
  name         = "orcamento-mensal"
  budget_type  = "COST"
  limit_amount = tostring(var.orcamento_mensal_usd)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  dynamic "notification" {
    for_each = length(var.emails_alerta_custo) > 0 ? [80, 100] : []

    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "FORECASTED"
      subscriber_email_addresses = var.emails_alerta_custo
    }
  }
}
