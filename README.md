# Cloud Programming Project (Development)

**Author:** Arfaan Zameerahmed Sayyad
**Course:** Cloud Programming

## Project Overview
This repository contains the Infrastructure as Code (IaC) written in Terraform for Phase 2 of the Cloud Programming portfolio project. 

The code provisions a highly available, fault-tolerant web architecture in AWS (`eu-central-1`), including:
* A custom VPC with public and private subnets across multiple Availability Zones.
* An Auto Scaling Group (ASG) with an EC2 Launch Template running Nginx.
* An Application Load Balancer (ALB) for traffic distribution.
* A CloudFront distribution for global content delivery.

**Note:** This infrastructure was built, tested, and destroyed as part of the academic assignment. The full procedure, architecture diagrams, and proof of deployment are documented in the accompanying composite presentation PDF.