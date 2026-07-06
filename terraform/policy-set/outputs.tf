output "policy_set_id" {
  description = "Created HCP Terraform policy set ID."
  value       = tfe_policy_set.global_governance.id
}

output "policy_set_name" {
  description = "Created HCP Terraform policy set name."
  value       = tfe_policy_set.global_governance.name
}

