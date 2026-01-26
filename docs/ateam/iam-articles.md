# A-Team Chronicles: IAM & Identity Articles

Curated A-Team articles for OCI Identity and Access Management.

---

## IDCS Integration with OCI

**URL**: https://docs.oracle.com/en/cloud/paas/identity-cloud/ateam-chronicles.html
**Topics**: IDCS, Federation, SSO, Identity, Authentication

**Summary**: Comprehensive guidance on integrating Oracle Identity Cloud Service (IDCS) with OCI for enterprise identity management and federated authentication

**Key Takeaways**:
- IDCS provides centralized identity management across Oracle Cloud
- Federation enables SSO between IDCS and OCI IAM
- Dynamic groups can leverage IDCS user attributes for fine-grained access control
- Supports SAML 2.0 for enterprise identity provider integration

**When to Use This Article**:
- Setting up enterprise SSO for OCI users
- Migrating from OCI native users to federated identity
- Implementing attribute-based access control (ABAC)
- Integrating OCI with corporate identity systems

**Relevant Commands**:
```bash
# List identity providers
oci iam identity-provider list \
  --protocol SAML2 \
  --compartment-id <tenancy-ocid>

# Create SAML2 identity provider (federation with IDCS)
oci iam saml2-identity-provider create \
  --compartment-id <tenancy-ocid> \
  --name "IDCS-Federation" \
  --description "Federation with Oracle IDCS" \
  --metadata-url <idcs-metadata-url>

# List identity provider groups
oci iam idp-group-mapping list \
  --identity-provider-id <idp-ocid>

# Map IDCS group to OCI group
oci iam idp-group-mapping create \
  --identity-provider-id <idp-ocid> \
  --idp-group-name "IDCS-Administrators" \
  --group-id <oci-group-ocid>
```

**IAM Requirements**:
```
# Allow administrators to manage identity providers
Allow group IdentityAdmins to manage identity-providers in tenancy

# Allow administrators to manage group mappings
Allow group IdentityAdmins to manage groups in tenancy
```

---

## [Placeholder: IAM Policy Best Practices]

**URL**: [To be added when found]
**Topics**: IAM, Policies, Security, Least Privilege

**Summary**: [Search for A-Team articles on IAM policy design patterns]

**Search Query**:
```
site:ateam-oracle.com "IAM policy"
site:ateam-oracle.com "least privilege"
site:blogs.oracle.com/ateam "OCI policies"
```

---

## [Placeholder: Dynamic Groups and Instance Principals]

**URL**: [To be added when found]
**Topics**: Dynamic Groups, Instance Principal, Service Principal

**Summary**: [Search for A-Team guidance on instance principals]

**Search Query**:
```
site:ateam-oracle.com "dynamic group"
site:ateam-oracle.com "instance principal"
```

**Example Dynamic Group**:
```bash
# Create dynamic group for compute instances
oci iam dynamic-group create \
  --compartment-id <tenancy-ocid> \
  --name "ComputeInstances" \
  --description "All compute instances in Production compartment" \
  --matching-rule "instance.compartment.id = 'ocid1.compartment.oc1..production'"
```

---

## Article Search

To find more IAM articles from A-Team:
```bash
# Google searches
site:ateam-oracle.com "OCI IAM"
site:ateam-oracle.com "identity management"
site:ateam-oracle.com "IDCS"
site:blogs.oracle.com/ateam "federation"
site:blogs.oracle.com/ateam "dynamic groups"
```

## Related Resources

- **Official Docs**: Use Context7 to query "OCI IAM documentation"
- **OCI Reference**: See `docs/references/oci-iam-reference.md` (TODO)
- **Skill File**: See `skills/iam-identity-management/SKILL.md`
- **Security Category**: https://www.ateam-oracle.com/category/atm-identity-access-management-and-security

---

*Curated by: OCI Plugin Team*
*Last Updated: 2026-01-26*
*Articles: 1 complete, 2 placeholders*

## Next Steps

1. Search for IAM policy best practices articles
2. Find dynamic groups and instance principal guides
3. Look for MFA and security hardening articles
4. Add user lifecycle management articles
