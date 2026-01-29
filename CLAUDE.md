# CLAUDE.md

Claude-specific configuration for OCI Agent Skills.

## Project Context

This repository contains Oracle Cloud Infrastructure (OCI) agent skills - expert knowledge externalized as markdown files that enhance AI coding agents' capabilities for OCI automation.

## Key Commands

```bash
# Release workflow
npm run release:patch    # Bump patch version
npm run release:minor    # Bump minor version
npm run release          # Auto-bump from commits

# After release
git push --follow-tags origin main
```

## Commit Convention

Use conventional commits (enforced by commitlint):
- `feat:` - New skill or feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `chore:` - Maintenance

Include co-author:
```
Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>
```

## Skill Development

When creating or modifying skills:

1. **SKILL.md** must have YAML frontmatter:
   ```yaml
   ---
   name: skill-name
   description: When to use this skill. Keywords.
   version: "2.0.0"
   license: MIT
   ---
   ```

2. **metadata.json** required per skill:
   ```json
   {
     "version": "2.0.0",
     "organization": "Community",
     "author": "Alexander Cedergren",
     "abstract": "Brief description",
     "references": ["https://docs.oracle.com/..."]
   }
   ```

3. **A++ Quality**: ≥6 NEVERs, ≤500 lines, references/ directory

## File Locations

- Skills: `skills/{skill-name}/SKILL.md`
- References: `skills/{skill-name}/references/`
- Plugin manifest: `.claude-plugin/plugin.json`
- Quality tests: `.skill-tests/`

## Secrets

Never commit:
- `.firecrawl/` - Contains API tokens
- `.skill-tests/results/` - Test output
