# platform-registry

Shared Azure Container Registry for platform Bicep modules, provisioned with Terraform and published via GitHub Actions.

## Overview

This repository manages:

1. **Azure Container Registry (ACR)** — deployed via Terraform to host reusable Bicep modules.
2. **Bicep Modules** — a catalogue of reusable Azure Bicep modules published to ACR with NerdBank GitVersioning.

## Repository Layout

- `terraform/` — Terraform configuration for ACR infrastructure (providers, variables, tfvars, backends).
- `modules/` — Bicep modules, each containing `main.bicep` and `version.json` (NerdBank GitVersioning).
- `scripts/` — Utility scripts including the ACR publish script.
- `.github/workflows/` — GitHub Actions CI/CD pipelines.

## Bicep Modules

| Module | Description |
|---|---|
| `apiManagementLogger` | API Management diagnostic logger |
| `apiManagementSubscription` | API Management subscription |
| `appConfigurationStore` | App Configuration store |
| `appInsights` | Application Insights instance |
| `frontDoorCNAME` | Front Door CNAME record |
| `frontDoorEndpoint` | Front Door endpoint |
| `keyVault` | Key Vault |
| `keyVaultAccessPolicy` | Key Vault access policy |
| `keyVaultRoleAssignment` | Key Vault role assignment |
| `keyVaultSecret` | Key Vault secret |
| `sqlDatabase` | SQL Database |
| `storageAccount` | Storage Account |
| `webTest` | Application Insights web test |

## Versioning

Modules are versioned using [NerdBank GitVersioning](https://github.com/dotnet/Nerdbank.GitVersioning). Each module has its own `version.json` with `pathFilters` scoped to its folder. Version height is computed from git commit history.

On push to `main`, the `publish-modules.yml` workflow:
1. Detects which module folders changed.
2. Resolves the version via `nbgv get-version`.
3. Creates git tags (`{module}/v{X.Y.Z}`, rolling `{module}/v{X.Y}`, `{module}/v{X}`).
4. Publishes to ACR with tags: `V{X.Y.Z}`, `V{X}.x`, `V{X.Y}.x`, and `latest`.

## CI/CD Workflows

| Workflow | Trigger | Purpose |
|---|---|---|
| `deploy-prd.yml` | Push to main, schedule, manual | Terraform plan+apply dev → prd |
| `deploy-dev.yml` | Manual dispatch | Terraform plan+apply dev only |
| `publish-modules.yml` | Push to main (modules changed) | Publish Bicep modules to ACR |
| `pr-verify.yml` | Pull requests | Bicep validation + Terraform plan |
| `build-and-test.yml` | Feature/bugfix/hotfix branches | Bicep validation + Terraform plan |
| `codequality.yml` | Push to main, PRs, weekly schedule | Security scanning + dependency review |
| `dependabot-automerge.yml` | Dependabot PRs | Auto-merge dependency updates |

## Local Development

```bash
# Validate Bicep modules
for module in modules/*/main.bicep; do az bicep build --file "$module"; done

# Terraform init and plan
cd terraform
terraform init -backend-config="backends/dev.backend.hcl"
terraform plan -var-file="tfvars/dev.tfvars"
```

## Local dev: MCP wire-up

This repo wires the `frasermolyneux-copilot` MCP server so the GitHub Copilot coding agent (and any MCP-capable client) can query the shared org catalog (`frasermolyneux/.github-copilot`) for instructions, prompts, and agents.

- Coding-agent config: `.github/copilot/mcp_config.json` (loaded by `copilot-setup-steps.yml`, which checks out `.github-copilot/` at the pinned tag and builds the MCP server).
- Local VS Code / Copilot CLI: point your client at the same `node .github-copilot/mcp-server/dist/index.js` entry, or use the repo-local `.vscode/mcp.json` once added.

See [`.github-copilot/mcp-server/README.md`](https://github.com/frasermolyneux/.github-copilot/blob/main/mcp-server/README.md) in the catalog repo for the tool surface, content-root resolution, and client-specific wire-up snippets.
