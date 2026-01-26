#!/bin/bash
# find-ateam-articles.sh - Helper script to search for A-Team articles

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Display usage
usage() {
    cat << EOF
${BLUE}A-Team Article Finder${NC}

Helps you search for Oracle A-Team Chronicles articles relevant to OCI services.

${YELLOW}Usage:${NC}
  $0 <service> [search-term]

${YELLOW}Services:${NC}
  compute      - Compute instances, bare metal
  network      - VCN, subnets, security groups
  database     - Autonomous DB, DB Systems, Exadata
  iam          - Identity, federation, policies
  monitoring   - Metrics, alarms, logs
  integration  - Middleware, GoldenGate, OIC
  genai        - Generative AI services
  all          - Search all services

${YELLOW}Examples:${NC}
  $0 compute                    # Search for compute articles
  $0 database "autonomous"      # Search for autonomous database articles
  $0 iam "federation"           # Search for IAM federation articles
  $0 all "performance"          # Search all services for performance

${YELLOW}Output:${NC}
  Generates Google search URLs you can open in your browser.
  Copy relevant articles to docs/ateam/[service]-articles.md

EOF
    exit 1
}

# Check arguments
if [ $# -lt 1 ]; then
    usage
fi

SERVICE="$1"
SEARCH_TERM="${2:-}"

echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}  A-Team Chronicles Article Search${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

# Define search terms for each service
case "$SERVICE" in
    compute)
        KEYWORDS="compute instance VM bare-metal shapes"
        FILE="compute-articles.md"
        ;;
    network|networking)
        KEYWORDS="VCN subnet NSG security-list gateway routing"
        FILE="networking-articles.md"
        ;;
    database|db)
        KEYWORDS="autonomous database exadata ATP ADW pluggable"
        FILE="database-articles.md"
        ;;
    iam|identity)
        KEYWORDS="IAM identity IDCS federation policies dynamic-groups"
        FILE="iam-articles.md"
        ;;
    monitoring|observability)
        KEYWORDS="monitoring metrics alarms logging events"
        FILE="monitoring-articles.md"
        ;;
    integration)
        KEYWORDS="integration GoldenGate OIC middleware"
        FILE="integration-articles.md"
        ;;
    genai|ai)
        KEYWORDS="generative-ai AI LLM foundation-models"
        FILE="genai-articles.md"
        ;;
    all)
        KEYWORDS="OCI cloud"
        FILE="all-articles.md"
        ;;
    *)
        echo -e "${YELLOW}Unknown service: $SERVICE${NC}"
        echo ""
        usage
        ;;
esac

# Add user search term if provided
if [ -n "$SEARCH_TERM" ]; then
    KEYWORDS="$KEYWORDS $SEARCH_TERM"
fi

echo -e "${GREEN}Service:${NC} $SERVICE"
echo -e "${GREEN}Keywords:${NC} $KEYWORDS"
echo -e "${GREEN}Output file:${NC} docs/ateam/$FILE"
echo ""

# Generate search URLs
echo -e "${CYAN}Google Search URLs:${NC}"
echo ""

# Main A-Team site
ATEAM_QUERY=$(echo "$KEYWORDS" | sed 's/ /+/g')
ATEAM_URL="https://www.google.com/search?q=site%3Aateam-oracle.com+${ATEAM_QUERY}"
echo -e "${YELLOW}1. A-Team Main Site:${NC}"
echo "   $ATEAM_URL"
echo ""

# Oracle blogs A-Team
BLOGS_QUERY=$(echo "$KEYWORDS OCI" | sed 's/ /+/g')
BLOGS_URL="https://www.google.com/search?q=site%3Ablogs.oracle.com%2Fateam+${BLOGS_QUERY}"
echo -e "${YELLOW}2. Oracle A-Team Blogs:${NC}"
echo "   $BLOGS_URL"
echo ""

# Oracle docs with A-Team
DOCS_QUERY=$(echo "a-team $KEYWORDS" | sed 's/ /+/g')
DOCS_URL="https://www.google.com/search?q=site%3Adocs.oracle.com+${DOCS_QUERY}"
echo -e "${YELLOW}3. Oracle Documentation:${NC}"
echo "   $DOCS_URL"
echo ""

# Generate search commands to copy
echo -e "${CYAN}Command to open all searches:${NC}"
echo ""

cat << EOF
# macOS
open "$ATEAM_URL" "$BLOGS_URL" "$DOCS_URL"

# Linux with default browser
xdg-open "$ATEAM_URL"
xdg-open "$BLOGS_URL"
xdg-open "$DOCS_URL"

# Windows (WSL)
powershell.exe start "$ATEAM_URL"
powershell.exe start "$BLOGS_URL"
powershell.exe start "$DOCS_URL"
EOF

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Next Steps${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""
echo "1. Click the URLs above or run the open commands"
echo "2. Browse the search results for relevant articles"
echo "3. For each useful article:"
echo "   - Copy the article URL"
echo "   - Note the title and key points"
echo "   - Add to: docs/ateam/$FILE"
echo ""
echo "4. Use the template from: docs/ateam/ARTICLE-TEMPLATE.md"
echo ""
echo -e "${GREEN}Happy curating! 📚${NC}"
echo ""

# Offer to create the file if it doesn't exist
if [ ! -f "docs/ateam/$FILE" ]; then
    echo -e "${YELLOW}File docs/ateam/$FILE doesn't exist yet.${NC}"
    echo ""
    read -p "Create it from template? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create from template
        SERVICE_NAME=$(echo "$SERVICE" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
        sed "s/\[Service Name\]/$SERVICE_NAME/g; s/\[OCI Service Description\]/OCI $SERVICE_NAME Service/g" \
            docs/ateam/ARTICLE-TEMPLATE.md > "docs/ateam/$FILE"
        echo -e "${GREEN}✓ Created docs/ateam/$FILE${NC}"
        echo ""
        echo "You can now add articles to this file."
    fi
fi
