# The original desktop-app method (v2)

> This is the **previous** version of Canvas Review, kept because it still works and because some
> people prefer it. Most users want the [Cowork setup](cowork-setup.md) instead — it's faster to
> install and needs no manual configuration.

## When you'd want this instead

Pick this method if you want:

- **Local Markdown files** you can read offline, keep in git, or grep — one `reviews/YYYY-MM-DD.md`
  per week, and a `deadlines.md` table on disk.
- **Full control** over the prompts, folder layout, and cron schedule.
- **Desktop-app scheduled tasks** rather than Cowork scheduled tasks.

The trade-off: you fill in four placeholder values by hand, and the system is pinned to one
machine.

## What's different

| | Cowork method (v3) | Desktop method (v2) |
|---|---|---|
| Install | Upload one `.zip` | Clone repo, copy folder to `~/Documents/` |
| Config | Automatic — Claude creates everything | Fill in 4 `<PLACEHOLDER>` values by hand |
| State lives in | Google Drive doc | Local Markdown files |
| Scheduling | Cowork scheduled tasks | Desktop-app scheduled tasks |
| Works on web/mobile | Yes (reads the synced doc) | No |

Both read Canvas the same way, through the Chrome extension on your logged-in session, and both
are strictly read-only in Canvas.

## Files

Everything for this method is in [`legacy/`](legacy/):

| File | Purpose |
|------|---------|
| [`legacy/CLAUDE.md`](legacy/CLAUDE.md) | The playbook every Claude session in the folder follows. Start here. |
| [`legacy/TOOLS.md`](legacy/TOOLS.md) | The read-only tool catalog + coverage-vs-canvas-mcp table. |
| [`legacy/TASK-PROMPTS.md`](legacy/TASK-PROMPTS.md) | Exact prompts + cron settings for the two scheduled tasks. |
| [`legacy/deadlines.md`](legacy/deadlines.md) | The living-memory deadline table (starts empty). |
| [`legacy/reviews/`](legacy/reviews/) | One `YYYY-MM-DD.md` per weekly run. |
| [`legacy/scheduled-tasks/`](legacy/scheduled-tasks/) | Ready-made `SKILL.md`-style copies of the routines. |

## Setup

1. **Copy `legacy/` somewhere permanent**, e.g. `~/Documents/Canvas Review/`.
2. **Open `CLAUDE.md`** and fill in every `<PLACEHOLDER>`:
   - `<PATH_TO_YOUR_CANVAS_REVIEW_FOLDER>` — where you put the folder
   - `<YOUR_TIMEZONE>` — e.g. `America/Mexico_City`
   - `<YOUR_GOOGLE_CALENDAR_ID>` — create a calendar, then Settings → Integrate calendar → Calendar ID
   - `<YOUR_GOOGLE_DRIVE_DEADLINES_DOC_ID>` — create a doc; the ID is the long string in its URL
     between `/d/` and `/edit`
   - `<YOUR_CANVAS_USER_ID>` — optional, for direct submission links
3. **Set up the two scheduled tasks** in the Claude desktop app using `TASK-PROMPTS.md`, or drop
   the files from `scheduled-tasks/` into `~/.claude/scheduled-tasks/<name>/SKILL.md`.
   Suggested crons: `0 18 * * 0` (Sunday 6 PM) and `0 16 * * 1-6` (Mon–Sat 4 PM).
4. **Run the weekly task once manually** ("Run now") to approve the browser-control permission.

## Prerequisites

1. The **Claude desktop app** (for scheduled tasks).
2. The **Claude in Chrome** extension, signed into the same Canvas account.
3. A **Google account** with a dedicated Calendar and a Drive doc you control.
4. **Google Calendar and Drive connectors enabled**, so the synced data is readable.

All of these require a paid Claude plan, same as the Cowork method.

## Migrating to the Cowork method

You don't have to redo anything by hand. Follow the [Cowork setup](cowork-setup.md), and when
Claude runs first-run setup, tell it:

> I already have a Canvas Deadlines calendar and my old deadlines are in
> `~/Documents/Canvas Review/deadlines.md` — use the existing calendar and import those rows.

It will reuse your calendar rather than creating a second one, and carry the existing Event IDs
across so the duplicate guard keeps working.
