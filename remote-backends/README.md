# Remote Backends

This directory contains Terraform configurations demonstrating remote state backend setups for AWS S3 and Azure Storage.

## AWS S3 Backend

**Location:** `aws/`

Uses S3 bucket with DynamoDB for state locking:

- Bucket: `imshakil-bkt-tfstate`
- DynamoDB table: `tf-state-lock`
- Region: `ap-southeast-1`
- Encryption enabled

**Resources:** Creates a VPC with CIDR `10.0.0.0/16`

## Azure Storage Backend

**Location:** `azure/`

Uses Azure Storage Account for remote state:

- Resource Group: `tfstate-rg`
- Storage Account: `tfstateinbackend`
- Container: `tfstate`

**Resources:** Creates a resource group and virtual network in Southeast Asia

## Usage

1. Navigate to either `aws/` or `azure/` directory
2. Initialize Terraform: `terraform init`
3. Plan deployment: `terraform plan`
4. Apply configuration: `terraform apply`
