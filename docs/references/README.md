# OCI Service References

Lightweight reference documentation for OCI services used in Claude Code skills.

## Philosophy

These references provide **just enough** information for Claude to:
1. Understand common OCI patterns quickly
2. Know where to find detailed docs (via Context7 MCP)
3. Generate accurate CLI commands
4. Troubleshoot common issues

## What's Different?

### Traditional llms-txt Approach
```
Input:  .llms.txt file with doc links
Tool:   llms_txt2ctx downloads FULL HTML
Output: 1.3MB file with embedded documentation
Result: ❌ Too large for LLM context
```

### Our Lightweight Approach
```
Input:  Service-specific reference files
Content: CLI examples + links + patterns
Output: 5-15KB concise references
Result: ✅ Perfect for LLM context + Context7 on-demand
```

## Reference Files

| Service | File | Size | Status |
|---------|------|------|--------|
| **OCI CLI** | `oci-cli-reference.md` | 15K | ✅ Complete |
| **CLI Quick Ref** | `oci-cli-quickref.md` | 5K | ✅ Complete |
| Compute | `oci-compute-reference.md` | 4.6K | ✅ Complete |
| Network | `oci-network-reference.md` | - | 🚧 TODO |
| Database | `oci-database-reference.md` | - | 🚧 TODO |
| Monitoring | `oci-monitoring-reference.md` | - | 🚧 TODO |
| IAM | `oci-iam-reference.md` | - | 🚧 TODO |
| Vault | `oci-vault-reference.md` | - | 🚧 TODO |
| GenAI | `oci-genai-reference.md` | - | 🚧 TODO |

## Creating New References

### 1. Use the Template

```bash
cp TEMPLATE.md oci-[service]-reference.md
```

### 2. Fill in Service Details

- Service overview and CLI namespace
- Common operations (3-5 most frequent tasks)
- Resource types table
- Best practices (5 key points)
- IAM policies (2-3 examples)
- Troubleshooting (3-5 common issues)
- Python SDK examples (2-3 patterns)

### 3. Keep It Concise

**Target**: 100-300 lines (5-15KB)
- Focus on 80% use cases
- Link to Context7 for edge cases
- Prioritize working examples over theory

### 4. Structure for Scanning

Claude should be able to:
- Find a command in <5 seconds of reading
- Identify troubleshooting steps quickly
- Get Python SDK patterns at a glance

## Reference Quality Guidelines

### ✅ Good Reference Includes

- **Concrete examples**: Full working CLI commands
- **Context7 links**: Where to find detailed docs
- **Common patterns**: Most frequent 3-5 operations
- **Troubleshooting**: Issues users actually encounter
- **IAM policies**: Real policy examples
- **SDK code**: Copy-paste Python examples

### ❌ Avoid

- **Long explanations**: Link to docs instead
- **Every possible flag**: Show common combos
- **Theoretical concepts**: Practical examples first
- **Duplicating official docs**: References, not rewrites
- **Stale information**: Use links to always-current docs

## Usage in Skills

Reference these files in your `SKILL.md`:

```markdown
---
name: compute-management
description: Manage OCI compute instances
---

# OCI Compute Management

Quick reference: See `docs/references/oci-compute-reference.md`

When users work with compute instances, Claude will:
1. Read the lightweight reference for patterns
2. Use Context7 to fetch specific detailed docs
3. Generate accurate commands
4. Provide relevant troubleshooting
```

## Benefits

### For Claude
- ✅ Fast to scan (5-15KB vs 1.3MB)
- ✅ Always current (links to live docs)
- ✅ Practical examples ready to use
- ✅ Troubleshooting patterns learned

### For Users
- ✅ Quick command generation
- ✅ Accurate OCI guidance
- ✅ Context7 fetches details on-demand
- ✅ Comprehensive troubleshooting

### For Maintainers
- ✅ Small files easy to update
- ✅ Links stay current automatically
- ✅ Template ensures consistency
- ✅ No stale embedded documentation

## How Context7 Integration Works

```
User: "Create an autonomous database"
  ↓
Claude reads: oci-database-reference.md (5KB)
  ↓
Claude sees: Example command + pattern
  ↓
Claude uses Context7: "OCI autonomous database create flags"
  ↓
Context7 fetches: Latest official docs
  ↓
Claude generates: Accurate, current command
```

## Maintenance

### Quarterly Review
1. Verify example commands still work
2. Update if OCI CLI changes syntax
3. Add new common patterns discovered
4. Remove deprecated features

### As-Needed Updates
- New OCI service features
- CLI namespace changes
- SDK major version updates
- Common issues discovered

## Examples

### Compute Reference (Complete)
See `oci-compute-reference.md` for a complete example covering:
- Instance launch/management
- VNIC operations
- Console access
- Shape selection
- Troubleshooting
- Python SDK examples

### Template (Starting Point)
See `TEMPLATE.md` for the structure to follow when creating new references.

## Comparison: Traditional vs Lightweight

| Aspect | llms-txt (Traditional) | Lightweight References |
|--------|----------------------|----------------------|
| File size | 1.3MB per service | 5-15KB per service |
| Content | Full HTML embedded | Commands + links |
| Updates | Re-run tool | Edit markdown |
| Freshness | Gets stale | Always current |
| Context fit | Often too large | Always fits |
| Processing | Slow | Fast |
| Maintenance | Regenerate all | Edit specific |

## Next Steps

1. **Create remaining references** using the template
2. **Update SKILL.md files** to reference these docs
3. **Test Claude's understanding** with real OCI questions
4. **Iterate based on usage** - add patterns as discovered

## Resources

- **Template**: `TEMPLATE.md` - Structure for new references
- **Example**: `oci-compute-reference.md` - Complete reference
- **Guide**: `../LLMS-TXT-GUIDE.md` - Full documentation approach guide
- **Script**: `../../scripts/gather-docs.sh` - Status checker

---

*References are designed to work in harmony with Context7 MCP server for on-demand detailed documentation.*
