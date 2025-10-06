# Infrastructure with Terraform

This repository contains Terraform configurations for deploying infrastructure across multiple cloud providers (AWS and Azure) with various deployment patterns and examples.

## Project Structure

- **aws/** - AWS-specific infrastructure examples
- **azure/** - Azure-specific infrastructure examples  
- **epicbook-deployment/** - Complete Azure application deployment (VM + MySQL)
- **multi-cloud-multi-region/** - Multi-cloud and multi-region deployments
- **remote-backends/** - Remote state backend configurations
- **terraform-workspaces/** - Workspace management examples

## Key Features

- Multi-cloud infrastructure (AWS & Azure)
- Modular Terraform configurations
- Environment-specific variable files
- Remote state management
- Automated application deployment
- Network security and isolation

## Prerequisites

- Terraform >= 1.0
- Azure CLI (for Azure deployments)
- AWS CLI (for AWS deployments)
- SSH key pair for VM access

## Quick Start

For the main application deployment, see [epicbook-deployment/README.md](epicbook-deployment/README.md)
