provider "aws" {
  region = var.regiao

  # O Atlantis entra com a task role e assume a role desta stack.
  # No drift detection o GitHub Actions já chega com a role de leitura,
  # então a variável vem vazia e o bloco some.
  dynamic "assume_role" {
    for_each = var.assume_role_arn == "" ? [] : [var.assume_role_arn]

    content {
      role_arn     = assume_role.value
      session_name = "atlantis-groundwork"
    }
  }

  default_tags {
    tags = {
      projeto     = "terraform-em-producao"
      repositorio = "${var.github_org}/groundwork"
      gerenciado  = "terraform"
      ambiente    = "shared"
    }
  }
}
