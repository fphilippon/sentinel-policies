data "tfe_github_app_installation" "selected" {
  count = var.github_app_installation_id == null && (var.github_app_installation_number != null || var.github_app_installation_name != null) ? 1 : 0

  installation_id = var.github_app_installation_number
  name            = var.github_app_installation_name
}

locals {
  github_app_installation_id = var.github_app_installation_id != null ? var.github_app_installation_id : try(data.tfe_github_app_installation.selected[0].id, null)
  vcs_auth_method_count = length([
    for enabled in [
      var.oauth_token_id != null,
      var.github_app_installation_id != null,
      var.github_app_installation_number != null,
      var.github_app_installation_name != null
    ] : enabled if enabled
  ])
}

resource "tfe_policy_set" "global_governance" {
  name          = var.policy_set_name
  description   = var.policy_set_description
  organization  = var.organization
  kind          = "sentinel"
  global        = var.global
  policies_path = var.working_directory

  vcs_repo {
    identifier                 = var.vcs_repo_identifier
    branch                     = var.vcs_branch
    oauth_token_id             = var.oauth_token_id
    github_app_installation_id = local.github_app_installation_id
  }
}

resource "tfe_project_policy_set" "global_governance" {
  for_each = toset(var.project_ids)

  project_id    = each.value
  policy_set_id = tfe_policy_set.global_governance.id
}

resource "tfe_workspace_policy_set" "global_governance" {
  for_each = toset(var.workspace_ids)

  workspace_id  = each.value
  policy_set_id = tfe_policy_set.global_governance.id
}

check "policy_set_scope" {
  assert {
    condition     = local.vcs_auth_method_count == 1
    error_message = "Set exactly one VCS authentication method: oauth_token_id, github_app_installation_id, github_app_installation_number, or github_app_installation_name."
  }

  assert {
    condition     = var.global || length(var.project_ids) > 0 || length(var.workspace_ids) > 0
    error_message = "Set global = true or provide at least one project_id or workspace_id."
  }

  assert {
    condition     = !(var.global && (length(var.project_ids) > 0 || length(var.workspace_ids) > 0))
    error_message = "Use either global scope or explicit project/workspace attachments, not both."
  }
}
