# Security Policy for OCI Agent Skills

This document outlines security practices for the OCI Agent Skills plugin and provides guidelines for reporting security vulnerabilities.

## Security Principles

### 1. Credential Management
- **Never hardcode credentials** in code, documentation, or configuration files
- Use OCI Vault, environment variables, or OCI config files for sensitive data
- All examples must reference best practices for credential handling
- API keys, tokens, and passwords must never appear in skill examples

### 2. Command Security
- CLI commands must not allow command injection vectors
- Use proper argument escaping in all examples
- Validate and document IAM permission requirements for each command
- Warn about commands that could expose sensitive information

### 3. Code Review & Testing
- All changes require code review before merging to main branch
- New skills must be reviewed for security implications
- Test CLI commands against OCI CLI documentation before merging
- Verify Python SDK examples follow secure-by-default patterns

### 4. Secret Detection
- Automated secret scanning prevents credential leaks
- All commits are scanned for API keys, tokens, and passwords
- If secrets are detected, commits are blocked and must be remediated
- Use `git filter-repo` to remove any accidentally committed secrets

### 5. Access Control
- Main branch is protected from direct pushes
- Only reviewed, approved changes are merged
- Branch protection rules require status checks to pass
- Code owners review critical files

## Reporting Security Vulnerabilities

**Please do NOT create public GitHub issues for security vulnerabilities.**

If you discover a security vulnerability in the OCI Agent Skills plugin:

1. **Email the maintainers** with details of the vulnerability
2. **Do not publicly disclose** until we've had time to address it
3. **Include proof of concept** if possible
4. **Allow 90 days** for us to release a fix before public disclosure

### Vulnerability Information to Include

When reporting a vulnerability, please provide:
- Description of the vulnerability
- Steps to reproduce
- Impact assessment (which skills are affected)
- Suggested remediation (if you have one)
- Your contact information for follow-up

## Security Best Practices for Contributors

### CLI Command Guidelines
```bash
# ✅ GOOD: Clearly marked placeholders, no hardcoded values
oci compute instance create \
  --compartment-id <compartment-ocid> \
  --availability-domain <ad-name> \
  --image-id <image-ocid>

# ❌ BAD: Could expose sensitive information
oci compute instance create \
  --compartment-id ocid1.compartment.oc1..exampleuniqueID \
  --image-id ocid1.image.oc1..exampleuniqueID
```

### Python SDK Examples
```python
# ✅ GOOD: Load credentials from OCI config
import oci

config = oci.config.from_file()
compute_client = oci.core.ComputeClient(config)

# ❌ BAD: Credentials in code
import oci

config = {
    "user": "ocid1.user.oc1..exampleuniqueID",
    "key_file": "/path/to/key.pem",
    "fingerprint": "00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff"
}
compute_client = oci.core.ComputeClient(config)
```

### IAM Permission Documentation
Always document which IAM permissions are required:

```bash
# List all instances in a compartment
# Required IAM permissions:
# - COMPARTMENT_INSPECT
# - INSTANCE_INSPECT_ALL (or INSTANCE_INSPECT on specific compartments)
oci compute instance list \
  --compartment-id <compartment-ocid>
```

## Security Scanning & Automation

### GitHub Secret Scanning
- Automatically scans all commits for API keys, tokens, and credentials
- Blocks commits containing detected secrets
- Monitors for exposure of secrets previously committed

### Repository Settings
- All pull requests require at least one approval
- Status checks (secret scanning, linting) must pass
- Stale reviews are dismissed when new commits are pushed
- Main branch protection enforces these rules

### Pre-commit Hooks
Consider using pre-commit hooks to catch secrets before committing:

```bash
# Install pre-commit
pip install pre-commit

# Add to .pre-commit-config.yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

## Security Considerations by Skill

### Compute Management
- Warn about public SSH key management
- Document IP whitelist best practices
- Highlight console access security implications

### Networking
- Security list and NSG rules examples should show least-privilege access
- Warn about overly permissive CIDR blocks (0.0.0.0/0)
- Document VPN and FastConnect security benefits

### Database Management
- Strongly recommend Transparent Data Encryption (TDE)
- Document backup security and retention policies
- Highlight database audit logging capabilities

### Secrets Management
- Always recommend OCI Vault for credential storage
- Show secure credential rotation patterns
- Document encryption key management best practices

### IAM & Identity Management
- Demonstrate least-privilege policy principles
- Show how to audit permissions and access patterns
- Recommend MFA and strong authentication

### FinOps & Cost Optimization
- Warn about visibility into cost data in shared environments
- Document cost anomaly detection security implications
- Show how to safely share cost reports

## Security Dependencies

The OCI Agent Skills plugin has minimal dependencies:

### Required
- OCI CLI (maintained by Oracle)
- OCI Python SDK (maintained by Oracle)

### Optional
- OCI MCP Servers (maintained by Oracle)

All dependencies are maintained by Oracle and follow Oracle's security practices.

## Regular Security Reviews

- Security policies are reviewed quarterly
- New OCI security features are evaluated for skill updates
- Vulnerability reports are assessed within 48 hours
- Critical security issues trigger immediate patches

## License

The security of this plugin is everyone's responsibility. By contributing, you agree to follow these security practices and report vulnerabilities responsibly.

## References

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OCI Security Best Practices](https://docs.oracle.com/en-us/iaas/Content/Security/Concepts/security.htm)
- [GitHub Security Documentation](https://docs.github.com/en/code-security)
- [Secure-by-Default Libraries](https://github.com/tldrsec/awesome-secure-defaults)
