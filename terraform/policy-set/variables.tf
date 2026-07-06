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
  description = "GitHub App installation ID for the HCP Terraform VCS connection. Use this instead of oauth_token_id when applicable."
  type        = string
  default     = null
}

variable "working_directory" {
  description = "Directory containing sentinel.hcl for the policy set."
  type        = string
  default     = "policy-sets/global-governance"
}

variable "project_ids" {
  description = "HCP Terraform project IDs to attach the policy set to. Prefer this for the pilot project when available."
  type        = list(string)
  default     = []
}

variable "workspace_ids" {
  description = "Workspace IDs to attach the policy set to for a narrow personal-org pilot."
  type        = list(string)
  default     = []
}

variable "global" {
  description = "Whether to apply the policy set to all workspaces in the organization."
  type        = bool
  default     = false
}
