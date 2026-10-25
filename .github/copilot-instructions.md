# Copilot Instructions

## Repository purpose

`platform-registry` manages the shared Azure Container Registry used for platform Bicep modules. Terraform owns the registry infrastructure; module sources under `modules/` are versioned and published separately.

## Layout and boundaries

- `terraform/container_registry.tf` defines the ACR.
- `terraform/remote_state.tf` resolves environment resource groups from `platform-workloads`.
- `terraform/backends/{dev,prd}.backend.hcl` and `terraform/tfvars/{dev,prd}.tfvars` are matching environment pairs.
- `modules/*/main.bicep` contains module source.
- `modules/*/version.json` controls NerdBank.GitVersioning for each module.
- `scripts/Publish-BicepModuleToAcr.ps1` and `.github/workflows/` implement publication.

CLI compatibility and provider constraints are authoritative in `terraform/providers.tf`; exact selections come from the committed root CLI pin and provider lock. Do not change these constraints during unrelated work.

Module versions come from NerdBank.GitVersioning and git history. Do not introduce `metadata.json`. Change a module's `version.json` only for an intentional major or minor version decision.

## Validation and planning

Documentation and Copilot configuration changes require `git diff --check` and link review; they do not require Terraform or Bicep builds.

For Terraform changes:

```pwsh
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend=false -lockfile=readonly
terraform -chdir=terraform validate
```

Run a state-backed plan only for registry infrastructure changes:

```pwsh
terraform -chdir=terraform init -lockfile=readonly -reconfigure -backend-config=backends/dev.backend.hcl
terraform -chdir=terraform plan -var-file=tfvars/dev.tfvars
```

Substitute both `dev` values with `prd` for production.

For each changed Bicep module:

```pwsh
az bicep lint --file modules/<name>/main.bicep
az bicep build --file modules/<name>/main.bicep
```

## Safety

- Preserve the `platform-workloads` remote-state contract and environment pairing.
- Treat ACR deletion, SKU, retention, networking, role assignment, and publication changes as consumer-impacting.
- Do not apply, import, move, or remove state unless explicitly requested.
- Use OIDC or managed identity; never add client secrets, registry credentials, tokens, or connection strings.
- Commit each root's `.terraform-version` and `.terraform.lock.hcl`. Select the exact root CLI pin before invoking Terraform; normal initialization uses `-lockfile=readonly`. Regenerate provider selections only in a reviewed dependency-update PR; never commit state, plans, or `.terraform/`.

Repository overview and consumer context are in [README.md](../README.md).
