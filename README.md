
## 📄 **README.md**

````md
# Terraform AWS Ubuntu Web Server

This project provisions an Ubuntu-based EC2 web server on AWS using Terraform.  
It deploys a fully functional Apache web server running in the AWS **eu-north-1 (Stockholm)** region and outputs key infrastructure details such as VPC ID, subnet IDs, security group ID, and public IP address.

The goal is to demonstrate real-world Infrastructure as Code (IaC) practices using:
- AWS IAM
- AWS CLI
- Terraform
- Terraform Cloud

---

## 📐 Architecture Overview

Terraform creates the following resources:

- Uses the **default AWS VPC**
- Fetches all **subnets** in the VPC
- Creates a **Security Group** allowing:
  - Port 22 (SSH)
  - Port 80 (HTTP)
- Launches an **Ubuntu 22.04 EC2 instance**
- Installs and starts **Apache Web Server**
- Displays a simple web page
- Outputs:
  - VPC ID
  - Subnet IDs
  - Security Group ID
  - EC2 Public IP

---

## 🧑‍💻 Step 1 — Create a Terraform IAM User in AWS

1. Open the **AWS Console**
2. Go to **IAM → Users → Create User**
3. Name the user (e.g. `terraform-admin`)
4. Enable **Programmatic Access**
5. Attach this policy:
   - `AdministratorAccess`
6. Finish creation and **download the Access Key & Secret Key**

---

## 🔐 Step 2 — Configure AWS CLI

Install AWS CLI and run:

```bash
aws configure
````

Enter:

* AWS Access Key
* AWS Secret Key
* Region: `eu-north-1`
* Output format: `json`

Verify:

```bash
aws sts get-caller-identity
```

You should see your IAM user returned.

---

## 🌍 Step 3 — Configure Terraform Cloud

1. Create an account at [https://app.terraform.io](https://app.terraform.io)
2. Go to **User Settings → Tokens**
3. Generate a token
4. Run:

```bash
terraform login
```

Paste the token when prompted.
Terraform is now authenticated to Terraform Cloud.

---

## 📄 Step 4 — main.tf Explained

The `main.tf` file defines the infrastructure.

It performs the following:

### 1. AWS Provider

```hcl
provider "aws" {
  region = "eu-north-1"
}
```

Tells Terraform to use AWS Stockholm region.

---

### 2. Fetch Default VPC and Subnets

```hcl
data "aws_vpc" "default" { default = true }
data "aws_subnets" "default" { ... }
```

Reuses AWS’s default network instead of creating a new one.

---

### 3. Create Security Group

Allows:

* HTTP (80)
* SSH (22)

This enables browser access and SSH login.

---

### 4. Launch Ubuntu EC2 Instance

Terraform provisions:

* Ubuntu 22.04
* t3.micro instance
* SSH key for access
* Security group attached

---

### 5. User Data (Boot Script)

Terraform installs Apache automatically:

```bash
apt update
apt install -y apache2
systemctl start apache2
systemctl enable apache2
```

A web page is written to:

```
/var/www/html/index.html
```

---

### 6. Outputs

Terraform prints:

* VPC ID
* Subnet IDs
* Security Group ID
* Public IP

These values allow integration with:

* Load balancers
* Databases
* Auto scaling
* Monitoring

---

## 🚀 Step 5 — Deploy Infrastructure

Run:

```bash
terraform init
```

This:

* Downloads AWS provider
* Connects to Terraform Cloud
* Prepares the project

Then:

```bash
terraform apply --auto-approve
```

Terraform will:

1. Create security group
2. Launch EC2
3. Install Apache
4. Output networking details

---

## 🌐 Step 6 — Access the Web Server

After Terraform completes, copy the `instance_public_ip` and open:

```
http://<public-ip>
```

You will see:

```
Fadilulahi Olasunkanmi
```

---

## 🧹 Destroy Resources

To clean up:

```bash
terraform destroy --auto-approve
```

---

## 🏆 Why This Matters

This project demonstrates:

* Secure cloud authentication
* Infrastructure as Code
* Automated server provisioning
* Cloud networking
* Production-grade Terraform workflow

It is suitable for:

* Cloud engineers
* DevOps portfolios
* Real-world infrastructure deployments

```

---

If you want, next I can:
- Add diagrams
- Add Terraform Cloud workspace instructions
- Convert this into a reusable module
- Or add CI/CD with GitHub Actions 🚀
```
