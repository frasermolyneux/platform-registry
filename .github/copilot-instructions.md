# Copilot Instructions

> Shared conventions: see [`.github-copilot/.github/instructions/terraform.instructions.md`](../../.github-copilot/.github/instructions/terraform.instructions.md) (sibling repo) for the standard Terraform layout, providers, remote-state pattern, validation commands, and CI/CD workflows.

## Org conventions via MCP (when available)

If a `frasermolyneux-copilot` MCP server is configured in your client (`.vscode/mcp.json`, the GitHub Copilot coding-agent MCP config at `.github/copilot/mcp_config.json`, or an equivalent stdio MCP wire-up), **prefer its tools** over your own assumptions when answering questions about org standards, branching, workflows, Terraform, .NET projects, Azure patterns, or shared library / platform consumption contracts. The tool surface is `list_instructions`, `get_instruction`, `search_instructions`, plus the matching `_prompts` and `_agents` equivalents (seven tools total). The catalog source-of-truth lives in `frasermolyneux/.github-copilot` — see `mcp-server/README.md` there for the tool contract.

This is **complementary** to the file-load model: if `./.github-copilot/` is checked out in the runner (per `copilot-setup-steps.yml`), continue to read those files directly. If both are available, prefer MCP for freshness. If no MCP server is configured in your client, treat this section as a no-op and fall back to the file paths above.

## Project Overview

This repository manages a shared Azure Container Registry (ACR) for platform Bicep modules. Infrastructure is provisioned with Terraform and modules are published via GitHub Actions using NerdBank GitVersioning.

## Repository Specifics

- `terraform/container_registry.tf` — ACR resource definition.
- `modules/` — Bicep modules, each containing `main.bicep` and `version.json`.
- `scripts/Publish-BicepModuleToAcr.ps1` — Publishes modules to ACR.

## Stack-specific conventions

- Run `az bicep build --file modules/<name>/main.bicep` to validate before committing.
- The ACR is deployed per environment but modules are only published to production.
- Requires Azure CLI with the Bicep extension.

## Versioning

Modules use NerdBank GitVersioning. Each module has a `version.json` with `pathFilters` scoped to its folder. Version height is computed from git history. Do not use `metadata.json` — versions come from NBGV.

When changing a module's `main.bicep`, the version patch is auto-incremented on merge to `main`. To bump major or minor, update the `version` field in the module's `version.json`.

## Module Publishing Workflow

In addition to the standard platform CI/CD workflows, this repo has:

- `publish-modules.yml` — Detects changed modules on push to main, resolves NBGV version, publishes to ACR, creates git tags.
- `pr-verify.yml` and `build-and-test.yml` add Bicep validation alongside the standard Terraform plan steps.
