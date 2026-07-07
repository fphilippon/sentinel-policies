moved {
  from = tfe_policy_set.global_governance
  to   = tfe_policy_set.this["global-governance"]
}

moved {
  from = tfe_policy_set.gcp_baseline
  to   = tfe_policy_set.this["gcp-baseline"]
}
