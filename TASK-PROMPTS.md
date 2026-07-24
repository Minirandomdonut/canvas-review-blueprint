# Scheduled-task prompts for the Claude desktop app

## Handoff instructions (for the desktop-app Claude reading this file)

Do these three things with the scheduled-tasks tools:

1. **Create/Update** the task `weekly-canvas-review` — cron `0 18 * * 0` (Sunday 6 PM),
   prompt = the **WEEKLY PROMPT** below.
2. **Create** the task `daily-canvas-check` — cron `0 16 * * 1-6` (Mon–Sat 4 PM; Sunday is
   covered by the weekly run), description "Daily Canvas check for surprise homework via
   Claude in Chrome", prompt = the **DAILY PROMPT** below.
3. *(Optional)* If you pause the tasks during a break, create a one-time task
   `resume-weekly-canvas-review` that re-enables **both** tasks on the day your term resumes,
   then suggest one "Run now" on the weekly task to approve the Chrome browser-control
   permissions.

Adjust the crons and timezone to your own schedule.

---

## WEEKLY PROMPT (task `weekly-canvas-review`, cron `0 18 * * 0`)

Run the weekly Canvas LMS review for the upcoming week.

ACCESS RULES: Canvas access requires your logged-in browser session. There is NO
Canvas API token (the institution disabled personal tokens). Use ONLY the Claude in Chrome
extension tools against the already-logged-in Canvas session. Do NOT attempt any
Canvas API or token-based MCP — they will not work.

WORKING FOLDER: <PATH_TO_YOUR_CANVAS_REVIEW_FOLDER> — read CLAUDE.md there first and
follow it.

STEPS:
1. Guard: verify Claude in Chrome is connected and you are logged into Canvas (find a
   Canvas tab or navigate to the dashboard). If not reachable, STOP and say:
   "I can't reach Canvas — please open Canvas in Chrome, make sure you're logged in, and
   re-run this task." Never fabricate results.
2. Across all active courses, gather for the next ~7 days: full assignment/project
   descriptions (open each assignment page and read the complete body, not just the title),
   due dates, linked resources and files (readings, PDFs, Pages, Module materials), and
   announcements posted in the last week.
3. Save the summary to reviews/YYYY-MM-DD.md (today's date): a "What's due this week"
   deadline timeline first, then per-course detail (instructions digest, resources,
   announcements).
4. Update deadlines.md: append any deadline not already in the table; set status to "past"
   for rows whose due date has passed (or "done" if Canvas shows it submitted). Keep the
   table sorted by due date.
5. Calendar sync (required — part of the integration): for each row with an EMPTY Event ID,
   create an event on your Google Calendar (calendarId: <YOUR_GOOGLE_CALENDAR_ID>, timezone
   <YOUR_TIMEZONE>). Title: "Course — Assignment due". Put the assignment's Canvas URL and a
   one-line requirement digest in the event description. Write the returned event ID back
   into the row. NEVER create an event for a row that already has an Event ID — that is the
   duplicate guard.
6. Drive sync (required — part of the integration): overwrite your Google Drive doc (file ID:
   <YOUR_GOOGLE_DRIVE_DEADLINES_DOC_ID>) with the current deadlines table followed by this
   week's summary, so claude.ai always sees fresh data.

CONSTRAINTS: read-only in Canvas — never submit, post, or change settings. If a page won't
load or you hit a permissions wall, note it in the output instead of guessing. Keep the
summary skimmable.

---

## DAILY PROMPT (task `daily-canvas-check`, cron `0 16 * * 1-6`)

Run the daily Canvas surprise-homework check. Teachers sometimes post new homework mid-week;
your ONLY job is to detect and intake anything new since the last run.

ACCESS RULES: same as the weekly review — NO Canvas API token exists; use ONLY Claude in
Chrome against the logged-in session.

WORKING FOLDER: <PATH_TO_YOUR_CANVAS_REVIEW_FOLDER> — read CLAUDE.md there first and
follow it.

STEPS:
1. Guard: if Chrome isn't connected or you aren't logged into Canvas, STOP and say:
   "I can't reach Canvas — please open Canvas in Chrome, make sure you're logged in, and
   re-run this task." Never fabricate results.
2. Quick scan ONLY: check the Canvas dashboard, To-Do list, and upcoming assignments across
   courses. Do not open assignment bodies yet.
3. Diff against the table in deadlines.md: any assignment visible on Canvas that is not in
   the table is NEW.
4. If nothing is new: reply exactly "Daily check: no new tasks." and STOP. Do not edit any
   file or the calendar.
5. If new items exist, for each one: open it and read the full description; append a row to
   deadlines.md; create its event on your Google Calendar (calendarId:
   <YOUR_GOOGLE_CALENDAR_ID>, timezone <YOUR_TIMEZONE>, title "Course — Assignment due",
   Canvas URL + digest in the description) and record the event ID in the row; then
   overwrite the Drive doc (file ID: <YOUR_GOOGLE_DRIVE_DEADLINES_DOC_ID>) with the updated
   table + latest summary; and append a dated "New task spotted: …" note to the current
   week's reviews/ file (create the file if this week has none yet).

CONSTRAINTS: read-only in Canvas; honest about anything that fails to load; keep the reply
short — this is a background check, not a report.
