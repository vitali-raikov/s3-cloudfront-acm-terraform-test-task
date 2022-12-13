globals {
  ### TERRAFORM ###############################################################

  ### global variables for use when generating providers
  # all variables defined here can be overwritten in any sub-directory and on the
  # stack level
  account_name                          = global.account_name_2
  terraform_provider_aws_config_profile = "bolt-${global.account_name}"
}
