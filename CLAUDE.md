# Canvas Review — playbook

This folder is the permanent home of the Canvas LMS review system. Any Claude session working
here (terminal, desktop app, or a scheduled task) must follow this playbook.

## Why this exists

Many institutions **disable personal Canvas API tokens**, so there is no API access.
Canvas is read **only** through the **Claude in Chrome** extension, riding your
logged-in browser session.

The point of the system is to be an **alternative Canvas integration for Claude**: because
claude.ai cannot read Canvas directly, this system writes every deadline into **Google
Calendar** and a **Google Drive doc**, which claude.ai *can* read through its native Google
connectors. That sync is therefore **the integration itself**, not an add-on — never skip it.

Consequences:

- If Chrome isn't connected or you aren't logged into Canvas, **stop and say so** —
  never fabricate Canvas content.
- Do NOT attempt any Canvas API, token-based MCP, or credential entry. They will not work
  and must not be tried.
- Everything in Canvas is **read-only**: never submit, post, comment, or change settings.
  This is a hard invariant — no exceptions, in any tool or routine.

## Tool catalog

Capabilities are organized as a **catalog of discrete, read-only tools** — the browser-native
counterpart to an MCP server's tool list. `TOOLS.md` is the **source of truth** for what the
system can do; read it to see each tool's Inputs → Returns → Safety → How it runs. Available
tools include `list_courses`, `list_assignments`, `get_assignment`, `get_rubric`,
`get_submission_feedback`, `list_modules`, `list_announcements`, `get_upcoming_work`,
`find_new_tasks`, and `sync_deadlines`.

The two scheduled routines below are **not** separate logic — they are **automations composed
from these tools** (e.g. the weekly review = `get_upcoming_work` → write `reviews/` →
`sync_deadlines`). When you need a capability, invoke the matching tool from `TOOLS.md` rather
than improvising.

## File map

- `TOOLS.md` — the **tool catalog** (read-only) + a coverage-vs-canvas-mcp table. Source of
  truth for capabilities.
- `deadlines.md` — the **living memory**. One table of every known deadline: course,
  assignment, due date, status (`upcoming` / `done` / `past`), Google Calendar event ID,
  notes. This file is the single source of truth for "what do we already know".
- `reviews/YYYY-MM-DD.md` — one file per weekly run: "What's due this week" timeline first,
  then per-course detail (full instructions digest, resources, announcements). Daily checks
  append dated "New task spotted" notes to the current week's file.
- `TASK-PROMPTS.md` — the prompts for the two scheduled tasks in the Claude desktop app
  (`weekly-canvas-review` and `daily-canvas-check`), plus handoff instructions.
- `scheduled-tasks/` — ready-made `SKILL.md`-style copies of the routines, in case you
  prefer to drop them straight into `~/.claude/scheduled-tasks/<name>/SKILL.md`.

### Optional: academic-profile knowledge base

Some users add an `academic-profile/` folder — a year-in-review knowledge base with one file
per course (module/resource maps, personal notes) plus a cross-course summary — and sync it
to a private Google Drive doc so the claude.ai chatbot can read it. This is **optional and
personal**; it is intentionally **not** part of this blueprint. If you build one, keep it out
of any public repository (see `.gitignore`).

## The two routines

**Weekly (e.g. Sundays ~6 PM, task `weekly-canvas-review`)** — deep dive: read the next
~7 days across all active courses (full assignment bodies, resources, announcements), write
the `reviews/` file, update `deadlines.md`, sync calendar and Drive.

**Daily (e.g. Mon–Sat ~4 PM, task `daily-canvas-check`)** — surprise-homework check: quick
scan of the dashboard/To-Do only, diff against `deadlines.md`. Nothing new → say "no new
tasks" and touch nothing. New items → full intake for just those items (description,
deadlines.md row, calendar event, Drive refresh, dated note in the week's review file).

## Sync rules (required — this is the integration)

- **Google Calendar**: events go on a dedicated calendar (e.g. "Canvas Deadlines") —
  calendarId `<YOUR_GOOGLE_CALENDAR_ID>`, timezone `<YOUR_TIMEZONE>`. Event title:
  `Course — Assignment due`, with the assignment's Canvas URL and a one-line digest in the
  description. After creating an event, write its event ID into the row in `deadlines.md`.
  **Never create an event for a row that already has an event ID** — that's the duplicate guard.
- **Google Drive**: after any change to `deadlines.md`, overwrite a Drive doc
  (e.g. "Canvas Deadlines", file ID `<YOUR_GOOGLE_DRIVE_DEADLINES_DOC_ID>`) with the
  current deadlines table followed by the latest weekly summary. This is how the main
  claude.ai chatbot can see the data — keep it current.
- Note: if your Google account also has an auto-imported Canvas iCal calendar, leave it
  alone — your curated "Canvas Deadlines" calendar is separate and richer.

## User context

Fill in your own context here (e.g. your courses, term dates, whether tasks are paused during
breaks). If you want direct submission links, your Canvas user ID makes them predictable:
submission pages look like `/courses/<course>/assignments/<id>/submissions/<YOUR_CANVAS_USER_ID>`.
