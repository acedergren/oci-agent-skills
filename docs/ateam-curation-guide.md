# A-Team Chronicles Curation Guide

This guide helps you manually curate and organize Oracle A-Team Chronicles content for use in your OCI plugin.

## Why Manual Curation?

The A-Team Chronicles website (ateam-oracle.com) blocks automated scraping (403 errors), so we need to manually collect relevant articles. This is actually beneficial because:

1. **Quality Control**: You select only OCI-relevant articles
2. **Organized by Topic**: Group articles by OCI service
3. **Metadata Addition**: Add context Claude needs
4. **Lightweight**: Avoid embedding full articles (learned from llms-txt experiment!)

## Curation Workflow

### Step 1: Browse A-Team Chronicles

Visit these sections and identify relevant articles:

```
Main Categories to Explore:
├── Identity & Security
│   └── https://www.ateam-oracle.com/category/atm-identity-access-management-and-security
├── Infrastructure & Compute
├── Networking
├── Database & Data
├── Middleware & Integration
└── Cloud Native
```

### Step 2: Identify OCI-Relevant Articles

For each article, ask:
- ✅ Does it cover OCI services (not just on-premises)?
- ✅ Is it practical/tutorial content (not just announcements)?
- ✅ Does it solve a problem our skills address?
- ✅ Is it recent enough to be current? (last 2-3 years)

### Step 3: Organize by Service

Create a reference file for each OCI service that maps to your skills:

```bash
docs/ateam/
├── compute-articles.md        # Compute-related A-Team articles
├── networking-articles.md     # VCN, networking articles
├── database-articles.md       # DB-related articles
├── iam-articles.md           # IAM/IDCS articles
├── monitoring-articles.md     # Observability articles
└── integration-articles.md    # Integration patterns
```

### Step 4: Use Article Reference Template

For each article, capture this minimal info:

```markdown
## [Article Title]

**URL**: [Full URL]
**Date**: YYYY-MM-DD (if available)
**Author**: [A-Team member name]
**Topics**: Tag1, Tag2, Tag3

**Summary**: One-sentence description of what problem it solves

**Key Takeaways**:
- Point 1
- Point 2
- Point 3

**Relevant CLI Commands** (if any):
\`\`\`bash
oci [service] [command] ...
\`\`\`

**When to Use**: Describe the scenario where this article helps

---
```

## Example: Curating IAM Articles

Let's say you find an article about IDCS integration:

**File**: `docs/ateam/iam-articles.md`

```markdown
# A-Team Chronicles: IAM & Identity Articles

Articles from Oracle A-Team about Identity and Access Management in OCI.

## IDCS Integration with OCI

**URL**: https://docs.oracle.com/en/cloud/paas/identity-cloud/ateam-chronicles.html
**Topics**: IDCS, Federation, SSO, Identity

**Summary**: Integrating Oracle Identity Cloud Service with OCI for federated authentication

**Key Takeaways**:
- IDCS provides SSO across Oracle Cloud applications
- Federation setup between IDCS and OCI IAM
- Dynamic groups can use IDCS attributes

**When to Use**:
- Setting up enterprise SSO for OCI
- Migrating from local users to federated identity
- Implementing attribute-based access control

**Related OCI CLI**:
\`\`\`bash
# List IDCS providers
oci iam identity-provider list --protocol SAML2

# Create federation trust
oci iam saml2-identity-provider create \
  --compartment-id <tenancy-ocid> \
  --metadata-url <idcs-metadata-url>
\`\`\`

---

## [Next Article]
...
```

## Automated Article Discovery

While we can't scrape the site, you can use these methods to find articles:

### Method 1: Browser Export

1. Visit https://www.ateam-oracle.com/
2. Browse categories relevant to OCI
3. Use browser developer tools:
   - Inspect navigation elements
   - Extract article links from HTML
   - Export to JSON/CSV

### Method 2: RSS/Atom Feeds

Check if A-Team has feeds:
```bash
# Check common feed URLs
curl -I https://www.ateam-oracle.com/feed
curl -I https://www.ateam-oracle.com/rss
curl -I https://blogs.oracle.com/ateam/rss
```

### Method 3: Google Site Search

Use Google to find specific OCI topics on A-Team:

```
site:ateam-oracle.com "OCI compute"
site:ateam-oracle.com "autonomous database"
site:ateam-oracle.com "VCN networking"
site:blogs.oracle.com/ateam "terraform OCI"
```

### Method 4: Oracle Search

Use Oracle's documentation search:
```
site:oracle.com "a-team" "OCI" [your topic]
```

## Integration with OCI Plugin

### Option 1: Lightweight Reference Files

Create small reference files (like we did for oci-compute-reference.md) that include A-Team article links:

**File**: `docs/references/oci-compute-reference.md`

```markdown
## Expert Resources

### A-Team Chronicles

See `docs/ateam/compute-articles.md` for curated A-Team articles on:
- Compute instance optimization
- Custom image best practices
- Performance tuning
- Troubleshooting patterns
```

### Option 2: Inline Article References

Add directly to skill files:

**File**: `skills/compute-management/SKILL.md`

```markdown
## Advanced Resources

**A-Team Chronicles - Compute Best Practices**:
- [Article Title](URL) - Brief description
- [Another Article](URL) - Brief description
```

### Option 3: Dedicated A-Team Skill

Create a new skill that activates when users need expert guidance:

**File**: `skills/ateam-guidance/SKILL.md`

```markdown
---
name: ateam-guidance
description: Access Oracle A-Team expert guidance and best practices
trigger: When users need advanced OCI patterns, troubleshooting, or best practices
---

# Oracle A-Team Expert Guidance

Access curated A-Team Chronicles articles for advanced OCI scenarios.

[Include references to your curated article collections]
```

## Maintenance

### Weekly Review (Optional)

```bash
# Set a reminder to check for new A-Team articles weekly
# Add this to crontab or calendar:
# "Review A-Team Chronicles for new OCI articles"
```

### Update Triggers

Update your curated articles when:
- ✅ Major OCI service updates announced
- ✅ New A-Team articles published (subscribe to Oracle blogs)
- ✅ Users encounter issues A-Team has documented
- ✅ Quarterly review of all references

## Practical Example: Building a Database Article Collection

Let's walk through curating database articles:

### Step 1: Search for Database Content

```
Google Search: site:ateam-oracle.com "autonomous database"
Google Search: site:ateam-oracle.com "exadata"
Google Search: site:ateam-oracle.com "database migration"
```

### Step 2: Create Collection File

```bash
touch docs/ateam/database-articles.md
```

### Step 3: Populate with Findings

```markdown
# A-Team Chronicles: Database Articles

## Autonomous Database Best Practices

**URL**: [Article URL]
**Summary**: Best practices for Autonomous Database configuration and optimization

**Key Points**:
- Auto-scaling configuration
- Backup strategies
- Performance tuning
- Cost optimization

**CLI Examples**:
\`\`\`bash
oci db autonomous-database create \
  --compartment-id <id> \
  --cpu-core-count 1 \
  --data-storage-size-in-tbs 1 \
  --db-name mydb \
  --is-auto-scaling-enabled true
\`\`\`

---

## Database Migration to OCI

**URL**: [Article URL]
**Summary**: Patterns for migrating on-premises databases to OCI

**Key Points**:
- Migration tools comparison (Data Pump, GoldenGate, RMAN)
- Network considerations
- Downtime minimization strategies
- Validation approaches

**When to Use**:
- Planning database cloud migration
- Minimizing migration downtime
- Choosing migration tools

---
```

### Step 4: Link from Database Skill

**File**: `skills/database-management/SKILL.md`

Add at the end:
```markdown
## Expert Resources

For advanced database scenarios, see:
- **A-Team Articles**: `docs/ateam/database-articles.md`
- **Official Docs**: Use Context7 to query latest DB documentation
```

## Directory Structure

Organize your A-Team content:

```
agent-skill-oci/
├── docs/
│   ├── ateam/                          # A-Team article collections
│   │   ├── README.md                   # This guide
│   │   ├── compute-articles.md         # Curated compute articles
│   │   ├── networking-articles.md      # Curated networking articles
│   │   ├── database-articles.md        # Curated database articles
│   │   ├── iam-articles.md            # Curated IAM articles
│   │   ├── monitoring-articles.md      # Curated monitoring articles
│   │   └── integration-articles.md     # Curated integration articles
│   ├── references/                     # Our lightweight references
│   │   └── oci-*-reference.md
│   └── ateam-chronicles.llms.txt      # Main llms.txt file (optional)
└── skills/
    └── */SKILL.md                      # Link to A-Team articles
```

## Benefits of Manual Curation

### Quality Over Quantity
- ✅ Only relevant OCI content
- ✅ No outdated articles
- ✅ Focused on your plugin's use cases

### Organized by Intent
- ✅ Grouped by OCI service
- ✅ Tagged by problem/solution
- ✅ Easy for Claude to navigate

### Lightweight
- ✅ Small reference files (not full article HTML)
- ✅ Links to live content (always current)
- ✅ Fits in Claude's context easily

### Maintainable
- ✅ Easy to add new articles
- ✅ Quick to update broken links
- ✅ Clear what content you have

## Checklist: Getting Started

- [ ] Create `docs/ateam/` directory
- [ ] Copy article reference template
- [ ] Search for articles in your priority OCI services
- [ ] Create your first article collection file
- [ ] Curate 3-5 high-value articles per service
- [ ] Link from relevant skills
- [ ] Test: Ask Claude a question that should reference an A-Team article
- [ ] Iterate: Add more articles as you discover them

## Tips for Efficient Curation

### Start Small
Begin with your most-used OCI services:
1. Compute (3-5 articles)
2. Networking (3-5 articles)
3. Database (3-5 articles)

### Focus on Patterns
Look for articles that provide:
- ✅ Architecture patterns
- ✅ Troubleshooting workflows
- ✅ Performance optimization
- ✅ Security best practices
- ✅ Real-world examples

### Avoid Redundancy
If official docs cover it well, just link to docs.
A-Team articles shine when they provide:
- Real-world lessons learned
- Edge case handling
- Integration patterns
- Undocumented tips

### Tag Effectively
Use consistent tags:
- Service: compute, networking, database, iam, etc.
- Type: tutorial, troubleshooting, best-practice, architecture
- Level: beginner, intermediate, advanced
- Topic: performance, security, cost, migration, etc.

## Resources

**Find A-Team Content**:
- Main Site: https://www.ateam-oracle.com/
- Oracle Blogs: https://blogs.oracle.com/ateam/
- Documentation: https://docs.oracle.com/en/cloud/paas/identity-cloud/ateam-chronicles.html

**Search Strategies**:
- Google: `site:ateam-oracle.com [your OCI topic]`
- Google: `site:blogs.oracle.com/ateam [your OCI topic]`
- Oracle Docs: Search for "A-Team" within OCI documentation

**Integration**:
- Link from skills: `skills/*/SKILL.md`
- Reference files: `docs/references/oci-*-reference.md`
- Standalone collections: `docs/ateam/*-articles.md`

---

*Manual curation creates higher quality, more focused documentation than automated scraping. Start small, focus on value, and grow your collection over time.*
