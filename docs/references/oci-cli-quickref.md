# OCI CLI Quick Reference

> **Quick cheat sheet for the most common OCI CLI commands**
> **Last Updated:** 2026-01-28

## Setup & Configuration

```bash
# Install OCI CLI
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

# Configure
oci setup config

# Test
oci iam region list --output table
```

## Common Patterns

### Output Formatting
```bash
--output json          # Default JSON output
--output table         # Human-readable table
--output text          # Plain text
--query 'data[*].id'   # JMESPath filtering
--raw-output           # Remove quotes (for scripting)
```

### Authentication
```bash
--auth api_key                # Default (from config)
--auth instance_principal     # From compute instance
--auth resource_principal     # OCI Functions
--profile prod                # Use specific profile
```

## Compute

```bash
# Launch instance
oci compute instance launch \
  --availability-domain <AD> \
  --compartment-id <CID> \
  --shape VM.Standard.E4.Flex \
  --subnet-id <SUBNET_ID> \
  --image-id <IMAGE_ID>

# List instances
oci compute instance list -c <CID> --output table

# Get instance
oci compute instance get --instance-id <INSTANCE_ID>

# Instance actions
oci compute instance action --instance-id <ID> --action START|STOP|REBOOT

# Terminate
oci compute instance terminate --instance-id <ID>
```

## Database

```bash
# List Autonomous Databases
oci db autonomous-database list -c <CID>

# Create ADB
oci db autonomous-database create \
  -c <CID> \
  --db-name mydb \
  --admin-password <PWD> \
  --cpu-core-count 1 \
  --data-storage-size-in-tbs 1

# Start/Stop ADB
oci db autonomous-database start --autonomous-database-id <ID>
oci db autonomous-database stop --autonomous-database-id <ID>
```

## Networking

```bash
# Create VCN
oci network vcn create -c <CID> --cidr-block "10.0.0.0/16"

# Create subnet
oci network subnet create \
  -c <CID> \
  --vcn-id <VCN_ID> \
  --cidr-block "10.0.1.0/24"

# List VCNs
oci network vcn list -c <CID> --output table
```

## Object Storage

```bash
# Create bucket
oci os bucket create -c <CID> --name my-bucket

# Upload object
oci os object put -bn my-bucket --file /path/to/file --name file.txt

# Download object
oci os object get -bn my-bucket --name file.txt --file /path/to/save

# List objects
oci os object list -bn my-bucket

# Delete object
oci os object delete -bn my-bucket --name file.txt
```

## IAM

```bash
# List users
oci iam user list -c <TENANCY_ID>

# Create user
oci iam user create --name john.doe@example.com

# List compartments
oci iam compartment list -c <TENANCY_ID> --compartment-id-in-subtree true

# Create policy
oci iam policy create \
  -c <CID> \
  --name my-policy \
  --statements '["Allow group admins to manage all-resources in compartment dev"]'
```

## Monitoring

```bash
# Query metrics
oci monitoring metric-data summarize-metrics-data \
  -c <CID> \
  --namespace oci_computeagent \
  --query-text "CpuUtilization[1m].mean()"

# Create alarm
oci monitoring alarm create \
  -c <CID> \
  --display-name "High CPU" \
  --destinations '["<TOPIC_ID>"]' \
  --query "CpuUtilization[1m].mean() > 80"
```

## Vault & Secrets

```bash
# Create vault
oci kms management vault create -c <CID> --display-name my-vault

# List vaults
oci kms management vault list -c <CID>

# Get secret value
oci secrets secret-bundle get --secret-id <SECRET_ID>
```

## Logging

```bash
# Create log group
oci logging log-group create -c <CID> --display-name my-logs

# Search logs
oci logging-search search-logs \
  --search-query 'search "<CID>" | where type="<TYPE>"'
```

## Resource Search

```bash
# Search all instances
oci search resource structured-search \
  --query-text "query instance resources"

# Search in compartment
oci search resource structured-search \
  --query-text "query all resources where compartmentId = '<CID>'"
```

## Useful Shortcuts

### Get Resource OCIDs
```bash
# Get compartment OCID by name
oci iam compartment list \
  --query "data[?name=='dev'].id | [0]" \
  --raw-output

# Get instance OCID by display name
oci compute instance list -c <CID> \
  --query "data[?\"display-name\"=='my-instance'].id | [0]" \
  --raw-output
```

### Scripting Examples
```bash
# Store OCID in variable
INSTANCE_ID=$(oci compute instance list -c <CID> \
  --query 'data[0].id' --raw-output)

# Loop through resources
for bucket in $(oci os bucket list -c <CID> --query 'data[*].name' --raw-output); do
  echo "Processing bucket: $bucket"
done
```

### Common JMESPath Queries
```bash
--query 'data[*].id'                           # All IDs
--query 'data[*].{Name:name,State:state}'     # Custom fields
--query 'data[?state==`RUNNING`]'             # Filter by state
--query 'data[0]'                              # First result
--query 'length(data)'                         # Count results
```

## Debugging

```bash
# Enable debug output
oci <command> --debug

# Use different config file
oci <command> --config-file ~/.oci/config-prod

# Override region
oci <command> --region us-ashburn-1

# Dry run (check command without executing)
oci <command> --generate-full-command-json-input
```

## Pagination

```bash
# Get all results (auto-pagination)
oci compute instance list -c <CID> --all

# Manual pagination
oci compute instance list -c <CID> --limit 10 --page <TOKEN>
```

## Best Practices

1. **Use profiles** for different environments
   ```bash
   oci session authenticate --profile prod
   oci session authenticate --profile dev
   ```

2. **Store OCIDs in variables** for reusability
   ```bash
   COMPARTMENT_ID="ocid1.compartment.oc1..xxx"
   ```

3. **Use `--output table`** for human readability
   ```bash
   oci compute instance list -c $CID --output table
   ```

4. **Use `--query`** for filtering in scripts
   ```bash
   oci compute instance list -c $CID --query 'data[*].id'
   ```

5. **Check exit codes** in scripts
   ```bash
   if oci compute instance get --instance-id $ID > /dev/null 2>&1; then
     echo "Instance exists"
   fi
   ```

## Common Abbreviations

- `-c` = `--compartment-id`
- `-bn` = `--bucket-name`
- `<CID>` = Compartment OCID
- `<ID>` = Resource OCID
- `<AD>` = Availability Domain
- `<VCN>` = Virtual Cloud Network
- `<ADB>` = Autonomous Database

## Related Documentation

- **Full Reference**: [oci-cli-reference.md](./oci-cli-reference.md)
- **OCI CLI Docs**: https://docs.oracle.com/iaas/tools/oci-cli/latest/
- **Scraped Docs**: `.firecrawl/oci-cli-docs/`

---

*Keep this cheat sheet bookmarked for quick command lookups!*
