# Changelog

All notable changes to this blueprint are documented here.
This project loosely follows [Semantic Versioning](https://semver.org/).

## [v3.0.0] — Packaged as an uploadable Skill

Repackages the blueprint so a non-technical student can install it **without git, a terminal, or a
GitHub account**. The capabilities are unchanged; the delivery is completely different.

### Added
- **`skill/canvas-review/`** — the whole system as an uploadable Agent Skill (`SKILL.md` plus
  `references/`), installable at claude.ai → Customize → Skills.
- **Self-bootstrapping setup.** On first run the skill creates the Google Calendar and the
  `Canvas Review Deadlines` Drive doc itself, then stores config in that doc's `## Config` header.
  **All four `<PLACEHOLDER>` values are gone** — there is nothing left to fill in by hand.
- **`build.sh`** — produces `dist/canvas-review.zip` with the correct archive root.
- **Claude Code plugin track** — `.claude-plugin/marketplace.json` and `plugin.json`, so the same
  skill installs via `/plugin marketplace add`.
- **`docs/cowork-setup.md`** and **`docs/troubleshooting.md`** — click-by-click guides written for
  students rather than developers.

### Changed
- **Cowork is now the primary surface.** It provides browser control, Google connectors, and
  scheduled tasks with no terminal, so Claude Code is no longer required.
- **State moved from local Markdown to the Google Drive doc**, which removes the "copy this folder
  to `~/Documents/`" step and makes deadlines readable from web and mobile.
- **README rewritten for students** — the paid-plan requirement is now stated in the first
  screenful, the quickstart comes before any MCP discussion, and the comparison material moved
  into collapsible sections.
- **Institution-agnostic** — the Canvas base URL is captured at setup instead of assumed.

### Preserved
- The v2 desktop-app method lives on in **`docs/desktop-legacy.md`** and `docs/legacy/`, for anyone
  who wants local Markdown review history. Includes migration notes that reuse an existing
  calendar rather than duplicating it.

### Fixed during live verification
Testing the bootstrap against real Google Calendar and Drive connectors surfaced three defects in
the first draft of this release:
- **Config discovery was unreliable.** Drive's `title = '...'` does not do exact matching — it
  fuzzy-matches, so the lookup also returned `Canvas Deadlines` and `Academic Profile — Canvas
  Year Review`. Discovery is now by a `CANVAS-REVIEW-CONFIG-V3` marker string scoped to
  `mimeType = 'application/vnd.google-apps.document'`, which returns exactly one result.
- **Setup assumed a calendar could be created.** The Google Calendar connector has no
  `create_calendar` tool. Setup now reuses an existing `Canvas Deadlines` calendar when present,
  and otherwise walks the user through making one — then resolves the ID by name, so no ID is ever
  copied by hand.
- **Google Docs escapes Markdown on write** (`## Config` → `\#\# Config`, `_` → `\_`), which would
  have broken config parsing on read-back. Parsing now matches on `Label: value` lines and ignores
  escaping.

### Known limitation
- **The Free plan cannot read Canvas.** Browser control requires a paid Claude plan. The skill
  uploads fine on Free but can't reach Canvas — a platform boundary, now documented up front.

### Invariant
- **Still strictly read-only in Canvas.** The only writes remain the user's own Google
  Calendar/Drive.

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
