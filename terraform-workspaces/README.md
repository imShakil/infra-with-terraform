# Deploy a React App With Terraform Workspaces

Deploys a React application on AWS EC2 with Nginx using Terraform workspaces for environment separation.

## Architecture

- **Dev**: Amazon Linux EC2 with Nginx
- **Prod**: Ubuntu EC2 with Nginx
- **State**: Azure Storage backend
- **Networking**: VPC, subnets, security groups

## Files

- `main.tf` - Infrastructure resources
- `variables.tf` - Variable definitions
- `outputs.tf` - Output values
- `user_data.sh` - EC2 bootstrap script
- `dev.tfvars` - Dev environment variables
- `prod.tfvars` - Prod environment variables

Project Structures:

```shell
terraform-workspaces
├── dev.tfvars
├── main.tf
├── outputs.tf
├── prod.tfvars
├── README.md
├── terraform.tfstate.d
│   ├── dev
│   └── prod
├── user_data.sh
└── variables.tf
```

## Deployment

### Prerequisites

```bash
# Configure AWS CLI
aws configure

# Configure Azure CLI (for backend)
az login
```

### Deploy

```bash
# Initialize
terraform init

# Create workspaces
terraform workspace new dev
terraform workspace new prod

# Deploy dev
terraform workspace select dev
terraform apply -var-file="dev.tfvars"

# Deploy prod
terraform workspace select prod
terraform apply -var-file="prod.tfvars"
```

### Access

After deployment, access your React app via the EC2 public IP on port 80.

## Features

- ✅ Workspace-based environment separation
- ✅ OS-specific deployments (Amazon Linux/Ubuntu)
- ✅ Automated React app deployment via user_data
- ✅ Environment-specific configurations
- ✅ Azure backend for state management
