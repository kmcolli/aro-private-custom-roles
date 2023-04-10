# Example of Using Terraform to build a private ARO cluster

This is an example of using the terraform provider for Azure Red Hat OpenShift https://github.com/rh-mobb/terraform-provider-azureopenshift 

This example does the following:
1. Registers the [UserDefinedRouting](https://learn.microsoft.com/en-us/azure/openshift/howto-create-private-cluster-4x#create-a-private-cluster-without-a-public-ip-address-preview) feature flag

2. Creates a Resource Group for the Virtual Network ARO will use along with 2 private subnets, one for the control plane and one for the worker nodes.

3.  A service principal is created and assigned limited set of permissions for both the VNET and Cluster itself.
The custom roles are specified in the variable.tf file
    
* vnet_role
* rp_role

4. A private ARO Cluster that uses User Defined Routing i.e. no public IPs 


