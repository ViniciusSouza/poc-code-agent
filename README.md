# poc-code-agent
Using code agent for migrate

## Project Structure

- **src/**: Source code for the modernization agent
  - `modernize.ts`: Main script for code modernization using Semgrep
  - `index.ts`: Entry point for the code agent coordinator

- **terraform/**: Azure infrastructure managed with Terraform
  - Infrastructure drift detection and remediation
  - See [terraform/README.md](terraform/README.md) for details

## Features

### Code Modernization
- Automated code analysis using Semgrep
- GitHub issue creation for detected code patterns
- Support for multiple target repositories

### Infrastructure Drift Detection
- Terraform-managed Azure infrastructure
- Automated drift detection and remediation
- Security-hardened configurations (TLS 1.2, HTTPS-only)

## Usage

### Run Code Modernization
```bash
npm run modernize
```

### Manage Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

See [terraform/README.md](terraform/README.md) for detailed infrastructure documentation.

