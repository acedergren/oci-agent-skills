---
name: sqlite-to-oracle-planner
description: Use when planning a SQLite-to-Oracle migration for a Node.js or TypeScript codebase. Scans for SQLite touch points, ORM assumptions, file-backed workflows, and cutover risks without implementing the migration. Keywords: SQLite, Oracle, migration, better-sqlite3, drizzle, manifest.
license: MIT
metadata:
  author: alexander-cedergren
  version: "2.3.0"
---

# SQLite to Oracle Planner

This is a planning-only skill. Use it to inventory the migration surface before any implementation starts.

## ⚠️ Migration Knowledge Gap

SQLite migrations fail when teams treat them as a pure schema conversion. Driver assumptions, file paths, test fixtures, fallback code paths, and local-dev shortcuts are usually the real blast radius.

## NEVER Do This

- Never edit source files before the SQLite touch-point inventory exists.
- Never treat this as only a SQL dialect migration.
- Never skip test harnesses and fixture setup when inventorying SQLite usage.
- Never assume fallback SQLite code paths are dead just because prod uses something else.
- Never collapse planning and implementation into one pass.
- Never stop at ORM files if the app still has direct connection strings or file references elsewhere.

## Inventory Order

1. Drivers, adapters, and ORM packages
2. Connection strings and file-backed database paths
3. Schema syntax and migration files
4. Test harnesses, fixtures, and local scripts
5. Cutover sequencing and residual fallback branches

## Output Shape

Produce a migration manifest with:
- SQLite entry points
- Oracle replacements
- Blocking assumptions
- Test-impact notes
- Recommended phased rollout
