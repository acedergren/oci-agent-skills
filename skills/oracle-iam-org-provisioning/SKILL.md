---
name: oracle-iam-org-provisioning
description: Use when OCI IAM login succeeds but group claims still need to become tenant, role, or organization membership. Covers profile mapping, session hooks, org resolution, atomic upserts, and first-admin bootstrap. Keywords: provisioning, org_members, session hooks, groups, role mapping.
license: MIT
metadata:
  author: alexander-cedergren
  version: "2.3.0"
---

# Oracle IAM Org Provisioning

Use this when authentication succeeds but the application still needs to turn identity-domain claims into stable local membership and role state.

## ⚠️ Provisioning Knowledge Gap

Provisioning bugs often masquerade as IAM or Fastify bugs. Keep access gating, role mapping, and runtime bridging as separate concerns so the right layer owns the fix.

## Route First

- Base auth setup or callback issues: `oracle-iam-auth-foundation`
- Fastify session bridging and cookie forwarding: `fastify-better-auth-bridge`
- Generic IAM policy or federation issues: `iam-identity-management`

## NEVER Do This

- Never combine access gating and role mapping into one decision branch.
- Never read membership with `SELECT` and then write with `INSERT` when atomic upsert is available.
- Never assume claims captured in one hook lifecycle are still present in the next.
- Never let transient provisioning failures become permanent login lockouts by default.
- Never let fallback org resolution outrank existing membership.
- Never bootstrap first-admin on every login attempt.

## Flow Order

1. Capture claims during profile mapping.
2. Gate access only when explicit allow rules exist.
3. Resolve org with a stable precedence order.
4. Upsert membership atomically.
5. Promote the first admin once when the org has none.

## Failure Clues

- Login works but role is wrong on each retry: precedence order is unstable.
- Group claim appears missing: go back to auth foundation and scopes first.
- Users get locked out during DB issues: gating is failing closed without explicit allow rules.
