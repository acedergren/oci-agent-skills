---
name: OCI Infrastructure as Code
description: Expert in Terraform for OCI, Resource Manager, OCI Landing Zones, and infrastructure automation. Complete reference for terraform-provider-oci with examples.
version: 1.0.0
---

# OCI Infrastructure as Code Skill

You are an expert in infrastructure as code for Oracle Cloud Infrastructure using Terraform, OCI Resource Manager, and OCI Landing Zones. This skill provides comprehensive guidance to compensate for Claude's limited OCI training data.

## Core Concepts

### Terraform Provider for OCI
- Official HashiCorp provider: `terraform-provider-oci`
- Comprehensive resource coverage for all OCI services
- Data sources for querying existing resources
- Authentication via OCI CLI config or instance principals

### OCI Resource Manager
- Managed Terraform service within OCI
- Stack-based infrastructure management
- Built-in state management
- Plan, apply, and destroy operations via console or API

### OCI Landing Zones
- Pre-built Terraform templates for enterprise patterns
- Security-hardened configurations
- Multi-environment support
- Compliance-ready architectures

## Terraform Provider Setup

### Provider Configuration
```hcl
# Configure the OCI Provider
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  # Authentication via OCI CLI config (default)
  # Reads from ~/.oci/config
  region = "us-phoenix-1"
}

# Alternative: Explicit authentication
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Instance Principal authentication (for compute instances)
provider "oci" {
  auth                = "InstancePrincipal"
  region              = "us-phoenix-1"
}
```

### Variables Configuration
```hcl
# variables.tf
variable "tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
}

variable "compartment_ocid" {
  description = "Target compartment OCID"
  type        = string
}

variable "region" {
  description = "OCI Region"
  type        = string
  default     = "us-phoenix-1"
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}
```

## Common Resource Examples

### Compartment
```hcl
resource "oci_identity_compartment" "app_compartment" {
  compartment_id = var.tenancy_ocid
  description    = "Application compartment"
  name           = "ApplicationCompartment"

  freeform_tags = {
    "Environment" = "Production"
    "CostCenter"  = "Engineering"
  }
}
```

### VCN (Virtual Cloud Network)
```hcl
resource "oci_core_vcn" "app_vcn" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "ApplicationVCN"
  dns_label      = "appvcn"

  freeform_tags = {
    "Environment" = "Production"
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "app_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "InternetGateway"
  enabled        = true
}

# NAT Gateway
resource "oci_core_nat_gateway" "app_nat" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "NATGateway"
}

# Service Gateway
resource "oci_core_service_gateway" "app_sgw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "ServiceGateway"

  services {
    service_id = data.oci_core_services.all_services.services[0].id
  }
}

# Data source for OCI services
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}
```

### Subnet with Security List
```hcl
# Public Subnet
resource "oci_core_subnet" "public_subnet" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.app_vcn.id
  cidr_block          = "10.0.1.0/24"
  display_name        = "PublicSubnet"
  dns_label           = "public"
  route_table_id      = oci_core_route_table.public_rt.id
  security_list_ids   = [oci_core_security_list.public_sl.id]
  prohibit_public_ip_on_vnic = false
}

# Private Subnet
resource "oci_core_subnet" "private_subnet" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.app_vcn.id
  cidr_block          = "10.0.2.0/24"
  display_name        = "PrivateSubnet"
  dns_label           = "private"
  route_table_id      = oci_core_route_table.private_rt.id
  security_list_ids   = [oci_core_security_list.private_sl.id]
  prohibit_public_ip_on_vnic = true
}

# Route Table for Public Subnet
resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "PublicRouteTable"

  route_rules {
    network_entity_id = oci_core_internet_gateway.app_igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# Route Table for Private Subnet
resource "oci_core_route_table" "private_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "PrivateRouteTable"

  route_rules {
    network_entity_id = oci_core_nat_gateway.app_nat.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }

  route_rules {
    network_entity_id = oci_core_service_gateway.app_sgw.id
    destination       = data.oci_core_services.all_services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
  }
}

# Security List for Public Subnet
resource "oci_core_security_list" "public_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "PublicSecurityList"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }
}

# Security List for Private Subnet
resource "oci_core_security_list" "private_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "PrivateSecurityList"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/16"
    tcp_options {
      min = 1521
      max = 1521
    }
  }
}
```

### Network Security Group (NSG)
```hcl
resource "oci_core_network_security_group" "app_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "ApplicationNSG"
}

# NSG Rule - Allow HTTP from internet
resource "oci_core_network_security_group_security_rule" "app_nsg_http" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

# NSG Rule - Allow HTTPS
resource "oci_core_network_security_group_security_rule" "app_nsg_https" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}
```

### Compute Instance
```hcl
# Get latest Oracle Linux image
data "oci_core_images" "ol8_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E4.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "app_instance" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = "VM.Standard.E4.Flex"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 16
  }

  display_name = "ApplicationServer"

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    assign_public_ip = true
    display_name     = "PrimaryVNIC"
    nsg_ids          = [oci_core_network_security_group.app_nsg.id]
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ol8_images.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
      hostname = "app-server"
    }))
  }

  freeform_tags = {
    "Environment" = "Production"
    "Application" = "WebApp"
  }
}

# Availability Domains data source
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}
```

### Autonomous Database
```hcl
resource "oci_database_autonomous_database" "app_adb" {
  compartment_id           = var.compartment_ocid
  db_name                  = "APPADB"
  display_name             = "Application Database"
  admin_password           = var.adb_admin_password
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1
  db_workload              = "OLTP"

  # Always Free configuration
  is_free_tier             = true

  # Or production configuration
  # is_auto_scaling_enabled  = true
  # license_model            = "LICENSE_INCLUDED"

  # Private endpoint (recommended)
  subnet_id                = oci_core_subnet.private_subnet.id
  nsg_ids                  = [oci_core_network_security_group.db_nsg.id]

  freeform_tags = {
    "Environment" = "Production"
  }
}

# Output connection strings
output "adb_connection_strings" {
  value     = oci_database_autonomous_database.app_adb.connection_strings
  sensitive = true
}
```

### Object Storage Bucket
```hcl
resource "oci_objectstorage_bucket" "app_bucket" {
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "application-data"
  access_type    = "NoPublicAccess"

  versioning = "Enabled"

  freeform_tags = {
    "Environment" = "Production"
  }
}

data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.compartment_ocid
}
```

### Vault and Secret
```hcl
resource "oci_kms_vault" "app_vault" {
  compartment_id = var.compartment_ocid
  display_name   = "ApplicationVault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "encryption_key" {
  compartment_id = var.compartment_ocid
  display_name   = "ApplicationKey"

  key_shape {
    algorithm = "AES"
    length    = 32
  }

  management_endpoint = oci_kms_vault.app_vault.management_endpoint
}

resource "oci_vault_secret" "db_password" {
  compartment_id = var.compartment_ocid
  vault_id       = oci_kms_vault.app_vault.id
  key_id         = oci_kms_key.encryption_key.id
  secret_name    = "database-password"

  secret_content {
    content_type = "BASE64"
    content      = base64encode(var.db_password)
  }
}
```

### Load Balancer
```hcl
resource "oci_load_balancer_load_balancer" "app_lb" {
  compartment_id = var.compartment_ocid
  display_name   = "ApplicationLB"
  shape          = "flexible"

  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 100
  }

  subnet_ids = [
    oci_core_subnet.public_subnet.id
  ]

  is_private = false
}

# Backend Set
resource "oci_load_balancer_backend_set" "app_backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.app_lb.id
  name             = "ApplicationBackendSet"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol          = "HTTP"
    port              = 80
    url_path          = "/health"
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
}

# Backend (instance)
resource "oci_load_balancer_backend" "app_backend" {
  load_balancer_id = oci_load_balancer_load_balancer.app_lb.id
  backendset_name  = oci_load_balancer_backend_set.app_backend_set.name
  ip_address       = oci_core_instance.app_instance.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

# Listener
resource "oci_load_balancer_listener" "app_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.app_lb.id
  name                     = "HTTP"
  default_backend_set_name = oci_load_balancer_backend_set.app_backend_set.name
  port                     = 80
  protocol                 = "HTTP"
}
```

## OCI Resource Manager

### Creating a Stack via CLI
```bash
# Create configuration ZIP
zip -r stack.zip *.tf

# Create stack in Resource Manager
oci resource-manager stack create \
  --compartment-id <compartment-ocid> \
  --config-source stack.zip \
  --display-name "ApplicationStack" \
  --description "Application infrastructure"

# Plan the stack
oci resource-manager job create-plan-job \
  --stack-id <stack-ocid> \
  --display-name "InitialPlan"

# Apply the stack
oci resource-manager job create-apply-job \
  --stack-id <stack-ocid> \
  --display-name "InitialApply" \
  --execution-plan-strategy AUTO_APPROVED

# Destroy resources
oci resource-manager job create-destroy-job \
  --stack-id <stack-ocid> \
  --display-name "Cleanup" \
  --execution-plan-strategy AUTO_APPROVED
```

### Stack Configuration with Remote State
```hcl
# backend.tf
terraform {
  backend "http" {
    address       = "https://objectstorage.us-phoenix-1.oraclecloud.com/n/${var.namespace}/b/${var.bucket}/o/terraform.tfstate"
    update_method = "PUT"
  }
}

# Alternative: OCI Object Storage backend
terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "prod/terraform.tfstate"
    region                      = "us-phoenix-1"
    endpoint                    = "https://${var.namespace}.compat.objectstorage.us-phoenix-1.oraclecloud.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

## OCI Landing Zones

### Using Landing Zone Modules
```hcl
# Example: CIS Landing Zone
module "cis_landing_zone" {
  source = "github.com/oracle-quickstart/oci-cis-landingzone-quickstart"

  tenancy_ocid         = var.tenancy_ocid
  region               = var.region
  service_label        = "prod"
  cis_level            = "1"

  # Network configuration
  vcn_cidr             = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"

  # Security configuration
  create_iam_resources = true
  create_budget        = true
  budget_amount        = "1000"
}
```

### Enterprise Landing Zone Pattern
```hcl
# Multi-environment landing zone structure
module "landing_zone" {
  source = "oracle-terraform-modules/landing-zone/oci"

  # Core settings
  tenancy_ocid = var.tenancy_ocid
  region       = var.region

  # Compartment structure
  compartments = {
    production = {
      description = "Production environment"
      enable_delete = false
    }
    development = {
      description = "Development environment"
      enable_delete = true
    }
    shared = {
      description = "Shared services"
      enable_delete = false
    }
  }

  # Networking
  vcns = {
    prod_vcn = {
      compartment_key = "production"
      cidr_blocks     = ["10.0.0.0/16"]
    }
    dev_vcn = {
      compartment_key = "development"
      cidr_blocks     = ["10.1.0.0/16"]
    }
  }

  # IAM configuration
  groups = {
    prod_admins = {
      description = "Production administrators"
    }
    dev_users = {
      description = "Development users"
    }
  }

  policies = {
    prod_admin_policy = {
      compartment_key = "production"
      statements = [
        "Allow group prod_admins to manage all-resources in compartment production"
      ]
    }
  }
}
```

## Advanced Patterns

### Multi-Region Deployment
```hcl
# providers.tf
provider "oci" {
  alias  = "phoenix"
  region = "us-phoenix-1"
}

provider "oci" {
  alias  = "ashburn"
  region = "us-ashburn-1"
}

# Deploy in Phoenix
resource "oci_core_vcn" "phoenix_vcn" {
  provider       = oci.phoenix
  compartment_id = var.compartment_ocid
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "Phoenix VCN"
}

# Deploy in Ashburn
resource "oci_core_vcn" "ashburn_vcn" {
  provider       = oci.ashburn
  compartment_id = var.compartment_ocid
  cidr_blocks    = ["10.1.0.0/16"]
  display_name   = "Ashburn VCN"
}
```

### Using Modules
```hcl
# modules/compute-instance/main.tf
variable "compartment_id" {}
variable "subnet_id" {}
variable "display_name" {}
variable "ssh_public_key" {}

resource "oci_core_instance" "this" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = "VM.Standard.E4.Flex"

  shape_config {
    ocpus = 1
    memory_in_gbs = 16
  }

  display_name = var.display_name

  create_vnic_details {
    subnet_id = var.subnet_id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ol8_images.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

output "instance_id" {
  value = oci_core_instance.this.id
}

output "public_ip" {
  value = oci_core_instance.this.public_ip
}

# main.tf - Using the module
module "web_server" {
  source = "./modules/compute-instance"

  compartment_id  = var.compartment_ocid
  subnet_id       = oci_core_subnet.public_subnet.id
  display_name    = "WebServer"
  ssh_public_key  = var.ssh_public_key
}

module "app_server" {
  source = "./modules/compute-instance"

  compartment_id  = var.compartment_ocid
  subnet_id       = oci_core_subnet.private_subnet.id
  display_name    = "AppServer"
  ssh_public_key  = var.ssh_public_key
}
```

### Dynamic Blocks
```hcl
variable "ingress_rules" {
  type = list(object({
    protocol    = string
    source      = string
    description = string
    tcp_options = object({
      min = number
      max = number
    })
  }))
}

resource "oci_core_security_list" "dynamic_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.app_vcn.id
  display_name   = "DynamicSecurityList"

  dynamic "ingress_security_rules" {
    for_each = var.ingress_rules
    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      description = ingress_security_rules.value.description

      tcp_options {
        min = ingress_security_rules.value.tcp_options.min
        max = ingress_security_rules.value.tcp_options.max
      }
    }
  }
}
```

## Best Practices

### State Management
1. **Remote state**: Use OCI Object Storage or Resource Manager
2. **State locking**: Enable locking for team environments
3. **Separate states**: Use different state files for different environments
4. **Backup state**: Regular backups of state files

### Code Organization
1. **Modules**: Create reusable modules for common patterns
2. **Environments**: Separate directories or workspaces per environment
3. **Variables**: Use terraform.tfvars for environment-specific values
4. **Outputs**: Define outputs for values needed by other stacks

### Security
1. **Sensitive variables**: Mark sensitive data appropriately
2. **Secrets**: Never commit secrets to version control
3. **IAM policies**: Use least privilege principle
4. **Network security**: Default to private, explicitly allow public

### Testing
1. **Terraform validate**: Check syntax before apply
2. **Terraform plan**: Always review plan before apply
3. **Test environments**: Test in non-production first
4. **Terratest**: Use Go tests for complex modules

## Common Workflows

### Initial Setup
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Plan deployment
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan
```

### Making Changes
```bash
# See what would change
terraform plan

# Apply specific resource
terraform apply -target=oci_core_instance.app_instance

# Taint resource for recreation
terraform taint oci_core_instance.app_instance

# Import existing resource
terraform import oci_core_vcn.app_vcn <vcn-ocid>
```

### Cleanup
```bash
# Destroy all resources
terraform destroy

# Destroy specific resource
terraform destroy -target=oci_core_instance.app_instance
```

## When to Use This Skill

Activate this skill when the user mentions:
- Terraform, infrastructure as code, or IaC
- OCI Resource Manager or stacks
- OCI Landing Zones
- Terraform modules or providers
- Automated infrastructure deployment
- Multi-environment management
- Infrastructure templating
- GitOps or CI/CD for infrastructure
- terraform-provider-oci

## Example Interactions

**User**: "Create Terraform code for a three-tier application"
**Response**: Provide complete Terraform configuration with VCN, subnets, compute, database, and load balancer.

**User**: "How do I use OCI Resource Manager?"
**Response**: Show stack creation, planning, and apply workflows with CLI examples.

**User**: "I need a production-ready landing zone"
**Response**: Reference OCI Landing Zone modules with security best practices and multi-compartment structure.
