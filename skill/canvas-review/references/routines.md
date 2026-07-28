# Routines

Two automations **composed from the read-only tools in `tools.md`**. Both stay strictly read-only
in Canvas.

Neither routine takes a working folder — all state lives in the `Canvas Review Deadlines` Google
Drive doc. Read its `## Config` header first for the Canvas base URL, timezone, calendar ID, and
Canvas user ID.

## Setting these up as scheduled tasks

In the Claude desktop app, open **Cowork → Scheduled → New task**. Use **Create with Claude** and
describe the routine, or **Set up manually** and paste the prompt below.

| Routine | Suggested cadence |
|---|---|
| `weekly-canvas-review` | Weekly, Sunday evening |
| `daily-canvas-check` | Daily on weekdays, afternoon |

Run the weekly task once with **Run now** after creating it, so the browser-control permission
prompt is approved while you're watching. After that, automatic runs won't pause on it.

Browser control requires the desktop app to be open when the task fires. If the user's term has a
break, suggest pausing both tasks and scheduling a one-time task to re-enable them when term
resumes.

---

## WEEKLY PROMPT (`weekly-canvas-review`)

Run the weekly Canvas LMS review for the upcoming week.

ACCESS RULES: Canvas access requires the logged-in browser session. There is NO Canvas API token
(the institution disabled personal tokens). Use ONLY browser control against the already-logged-in
Canvas session. Do NOT attempt any Canvas API or token-based MCP — they will not work.

CONFIG: find the Google Drive doc titled "Canvas Review Deadlines" and read its `## Config`
section for the Canvas base URL, timezone, calendar ID, and Canvas user ID. If the doc doesn't
exist, run first-run setup instead of guessing.

STEPS:
1. Guard: verify browser control is connected and you are logged into Canvas (find a Canvas tab or
   navigate to the dashboard). If not reachable, STOP and say: "I can't reach Canvas — please open
   Canvas in Chrome, make sure you're logged in, and re-run this task." Never fabricate results.
2. Across all active courses, gather for the next ~7 days: full assignment/project descriptions
   (open each assignment page and read the complete body, not just the title), due dates, linked
   resources and files (readings, PDFs, Pages, Module materials), and announcements posted in the
   last week.
   Where it adds useful context (still read-only), also use `get_rubric`,
   `get_submission_feedback`, and `list_modules` — e.g. note the grading rubric for a big
   assignment, or flag returned feedback on a prior submission.
3. Build the week's summary: a "What's due this week" deadline timeline first, then per-course
   detail (instructions digest, resources, announcements).
4. Update the deadlines table: append any deadline not already in it; set status to "past" for
   rows whose due date has passed (or "done" if Canvas shows it submitted). Keep the table sorted
   by due date.
5. Calendar sync (required — part of the integration): for each row with an EMPTY Event ID, create
   an event on the configured calendar. Title: "Course — Assignment due". Put the assignment's
   Canvas URL and a one-line requirement digest in the event description. Write the returned event
   ID back into the row. NEVER create an event for a row that already has an Event ID — that is
   the duplicate guard.
6. Drive sync (required — part of the integration): overwrite the "Canvas Review Deadlines" doc
   with the `## Config` header unchanged, then the current deadlines table, then this week's
   summary. Preserve the config header.

CONSTRAINTS: read-only in Canvas — never submit, post, or change settings. If a page won't load or
you hit a permissions wall, note it in the output instead of guessing. Keep the summary skimmable.

---

## DAILY PROMPT (`daily-canvas-check`)

Run the daily Canvas surprise-homework check. Teachers sometimes post new homework mid-week; your
ONLY job is to detect and intake anything new since the last run.

ACCESS RULES: same as the weekly review — NO Canvas API token exists; use ONLY browser control
against the logged-in session.

CONFIG: find the Google Drive doc titled "Canvas Review Deadlines" and read its `## Config`
section. If the doc doesn't exist, run first-run setup instead of guessing.

STEPS:
1. Guard: if browser control isn't connected or you aren't logged into Canvas, STOP and say: "I
   can't reach Canvas — please open Canvas in Chrome, make sure you're logged in, and re-run this
   task." Never fabricate results.
2. Quick scan ONLY: check the Canvas dashboard, To-Do list, and upcoming assignments across
   courses. Do not open assignment bodies yet.
3. Diff against the deadlines table in the Drive doc: any assignment visible on Canvas that is not
   in the table is NEW.
4. If nothing is new: reply exactly "Daily check: no new tasks." and STOP. Do not touch the doc or
   the calendar.
5. If new items exist, for each one: open it and read the full description; append a row to the
   deadlines table; create its calendar event (title "Course — Assignment due", Canvas URL +
   digest in the description) and record the event ID in the row; then overwrite the Drive doc
   with the updated table, preserving the config header; and add a dated "New task spotted: …"
   note to the latest summary section.

CONSTRAINTS: read-only in Canvas; honest about anything that fails to load; keep the reply short —
this is a background check, not a report.
