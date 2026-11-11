data "aws_caller_identity" "atual" {}

# Módulo DA ORG, do monorepo terraform-modules, pinado pela tag do módulo.
module "bucket_logs" {
  source = "git::https://github.com/terraform-em-producao/terraform-modules.git//modules/s3-bucket-seguro?ref=s3-bucket-seguro/v1.0.0"

  nome                            = "tep-shared-logs-${data.aws_caller_identity.atual.account_id}"
  expirar_versoes_antigas_em_dias = 30
}
