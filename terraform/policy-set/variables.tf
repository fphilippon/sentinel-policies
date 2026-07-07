variable "tfe_hostname" {
  description = "HCP Terraform or Terraform Enterprise hostname."
  type        = string
  default     = "app.terraform.io"
}

variable "organization" {
  description = "HCP Terraform organization name."
  type        = string
}

variable "policy_set_name" {
  description = "Name of the Sentinel policy set."
  type        = string
  default     = "global-governance"
}

variable "policy_set_description" {
  description = "Description shown in HCP Terraform."
  type        = string
  default     = "Pilot Sentinel policy set for common governance controls."
}

variable "vcs_repo_identifier" {
  description = "VCS repository identifier, for example github-user/repo-name."
  type        = string
  default     = "fphilippon/sentinel-policies"
}

variable "vcs_branch" {
  description = "Branch HCP Terraform should sync."
  type        = string
  default     = "main"
}

variable "oauth_token_id" {
  description = "OAuth token ID from the HCP Terraform VCS connection."
  type        = string
  default     = null
  sensitive   = true
}

variable "github_app_installation_id" {
  description = "Internal HCP Terraform GitHub App installation ID. Use this instead of oauth_token_id when already known."
  type        = string
  default     = null
}

variable "github_app_installation_number" {
  description = "GitHub-side installation number from the GitHub App configuration URL, for example https://github.com/settings/installations/12345678."
  type        = number
  default     = null
}

variable "github_app_installation_name" {
  description = "GitHub user or organization account name that installed the Terraform Cloud GitHub App."
  type        = string
  default     = null
}

variable "working_directory" {
  description = "Deprecated. Use policy_sets instead."
  type        = string
  default     = "policy-sets/global-governance"
}

variable "gcp_baseline_policy_set_name" {
  description = "Deprecated. Use policy_sets instead."
  type        = string
  default     = "gcp-baseline"
}

variable "gcp_baseline_policy_set_description" {
  description = "Deprecated. Use policy_sets instead."
  type        = string
  default     = "GCP security baseline controls for public exposure and managed-service hardening."
}

variable "gcp_baseline_working_directory" {
  description = "Deprecated. Use policy_sets instead."
  type        = string
  default     = "policy-sets/gcp-baseline"
}

variable "policy_sets" {
  description = "Policy sets to create from the configured VCS repository. The map key is used as the HCP Terraform policy set name."
  type = map(object({
    description   = string
    policies_path = string
  }))
  default = {
    global-governance = {
      description   = "Pilot Sentinel policy set for common governance controls."
      policies_path = "policy-sets/global-governance"
    }
    gcp-baseline = {
      description   = "GCP security baseline controls for public exposure and managed-service hardening."
      policies_path = "policy-sets/gcp-baseline"
    }
  }
}

variable "project_ids" {
  description = "HCP Terraform project IDs to attach the policy set to. Prefer this for the pilot project when available."
  type        = list(string)
  default     = []
}

variable "workspace_ids" {
  description = "Workspace IDs to attach the policy set to when workspace-level scoping is required."
  type        = list(string)
  default     = []
}

variable "global" {
  description = "Whether to apply the policy set to all workspaces in the organization."
  type        = bool
  default     = false
}
