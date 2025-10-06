# EpicBook Monolith Application Deployment

Production-grade two-tier monolith Node.js application deployment on Azure using modular Terraform architecture. Demonstrates infrastructure-as-code best practices with separate presentation and data tiers for scalable, maintainable deployments.

## What It Deploys

- **Resource Group** - Container for all resources
- **Virtual Network** - Isolated network with public/private subnets
- **Linux VM** - Ubuntu 22.04 with application auto-deployment
- **MySQL Flexible Server** - Managed database in private subnet
- **Public IP & Load Balancer** - External access to application
- **Network Security** - Private DNS zone and subnet delegation

## Prerequisites

- Terraform >= 1.12
- Azure ARM based authentication
- SSH key pair at `~/.ssh/id_rsa.pub`, or change the path with your key file
- Azure Storage Account for remote state (see [backend.tf](./backend.tf))

## Required Variables

Create environment-specific `.tfvars` files or set these variables:

```hcl
mysqlAdmin     = "your-db-admin-username"
mysqlAdminPass = "your-secure-password"
```

## Optional Variables

```hcl
prefix                 = "epkbk"              # Resource name prefix
region                 = "southeastasia"       # Azure region
vnet_cidr             = "10.0.0.0/16"         # VNet CIDR block
vnet_cidr_public_sub1 = "10.0.1.0/24"         # Public subnet CIDR
vnet_cidr_private_sub1= "10.0.16.0/24"        # Private subnet CIDR
ssh_username          = "azureuser"           # VM admin username
ssh_key_path          = "~/.ssh/id_rsa.pub"   # SSH public key path
```

## Deployment

## Project Structures

```shell
epicbook-deployment
├── env
│   ├── dev.tfvars
│   └── prod.tfvars
├── modules
│   ├── db
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── README.md
│   │   └── variables.tf
│   ├── network
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── README.md
│   │   └── variables.tf
│   └── vm
│       ├── main.tf
│       ├── outputs.tf
│       ├── README.md
│       └── variables.tf
├── scripts
│   └── epkbk-deploy.sh
├── backend.tf
├── main.tf
├── outputs.tf
├── README.md
└── variables.tf
```

### Development Environment

```bash
terraform init
terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars"
```

### Production Environment

```bash
terraform init
terraform plan -var-file="env/prod.tfvars"
terraform apply -var-file="env/prod.tfvars"
```

### With Custom Variables

```bash
terraform apply \
  -var="mysqlAdmin=dbadmin" \
  -var="mysqlAdminPass=SecurePass123!"
```

## Outputs

After deployment, you'll get:

- `vm_public_ip` - Access your application at http://[IP]
- `db_hostname` - MySQL server FQDN
- `resource_group_name` - Created resource group

## Application Details

The deployment automatically:

1. Installs Node.js, Nginx, MySQL client
2. Clones EpicBook application from GitHub
3. Configures database connection with SSL
4. Sets up Nginx reverse proxy
5. Creates systemd service for auto-start
6. Imports database schema and seed data

## Cleanup

```bash
terraform destroy -var-file="env/dev.tfvars"
```

## Troubleshooting

- Check VM deployment logs: `/var/log/epkbk_install.log`
- Verify application status: `systemctl status epicbook`
- Test database connectivity from VM
- Ensure SSH key exists and is accessible