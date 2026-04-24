# Source Skill Evaluation

This repo already covered the core OCI platform skills, but it was missing several OCI-adjacent skills that existed in `acedergren/agentic-tools`.

## Added to this repo

| Source skill | Added here as | Why |
| --- | --- | --- |
| `oracle-idcs-better-auth-setup` | `oracle-iam-auth-foundation` | Modernizes old IDCS wording to OCI IAM Identity Domains while keeping the auth-foundation routing boundary |
| `fastify-better-auth-bridge` | `fastify-better-auth-bridge` | Preserves the runtime bridge skill that should stay separate from auth setup and provisioning |
| `oracle-idcs-org-provisioning` | `oracle-iam-org-provisioning` | Keeps post-login claim-to-org mapping isolated from base IAM auth setup |
| `sqlite-to-oracle-planner` | `sqlite-to-oracle-planner` | Adds a planning-only migration inventory skill that complements database and DBA work |
| `oci-pptx` | `oci-pptx` | Adds Oracle-branded presentation guidance for sharing OCI work across teams and stakeholders |

## Improvements applied

- Updated the auth terminology from IDCS-first to OCI IAM Identity Domains-first for broader Oracle-org reuse.
- Preserved the original domain split between auth foundation, Fastify bridging, and org provisioning to avoid scope creep.
- Documented the new skills in the repo marketplace and README so they are installable and discoverable here instead of living only in a different repo.
