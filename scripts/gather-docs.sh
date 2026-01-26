#!/bin/bash
# gather-docs.sh - Create lightweight OCI documentation references

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}OCI Documentation Reference Generator${NC}"
echo "======================================"
echo ""

# Create docs directory if it doesn't exist
mkdir -p docs/references

cat << 'EOF'
This script generates lightweight reference documents for OCI services.

Unlike llms_txt2ctx which downloads full HTML (creating 1.3MB+ files),
these references provide:
  ✓ Quick command examples
  ✓ Links to official docs (fetched on-demand via Context7)
  ✓ Best practices and patterns
  ✓ Troubleshooting guides
  ✓ Python SDK examples

Benefits:
  • Small file size (fits in LLM context)
  • Always points to latest docs (via Context7 MCP)
  • Faster to load and process
  • No stale embedded content

EOF

echo ""
echo -e "${GREEN}Creating service reference files...${NC}"
echo ""

# List of OCI services to document
services=(
    "compute:Compute instances and bare metal"
    "network:VCN, subnets, security groups"
    "database:Autonomous DB, DB Systems"
    "monitoring:Metrics, alarms, logs"
    "iam:Users, groups, policies"
    "vault:Secrets management"
    "genai:Generative AI services"
)

for service_info in "${services[@]}"; do
    service="${service_info%%:*}"
    desc="${service_info#*:}"

    ref_file="docs/references/oci-${service}-reference.md"

    if [ ! -f "$ref_file" ]; then
        echo -e "${YELLOW}  [ ] ${service} - ${desc}${NC}"
        echo "      Create: $ref_file"
    else
        echo -e "${GREEN}  ✓ ${service} - ${desc}${NC}"
    fi
done

echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo ""
echo "1. Create reference files in docs/references/"
echo "   Format: oci-{service}-reference.md"
echo ""
echo "2. Include in your SKILL.md files:"
echo "   <!-- See docs/references/oci-compute-reference.md -->"
echo ""
echo "3. Claude will:"
echo "   • Read the lightweight reference for quick patterns"
echo "   • Use Context7 MCP to fetch detailed docs on-demand"
echo "   • Provide accurate, up-to-date OCI guidance"
echo ""
echo -e "${YELLOW}Example reference created: docs/oci-compute-reference.md${NC}"
