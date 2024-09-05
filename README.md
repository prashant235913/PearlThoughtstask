# Terraform Deployment for Medusa Backend on AWS ECS Fargate

This repository contains Terraform configuration files for deploying the Medusa open-source headless commerce platform backend on AWS using ECS Fargate. This project is submitted to **Pearl Thoughts** to demonstrate Terraform skills and AWS ECS deployment.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Terraform Configuration](#terraform-configuration)
- [Deployment](#deployment)
- [Cleanup](#cleanup)
- [Video Explanation](#video-explanation)
- [License](#license)

## Prerequisites

Before you begin, ensure you have the following installed:

- **AWS CLI**: For interacting with AWS services.
- **Terraform**: Version 1.0 or later for infrastructure as code.
- **Git**: To clone the repository.

## Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://github.com/<your-username>/terraform-ecs-medusa.git
   cd terraform-ecs-medusa
Initialize Terraform```

```bash
  Copy code
  terraform init
  This command initializes the Terraform configuration and downloads the necessary provider plugins.```

Review the Terraform Plan

```bash
  Copy code
  terraform plan
  This command shows a preview of the changes Terraform will make to your infrastructure.```

Apply the Terraform Configuration

```bash
  Copy code
  terraform apply
  Type yes to approve the changes and deploy the resources.
