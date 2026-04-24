---
name: oracle-iam-auth-foundation
description: Use when setting up or debugging Better Auth with OCI IAM Identity Domains, OIDC callback URLs, trusted origins, provider bootstrap order, or shared auth behavior across Fastify and Next.js. Keywords: OCI IAM, Identity Domains, Better Auth, OIDC, callback URL, trusted origins.
license: MIT
metadata:
  author: alexander-cedergren
  version: "2.3.0"
---

# Oracle IAM Auth Foundation

Use this as the entry skill for Oracle-authenticated web apps that rely on OCI IAM Identity Domains. This skill owns provider setup and auth foundations, not runtime bridging or post-login org writes.

## ⚠️ OCI Identity Domain Knowledge Gap

Oracle's IAM and Identity Domains surfaces evolve faster than base model knowledge. Do not guess current callback requirements, scope behavior, or setup flow details when exact Oracle semantics matter.

When live setup details are needed:
1. Use the official references in `references/official-docs.md`
2. Verify current Identity Domains behavior before changing production auth
3. Keep old `IDCS` references as translation context, not as the primary terminology

## Route First

- Fastify runtime session bridging: switch to `fastify-better-auth-bridge`
- Post-login group and org membership logic: switch to `oracle-iam-org-provisioning`
- General IAM policies and principal types: switch to `iam-identity-management`

## NEVER Do This

- Never treat old IDCS wording and OCI IAM Identity Domains as separate products in new implementation docs.
- Never bootstrap auth from database-managed provider rows alone.
- Never overwrite operator-managed provider settings during env bootstrap.
- Never skip the group-related scope when downstream RBAC expects group claims.
- Never assume OAuth redirect success means local session creation succeeded.
- Never diverge shared auth behavior across Fastify and Next.js without a reason and explicit audit.

## Verification Order

1. Verify the provider tables and adapter state exist.
2. Verify the callback URL exactly matches the deployed entrypoint.
3. Verify trusted origins and cookie settings match the topology.
4. Verify required scopes and claim mapping are present.
5. Verify env-first bootstrap works before DB-managed rows are edited.

## Failure Clues

- OAuth succeeds, session fails immediately: callback URL or local cookie/origin mismatch.
- Groups never appear in claims: scope or app configuration problem before provisioning logic.
- Works locally but fails in prod: trusted origins or cookie attribute mismatch.
