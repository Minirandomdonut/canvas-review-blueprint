---
name: daily-canvas-check
description: Daily Canvas check for surprise homework via Claude in Chrome
---

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
