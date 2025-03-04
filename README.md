# Terraform EKS Cluster with Karpenter Auto-Scaling

This project provides infrastructure as code (IaC) for deploying a production-ready Amazon EKS (Elastic Kubernetes Service) cluster with proper VPC configuration and Karpenter-based auto-scaling using Terraform and Terragrunt.

## Project Overview

This infrastructure deployment provides:

- A fully configured VPC with public and private subnets across multiple availability zones
- An EKS cluster with managed node groups for baseline capacity
- Karpenter integration for efficient and rapid auto-scaling
- EKS add-ons for extended functionality
- S3 bucket creation for infrastructure-related storage
- Terragrunt for managing Terraform configurations across multiple environments

## Architecture

The architecture follows AWS best practices for EKS deployments:

- **VPC**: Multi-AZ design with public and private subnets
- **EKS Cluster**: Version-managed Kubernetes control plane with OIDC provider
- **EKS Add-ons**: Essential add-ons for cluster functionality
- **Node Groups**: Managed node groups for baseline capacity
- **Karpenter**: Event-driven node provisioning for efficient scaling
- **Security Groups**: Properly configured network security
- **S3**: Storage buckets for infrastructure artifacts

## Prerequisites

Before you begin, ensure you have the following tools installed:

- [Terraform](https://www.terraform.io/downloads.html) (version >= 1.0.0)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) (version >= 0.35.0)
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate permissions
- [kubectl](https://kubernetes.io/docs/tasks/tools/) for interacting with the cluster post-deployment

## Project Structure

```
.
├── LICENSE
├── README.md
├── _envcommon                 # Common Terragrunt configurations
│   ├── eks-addons.hcl         # Common config for EKS add-ons
│   ├── eks.hcl                # Common config for EKS clusters
│   ├── karpenter.hcl          # Common config for Karpenter
│   ├── s3.hcl                 # Common config for S3 buckets
│   └── vpc.hcl                # Common config for VPC
├── dev                        # Development environment
│   ├── account.hcl            # AWS account configuration for dev
│   └── eu-central-1           # EU Central 1 region
│       ├── dev                # Dev environment in EU Central 1
│       │   ├── eks            # EKS cluster configuration
│       │   │   └── terragrunt.hcl
│       │   ├── eks-addons     # EKS add-ons configuration
│       │   │   └── terragrunt.hcl
│       │   ├── env.hcl        # Environment-specific variables
│       │   ├── karpenter      # Karpenter configuration
│       │   │   └── terragrunt.hcl
│       │   └── s3             # S3 bucket configuration
│       │       └── terragrunt.hcl
│       └── region.hcl         # Region-specific variables
├── infra                      # Infrastructure modules
│   └── modules                # Terraform modules
│       ├── eks                # EKS cluster module
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── vars.tf
│       ├── eks-addons         # EKS add-ons module
│       │   ├── bootstrap
│       │   │   └── addons.yaml
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       ├── karpenter          # Karpenter module
│       │   ├── main.tf
│       │   └── vars.tf
│       ├── s3                 # S3 bucket module
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── vars.tf
│       └── vpc                # VPC module
│           ├── data.tf
│           ├── main.tf
│           ├── outputs.tf
│           └── vars.tf
├── terragrunt                 # Terragrunt configurations directory
│   └── ...                    # Contains environment-specific configurations
├── makefile                   # Make targets for common operations
└── terragrunt.hcl             # Root Terragrunt configuration
```

## Getting Started

### Configuration

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/terraform-eks-karpenter.git
   cd terraform-eks-karpenter
   ```

2. Review and update the environment-specific variables:
   - In `dev/account.hcl` for AWS account settings
   - In `dev/eu-central-1/region.hcl` for region-specific settings
   - In `dev/eu-central-1/dev/env.hcl` for environment-specific settings

3. Review the common configuration in `_envcommon/` files which provide shared settings across environments.

### Deployment

The project includes a makefile with common operations. Here's the makefile structure:

```makefile
SHELL := /usr/bin/env bash
export AWS_PROFILE=$(aws_profile)
export TF_PLUGIN_CACHE_DIR=$(HOME)/.terraform.d/plugin-cache

init:
	brew install terragrunt terraform

format:
	cd infra && terraform fmt -check
	cd infra && terraform fmt -recursive
	cd terragrunt && terragrunt hclfmt

validate:
	cd terragrunt/$(directory) && terragrunt run-all validate
plan:
	cd terragrunt/$(directory) && terragrunt run-all plan
apply:
	cd terragrunt/$(directory) && terragrunt run-all apply
destroy:
	cd terragrunt/$(directory) && terragrunt run-all destroy

validate-module:
	cd terragrunt/$(directory) && terragrunt run-all plan --terragrunt-include-dir $(module)

plan-module:
	cd terragrunt/$(directory) && terragrunt run-all plan --terragrunt-include-dir $(module)

apply-module:
	cd terragrunt/$(directory) && terragrunt run-all apply --terragrunt-include-dir $(module)

destroy-module:
	cd terragrunt/$(directory) && terragrunt run-all destroy --terragrunt-working-dir $(module)

unlock:
	cd terragrunt/$(directory) && terragrunt force-unlock $(lock_id)

clean-cache:
	find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
clean-lock:
	find . -type f -name ".terraform.lock.hcl" -prune -exec rm -rf {} \;
```

To use the makefile:

1. Initialize tools if not installed:
   ```
   make init
   ```

2. Format your Terraform and HCL files:
   ```
   make format
   ```

3. For working with entire configurations in a directory:
   ```
   # Validate configurations
   make validate directory=dev/eu-central-1/dev

   # Plan deployments
   make plan directory=dev/eu-central-1/dev

   # Apply configurations
   make apply directory=dev/eu-central-1/dev

   # Destroy resources
   make destroy directory=dev/eu-central-1/dev
   ```

4. For working with specific modules:
   ```
   # Validate a specific module
   make validate-module directory=dev/eu-central-1/dev module=eks

   # Plan a specific module
   make plan-module directory=dev/eu-central-1/dev module=eks

   # Apply a specific module
   make apply-module directory=dev/eu-central-1/dev module=eks

   # Destroy a specific module
   make destroy-module directory=dev/eu-central-1/dev module=eks
   ```

5. For maintenance operations:
   ```
   # Unlock a Terraform state lock
   make unlock directory=dev/eu-central-1/dev lock_id=<lock-id>

   # Clean Terragrunt cache
   make clean-cache

   # Clean Terraform lock files
   make clean-lock
   ```

6. After deployment, configure kubectl to interact with your new cluster:
   ```
   aws eks update-kubeconfig --name <cluster-name> --region eu-central-1
   ```

## Module Details

### VPC Module

The VPC module (`infra/modules/vpc/`) creates:
- Public and private subnets across multiple AZs
- Internet Gateway and NAT Gateways
- Route tables and security groups
- Proper tagging for Kubernetes integration

### EKS Module

The EKS module (`infra/modules/eks/`) configures:
- EKS control plane with appropriate IAM roles
- Managed node groups for baseline capacity
- OIDC provider for IAM roles for service accounts
- Required security groups

### EKS Add-ons Module

The EKS add-ons module (`infra/modules/eks-addons/`) includes:
- Core Kubernetes add-ons via `bootstrap/addons.yaml`
- AWS load balancer controller
- Other essential services for cluster functionality

### Karpenter Module

The Karpenter module (`infra/modules/karpenter/`) sets up:
- Karpenter controller deployment
- Node provisioners with scaling rules
- IAM roles and policies for Karpenter
- Integration with EKS cluster

### S3 Module

The S3 module (`infra/modules/s3/`) creates:
- S3 buckets for storing logs, artifacts, or other data
- Appropriate bucket policies and encryption settings

## Environment Structure

This project uses Terragrunt's directory structure to manage different environments:

- `_envcommon/`: Contains common configuration shared across environments
- `dev/`: Development environment configurations
  - Can be extended with additional environments (staging, prod, etc.)
- Environment-specific settings are in `env.hcl` files
- Region-specific settings are in `region.hcl` files
- Account-level settings are in `account.hcl` files

## Terragrunt Configuration

Terragrunt is used to:
1. Keep your Terraform code DRY across environments
2. Manage remote state configuration
3. Provide input variables to Terraform modules
4. Execute operations on multiple modules

The root `terragrunt.hcl` defines global settings, while child terragrunt.hcl files handle module-specific configurations.

## Maintenance and Operations

### Updating the Cluster

To update the EKS cluster version:

1. Modify the Kubernetes version in the appropriate `terragrunt.hcl` file
2. Run the plan command to validate changes:
   ```
   make plan-module directory=dev/eu-central-1/dev module=eks
   ```
3. Apply the changes:
   ```
   make apply-module directory=dev/eu-central-1/dev module=eks
   ```

### Scaling the Cluster

The baseline capacity is managed through the EKS node groups configuration, while dynamic scaling is handled by Karpenter.

To modify the baseline capacity:
1. Update the node group configuration in the EKS terragrunt.hcl file
2. Apply the changes:
   ```
   make apply-module directory=dev/eu-central-1/dev module=eks
   ```

### Adding New Environments

To add a new environment (e.g., staging):

1. Create a new directory structure following the pattern in `dev/`
2. Update account, region, and environment HCL files
3. Create the necessary terragrunt.hcl files for each component

## Troubleshooting

### Common Issues

1. **Terraform state locking issues**:
   - Check if a previous operation is still running
   - Use the unlock command:
     ```
     make unlock directory=dev/eu-central-1/dev lock_id=<lock-id>
     ```

2. **EKS connectivity issues**:
   - Verify security group configurations
   - Check IAM roles and policies
   - Validate VPC and subnet configurations

3. **Karpenter not scaling**:
   - Verify Karpenter controller deployment
   - Check provisioner configurations
   - Inspect Karpenter logs for errors

### Helpful Commands

Use these commands to troubleshoot issues:

```bash
# Check EKS cluster status
aws eks describe-cluster --name <cluster-name> --region eu-central-1

# View Karpenter logs
kubectl logs -n karpenter -l app.kubernetes.io/name=karpenter

# Check node status
kubectl get nodes -o wide

# View pod status
kubectl get pods -A
```

For Terragrunt-specific issues:

```bash
# Clear Terragrunt cache
make clean-cache

# Remove Terraform lock files
make clean-lock

# Unlock a stuck state lock
make unlock directory=dev/eu-central-1/dev lock_id=<lock-id>
```

## AWS Profile Configuration

The makefile uses the AWS profile specified by the `aws_profile` variable. Set this variable when running make commands:

```bash
make plan directory=dev/eu-central-1/dev aws_profile=my-profile
```

## Contributing

Please follow these steps to contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `make format` to ensure consistent code formatting
5. Create a pull request

## License

This project is licensed under the terms specified in the LICENSE file.

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Karpenter Documentation](https://karpenter.sh/docs/)
