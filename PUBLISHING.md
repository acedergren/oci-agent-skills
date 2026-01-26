# Publishing Guide: OCI Cloud Operations Plugin

Complete step-by-step guide to publish your plugin to the Claude Code marketplace ecosystem.

## Prerequisites

- GitHub account
- Git installed locally
- Plugin files ready (✓ all files are prepared)

## Publication Checklist

- [x] `LICENSE` file created
- [x] `CHANGELOG.md` with version history
- [x] `.claude-plugin/marketplace.json` configured
- [x] Enhanced `plugin.json` with metadata
- [ ] GitHub repository created
- [ ] Initial commit and push
- [ ] Release tag created
- [ ] README updated with installation instructions

## Step-by-Step Publishing Process

### Step 1: Initialize Git Repository

```bash
cd /Users/acedergr/Projects/agent-skill-oci

# Initialize git repository
git init
git branch -M main

# Create .gitignore
cat > .gitignore << 'EOF'
# macOS
.DS_Store

# Editor
.vscode/
.idea/

# Testing
test-output/
.claude-test/

# Temporary files
*.tmp
*.log
EOF

# Add all files
git add .

# Initial commit
git commit -m "Initial commit: OCI Cloud Operations Plugin v1.0.0

Features:
- 8 comprehensive skills covering compute, networking, database, monitoring, secrets, GenAI, IAM, and IaC
- 800+ OCI CLI command examples with full syntax
- Python SDK integration examples
- MCP server integration (oci-api, context7)
- OCI Cloud Architect orchestrator agent
- Complete documentation and quick start guide

Resolves: Initial release preparation
"
```

### Step 2: Create GitHub Repository

1. **Go to GitHub**: https://github.com/new

2. **Repository settings**:
   - Name: `agent-skill-oci`
   - Description: "Oracle Cloud Infrastructure operations plugin for Claude Code with intelligent agent skills"
   - Visibility: **Public** (required for marketplace)
   - ⚠️ Do NOT initialize with README (you already have one)

3. **Add topics** (after creation):
   ```
   claude-code
   claude-plugin
   oci
   oracle-cloud
   infrastructure
   devops
   terraform
   automation
   ```

### Step 3: Push to GitHub

```bash
# Add remote (replace 'acedergren' with your GitHub username)
git remote add origin https://github.com/acedergren/agent-skill-oci.git

# Push to GitHub
git push -u origin main

# Create and push v1.0.0 tag
git tag -a v1.0.0 -m "Release v1.0.0: Initial public release

Complete OCI operations plugin with:
- 8 specialized skills
- MCP integration
- 800+ CLI commands
- Comprehensive documentation
"
git push origin v1.0.0
```

### Step 4: Update Repository URLs

After creating the GitHub repo, update the URLs in your files:

```bash
# Update plugin.json
sed -i '' 's|acedergren|YOUR_GITHUB_USERNAME|g' .claude-plugin/plugin.json

# Commit the update
git add .claude-plugin/plugin.json
git commit -m "Update repository URLs with actual GitHub username"
git push
```

### Step 5: Configure GitHub Repository

On GitHub, go to **Settings**:

1. **About section** (right sidebar):
   - Description: "Oracle Cloud Infrastructure operations plugin for Claude Code"
   - Website: Your documentation site (or leave as repo URL)
   - Topics: Add all relevant tags

2. **Social preview** (optional):
   - Create a banner image (1280x640px)
   - Upload to Settings → General → Social preview

3. **Enable issues** (Settings → General):
   - ✓ Issues (for user bug reports and feature requests)

4. **Create GitHub Pages** (optional, for documentation):
   - Settings → Pages
   - Source: Deploy from branch `main`, folder `/` or `/docs`

### Step 6: Create Release on GitHub

1. Go to: https://github.com/acedergren/agent-skill-oci/releases/new

2. **Release details**:
   - Tag: `v1.0.0` (select existing tag)
   - Title: `OCI Cloud Operations Plugin v1.0.0`
   - Description:
     ```markdown
     ## 🎉 Initial Release

     Complete Oracle Cloud Infrastructure operations plugin for Claude Code with intelligent agent skills.

     ### Features
     - **8 Specialized Skills**: Compute, Networking, Database, Monitoring, Secrets, GenAI, IAM, IaC
     - **800+ CLI Commands**: Complete OCI CLI reference with examples
     - **Python SDK Examples**: Ready-to-use automation code
     - **MCP Integration**: Live documentation and API access
     - **Best Practices**: Security, cost optimization, performance tuning

     ### Installation

     ```bash
     /plugin marketplace add acedergren/agent-skill-oci
     /plugin install oci-cloud-ops@oracle-cloud-ops
     ```

     ### Quick Start

     See [QUICKSTART.md](QUICKSTART.md) for 5-minute getting started guide.

     ### Documentation

     - [README.md](README.md): Comprehensive plugin documentation
     - [Skills Reference](skills/): Detailed CLI command references
     - [Agent Guide](agents/): Multi-skill orchestration

     ### Requirements

     - Claude Code
     - OCI CLI configured (`oci setup config`)
     - Oracle Cloud account
     ```

3. Click **Publish release**

## How Users Will Install

### Method 1: Via Marketplace (Recommended)

```bash
# Add your marketplace
/plugin marketplace add acedergren/agent-skill-oci

# Install the plugin
/plugin install oci-cloud-ops@oracle-cloud-ops

# Verify installation
/help
```

### Method 2: Direct Clone

```bash
# Clone to plugins directory
git clone https://github.com/acedergren/agent-skill-oci.git ~/.claude/plugins/oci-cloud-ops

# Restart Claude Code
```

### Method 3: NPM (Future Option)

If you publish to npm:
```bash
/plugin install oci-cloud-ops
```

## Update Your README

Add installation section to README.md:

```markdown
## Installation

### Via Claude Code Marketplace (Recommended)

1. Add the marketplace:
   ```bash
   /plugin marketplace add acedergren/agent-skill-oci
   ```

2. Install the plugin:
   ```bash
   /plugin install oci-cloud-ops@oracle-cloud-ops
   ```

3. Verify installation:
   ```bash
   /help
   ```
   You should see OCI skills listed.

### Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) configured
- Oracle Cloud account with appropriate permissions

### Alternative: Manual Installation

```bash
git clone https://github.com/acedergren/agent-skill-oci.git ~/.claude/plugins/oci-cloud-ops
```

Then restart Claude Code.
```

## Publishing Updates

### For Bug Fixes (1.0.1, 1.0.2, etc.)

```bash
# Make your changes
git add .
git commit -m "Fix: Correct database connection example"

# Update version in plugin.json
sed -i '' 's/"version": "1.0.0"/"version": "1.0.1"/' .claude-plugin/plugin.json

# Update CHANGELOG.md
cat >> CHANGELOG.md << 'EOF'

## [1.0.1] - 2026-01-27

### Fixed
- Corrected database connection example in database-management skill
- Fixed typo in IAM policy example
EOF

# Commit version bump
git add .
git commit -m "Bump version to 1.0.1"

# Create tag and push
git tag v1.0.1
git push origin main --tags

# Create GitHub release for v1.0.1
```

### For New Features (1.1.0, 1.2.0, etc.)

```bash
# Make your changes (new skill, new commands, etc.)
git add .
git commit -m "Add: New OKE (Kubernetes) management skill"

# Update version
sed -i '' 's/"version": "1.0.0"/"version": "1.1.0"/' .claude-plugin/plugin.json

# Update CHANGELOG
# ... add new features section ...

# Commit, tag, push
git add .
git commit -m "Release v1.1.0: Add Kubernetes management"
git tag v1.1.0
git push origin main --tags
```

Users will automatically see updates when they run:
```bash
/plugin marketplace update
/plugin upgrade oci-cloud-ops
```

## Promoting Your Plugin

### Community Sharing

1. **Claude Code Discord**
   - Announce in #plugins channel
   - Share use cases and examples

2. **Reddit**
   - r/ClaudeAI
   - r/devops
   - r/oracle
   - r/CloudComputing

3. **Twitter/X**
   ```
   🚀 New Claude Code Plugin: OCI Cloud Operations

   Manage Oracle Cloud Infrastructure with AI assistance!

   ✨ 8 specialized skills
   📚 800+ CLI commands
   🤖 Intelligent orchestration
   🔐 Built-in best practices

   Install: /plugin marketplace add acedergren/agent-skill-oci

   #ClaudeCode #OCI #DevOps #CloudComputing
   ```

4. **Hacker News**
   - Title: "Show HN: OCI Cloud Operations Plugin for Claude Code"
   - Include use cases and unique value

5. **Dev.to / Hashnode**
   - Write tutorial: "Managing OCI Infrastructure with AI"
   - Include real examples from QUICKSTART.md

6. **Oracle Communities**
   - Oracle Cloud Infrastructure forum
   - Oracle developer community

### Documentation Site (Optional)

Create GitHub Pages for better documentation:

```bash
# Create docs directory
mkdir docs
cp README.md docs/index.md
cp QUICKSTART.md docs/quickstart.md

# Enable GitHub Pages in Settings → Pages
# Source: Deploy from branch main, folder /docs
```

## Support and Maintenance

### Set Up Issue Templates

Create `.github/ISSUE_TEMPLATE/bug_report.md`:
```markdown
---
name: Bug report
about: Report a bug in the OCI Cloud Operations plugin
title: '[BUG] '
labels: bug
---

**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Run command '...'
2. See error

**Expected behavior**
What you expected to happen.

**Environment**
- Claude Code version:
- OCI CLI version: (run `oci --version`)
- Plugin version:
- Operating system:

**Additional context**
Any other relevant information.
```

### Security Policy

Create `SECURITY.md`:
```markdown
# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this plugin, please email security@example.com.

Please do NOT open a public issue.

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Security Best Practices

This plugin:
- Never hardcodes credentials
- Uses OCI Vault for secret management
- Follows least-privilege IAM principles
- Validates all user inputs
```

## Metrics and Analytics

Track your plugin's success:

1. **GitHub Insights**
   - Stars, forks, watchers
   - Clone statistics
   - Visitor analytics

2. **User Feedback**
   - GitHub issues and discussions
   - Discord community feedback

3. **Version Adoption**
   - Download counts per release
   - Active marketplace installations

## Next Steps

Once published:

1. ✅ Monitor GitHub issues for bug reports
2. ✅ Respond to community questions
3. ✅ Plan feature roadmap (see CHANGELOG.md unreleased section)
4. ✅ Regular updates for new OCI CLI features
5. ✅ Consider adding more skills (OKE, Functions, API Gateway)

## Example: Full Publication Command Sequence

```bash
# From plugin directory
cd /Users/acedergr/Projects/agent-skill-oci

# Initialize and commit
git init
git add .
git commit -m "Initial commit: OCI Cloud Operations Plugin v1.0.0"
git branch -M main

# Update URLs (replace with your username)
sed -i '' 's|acedergren|YOUR_GITHUB_USERNAME|g' .claude-plugin/plugin.json
git add .claude-plugin/plugin.json
git commit -m "Update repository URLs"

# Create GitHub repo (via web interface), then:
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/agent-skill-oci.git
git push -u origin main

# Tag and release
git tag -a v1.0.0 -m "Release v1.0.0: Initial public release"
git push origin v1.0.0

# Create release on GitHub web interface
# Announce in communities
# Done! 🎉
```

---

**Your plugin is production-ready!** Follow these steps to make it available to the Claude Code community.
