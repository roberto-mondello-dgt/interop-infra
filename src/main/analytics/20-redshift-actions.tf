resource "aws_redshift_scheduled_action" "analytics_resume" {
  count = local.deploy_redshift_cluster ? 1 : 0

  name     = format("%s-analytics-redshift-resume-%s", local.project, var.env)
  schedule = "cron(0 6 ? * 2-6 *)"
  iam_role = aws_iam_role.analytics_scheduled_actions[0].arn

  target_action {
    resume_cluster {
      cluster_identifier = aws_redshift_cluster.analytics[0].cluster_identifier
    }
  }
}

resource "aws_redshift_scheduled_action" "analytics_pause" {
  count = local.deploy_redshift_cluster ? 1 : 0

  name     = format("%s-analytics-redshift-pause-%s", local.project, var.env)
  schedule = "cron(0 18 ? * 2-6 *)"
  iam_role = aws_iam_role.analytics_scheduled_actions[0].arn

  target_action {
    pause_cluster {
      cluster_identifier = aws_redshift_cluster.analytics[0].cluster_identifier
    }
  }
}
