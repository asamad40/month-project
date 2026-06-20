# Month 2 Project - 3-Tier Web Application on AWS

## 📖 Project Overview

This project deploys a **complete 3-Tier Web Application** on Amazon Web Services (AWS) using **Infrastructure as Code** with AWS CloudFormation. The architecture follows industry best practices for security, scalability, and maintainability.

### What is a 3-Tier Architecture?

A 3-tier architecture separates an application into three logical layers:

| Tier | Purpose | In This Project |
|------|---------|-----------------|
| **Presentation Tier (Web)** | User interface | Nginx web server serving HTML |
| **Application Tier (App)** | Business logic | EC2 instance with IAM role for S3 access |
| **Database Tier (Data)** | Data storage | RDS MySQL database in private subnet |

This separation allows each tier to be scaled, secured, and maintained independently.

---

## 🎯 Project Requirements

This project fulfills the following requirements:

### 1. VPC & Networking
- ✅ Custom VPC with CIDR block `10.0.0.0/16`
- ✅ Public subnet `10.0.1.0/24` for web servers
- ✅ Private subnet `10.0.2.0/24` for application servers
- ✅ Private subnet `10.0.3.0/24` for database (RDS requires 2 AZs)
- ✅ Internet Gateway attached to VPC
- ✅ Route tables: public subnet routes `0.0.0.0/0` to Internet Gateway
- ✅ Private subnets have no internet route (isolated)

### 2. Security Groups
- ✅ **web-sg**: Allows SSH (port 22) from your IP only
- ✅ **web-sg**: Allows HTTP (port 80) from anywhere (`0.0.0.0/0`)
- ✅ **db-sg**: Allows MySQL (port 3306) from web-sg ONLY
- ✅ **db-sg**: NEVER allows access from `0.0.0.0/0` (database is private)

### 3. EC2 Web Server
- ✅ Launched in public subnet
- ✅ Attached to web-sg
- ✅ UserData script installs Nginx on boot
- ✅ Confirmed reachable via public IP in browser
- ✅ Displays: "Hello from Month 2 Project!"

### 4. RDS Database
- ✅ Launched in private subnet group (2 AZs minimum)
- ✅ Attached to db-sg
- ✅ Public accessibility: **NO** (not exposed to internet)
- ✅ Only accessible from EC2 web server
- ✅ MySQL version: 8.0.46

### 5. S3 + IAM Role
- ✅ S3 bucket created for static assets
- ✅ IAM Role with S3 read-only access
- ✅ IAM Role attached to EC2 instance
- ✅ **No access keys anywhere** (uses IAM Role)
- ✅ EC2 can access S3 without `aws configure`

### 6. Documentation & Publishing
- ✅ README.md with detailed setup steps
- ✅ Architecture diagram (separate file)
- ✅ Screenshot of working application
- ✅ Pushed to GitHub

---

## 🛠️ Technologies Used

| Category | Technology | Purpose |
|----------|------------|---------|
| **Infrastructure as Code** | AWS CloudFormation | Define and deploy resources |
| **Web Server** | Amazon Linux 2 + Nginx | Serve web pages |
| **Database** | Amazon RDS MySQL 8.0.46 | Managed relational database |
| **Storage** | Amazon S3 | Store static assets |
| **Networking** | Custom VPC | Isolated network with subnets |
| **Security** | Security Groups + IAM Roles | Control access and permissions |
| **Scripting** | Bash | Automate deployment |
| **Version Control** | Git + GitHub | Code management |

---

## 📋 Prerequisites

### AWS Account
- Valid AWS account with billing enabled
- IAM user with permissions to create VPC, EC2, RDS, S3, IAM
- AWS CLI installed and configured

### Local Machine
- Git installed
- Terminal access (Mac/Linux) or WSL (Windows)

### EC2 KeyPair
```bash
# Check if you have a keypair
aws ec2 describe-key-pairs --region eu-north-1 --query "KeyPairs[].KeyName" --output table

# If you don't have one, create it
aws ec2 create-key-pair \
  --key-name virus-key \
  --query "KeyMaterial" \
  --output text > ~/Downloads/virus-key.pem

# Set correct permissions (important!)
chmod 400 ~/Downloads/virus-key.pem