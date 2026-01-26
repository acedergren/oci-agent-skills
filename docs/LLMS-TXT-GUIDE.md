# Documentation Strategy for OCI Plugin

This guide explains the documentation approach for the OCI Cloud Operations plugin and when to use llms-txt CLI vs. lightweight references.

## TL;DR - Recommended Approach

**For OCI Plugin**: Use **lightweight reference files** + **Context7 MCP server**

❌ **Don't use** llms_txt2ctx (creates 1.3MB+ files with full HTML)
✅ **Do use** quick reference docs that link to official docs (Claude fetches on-demand)

## Why Not Use llms-txt Traditional Way?

### The Problem We Discovered

When we ran `llms_txt2ctx` on our `oci-services.llms.txt` file:

```bash
llms_txt2ctx docs/oci-services.llms.txt > output.md
```

**Result**: 17,605 lines, 1.3MB file containing full HTML of every linked page!

```
   17605 docs/llms-context/oci-services.md     # Full HTML embedded
```

### Why This Doesn't Work for OCI

1. **Too Large**: 1.3MB exceeds practical LLM context limits
2. **HTML Cruft**: Includes CSS, JavaScript, navigation elements
3. **Stale Content**: Oracle updates docs frequently, embedded content goes stale
4. **Unnecessary**: You have Context7 MCP server for live documentation access
5. **Slow Processing**: Large files slow down Claude's response time

### The Better Approach: Lightweight References

Create small reference files (5-15KB) that:
- Provide quick command examples
- Link to official docs (Context7 fetches on-demand)
- Include common patterns and troubleshooting
- Stay current (links always point to latest docs)

**Example**: `docs/references/oci-compute-reference.md` (15KB vs 1.3MB!)

## Overview of llms-txt (For Other Use Cases)

The llms-txt CLI converts structured `.llms.txt` files into XML context documents optimized for LLMs. This helps Claude understand OCI services better by providing organized, up-to-date documentation references.

## Installation

```bash
pip install llms-txt
```

## Quick Start

### 1. Create a `.llms.txt` File

Structure your documentation with this format:

```markdown
# Service Name

> Brief description

## Category 1
- [Link Title](URL)
- [Another Link](URL)

## Category 2
- [Resource](URL)

## Optional Resources
- [Advanced Topic](URL)
```

### 2. Convert to Context

```bash
# Basic conversion
llms_txt2ctx docs/oci-services.llms.txt > docs/context/oci-services.md

# Include optional sections
llms_txt2ctx docs/oci-services.llms.txt --optional True > docs/context/oci-services-full.md
```

## Workflow for OCI Plugin

### Step 1: Identify Documentation Needs

For each skill, identify what documentation Claude needs:

**Compute Management Skill:**
- Instance launch/management
- VNIC configuration
- Boot volumes
- Console connections

**Networking Skill:**
- VCN creation
- Subnets and CIDR blocks
- Security lists vs NSGs
- Gateway types

### Step 2: Create Service-Specific `.llms.txt` Files

Create organized documentation files:

```bash
docs/
├── oci-services.llms.txt        # Main OCI services
├── compute.llms.txt              # Compute-specific docs
├── networking.llms.txt           # Networking-specific docs
├── database.llms.txt             # Database-specific docs
└── ...
```

### Step 3: Run the Documentation Gatherer

Use the provided script:

```bash
./scripts/gather-docs.sh
```

Or manually:

```bash
# Convert each service documentation
llms_txt2ctx docs/compute.llms.txt > docs/context/compute.md
llms_txt2ctx docs/networking.llms.txt > docs/context/networking.md
llms_txt2ctx docs/database.llms.txt > docs/context/database.md
```

### Step 4: Reference in Skills

Update your `SKILL.md` files to reference the context:

```markdown
---
name: compute-management
description: Manage OCI compute instances
trigger: When users work with OCI compute instances, VMs, or bare metal servers
---

# Compute Management Skill

<!-- Include the gathered documentation context -->
See docs/context/compute.md for comprehensive CLI references.

## Common Operations
...
```

## Example: Complete Workflow

### 1. Create Documentation File

`docs/genai.llms.txt`:

```markdown
# OCI Generative AI Service

> Foundation models, text generation, embeddings, and chat capabilities

## Service Overview
- [GenAI Overview](https://docs.oracle.com/en-us/iaas/Content/generative-ai/overview.htm)
- [GenAI Concepts](https://docs.oracle.com/en-us/iaas/Content/generative-ai/concepts.htm)

## CLI Reference
- [CLI GenAI Commands](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/oci_cli_docs/cmdref/generative-ai.html)
- [CLI Inference Commands](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/oci_cli_docs/cmdref/generative-ai-inference.html)

## Foundation Models
- [Pretrained Models](https://docs.oracle.com/en-us/iaas/Content/generative-ai/pretrained-models.htm)
- [Model Selection](https://docs.oracle.com/en-us/iaas/Content/generative-ai/model-selection.htm)

## Text Generation
- [Generate Text](https://docs.oracle.com/en-us/iaas/Content/generative-ai/generate-text.htm)
- [Chat Completion](https://docs.oracle.com/en-us/iaas/Content/generative-ai/chat.htm)

## Embeddings
- [Embeddings Overview](https://docs.oracle.com/en-us/iaas/Content/generative-ai/embeddings.htm)
- [Use Embeddings](https://docs.oracle.com/en-us/iaas/Content/generative-ai/use-embeddings.htm)

## Optional Resources
- [Fine-tuning Models](https://docs.oracle.com/en-us/iaas/Content/generative-ai/fine-tune.htm)
- [Best Practices](https://docs.oracle.com/en-us/iaas/Content/generative-ai/best-practices.htm)
```

### 2. Convert to Context

```bash
llms_txt2ctx docs/genai.llms.txt > docs/context/genai.md
```

### 3. Use in Python

You can also use the Python API programmatically:

```python
from llms_txt import parse_llms_file, create_ctx

# Parse the documentation file
with open('docs/genai.llms.txt', 'r') as f:
    content = f.read()

# Parse into structured data
parsed = parse_llms_file(content)
print(f"Title: {parsed.title}")
print(f"Summary: {parsed.summary}")
print(f"Sections: {list(parsed.sections.keys())}")

# Create LLM-optimized context
ctx = create_ctx(content)
with open('docs/context/genai.md', 'w') as f:
    f.write(ctx)
```

## Benefits for Your OCI Plugin

### 1. **Organized Documentation**
   - Structured references to official OCI docs
   - Easy to update as OCI evolves
   - Categorized by service and use case

### 2. **Claude Knowledge Enhancement**
   - Compensates for limited OCI training data
   - Provides up-to-date CLI syntax
   - Includes best practices and patterns

### 3. **Maintainability**
   - Single source of truth for documentation links
   - Easy to regenerate when OCI docs update
   - Version control friendly

### 4. **Skill Activation Improvement**
   - Better context helps Claude understand when to activate skills
   - More accurate command generation
   - Improved troubleshooting guidance

## Best Practices

### 1. Service-Specific Files
Create separate `.llms.txt` files for each major service:
- `compute.llms.txt`
- `networking.llms.txt`
- `database.llms.txt`
- etc.

### 2. Hierarchical Organization
Structure documentation hierarchically:
```
## Overview          # High-level concepts
## Getting Started   # Quick start guides
## Common Operations # Frequent tasks
## CLI Reference     # Command syntax
## SDK Reference     # Python/Java SDK
## Optional Resources # Advanced topics
```

### 3. Update Regularly
- Check for OCI documentation updates quarterly
- Regenerate context files when docs change
- Version your `.llms.txt` files in git

### 4. Link Quality
- Prefer official Oracle documentation
- Link to specific pages, not just main docs
- Include both concept and reference pages

### 5. Test Generated Context
After generating context:
1. Verify links are valid
2. Ensure structure is preserved
3. Test Claude's ability to use the context

## Automation

### GitHub Actions Workflow

Create `.github/workflows/update-docs.yml`:

```yaml
name: Update Documentation Context

on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
  workflow_dispatch:

jobs:
  update-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install llms-txt
        run: pip install llms-txt

      - name: Generate documentation context
        run: ./scripts/gather-docs.sh

      - name: Commit updates
        run: |
          git config user.name "Documentation Bot"
          git config user.email "bot@example.com"
          git add docs/llms-context/
          git diff --quiet || git commit -m "Update documentation context"
          git push
```

## Troubleshooting

### Issue: "llms_txt2ctx: command not found"
**Solution:** Install llms-txt:
```bash
pip install llms-txt
# or
pip install --user llms-txt
```

### Issue: "Invalid .llms.txt format"
**Solution:** Verify your format:
- Must have level 1 heading (#) as title
- Categories are level 2 headings (##)
- Links must be in markdown format `[text](url)`

### Issue: "Generated context is too large"
**Solution:**
- Remove optional sections: use `--optional False`
- Split into multiple smaller files
- Focus on most relevant documentation

## Resources

- [llms-txt Official Site](https://llmstxt.org)
- [llms-txt GitHub](https://github.com/simonw/llms-txt)
- [OCI Documentation](https://docs.oracle.com/en-us/iaas/)
- [Claude Code Plugin Development](https://github.com/anthropics/claude-code)

## Next Steps

1. **Create comprehensive `.llms.txt` files** for each OCI service
2. **Run the documentation gatherer** regularly
3. **Update your skills** to reference the generated context
4. **Test Claude's improved understanding** of OCI services
5. **Automate the process** with GitHub Actions or cron jobs
