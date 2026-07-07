policy "no-gcp-compute-public-ip" {
  source            = "./no-gcp-compute-public-ip.sentinel"
  enforcement_level = "advisory"
}

policy "restrict-gcp-firewall-admin-ingress" {
  source            = "./restrict-gcp-firewall-admin-ingress.sentinel"
  enforcement_level = "advisory"
}

policy "require-gcs-bucket-security" {
  source            = "./require-gcs-bucket-security.sentinel"
  enforcement_level = "advisory"
}

policy "require-cloudsql-private-ip" {
  source            = "./require-cloudsql-private-ip.sentinel"
  enforcement_level = "advisory"
}
