---
name: fastify-better-auth-bridge
description: Use when Better Auth already exists but Fastify 5 still needs a runtime bridge for session resolution, cookie forwarding, request decoration, or missing active-org context after OCI login. Keywords: Fastify 5, Better Auth, getSession, cookie forwarding, session bridge.
license: MIT
metadata:
  author: alexander-cedergren
  version: "2.3.0"
---

# Fastify Better Auth Bridge

Use this when auth foundation is correct but Fastify requests still do not resolve identity correctly at runtime.

## ⚠️ Runtime Bridge Knowledge Gap

Framework adapters hide subtle request-shape requirements. Do not assume a Fastify request can be passed directly into Better Auth APIs without bridging to the native Web `Request` shape.

## Route First

- Callback URLs, trusted origins, provider bootstrap: `oracle-iam-auth-foundation`
- Group-to-role or org membership logic: `oracle-iam-org-provisioning`

## NEVER Do This

- Never build a parallel session system when cookie forwarding is the real gap.
- Never enforce authorization policy inside the bridge hook.
- Never pass the raw Fastify request object to `auth.api.getSession()`.
- Never use shared mutable array defaults on decorated request state.
- Never patch org context unless it is actually absent.
- Never fail the whole request at bridge level just because session resolution threw once.

## Verification Order

1. Build a native Web `Request` that includes the `cookie` header.
2. Resolve the session from Better Auth.
3. Decorate request state consistently once.
4. Patch org context only when the session lacks it.
5. Let route guards and RBAC happen after identity resolution.

## Failure Clues

- Login succeeds but every route is anonymous: cookie header never made it into the Web `Request`.
- Permissions leak between requests: mutable decorator defaults are shared.
- Org-aware code sees `undefined`: login succeeded but active organization was never patched.
