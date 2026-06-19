# ☁️ AWS Three-Tier Architecture

[![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/Cloud-AWS-232F3E?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Region](https://img.shields.io/badge/Region-ap--south--1-orange)](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)
[![Well-Architected](https://img.shields.io/badge/AWS-Well--Architected-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/architecture/well-architected/)

A **production-grade three-tier architecture** deployed on AWS following the AWS Well-Architected Framework. Demonstrates real-world cloud infrastructure design with high availability, security hardening, and full Infrastructure as Code using Terraform.

---

## 🏗️ Architecture Diagram

```
                        Internet
                           │
                    ┌──────▼──────┐
                    │  Internet   │
                    │   Gateway   │
                    └──────┬──────┘
                           │
              ┌────────────▼────────────┐
              │   Application Load      │
              │   Balancer (ALB)        │
              └────────┬────────────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
  AZ: ap-south-1a              AZ: ap-south-1b
        │                             │
┌───────▼───────┐           ┌─────────▼───────┐
│ Public Subnet │           │  Public Subnet   │
│  (Web Tier)   │           │   (Web Tier)     │
│  EC2 Instance │           │  EC2 Instance    │
└───────┬───────┘           └────────┬─────────┘
        │                            │
┌───────▼───────┐           ┌────────▼─────────┐
│Private Subnet │           │  Private Subnet   │
│  (App Tier)   │           │   (App Tier)      │
│ EC2 Instance  │           │  EC2 Instance     │
└───────┬───────┘           └────────┬──────────┘
        │                            │
┌───────▼────────────────────────────▼──────────┐
│             Private Subnet (Data Tier)          │
│               RDS MySQL (Multi-AZ)              │
└────────────────────────────────────────────────┘
```

---

## 🛠️ AWS Services Used

| Service | Purpose |
|---|---|
| **VPC** | Isolated network with custom CIDR `10.0.0.0/16` |
| **Subnets** | Public (web) + Private (app + data) across 2 AZs |
| **Internet Gateway** | Enables internet access for public subnets |
| **NAT Gateway** | Outbound internet for private subnets |
| **Route Tables** | Controls traffic flow between subnets |
| **Application Load Balancer** | Distributes traffic across EC2 web tier |
| **EC2** | Web and application tier compute |
| **RDS** | Managed relational database in data tier |
| **Security Groups** | Stateful firewall rules per tier |
| **IAM Roles** | Least-privilege access for EC2 instances |

---

## 🌐 Network Configuration

```
VPC CIDR: 10.0.0.0/16

Public Subnets (Web Tier):
  ap-south-1a → 10.0.1.0/24
  ap-south-1b → 10.0.2.0/24

Private Subnets (App Tier):
  ap-south-1a → 10.0.3.0/24
  ap-south-1b → 10.0.4.0/24

Private Subnets (Data Tier):
  ap-south-1a → 10.0.5.0/24
  ap-south-1b → 10.0.6.0/24
```

---

## 🔐 Security Design

**Traffic flow (strictly enforced via Security Groups):**

```
Internet → ALB SG → Web Tier SG → App Tier SG → Data Tier SG
```

- ALB: accepts HTTP/HTTPS from `0.0.0.0/0` only
- Web EC2: accepts traffic from ALB SG only
- App EC2: accepts traffic from Web SG only
- RDS: accepts traffic from App SG only — no direct internet access
- EC2 instances use **IAM instance profiles** — zero hardcoded credentials

---

## 🚀 Deployment with Terraform

### Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform >= 1.0 installed

### Deploy
```bash
git clone https://github.com/manojkumar-021/aws-three-tier-architecture.git
cd aws-three-tier-architecture/terraform

terraform init
terraform plan
terraform apply
```

### Destroy (to avoid AWS charges)
```bash
terraform destroy
```

---

## ✅ High Availability Design

- Resources span **2 Availability Zones** (ap-south-1a, ap-south-1b)
- ALB automatically routes to healthy instances via health checks
- AZ failure → traffic shifts automatically with zero manual intervention
- Each tier is independently scalable

---

## 📐 AWS Well-Architected Pillars

| Pillar | Implementation |
|---|---|
| **Operational Excellence** | Full IaC with Terraform, repeatable deployments |
| **Security** | Tiered SGs, IAM roles, private subnets, no public DB access |
| **Reliability** | Multi-AZ deployment, ALB health checks |
| **Performance Efficiency** | Right-sized EC2 per tier |
| **Cost Optimization** | NAT Gateway shared across AZs |

---

## 🔭 Upcoming Enhancements

- [ ] Auto Scaling Groups for web and app tiers
- [ ] CloudWatch alarms and dashboards
- [ ] AWS WAF on ALB
- [ ] Remote Terraform state with S3 + DynamoDB locking

---

## 💡 Key Learnings

- Designing multi-tier network isolation with VPC, subnets, and route tables
- Implementing least-privilege security with Security Groups and IAM
- Building high availability with multi-AZ and load balancing
- Provisioning infrastructure end-to-end with Terraform

---

## 👤 Author

**Manoj Kumar**
- GitHub: [@manojkumar-021](https://github.com/manojkumar-021)
- LinkedIn: [manojvijayakumar](https://www.linkedin.com/in/manojvijayakumar)
