terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

resource "datadog_synthetics_global_variable" "wam_username" {
  name        = "PLAYBYPOINT_USERNAME"
  description = "Username to wam.playbypoint.com"
  value       = var.wam_username
}

resource "datadog_synthetics_global_variable" "wam_password" {
  name        = "PLAYBYPOINT_PASSWORD"
  description = "Password to wam.playbypoint.com"
  value       = var.wam_password
  secure      = true
}
