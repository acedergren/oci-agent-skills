# Publication Checklist

Use this checklist to track your progress publishing the OCI Cloud Operations Plugin.

## Pre-Publication (✅ Complete!)

- [x] Plugin structure created
- [x] 8 comprehensive skills developed
- [x] OCI Cloud Architect agent created
- [x] MCP servers configured (oci-api, context7)
- [x] README.md with comprehensive documentation
- [x] QUICKSTART.md for user onboarding
- [x] LICENSE file (MIT)
- [x] CHANGELOG.md with version history
- [x] Enhanced plugin.json with metadata
- [x] marketplace.json created
- [x] PUBLISHING.md guide created

## GitHub Repository Setup

- [ ] Create GitHub account (if needed)
- [ ] Create new repository: `agent-skill-oci`
  - [ ] Set as Public
  - [ ] Do NOT initialize with README
- [ ] Note your GitHub username: `__________________`

## Local Git Setup

- [ ] Initialize git repository
  ```bash
  cd /Users/acedergr/Projects/agent-skill-oci
  git init
  git branch -M main
  ```

- [ ] Create .gitignore
  ```bash
  cat > .gitignore << 'EOF'
  .DS_Store
  .vscode/
  .idea/
  *.tmp
  *.log
  EOF
  ```

- [ ] Update URLs in plugin.json with your GitHub username
  ```bash
  # Replace 'acedergren' with your actual username
  sed -i '' 's|acedergren|YOUR_GITHUB_USERNAME|g' .claude-plugin/plugin.json
  ```

- [ ] Initial commit
  ```bash
  git add .
  git commit -m "Initial commit: OCI Cloud Operations Plugin v1.0.0"
  ```

## Push to GitHub

- [ ] Add remote
  ```bash
  git remote add origin https://github.com/YOUR_GITHUB_USERNAME/agent-skill-oci.git
  ```

- [ ] Push to GitHub
  ```bash
  git push -u origin main
  ```

- [ ] Create and push release tag
  ```bash
  git tag -a v1.0.0 -m "Release v1.0.0: Initial public release"
  git push origin v1.0.0
  ```

## GitHub Repository Configuration

- [ ] Add repository description
  - "Oracle Cloud Infrastructure operations plugin for Claude Code with intelligent agent skills"

- [ ] Add topics/tags:
  - [ ] `claude-code`
  - [ ] `claude-plugin`
  - [ ] `oci`
  - [ ] `oracle-cloud`
  - [ ] `infrastructure`
  - [ ] `devops`
  - [ ] `terraform`
  - [ ] `automation`

- [ ] Enable Issues (Settings → General)
- [ ] Add About section with website/description

## Create GitHub Release

- [ ] Go to Releases → Create new release
- [ ] Select tag: `v1.0.0`
- [ ] Release title: `OCI Cloud Operations Plugin v1.0.0`
- [ ] Add release notes (see PUBLISHING.md for template)
- [ ] Publish release

## Testing Installation

- [ ] Test marketplace installation locally
  ```bash
  /plugin marketplace add YOUR_GITHUB_USERNAME/agent-skill-oci
  /plugin install oci-cloud-ops@oracle-cloud-ops
  ```

- [ ] Verify skills appear
  ```bash
  /help
  ```

- [ ] Test a skill activation
  ```
  List all compute instances in my compartment
  ```

## Update README with Installation

- [ ] Add installation section with your actual GitHub URL
- [ ] Include prerequisites
- [ ] Add quick verification steps
- [ ] Commit and push updates

## Optional Enhancements

- [ ] Create social preview image (1280x640px)
- [ ] Set up GitHub Pages for docs
- [ ] Create issue templates (`.github/ISSUE_TEMPLATE/`)
- [ ] Add SECURITY.md
- [ ] Add CONTRIBUTING.md

## Community Promotion

- [ ] Share on Claude Code Discord
- [ ] Post on Reddit (r/ClaudeAI, r/devops, r/oracle)
- [ ] Tweet announcement
- [ ] Post on Dev.to or Hashnode
- [ ] Share in Oracle Cloud communities

## Announcement Template

Use this for social media:

```
🚀 Excited to release: OCI Cloud Operations Plugin for Claude Code!

Manage Oracle Cloud Infrastructure with AI assistance:

✨ 8 specialized skills (Compute, Networking, Database, Monitoring, GenAI, IAM, IaC)
📚 800+ CLI commands with examples
🤖 Intelligent multi-skill orchestration
🔐 Built-in security best practices
🐍 Python SDK integration

Installation:
/plugin marketplace add YOUR_GITHUB_USERNAME/agent-skill-oci

GitHub: https://github.com/YOUR_GITHUB_USERNAME/agent-skill-oci

#ClaudeCode #OCI #DevOps #CloudComputing #Infrastructure
```

## Post-Publication

- [ ] Monitor GitHub Issues for bug reports
- [ ] Respond to community questions
- [ ] Plan next features (see CHANGELOG.md "Unreleased")
- [ ] Set up GitHub Actions for testing (optional)
- [ ] Create demo video or GIF (optional)

## Maintenance Schedule

- [ ] Weekly: Check issues and discussions
- [ ] Monthly: Review and update documentation
- [ ] Quarterly: Update CLI references with new OCI features
- [ ] As needed: Bug fixes and security patches

---

## Quick Reference: Your URLs

Once published, update these:

- Repository: `https://github.com/YOUR_GITHUB_USERNAME/agent-skill-oci`
- Installation: `/plugin marketplace add YOUR_GITHUB_USERNAME/agent-skill-oci`
- Issues: `https://github.com/YOUR_GITHUB_USERNAME/agent-skill-oci/issues`
- Releases: `https://github.com/YOUR_GITHUB_USERNAME/agent-skill-oci/releases`

---

**Need help?** See PUBLISHING.md for detailed step-by-step instructions.

**Ready to publish?** Start with "GitHub Repository Setup" section above!
