
module "vpn_automation_ses_iam_policy" {
  source = "./modules/ses-iam-policy"
  count  = var.env == "dev" ? 1 : 0

  env                            = var.env
  ses_iam_policy_name            = format("interop-vpn-automation-ses-policy-%s", var.env)
  ses_identity_arn               = module.internal_ses_identity[0].ses_identity_arn
  ses_configuration_set_arn      = module.internal_ses_identity[0].ses_configuration_set_arn
  allowed_recipients_regex       = ["*@pagopa.it"]
  allowed_recipients_literal     = ["manuel.morini@dxc.com"]
  allowed_from_addresses_literal = [format("noreply@%s", module.internal_ses_identity[0].ses_identity_name)]
}

module "vpn_automation" {
  source = "./modules/vpn-automation"
  count  = var.env == "dev" ? 1 : 0

  env          = var.env
  project_name = "interop"

  efs_clients_security_groups_ids = toset([aws_security_group.vpn_clients.id])
  mount_target_subnets_ids        = toset(data.aws_subnets.int_lbs.ids)
  lambda_function_subnets_ids     = toset(data.aws_subnets.int_lbs.ids)
  vpc_id                          = module.vpc.vpc_id
  vpn_endpoint_id                 = aws_ec2_client_vpn_endpoint.vpn.id
  client_vpn_endpoint_arn         = aws_ec2_client_vpn_endpoint.vpn.arn

  ses_from_address           = format("noreply@%s", module.internal_ses_identity[0].ses_identity_name)
  ses_from_display_name      = "Interop VPN"
  ses_mail_subject           = format("Interop VPN %s access", var.env)
  ses_configuration_set_name = module.internal_ses_identity[0].ses_configuration_set_name

  clients_diff_image_tag    = "latest"
  clients_updater_image_tag = "latest"

  efs_pki_directory = format("pki-%s", var.env)
}
