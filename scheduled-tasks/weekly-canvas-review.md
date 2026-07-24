---
name: weekly-canvas-review
description: Sunday-evening weekly Canvas LMS review via Claude in Chrome (logged-in session).
---

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
5. Calendar sync (optional): for each row with an EMPTY Event ID, create an event on your
   Google Calendar (calendarId: <YOUR_GOOGLE_CALENDAR_ID>, timezone <YOUR_TIMEZONE>).
   Title: "Course — Assignment due". Put the assignment's Canvas URL and a one-line
   requirement digest in the event description. Write the returned event ID back into the
   row. NEVER create an event for a row that already has an Event ID — that is the
   duplicate guard.
6. Drive sync (optional): overwrite your Google Drive doc (file ID:
   <YOUR_GOOGLE_DRIVE_DEADLINES_DOC_ID>) with the current deadlines table followed by this
   week's summary, so claude.ai always sees fresh data.

CONSTRAINTS: read-only in Canvas — never submit, post, or change settings. If a page won't
load or you hit a permissions wall, note it in the output instead of guessing. Keep the
summary skimmable.
