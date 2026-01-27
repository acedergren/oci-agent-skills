# Contributing to OCI Agent Skills

Thank you for your interest in contributing to OCI Agent Skills! We welcome contributions from the community, whether you're fixing bugs, adding features, or improving documentation.

## Getting Started

### Prerequisites
- Claude Code installed
- Basic familiarity with OCI services
- Git and GitHub account

### Setting Up Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/oci-agent-skills.git
   cd oci-agent-skills
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Types of Contributions

### 🐛 Bug Reports
- **Check existing issues** before reporting
- **Provide detailed steps** to reproduce
- **Include error messages** and logs
- **Specify your setup** (OS, Claude Code version, OCI CLI version)

### 💡 Feature Requests
- **Describe the use case** you're trying to solve
- **Explain the benefit** to other users
- **Provide examples** of how it would be used
- **Reference OCI documentation** if applicable

### ✨ Code Contributions

#### Adding a New Skill

1. **Check current skills** in `skills/` directory to avoid duplicates
2. **Create skill directory**:
   ```bash
   mkdir skills/your-skill-name
   ```
3. **Create `SKILL.md`** following this template:
   ```markdown
   ---
   name: Your Skill Name
   description: What this skill helps with (one line)
   version: 1.0.0
   ---

   ## Overview
   Brief description of the skill's purpose and when to use it.

   ## Core Capabilities
   - Capability 1
   - Capability 2
   - Capability 3

   ## CLI Commands

   ### Basic Operations
   [Include 3-5 essential CLI commands with explanations]

   ### Advanced Operations
   [Include advanced scenarios and patterns]

   ## Python SDK Examples

   ### Setup
   [Show import and authentication]

   ### Common Tasks
   [Include 2-3 practical examples]

   ## Best Practices
   - Best practice 1
   - Best practice 2
   - Security considerations

   ## Troubleshooting

   ### Common Issues
   [Include error messages and solutions]
   ```

4. **Test your skill**:
   - Verify commands work against OCI CLI docs
   - Test Python SDK examples if applicable
   - Check formatting and clarity

5. **Reference [AGENTS.md](./AGENTS.md)** for detailed standards:
   - Content organization requirements
   - Coding conventions for CLI commands
   - SDK example patterns
   - What to include/exclude

#### Enhancing Existing Skills

1. **Identify the skill** you want to improve
2. **Make your changes** following existing patterns
3. **Verify all** CLI commands still work
4. **Test** Python SDK examples
5. **Update version** number in SKILL.md frontmatter

#### Updating Documentation

1. **Check the README** and docs for clarity
2. **Fix typos or unclear sections**
3. **Add examples** for complex features
4. **Update links** if broken

### 📚 Documentation Contributions
- Improve README clarity
- Fix typos or grammar
- Add examples
- Update links
- Improve troubleshooting guides

## Submission Process

### Before You Submit
- ✅ Read [AGENTS.md](./AGENTS.md) for standards
- ✅ Review [SECURITY.md](./SECURITY.md) for security requirements
- ✅ Test your changes thoroughly
- ✅ Check your code follows project patterns
- ✅ Update version numbers appropriately

### Creating a Pull Request

1. **Push your branch** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Open a pull request** on GitHub with:
   - Clear title describing the change
   - Description of what you changed and why
   - Reference to related issues (use `#123` format)
   - Testing notes (what you tested and how)

3. **PR Template** (if applicable):
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New skill
   - [ ] Skill enhancement
   - [ ] Documentation
   - [ ] Other

   ## How Has This Been Tested?
   Describe your test process

   ## Related Issues
   Fixes #123
   Related to #456

   ## Checklist
   - [ ] Followed AGENTS.md standards
   - [ ] Reviewed SECURITY.md requirements
   - [ ] CLI commands verified
   - [ ] Documentation updated
   - [ ] Version number updated
   ```

## Code Standards

### CLI Command Examples
✅ **GOOD**:
```bash
# List instances in production compartment
oci compute instance list \
  --compartment-id <COMPARTMENT_OCID> \
  --query 'data[].{ID:id,Name:display-name,State:lifecycle-state}'
```

❌ **AVOID**:
```bash
oci compute instance list
```

### Python SDK Examples
✅ **GOOD**:
```python
from oci import config
from oci.compute import ComputeClient

# Load configuration from ~/.oci/config
cfg = config.from_file()
client = ComputeClient(cfg)

# List instances with error handling
try:
    instances = client.list_instances(
        compartment_id="ocid1.compartment.oc1...",
        sort_by="TIMECREATED"
    )
    for instance in instances.data:
        print(f"{instance.display_name}: {instance.lifecycle_state}")
except Exception as e:
    print(f"Error: {e}")
```

❌ **AVOID**:
```python
from oci.compute import ComputeClient
client = ComputeClient()
instances = client.list_instances()
```

### Security Requirements

**Required for all skills:**
- ✅ Never hardcode credentials or API keys
- ✅ Include examples using environment variables or OCI Vault
- ✅ Document IAM policy requirements
- ✅ Warn about least-privilege principles
- ✅ Include credential rotation best practices if applicable

See [SECURITY.md](./SECURITY.md) for detailed security guidelines.

## Review Process

All pull requests will be reviewed for:

1. **Accuracy**: Commands and examples work correctly
2. **Completeness**: Documentation is thorough
3. **Security**: No credentials or sensitive data exposed
4. **Style**: Follows project conventions
5. **Testing**: Changes are validated

We aim to review PRs within 1-2 weeks. Feel free to ask questions during the review process.

## Questions?

- 📖 **Questions about contributing?** Check the [README](./README.md#community)
- 💬 **Want to discuss first?** Start a [discussion on GitHub](https://github.com/acedergren/oci-agent-skills/discussions)
- 🐛 **Found a bug in contributing process?** [Report it](https://github.com/acedergren/oci-agent-skills/issues)

## License

By contributing to OCI Agent Skills, you agree that your contributions will be licensed under the MIT License. See [LICENSE](./LICENSE) for details.

## Code of Conduct

We're committed to providing a welcoming and inclusive environment. Please:
- Be respectful and professional
- Welcome diverse perspectives
- Focus on what's best for the community
- Report violations privately

Thank you for making OCI Agent Skills better! 🙏
