# NOTE: Update resource_group_name and storage_account_name after deploying
# platform-workloads with the platform-registry workload JSON.
# These values come from the platform-workloads Terraform output:
#   workload_terraform_backends["platform-registry"]["Production"]
resource_group_name  = "PLACEHOLDER-UPDATE-AFTER-PLATFORM-WORKLOADS-DEPLOY"
storage_account_name = "PLACEHOLDER-UPDATE-AFTER-PLATFORM-WORKLOADS-DEPLOY"
container_name       = "tfstate"
key                  = "terraform.tfstate"
use_oidc             = true
use_azuread_auth     = true
subscription_id      = "7760848c-794d-4a19-8cb2-52f71a21ac2b"
tenant_id            = "e56a6947-bb9a-4a6e-846a-1f118d1c3a14"
