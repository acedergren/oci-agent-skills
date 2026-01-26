# A-Team Chronicles Integration - Summary

This document summarizes how to integrate Oracle A-Team Chronicles content into your OCI plugin.

## What We Built

Since A-Team Chronicles website blocks automated scraping, we created a **manual curation system** that's actually better than automated approaches:

### 1. Directory Structure

```
docs/
├── ateam/
│   ├── README.md                    # Overview and statistics
│   ├── ARTICLE-TEMPLATE.md          # Template for new articles
│   ├── iam-articles.md              # Example: IAM articles (1 complete)
│   ├── compute-articles.md          # TODO: Create
│   ├── networking-articles.md       # TODO: Create
│   ├── database-articles.md         # TODO: Create
│   ├── monitoring-articles.md       # TODO: Create
│   └── integration-articles.md      # TODO: Create
├── ateam-chronicles.llms.txt        # Main llms.txt file (optional)
└── ateam-curation-guide.md          # Complete curation guide
```

### 2. Scripts

```
scripts/
└── find-ateam-articles.sh           # Helper to generate search URLs
```

### 3. Documentation

- **Curation Guide**: `docs/ateam-curation-guide.md` - Complete workflow
- **Article Template**: `docs/ateam/ARTICLE-TEMPLATE.md` - Structure for articles
- **Example Collection**: `docs/ateam/iam-articles.md` - Shows how it works

## Quick Start

### Find Articles for a Service

```bash
# Search for compute articles
./scripts/find-ateam-articles.sh compute

# Search for specific topic
./scripts/find-ateam-articles.sh database "autonomous"

# Search all services for a topic
./scripts/find-ateam-articles.sh all "performance"
```

This generates Google search URLs you can open:
- A-Team main site
- Oracle A-Team blogs
- Oracle documentation

### Add Articles to Collection

1. **Copy the template**:
   ```bash
   cp docs/ateam/ARTICLE-TEMPLATE.md docs/ateam/compute-articles.md
   ```

2. **Fill in article details**:
   - URL
   - Summary (one sentence)
   - Key takeaways (bullet points)
   - Relevant CLI commands
   - When to use

3. **Keep it lightweight**:
   - Don't copy full article text
   - Link to live content
   - Focus on practical value

## Why Manual Curation Wins

### ❌ Automated Approach (llms-txt)
- Downloads full HTML of every page
- Creates 1.3MB+ files
- Includes CSS, JavaScript, navigation
- Gets stale quickly
- Too large for LLM context

### ✅ Manual Curation Approach
- Small reference files (5-15KB each)
- Links to always-current content
- Only OCI-relevant articles
- Organized by your needs
- Perfect for Claude's context

## Integration with Your Plugin

### Option 1: Reference from Skills

Add to your `SKILL.md` files:

```markdown
## Expert Resources

**A-Team Best Practices**:
See `docs/ateam/compute-articles.md` for expert guidance on:
- Compute optimization
- Performance tuning
- Troubleshooting patterns
```

### Option 2: Inline in Reference Files

Add to `docs/references/oci-compute-reference.md`:

```markdown
## A-Team Resources

- [Performance Tuning Guide](URL) - A-Team best practices
- [Troubleshooting Patterns](URL) - Real-world solutions
```

### Option 3: Dedicated A-Team Skill

Create `skills/ateam-guidance/SKILL.md`:

```markdown
---
name: ateam-guidance
description: Oracle A-Team expert guidance
trigger: When users need advanced patterns or troubleshooting
---

Access curated A-Team Chronicles articles organized by service.
```

## Benefits

### For Claude
- ✅ Fast to scan (5-15KB vs 1.3MB)
- ✅ Always current via links
- ✅ Organized by OCI service
- ✅ Practical examples ready

### For Users
- ✅ Expert real-world guidance
- ✅ Beyond official documentation
- ✅ Troubleshooting patterns
- ✅ Best practices from field

### For You
- ✅ Quality control (curate what matters)
- ✅ Easy to maintain
- ✅ No stale embedded content
- ✅ Grows with your needs

## Example: IAM Articles

We created `docs/ateam/iam-articles.md` as an example:

**Complete Article**:
- IDCS Integration with OCI
- Full CLI commands
- IAM policy examples
- When to use guidance

**Placeholders**:
- IAM Policy Best Practices (search needed)
- Dynamic Groups (search needed)

**Next Steps**:
- Run search script
- Find articles
- Add to collection

## Workflow

```
1. Need articles for a service?
   ↓
2. Run: ./scripts/find-ateam-articles.sh [service]
   ↓
3. Opens Google searches in browser
   ↓
4. Browse results, find relevant articles
   ↓
5. For each good article:
   - Copy URL, title, key points
   - Add to docs/ateam/[service]-articles.md
   ↓
6. Reference from your skills
   ↓
7. Claude uses curated articles + Context7
```

## Current Status

```
Articles Curated by Service:
├── IAM/Identity:    1 complete, 2 placeholders
├── Compute:         Not started
├── Networking:      Not started
├── Database:        Not started
├── Monitoring:      Not started
└── Integration:     Not started

Tools Created:
├── ✅ Article finder script
├── ✅ Curation guide
├── ✅ Article template
├── ✅ Example collection (IAM)
└── ✅ Directory structure

Ready to Use:
✅ Find articles with script
✅ Add articles with template
✅ Reference from skills
```

## Next Steps

### Immediate (5-10 minutes each)
1. **Run article finder for your top service**:
   ```bash
   ./scripts/find-ateam-articles.sh compute
   ```

2. **Curate 3-5 articles**:
   - Create `docs/ateam/compute-articles.md`
   - Add your first articles

3. **Link from a skill**:
   - Update `skills/compute-management/SKILL.md`
   - Reference your curated articles

### Short-term (1-2 hours)
4. **Curate remaining priority services**:
   - Database (3-5 articles)
   - Networking (3-5 articles)
   - IAM (complete placeholders)

5. **Update skill files**:
   - Add A-Team references to relevant skills

### Ongoing (monthly)
6. **Check for new A-Team content**:
   - Subscribe to Oracle blogs
   - Run searches for new articles
   - Add relevant content as discovered

## Resources

### What You Have

- **Main Guide**: `docs/ateam-curation-guide.md`
- **Template**: `docs/ateam/ARTICLE-TEMPLATE.md`
- **Example**: `docs/ateam/iam-articles.md`
- **Finder Script**: `scripts/find-ateam-articles.sh`
- **Directory**: `docs/ateam/`

### A-Team Resources

- **Main Site**: https://www.ateam-oracle.com/
- **Blog**: https://blogs.oracle.com/ateam/
- **Identity Category**: https://www.ateam-oracle.com/category/atm-identity-access-management-and-security
- **WebCenter**: https://www.ateam-oracle.com/webcenter-atc
- **Integration**: https://oracle-integration.cloud/tag/a-team/

### Oracle Resources

- **Docs**: https://docs.oracle.com/
- **Community**: https://community.oracle.com/
- **GitHub**: https://github.com/oracle/

## Comparison: Approaches

| Aspect | llms-txt Auto | Manual Curation |
|--------|--------------|-----------------|
| File size | 1.3MB+ | 5-15KB |
| Content freshness | Stale | Current (links) |
| Quality | Everything | Best only |
| Setup time | Minutes | Hours |
| Maintenance | Regenerate all | Update specific |
| Context fit | Often too large | Always fits |
| Organization | By doc structure | By your needs |
| Value density | Low (lots of fluff) | High (curated) |

## Tips for Success

### Start Small
- Begin with 1-2 services
- Curate 3-5 articles each
- Expand as needed

### Focus on Value
- Real-world guidance
- Troubleshooting patterns
- Architecture best practices
- Edge case handling

### Keep It Lightweight
- Link, don't embed
- Summarize key points
- Include relevant commands
- Note when to use

### Maintain Quality
- Monthly check for new content
- Quarterly verify links
- Remove outdated content
- Update based on user feedback

## Questions?

See the detailed guides:
- **How to curate**: `docs/ateam-curation-guide.md`
- **Article format**: `docs/ateam/ARTICLE-TEMPLATE.md`
- **Example**: `docs/ateam/iam-articles.md`

Run the finder script:
```bash
./scripts/find-ateam-articles.sh --help
```

---

**Bottom Line**: Manual curation takes a bit more time upfront but creates higher quality, more maintainable, and more valuable documentation than automated scraping. Start with one service, prove the value, then expand.

*Created: 2026-01-26*
*Status: Ready to use*
