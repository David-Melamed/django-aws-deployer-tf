# Django Deployer Application

## Overview
This project is a Terraform-based deployer for a Django application on AWS. It automates the creation and configuration of AWS resources including S3, VPC, RDS, Route 53, ACM, ECR, CodeBuild, and Elastic Beanstalk.

## Features
- Automated deployment of Django applications
- Infrastructure as Code using Terraform
- Secure storage of secrets using AWS Secrets Manager
- CI/CD using AWS CodeBuild
- High availability and scalability with Elastic Beanstalk
- Custom domain setup with Route 53 and SSL certificates via ACM

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS CLI configured
- AWS Access key with the relevant permissions (I will add the relevant policy soon)
- Docker installed (Username and Password are required)
- A registered domain name (Route53 -> Registrar domain -> Buy domain)

## Getting Started

### Clone the Repository
```bash
git clone https://github.com/David-Melamed/django-aws-deployer-tf.git
cd django-aws-deployer-tf
```

### Configure Variables
Edit variables.tf or create terraform.tfvars with:
* app_name
* zone_name
* db_username
* db_password
* django_project_url
* docker_username
* docker_password

### Initialize Terraform
```bash
terraform init
```

### Plan and Apply
```bash
terraform plan
terraform apply
```

### Modules
S3: Manages S3 buckets for static and media files.
VPC: Configures VPC, subnets, route tables, and security groups.
RDS: Sets up RDS for the Django application.
IAM: Manages IAM roles and policies.
Route 53: Configures DNS settings.
ACM: Provisions SSL certificates.
ECR: Manages ECR for Docker images.
CodeBuild: Sets up CodeBuild for CI/CD.
Elastic Beanstalk: Deploys the Django application.

### Directory Structure
├── modules
│   ├── s3
│   ├── vpc
│   ├── rds
│   ├── iam
│   ├── route53
│   ├── acm
│   ├── ecr
│   ├── codebuild
│   └── beanstalk
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md


### Acknowledgements
Thanks to the Terraform and AWS communities for their valuable tools and documentation.

### Contact
If you have any questions, feel free to contact me at [davidmelamed269@gmail.com].