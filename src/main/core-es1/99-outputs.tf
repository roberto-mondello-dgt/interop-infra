output "safe_storage_endpoint_host" {
  description = "Hostname to use into HTTP(S) requests to SafeStorage "
  value       = var.safe_storage_vpce_service_name != null ? module.safe_storage_vpce[0].endpoints["safe_storage"].dns_entry[0].dns_name : ""
}
