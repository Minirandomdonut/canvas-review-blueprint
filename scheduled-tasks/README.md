# scheduled-tasks

Ready-made copies of the two recurring routines (plus an optional one-time "resume" task),
in the `SKILL.md` shape the Claude desktop app's scheduler expects.

To use one, place it at:

```
~/.claude/scheduled-tasks/<task-name>/SKILL.md
```

for example `~/.claude/scheduled-tasks/weekly-canvas-review/SKILL.md`. Then create the
matching scheduled task in the Claude desktop app with the cron shown in `TASK-PROMPTS.md`.

Remember to fill in every `<PLACEHOLDER>` (your folder path, timezone, your Google Calendar
ID, and your Google Drive doc ID) before running them. The Calendar and Drive values are
required — the sync into Google is what lets claude.ai read your Canvas deadlines.
