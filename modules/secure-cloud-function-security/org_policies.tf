/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  project      = var.policy_for == "project" ? var.serverless_project_id : ""
  folder       = var.policy_for == "folder" ? var.folder_id : ""
  organization = var.policy_for == "organization" ? var.organization_id : ""
}

module "cloudfunction_allowed_ingress" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 7.0"

  policy_for        = var.policy_for
  project_id        = local.project
  folder_id         = local.folder
  organization_id   = local.organization
  constraint        = "constraints/cloudfunctions.allowedIngressSettings"
  policy_type       = "list"
  allow             = ["ALLOW_INTERNAL_ONLY"]
  allow_list_length = 1
}

module "cloudfunction_allowed_vpc_egress" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 7.0"

  policy_for      = var.policy_for
  project_id      = local.project
  folder_id       = local.folder
  organization_id = local.organization
  constraint      = "constraints/cloudfunctions.requireVPCConnector"
  policy_type     = "boolean"
  enforce         = "true"
}

module "cloudfunction_vpc_connector_egress_settings" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 7.0"

  policy_for        = var.policy_for
  project_id        = local.project
  folder_id         = local.folder
  organization_id   = local.organization
  policy_type       = "list"
  constraint        = "cloudfunctions.allowedVpcConnectorEgressSettings"
  allow             = ["ALL_TRAFFIC"]
  allow_list_length = 1
}

module "cloudrun_allowed_ingress" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 7.0"

  policy_for        = var.policy_for
  project_id        = local.project
  folder_id         = local.folder
  organization_id   = local.organization
  constraint        = "constraints/run.allowedIngress"
  policy_type       = "list"
  allow             = ["is:internal-and-cloud-load-balancing"]
  allow_list_length = 1
}

module "cloudrun_allowed_vpc_egress" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 7.0"

  policy_for        = var.policy_for
  project_id        = local.project
  folder_id         = local.folder
  organization_id   = local.organization
  constraint        = "constraints/run.allowedVPCEgress"
  policy_type       = "list"
  allow             = ["all-traffic"]
  allow_list_length = 1
}
