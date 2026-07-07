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

  project_policy_set_attachments = merge([
    for policy_set_key, policy_set in var.policy_sets : {
      for project_id in var.project_ids : "${policy_set_key}:${project_id}" => {
        policy_set_key = policy_set_key
        project_id     = project_id
      }
    }
  ]...)

  workspace_policy_set_attachments = merge([
    for policy_set_key, policy_set in var.policy_sets : {
      for workspace_id in var.workspace_ids : "${policy_set_key}:${workspace_id}" => {
        policy_set_key = policy_set_key
        workspace_id   = workspace_id
      }
    }
  ]...)
}

resource "tfe_policy_set" "this" {
  for_each = var.policy_sets

  name          = each.key
  description   = each.value.description
  organization  = var.organization
  kind          = "sentinel"
  global        = var.global
  policies_path = each.value.policies_path

  vcs_repo {
    identifier                 = var.vcs_repo_identifier
    branch                     = var.vcs_branch
    oauth_token_id             = var.oauth_token_id
    github_app_installation_id = local.github_app_installation_id
  }
}

resource "tfe_project_policy_set" "this" {
  for_each = local.project_policy_set_attachments

  project_id    = each.value.project_id
  policy_set_id = tfe_policy_set.this[each.value.policy_set_key].id
}

resource "tfe_workspace_policy_set" "this" {
  for_each = local.workspace_policy_set_attachments

  workspace_id  = each.value.workspace_id
  policy_set_id = tfe_policy_set.this[each.value.policy_set_key].id
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
