# ☁️ AWS Three-Tier Architecture

A production-grade **three-tier architecture** deployed on AWS, following the AWS Well-Architected Framework. Built to demonstrate real-world cloud infrastructure design with high availability, security, and scalability.

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
              │    Application Load     │
              │    Balancer (ALB)        │
              └────────┬────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
   AZ-1 (ap-south-1a)           AZ-2 (ap-south-1b)
        │                             │
┌───────▼───────┐           ┌─────────▼──────┐
│  Public Subnet│           │  Public Subnet  │
│  (Web Tier)   │           │  (Web Tier)     │
│  EC2 Instance │           │  EC2 Instance   │
└───────┬───────┘           └────────┬────────┘
        │                            │
┌───────▼───────┐           ┌────────▼────────┐
│ Private Subnet│           │  Private Subnet  │
│ (App Tier)    │           │  (App Tier)      │
│ EC2 Instance  │           │  EC2 Instance    │
└───────┬───────┘           └────────┬─────────┘
        │                            │
┌───────▼────────────────────────────▼─────────┐
│              Private Subnet (Data Tier)        │
│                  RDS / Database               │
└───────────────────────────────────────────────┘
```

---

## 🛠️ AWS Services Used

| Service | Purpose |
|---|---|
| **VPC** | Isolated network with custom CIDR block |
| **Subnets** | Public (web) + Private (app + data) per AZ |
| **Internet Gateway** | Enables internet access for public subnets |
| **Route Tables** | Controls traffic flow between subnets |
| **Application Load Balancer (ALB)** | Distributes traffic across EC2 instances |
| **EC2** | Web and application tier compute |
| **Security Groups** | Stateful firewall rules per tier |
| **IAM Roles** | Least-privilege access for EC2 instances |
| **NAT Gateway** | Outbound internet for private subnets |

---

## 🔐 Security Design

### Security Group Rules

**ALB Security Group**
- Inbound: HTTP (80) + HTTPS (443) from `0.0.0.0/0`
- Outbound: To Web Tier SG only

**Web Tier (EC2)**
- Inbound: HTTP from ALB SG only
- Outbound: To App Tier SG only

**App Tier (EC2)**
- Inbound: From Web Tier SG only
- Outbound: To Data Tier SG only

**Data Tier**
- Inbound: From App Tier SG only
- No direct internet access

### IAM
- EC2 instances use instance profiles (no hardcoded credentials)
- Least-privilege policies scoped to required services only

---

## 🌐 VPC Configuration

```
VPC CIDR: 10.0.0.0/16

Public Subnets (Web Tier):
  AZ-1: 10.0.1.0/24
  AZ-2: 10.0.2.0/24

Private Subnets (App Tier):
  AZ-1: 10.0.3.0/24
  AZ-2: 10.0.4.0/24

Private Subnets (Data Tier):
  AZ-1: 10.0.5.0/24
  AZ-2: 10.0.6.0/24
```

---

## ✅ High Availability Design

- Resources deployed across **2 Availability Zones** (ap-south-1a, ap-south-1b)
- ALB automatically routes traffic to healthy instances
- If one AZ goes down, traffic shifts to the other AZ with zero manual intervention
- Each tier is independently scalable

---

## 🚀 Deployment Steps

### 1. Create VPC and Networking
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create subnets, IGW, NAT Gateway, Route Tables
# (refer to deployment scripts in /scripts folder)
```

### 2. Configure Security Groups
```bash
# Create SGs for each tier
aws ec2 create-security-group --group-name alb-sg --description "ALB Security Group" --vpc-id <vpc-id>
aws ec2 create-security-group --group-name web-sg --description "Web Tier SG" --vpc-id <vpc-id>
aws ec2 create-security-group --group-name app-sg --description "App Tier SG" --vpc-id <vpc-id>
```

### 3. Launch EC2 Instances
- Launch web tier instances in **public subnets**
- Launch app tier instances in **private subnets**
- Attach appropriate IAM roles and security groups

### 4. Set Up ALB
- Create target group pointing to web tier EC2s
- Configure listener rules (HTTP → target group)
- Enable health checks

---

## 📐 AWS Well-Architected Pillars Applied

| Pillar | Implementation |
|---|---|
| **Operational Excellence** | Infrastructure documented, repeatable setup |
| **Security** | Tiered security groups, IAM roles, private subnets |
| **Reliability** | Multi-AZ deployment, ALB health checks |
| **Performance Efficiency** | Right-sized EC2 instances per tier |
| **Cost Optimization** | NAT Gateway shared across AZs |

---

## 🔭 Upcoming Enhancements

- [ ] Add Terraform scripts for full IaC provisioning
- [ ] Integrate Auto Scaling Groups for web and app tiers
- [ ] Add CloudWatch alarms and dashboards
- [ ] Enable AWS WAF on ALB for web application firewall

---

## 🔑 Key Learnings

- Designing network isolation using VPC, subnets, and route tables
- Implementing least-privilege security with Security Groups and IAM
- Building high availability with multi-AZ deployments
- Understanding traffic flow through ALB → Web → App → Data tiers

---

## 👤 Author

**Manoj Kumar**
- GitHub: [@manojkumar-021](https://github.com/manojkumar-021)
- LinkedIn: [manojvijayakumar](https://www.linkedin.com/in/manojvijayakumar)
