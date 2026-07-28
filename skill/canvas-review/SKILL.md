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

All configuration and state live in **one Google Drive doc titled `Canvas Review Deadlines`**,
identified by the marker string `CANVAS-REVIEW-CONFIG-V3` in its body. There is nothing for the
user to edit by hand and no config file in this skill.

**Find it with this exact query — do not search by title alone:**

```
fullText contains 'CANVAS-REVIEW-CONFIG-V3' and mimeType = 'application/vnd.google-apps.document'
```

Title search is unreliable here. Drive's `title = '...'` does **not** do exact matching — it
returns fuzzy matches — so searching for `Canvas Review Deadlines` also returns docs called
`Canvas Deadlines`, `Academic Profile — Canvas Year Review`, and similar. Picking the wrong one
means reading nonsense config or overwriting an unrelated document.

- **Exactly one result** → that's the config doc. Read it.
- **No results** → run first-run setup (Step 2). A newly created doc can take a few seconds to
  become searchable, so if you just created one, retry once before concluding it's missing.
- **More than one result** → don't guess. Show the user the titles and ask which to use.

**Fallback** if the marker query returns nothing but the user insists setup was already done:
search `title contains 'Canvas Review Deadlines'`, then **read each candidate and confirm it
contains the marker** before using it. Never trust a title match on its own.

### Reading the config values

Google Docs escapes Markdown punctuation when a doc is created from text — `## Config` comes back
as `\#\# Config`, and `America/Mexico_City` as `America/Mexico\_City`. **Do not parse Markdown
structure.** Instead find the line containing each label and take everything after the colon,
stripping any stray `\` characters:

| Label to find | Example value |
|---|---|
| `Canvas base URL:` | `https://canvas.school.edu` |
| `Canvas user ID:` | `465957` (may be blank) |
| `Timezone:` | `America/Mexico_City` |
| `Calendar ID:` | `abc123@group.calendar.google.com` |

If the Google Drive connector isn't enabled, say so and point the user at `docs/cowork-setup.md` —
the sync is the integration, so it can't be skipped.

## Step 2 — first-run setup (only when no config doc exists)

Do as much as possible for the user. They should never have to copy an ID.

**Important: you cannot create a Google Calendar.** The Google Calendar connector can create
*events* but not *calendars* — there is no `create_calendar` tool. So the calendar is the one
thing the user makes themselves, and you find its ID afterwards.

Ask these questions in one short message:

1. **What's your Canvas web address?** (e.g. `https://canvas.school.edu` — tell them to copy it
   from the address bar while Canvas is open)
2. **What timezone are you in?** (offer a guess from their locale)

Then:

3. **Find or set up the calendar.** Call `list_calendars` and look for one named
   `Canvas Deadlines`.
   - **Found** → use its ID. Say so, and don't ask them to make another. (Returning users from the
     old desktop version will already have this.)
   - **Not found** → ask them to create it, with these exact steps:
     > Open [calendar.google.com](https://calendar.google.com) → in the left sidebar, click the
     > **+** next to "Other calendars" → **Create new calendar** → name it exactly
     > **`Canvas Deadlines`** → set the timezone → **Create calendar**. Tell me when it's done.

     Then call `list_calendars` again and read the ID yourself. **Never ask them to copy the
     calendar ID** — that's the step this design exists to remove.
   - If they'd rather not create one, offer to use their primary calendar instead, and warn that
     deadlines will be mixed in with everything else.
4. **Get the Canvas user ID** from the browser (open `/profile/settings` or read it from any
   submission URL). If it can't be determined, leave it blank — it only affects direct submission
   links.
5. **Create the Drive doc** titled exactly `Canvas Review Deadlines`, using
   `references/doc-template.md`. The body **must** contain the line `CANVAS-REVIEW-CONFIG-V3` —
   that marker is how every future run finds it. Fill in the values you gathered.
6. **Verify** by running the Step 1 marker query. If it doesn't come back within a couple of
   retries, tell the user rather than assuming success.
7. Confirm in plain language what you set up, and offer to run a first review.

Never create a second calendar or a second doc when one already exists.

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

**Google Drive.** Overwrite the `Canvas Review Deadlines` doc with: the marker line and config
section unchanged, then the current deadlines table, then the latest summary.

> **Two things that must survive every write:**
> - The `CANVAS-REVIEW-CONFIG-V3` marker line — lose it and no future run can find the doc.
> - The config values — lose them and the user is pushed back through setup.
>
> Read the doc before overwriting it and carry both forward. Never write a fresh doc from the
> template on a normal sync; the template is for first-run only.

Because Google Docs escapes Markdown punctuation, don't rely on the table rendering as Markdown.
Keep one deadline per line with a consistent separator so it stays parseable when read back, and
always keep the Event ID on the same line as its assignment.

If the user's Google account also auto-imports a Canvas iCal calendar, leave it alone. The curated
`Canvas Deadlines` calendar is separate and richer.

## Status values

`upcoming` = not due yet · `done` = submitted per Canvas · `past` = due date passed.

## Tone

The users are high-school and university students, often stressed and short on time. Lead with
what's due soonest. Keep summaries skimmable. Don't bury a deadline in prose.
