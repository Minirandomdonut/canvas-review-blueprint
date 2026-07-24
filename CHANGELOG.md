# Changelog

All notable changes to this blueprint are documented here.
This project loosely follows [Semantic Versioning](https://semver.org/).

## [v2.0.0] — Browser-native Canvas tool catalog

Reframes the blueprint from a *scheduled review workflow* into an **on-demand, read-only tool
catalog** — the no-token counterpart to an MCP server.

### Added
- **`TOOLS.md`** — the tool catalog: discrete, well-specified, read-only tools Claude in Chrome
  invokes on demand (Inputs → Returns → Safety → How it runs).
- New read tools: **`get_rubric`** (grading criteria), **`get_submission_feedback`** (submission
  status + grade + instructor comments), and **`list_modules`** (browse course modules).
- A **"Coverage vs. canvas-mcp"** table mapping each canvas-mcp tool to its browser equivalent,
  including what is intentionally excluded.
- This `CHANGELOG.md`.

### Changed
- Repositioned the README as a "browser-native Canvas tool catalog for Claude."
- `CLAUDE.md` now describes the tool-catalog model; the weekly/daily routines are documented as
  **automations composed from the tools**.

### Invariant
- **Strictly read-only.** No tool submits work, uploads files, or posts to discussions. The
  only writes are to your own Google Calendar/Drive (the `sync_deadlines` integration).

## [v1.0.0] — Scheduled review + Google sync

- Weekly deep-dive and daily surprise-homework routines via Claude in Chrome.
- `deadlines.md` living memory with a calendar-event duplicate guard.
- Google Calendar + Google Drive sync so claude.ai can read the workload via its connectors.
- Sanitized, personal-data-free blueprint with a companion pointer to canvas-mcp.
