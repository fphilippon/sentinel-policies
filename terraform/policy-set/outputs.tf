output "global_governance_policy_set_id" {
  description = "Created global governance HCP Terraform policy set ID."
  value       = tfe_policy_set.this["global-governance"].id
}

output "global_governance_policy_set_name" {
  description = "Created global governance HCP Terraform policy set name."
  value       = tfe_policy_set.this["global-governance"].name
}

output "gcp_baseline_policy_set_id" {
  description = "Created GCP baseline HCP Terraform policy set ID."
  value       = tfe_policy_set.this["gcp-baseline"].id
}

output "gcp_baseline_policy_set_name" {
  description = "Created GCP baseline HCP Terraform policy set name."
  value       = tfe_policy_set.this["gcp-baseline"].name
}

output "policy_set_ids" {
  description = "Created HCP Terraform policy set IDs by policy set name."
  value = {
    for name, policy_set in tfe_policy_set.this : name => policy_set.id
  }
}
