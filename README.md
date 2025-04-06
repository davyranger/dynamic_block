# Terraform Infrastructure Deployment in Azure Using OIDC

This guide provides instructions for deploying Terraform infrastructure in Azure using OpenID Connect (OIDC) with GitHub Actions.

---

## Prerequisites

### GitHub Actions
[GitHub Actions Marketplace](https://github.com/marketplace)
[**shift security left** with Static Application Security Testing (SAST)](https://github.com/aquasecurity/tfsec)

### Terraform Azure Provider
[Terraform Azure provider configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Azure Backend
Ensure the Azure Resource Manager (AzureRM) backend is configured in your Terraform setup main.tf parent_directory. The backend must already exist and be accessible.

### GitHub Secrets
The following secrets must be defined in your GitHub repository for authentication with Azure:
- `AZURE_CLIENT_ID`: The Azure Active Directory client (application) ID.
- `AZURE_SUBSCRIPTION_ID`: The Azure subscription ID.
- `AZURE_TENANT_ID`: The Azure Active Directory tenant ID.

Example:
```yaml
ARM_CLIENT_ID: "${{ secrets.AZURE_CLIENT_ID }}"
ARM_SUBSCRIPTION_ID: "${{ secrets.AZURE_SUBSCRIPTION_ID }}"
ARM_TENANT_ID: "${{ secrets.AZURE_TENANT_ID }}"
```

### Special Permissions Required for OIDC Authentication

1. **Configure GitHub Actions Permissions**  
   Follow the guide to configure permissions for GitHub Actions:  
   [GitHub Actions Permissions Guide](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect#adding-permissions-settings)

2. **Configure Azure Resources for OIDC**  
   Learn how to configure Azure resources to use OIDC:  
   [Azure OIDC Configuration Guide](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect#prerequisites)

3. **Register an App in Microsoft Entra ID Tenant**  
   Follow the steps to register an application in the Microsoft Entra ID (Azure Active Directory):  
   [Register an Application Guide](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal#prerequisites)

4. **Configure an app to trust an external identity provider**
    This describes how to manage a federated identity credential on an application in Microsoft Entra ID:
    [Configure a federated identity credential on an app](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?/pivots=identity-wif-apps-methods-azp#configure-a-federated-identity-credential-on-an-app)

5. **Authenticating using a Service Principal with Open ID Connect**
    Setting up an Application and Service Principal in Azure
    [Configure Azure Active Directory Application to Trust a GitHub Repository](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_oidc)

---

## Instructions

### 1. Clone the Repository
Clone the repository to your local machine:
```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Configure Terraform Variables
Ensure that all required variables for your Terraform setup are defined. These can be passed via:
- `.tfvars` files
- Environment variables
- Directly in the Terraform code (not recommended for sensitive data)

### 3. Initialize Terraform
Run the following command to initialize Terraform. This will configure the backend and download required provider plugins:
```bash
terraform init
```

### 4. Validate the Configuration
Check that the configuration is syntactically valid:
```bash
terraform validate
```

### 5. Plan the Deployment
Generate and review an execution plan:
```bash
terraform plan
```

### 6. Apply the Changes
Deploy the infrastructure to Azure:
```bash
terraform apply
```

### 7. GitHub Actions Workflow
To trigger the deployment through GitHub Actions:
1. Push your changes to the repository.
2. GitHub Actions will automatically authenticate using OIDC and deploy the infrastructure.

### 8. Destroy Resources (Optional)
To remove the deployed infrastructure, run:
```bash
terraform destroy
```

---

## Notes

- Ensure you have the correct permissions in Azure for the service principal tied to the OIDC configuration.
- The GitHub Actions workflow uses OIDC for secure authentication without requiring long-lived credentials.

## Troubleshooting

- **Authentication Issues**: Verify that the GitHub secrets are correctly set and the service principal has the necessary permissions in Azure.
- **Backend Errors**: Ensure that the AzureRM backend is correctly configured and accessible.

For further assistance, refer to:
- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

