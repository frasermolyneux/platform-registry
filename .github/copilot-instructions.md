# Copilot Instructions

## Project Overview

This repository manages a shared Azure Container Registry (ACR) for platform Bicep modules. Infrastructure is provisioned with Terraform and modules are published via GitHub Actions using NerdBank GitVersioning.

## Repository Layout

- `terraform/` — Terraform configuration for ACR infrastructure.
  - `providers.tf` — azurerm provider and backend configuration.
  - `variables.tf` — input variables (environment, location, subscription, etc.).
  - `container_registry.tf` — ACR resource definition.
  - `locals.tf` — computed values and resource group lookups.
  - `remote_state.tf` — platform-workloads remote state reference.
  - `outputs.tf` — ACR name, login server, and resource ID.
  - `tfvars/` — per-environment variable files (dev.tfvars, prd.tfvars).
  - `backends/` — per-environment backend config (dev.backend.hcl, prd.backend.hcl).
- `modules/` — Bicep modules, each containing `main.bicep` and `version.json`.
- `scripts/` — `Publish-BicepModuleToAcr.ps1` for publishing modules to ACR.
- `.github/workflows/` — GitHub Actions CI/CD pipelines.

## Versioning

Modules use NerdBank GitVersioning. Each module has a `version.json` with `pathFilters` scoped to its folder. Version height is computed from git history. Do not use `metadata.json` — versions come from NBGV.

When changing a module's `main.bicep`, the version patch is auto-incremented on merge to `main`. To bump major or minor, update the `version` field in the module's `version.json`.

## CI/CD Workflows

- `deploy-prd.yml` — Terraform plan+apply dev then prd on push to main.
- `deploy-dev.yml` — Manual dispatch for dev-only deployment.
- `publish-modules.yml` — Detects changed modules on push to main, resolves NBGV version, publishes to ACR, creates git tags.
- `pr-verify.yml` — Bicep validation + Terraform plan on PRs.
- `build-and-test.yml` — Bicep validation + Terraform plan on feature branches.
- `codequality.yml` — Security scanning and dependency review.

## Conventions

- Run `az bicep build --file modules/<name>/main.bicep` to validate before committing.
- Terraform files must pass `terraform fmt -recursive`.
- Follow existing naming patterns for new modules.
- The ACR is deployed per environment but modules are only published to production.

## Dependencies

- Terraform >= 1.14.3, azurerm provider ~> 4.60.0
- Azure CLI with Bicep extension
- `frasermolyneux/actions` repository (for reusable GitHub Actions workflows)
- `platform-workloads` remote state (for resource group discovery)
