# TODO: refactor
resource "aws_secretsmanager_secret" "anac" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/anac"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "anac"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "selfcare_v2" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/selfcare-v2"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "selfcare-v2"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "postgres" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/postgres"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "postgres"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "documentdb" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/documentdb"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "documentdb"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "metrics_reports" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/metrics-reports"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "metrics-reports"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "smtp_reports" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/smtp-reports"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "smtp-reports"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "pn_consumers" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/pn-consumers"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "pn-consumers"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "onetrust" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/onetrust"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "onetrust"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "smtp_certified" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/smtp-certified"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "smtp-certified"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "support_saml" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/support-saml"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "support-saml"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "event_store" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/event-store"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "event-store"
    }
  )
}

# TODO: refactor
resource "aws_secretsmanager_secret" "read_model" {
  count = local.deployment_repo_v2_active ? 1 : 0

  name = "app/backend/read-model"

  tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "read-model"
    }
  )
}
