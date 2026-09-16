# Cloud Programming: Multi-AZ AWS Web Architecture

**Author:** Arfaan Sayyad  
**Course:** Cloud Programming (DLBSEPCP01_E)  
**Task:** Task 1 - Host a simple webpage on AWS  

## Project Overview
This repository contains the Infrastructure as Code (IaC) required to deploy a highly available, auto-scaling, and low-latency web architecture on Amazon Web Services (AWS). The infrastructure is provisioned entirely using Terraform.

## Architecture Components
*   **Networking:** A custom Amazon VPC spanning two Availability Zones in `eu-central-1` with isolated Public and Private Subnets.
*   **Compute:** An Auto Scaling Group (ASG) deploying EC2 instances (running Nginx) strictly within the private subnets.
*   **Load Balancing:** A multi-AZ Application Load Balancer (ALB) that routes internet traffic only to healthy instances.
*   **Global Delivery:** An Amazon CloudFront distribution acting as a global CDN to cache content at edge locations for minimal latency.

## Prerequisites
To deploy this infrastructure, you will need:
1.  [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0 or newer).
2.  [AWS CLI](https://aws.amazon.com/cli/) installed and configured with valid IAM credentials (`aws configure`).
3.  An active AWS account.

## Deployment Instructions

**1. Initialize Terraform**
Download the necessary provider plugins (AWS Provider) and initialize the working directory:
`terraform init`

**2. Preview the Infrastructure**
Review the execution plan to see exactly what AWS resources will be created:
`terraform plan`

**3. Deploy the Infrastructure**
Apply the configuration to provision the resources. (You will be prompted to type `yes` to confirm):
`terraform apply`

## Verification
Once the deployment is complete, Terraform will output two URLs in your terminal:
*   `alb_dns_name`: The direct URL to the Application Load Balancer.
*   `cloudfront_domain_name`: The global CDN endpoint.

Copy the `cloudfront_domain_name` and paste it into a standard web browser. You should see the live "Hello World" HTML page, confirming that the CloudFront CDN is successfully routing traffic to the EC2 backend.

## Cleanup
**Important:** To avoid incurring unnecessary AWS charges, destroy all provisioned resources once testing is complete.
`terraform destroy`
(You will be prompted to type `yes` to confirm the destruction of all resources).