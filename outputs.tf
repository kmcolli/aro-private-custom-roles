output "SP_Password" {
    value   = azuread_service_principal_password.cluster.value
    description = "The service principal password"
    sensitive = true
}

output "kubeadmin_password" {
    value = nonsensitive(azureopenshift_redhatopenshift_cluster.cluster.kubeadmin_password)
}
