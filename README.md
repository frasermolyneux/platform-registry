# platform-registry

[![Build and Test](https://github.com/frasermolyneux/platform-registry/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/build-and-test.yml)
[![Code Quality](https://github.com/frasermolyneux/platform-registry/actions/workflows/codequality.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/codequality.yml)
[![Dependabot Auto-Merge](https://github.com/frasermolyneux/platform-registry/actions/workflows/dependabot-automerge.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/dependabot-automerge.yml)
[![Deploy Dev](https://github.com/frasermolyneux/platform-registry/actions/workflows/deploy-dev.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/deploy-dev.yml)
[![Deploy Prd](https://github.com/frasermolyneux/platform-registry/actions/workflows/deploy-prd.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/deploy-prd.yml)
[![Destroy Development](https://github.com/frasermolyneux/platform-registry/actions/workflows/destroy-development.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/destroy-development.yml)
[![Destroy Environment](https://github.com/frasermolyneux/platform-registry/actions/workflows/destroy-environment.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/destroy-environment.yml)
[![PR Verify](https://github.com/frasermolyneux/platform-registry/actions/workflows/pr-verify.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/pr-verify.yml)

## Documentation

Documentation is being expanded in the docs folder.

## Overview

This repository provisions and manages the shared Azure Container Registry used for platform Bicep modules. Terraform defines and deploys the registry infrastructure, while module publishing is handled by GitHub Actions workflows. Module versioning is driven by Nerdbank.GitVersioning with per-module version scopes. The stack acts as a central module registry for downstream infrastructure repositories.

## Shared production registry

The production registry is intentionally shared with `portal-server-agent` development deployments. Environment isolation is enforced with separate repositories in the same registry:

- Production: `portal-server-agent`
- Development: `portal-server-agent-dev`

This repository's Terraform grants `AcrPull` to the production and development Container App managed identities and grants `AcrPush` to the `portal-server-agent` Development GitHub Actions OIDC principal at the registry scope only. `platform-workloads` separately grants that development principal `Storage Blob Data Reader` on the production platform-registry Terraform state so it can consume the registry output.

## Workload image registry

The stack also provisions a separate ACR for repository-owned bare-metal
workload images. It is created in `AbacRepositoryPermissions` mode so workload
OIDC identities can publish only to their assigned `workloads/<workload>`
repository. Hosting Arc managed identities receive read access to the
`workloads/` prefix and authenticate with short-lived managed-identity tokens;
registry credentials and GitHub PATs are not used.

The workload image registry is deliberately separate from the existing Bicep
module and portal image registry. This allows repository-scoped authorization
without changing the legacy role mode used by current consumers.

The `Destroy Development` workflow is hard-coded to the development backend and tfvars. It runs nightly at 23:55 UTC, after the application teardown window used across the estate, and retains manual dispatch.

## Contributing

Please read the [contributing](CONTRIBUTING.md) guidance; this is a learning and development project.

## Security

Please read the [security](SECURITY.md) guidance; I am always open to security feedback through email or opening an issue.
