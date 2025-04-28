resource "aws_ssm_parameter" "database_hostname" {
  name  = "/searchkick-playground/database/hostname"
  type  = "String"
  value = aws_db_instance.this.address
}

resource "aws_ssm_parameter" "database_username" {
  name  = "/searchkick-playground/database/username"
  type  = "String"
  value = var.database_username
}

resource "aws_ssm_parameter" "database_password" {
  name  = "/searchkick-playground/database/password"
  type  = "SecureString"
  value = var.database_password
}

resource "aws_ssm_parameter" "opensearch_url" {
  name  = "/searchkick-playground/opensearch/url"
  type  = "String"
  value = aws_opensearch_domain.this.endpoint
}
