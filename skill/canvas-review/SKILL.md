---
name: canvas-review
description: Track Canvas LMS coursework without an API token. Reads assignments, due dates, rubrics, grades and feedback from Canvas through the logged-in browser, then syncs deadlines to Google Calendar and a Google Drive doc. Use whenever the user asks about homework, assignments, deadlines, due dates, what's due, grades, feedback, rubrics, announcements, or their Canvas courses.
---

# Canvas Review

Turns Claude into a Canvas LMS assistant for students whose institution has **disabled personal
Canvas API tokens**. Canvas is read through the **browser**, riding the user's already-logged-in
session. Deadlines are then written to **Google Calendar** and a **Google Drive doc**, so the data
stays readable from any Claude surface through the Google connectors.

## Hard invariants

These are absolute. They apply to every tool and every routine, without exception.

1. **Read-only in Canvas.** Never submit work, upload a file, post or reply to a discussion, add a
   comment, or change any Canvas setting. Reading only.
2. **Never fabricate.** If the browser isn't connected or Canvas isn't reachable, **stop and say
   so**. Never invent an assignment, due date, grade, or announcement.
3. **Never attempt a Canvas API or token.** Personal tokens are disabled for these users. Do not
   try API endpoints, do not ask the user for a token, do not suggest a token-based MCP server.

## Requirements check

This skill needs browser control to read Canvas. If browser control is unavailable in the current
surface, say plainly:

> I can read your Canvas data only through browser control, which isn't available here. Open the
> Claude desktop app and use Cowork, then ask me again.

Do not fall back to guessing or to asking the user to paste data unless they explicitly ask for
that.

## Step 1 — find the config (do this first, every time)

All configuration and state live in **one Google Drive doc titled `Canvas Review Deadlines`**.
There is nothing for the user to edit by hand and no config file in this skill.

1. Search Google Drive for a doc named `Canvas Review Deadlines`.
2. If found, read it. Its `## Config` section holds everything you need:

   ```
   ## Config
   - Canvas base URL: https://canvas.school.edu
   - Canvas user ID: 465957
   - Timezone: America/Mexico_City
   - Calendar ID: abc123@group.calendar.google.com
   - Set up on: 2026-07-27
   ```

3. If **not** found, run the first-run setup below. Do not ask the user for IDs before checking.

If the Google Drive connector isn't enabled, say so and point the user at
`docs/cowork-setup.md` — the sync is the integration, so it can't be skipped.

## Step 2 — first-run setup (only when no config doc exists)

Create everything for the user. Do **not** ask them to hunt down a calendar ID or a file ID by
hand — those are the two worst steps in the old setup and you can do both yourself.

Ask only these questions, in one short message:

1. **What's your Canvas web address?** (e.g. `https://canvas.school.edu` — tell them to copy it
   from the address bar while Canvas is open)
2. **What timezone are you in?** (offer a guess from their locale)

Then, without further prompting:

3. Create a Google Calendar named **`Canvas Deadlines`** in that timezone. Keep its calendar ID.
4. Read the user's Canvas user ID from Canvas via the browser (open `/profile/settings` or read it
   from any submission URL). If it can't be determined, leave it blank — it only affects direct
   submission links.
5. Create a Google Drive doc titled exactly **`Canvas Review Deadlines`**, seeded with the
   template in `references/doc-template.md`, filling the `## Config` values you just gathered.
6. Confirm to the user in plain language what you made, and offer to run a first review now.

Never create a second calendar or a second doc if one already exists.

## Step 3 — do the work

Capabilities are specified as a catalog of discrete, read-only tools. **Read
`references/tools.md`** for each tool's Inputs → Returns → Safety → How it runs, and invoke the
matching tool rather than improvising. Available tools:

`list_courses`, `list_assignments`, `get_assignment`, `get_rubric`, `get_submission_feedback`,
`list_modules`, `list_announcements`, `get_upcoming_work`, `find_new_tasks`, `sync_deadlines`.

For the weekly review and daily surprise-homework check — including the exact prompts to use when
setting these up as scheduled tasks — **read `references/routines.md`**. Those routines are not
separate logic; they are automations composed from the tools above.

## Step 4 — sync (required, this is the integration)

After any change to the deadlines table, both syncs must run. Claude on other surfaces can't read
Canvas, but it *can* read Google — so this sync is what makes the data useful everywhere.

**Google Calendar.** For each deadline row with an **empty** Event ID, create an event on the
configured calendar. Title: `Course — Assignment due`. Put the assignment's Canvas URL and a
one-line requirement digest in the description. Write the returned event ID back into the row.

> **Duplicate guard:** never create an event for a row that already has an Event ID. This is the
> only thing preventing a re-run from spamming the user's calendar. Check it every time.

**Google Drive.** Overwrite the `Canvas Review Deadlines` doc with: the `## Config` section
unchanged, then the current deadlines table, then the latest weekly summary. Preserve the config
header — losing it forces the user through setup again.

If the user's Google account also auto-imports a Canvas iCal calendar, leave it alone. The curated
`Canvas Deadlines` calendar is separate and richer.

## Status values

`upcoming` = not due yet · `done` = submitted per Canvas · `past` = due date passed.

## Tone

The users are high-school and university students, often stressed and short on time. Lead with
what's due soonest. Keep summaries skimmable. Don't bury a deadline in prose.
