# AWS Cloud Transition Lab

## Overview

This project demonstrates the design and deployment of a scalable AWS infrastructure using **Terraform Infrastructure as Code**.

The environment includes a secure VPC architecture, public and private subnets, an Application Load Balancer, an Auto Scaling Group, and CloudWatch monitoring.

The goal of the project was to simulate a **production-style cloud architecture** and deploy it entirely using Terraform.

---

## Architecture

Internet traffic flows through an **Application Load Balancer (ALB)** to a fleet of EC2 instances managed by an **Auto Scaling Group (ASG)**.

Private compute resources are managed securely using **AWS Systems Manager (SSM)** without requiring SSH access.

Monitoring and scaling are handled by **CloudWatch alarms** based on CPU utilization.

---

## Infrastructure Components

### Networking
- VPC
- Public Subnets (2)
- Private Subnets (2)
- Route Tables
- Internet Gateway

### Compute
- EC2 Public Web Instance
- EC2 Private Instance
- Launch Template
- Auto Scaling Group

### Traffic Layer
- Application Load Balancer (ALB)
- Target Group
- HTTP Listener
- Health Checks

### Security and Access
- Security Groups
- IAM Role
- SSM Instance Profile

### Monitoring and Scaling
- CloudWatch CPU Alarms
- Scale-Up Policy
- Scale-Down Policy

### Storage
- S3 Bucket (lab storage)

---

## Auto Scaling Behavior

The environment automatically scales based on CPU utilization:

| Condition | Action |
|-----------|--------|
| CPU > 60% | Launch additional EC2 instance |
| CPU < 20% | Terminate excess instances |

This demonstrates **elastic scaling in AWS**.

---

## Terraform Structure

```text
terraform/
│
├── vpc.tf
├── network_public.tf
├── network_private.tf
├── security.tf
├── ec2.tf
├── ec2_private.tf
├── alb.tf
├── launch_template.tf
├── asg.tf
├── scaling.tf
├── cloudwatch.tf
├── s3.tf
└── outputs.tf

Technologies Used
AWS EC2
AWS VPC
AWS ALB
AWS Auto Scaling
AWS S3
AWS CloudWatch
AWS Systems Manager (SSM)
Terraform
GitHub

Key Skills Demonstrated
Infrastructure as Code (Terraform)
AWS network architecture design
Secure private instance management
Load balancing and high availability
Auto scaling based on metrics
Monitoring with CloudWatch
Git-based version control
Cost-aware cloud operations

Future Enhancements
Planned advanced extensions:
CloudWatch dashboards
CloudFront CDN
RDS database integration
Terraform modules refactor
Remote Terraform state (S3 + DynamoDB)
CI/CD pipeline using GitHub Actions

Author
Brent Hargreaves
AWS Cloud Engineering Project
