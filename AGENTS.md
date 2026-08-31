# AGENTS.md - platform-registry

This repository owns the shared Azure Container Registry used for platform Bicep modules and the module sources published to it. Terraform manages registry infrastructure; GitHub Actions and PowerShell publish versioned Bicep modules.

## Key locations

- `terraform/` - registry infrastructure and `platform-workloads` remote state.
- `modules/*/main.bicep` - published module sources.
- `modules/*/version.json` - NerdBank.GitVersioning scope and version.
- `scripts/Publish-BicepModuleToAcr.ps1` - module publication.
- `.github/workflows/` - infrastructure deployment and module publishing.

## Validation

For documentation or Copilot-configuration-only changes:

```pwsh
git diff --check
```

For Terraform changes:

```pwsh
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend=false -upgrade
terraform -chdir=terraform validate
```

For a changed module:

```pwsh
az bicep lint --file modules/<name>/main.bicep
az bicep build --file modules/<name>/main.bicep
```

Run a state-backed plan only for registry infrastructure changes, using matching `dev` or `prd` backend and tfvars files.

## Guardrails

- Preserve the boundary between registry infrastructure and module publication.
- Module versions come from `version.json` and git history; do not add `metadata.json`.
- Preserve the `platform-workloads` remote-state contract.
- ACR deletion, SKU, retention, networking, or permission changes can affect all module consumers.
- Use OIDC or managed identity; never add credentials.
- `.terraform.lock.hcl` is local generated state, ignored, and not committed.

See [README.md](README.md) and the workflows beside the publishing script.
