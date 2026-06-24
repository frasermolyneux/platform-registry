# platform-registry

[![Build and Test](https://github.com/frasermolyneux/platform-registry/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/build-and-test.yml)
[![Code Quality](https://github.com/frasermolyneux/platform-registry/actions/workflows/codequality.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/codequality.yml)
[![Dependabot Auto-Merge](https://github.com/frasermolyneux/platform-registry/actions/workflows/dependabot-automerge.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/dependabot-automerge.yml)
[![Deploy Dev](https://github.com/frasermolyneux/platform-registry/actions/workflows/deploy-dev.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/deploy-dev.yml)
[![Deploy Prd](https://github.com/frasermolyneux/platform-registry/actions/workflows/deploy-prd.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/deploy-prd.yml)
[![Destroy Environment](https://github.com/frasermolyneux/platform-registry/actions/workflows/destroy-environment.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/destroy-environment.yml)
[![PR Verify](https://github.com/frasermolyneux/platform-registry/actions/workflows/pr-verify.yml/badge.svg)](https://github.com/frasermolyneux/platform-registry/actions/workflows/pr-verify.yml)

## Documentation

Documentation is being expanded in the docs folder.

## Overview

This repository provisions and manages the shared Azure Container Registry used for platform Bicep modules. Terraform defines and deploys the registry infrastructure, while module publishing is handled by GitHub Actions workflows. Module versioning is driven by Nerdbank.GitVersioning with per-module version scopes. The stack acts as a central module registry for downstream infrastructure repositories.

## Contributing

Please read the [contributing](CONTRIBUTING.md) guidance; this is a learning and development project.

## Security

Please read the [security](SECURITY.md) guidance; I am always open to security feedback through email or opening an issue.
