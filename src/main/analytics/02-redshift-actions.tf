resource "aws_redshift_scheduled_action" "analytics_resume" {
  name     = format("%s-analytics-redshift-resume-%s", local.project, var.env)
  schedule = "cron(0 8 ? * 2-6 *)"
  iam_role = aws_iam_role.analytics_scheduled_actions.arn

  target_action {
    resume_cluster {
      cluster_identifier = aws_redshift_cluster.analytics.cluster_identifier
    }
  }
}

resource "aws_redshift_scheduled_action" "analytics_pause" {
  name     = format("%s-analytics-redshift-pause-%s", local.project, var.env)
  schedule = "cron(0 20 ? * 2-6 *)"
  iam_role = aws_iam_role.analytics_scheduled_actions.arn

  target_action {
    pause_cluster {
      cluster_identifier = aws_redshift_cluster.analytics.cluster_identifier
    }
  }
}
