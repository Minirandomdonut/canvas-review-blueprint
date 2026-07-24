---
name: resume-weekly-canvas-review
description: One-time - re-enable the paused Canvas review tasks when the term resumes.
---

Re-enable the paused Canvas review tasks for the start of a new term (optional — only useful
if you disable the tasks during breaks).

Use the scheduled-tasks tools to:
1. Set `weekly-canvas-review` to enabled: true.
2. Set `daily-canvas-check` to enabled: true.

Then confirm that both tasks (`weekly-canvas-review` and `daily-canvas-check`) are now
active, and suggest clicking "Run now" on the weekly-canvas-review task once to approve the
Claude in Chrome browser-control permissions, so future automatic runs don't pause on a
permission prompt.
