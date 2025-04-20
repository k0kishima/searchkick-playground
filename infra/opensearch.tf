data "aws_caller_identity" "current" {}

resource "aws_opensearch_domain" "this" {
  domain_name    = "${var.project_name}-search"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type          = var.opensearch_cluster_instance_type
    instance_count         = var.opensearch_cluster_instance_count
    zone_awareness_enabled = false
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.opensearch_ebs_volume_size
    volume_type = "gp3"
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
  }

  vpc_options {
    subnet_ids         = [aws_subnet.private[0].id]
    security_group_ids = [aws_security_group.opensearch.id]
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true

    master_user_options {
      master_user_name     = "admin"
      master_user_password = var.opensearch_master_user_password
    }
  }
  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.ecs_task_role.arn
        },
        Action = [
          "es:ESHttpGet",
          "es:ESHttpPost",
          "es:ESHttpPut",
          "es:ESHttpDelete",
          "es:ESHttpHead"
        ]
        Resource = "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.project_name}-search/*"
      }
    ]
  })
}
