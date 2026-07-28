# Troubleshooting

## "I can't reach Canvas"

The skill says this instead of guessing — it will never invent assignments.

Check, in order:

1. Is the **Claude desktop app** open? Browser control won't work without it.
2. Is **Chrome** open with a **Canvas tab logged in**? Try loading Canvas yourself first.
3. Did you approve the **browser-control permission** prompt? Run the task manually once with
   **Run now** and watch for it.
4. Are you on a **paid plan**? Claude in Chrome isn't available on Free.

---

## I don't see Skills on claude.ai

Turn on **Settings → Capabilities → Code execution and file creation**. Skills need it.

On Team or Enterprise, an owner must enable both *Code execution and file creation* and *Skills*
in organization settings first.

---

## The upload was rejected

The zip has to contain the `canvas-review` folder **as its root** — not a folder containing it,
and not the loose files.

Correct:

```
canvas-review.zip
└── canvas-review/
    ├── SKILL.md
    └── references/
```

Wrong — files at the top with no folder:

```
canvas-review.zip
├── SKILL.md
└── references/
```

Use `./build.sh`, which gets this right. If you zipped by hand on macOS, right-clicking the
*folder* → Compress gives the correct shape; selecting the files inside does not.

---

## It asks me to set up again every time

It couldn't find the config doc. Check that:

- The Google Drive doc is still titled exactly **`Canvas Review Deadlines`** — renaming it breaks
  the lookup.
- The **Google Drive connector** is still connected.
- You're signed into the same Google account.
- The `## Config` section at the top of the doc still exists. If a sync overwrote it, paste it
  back or delete the doc and run setup again.

---

## Duplicate calendar events

Every deadline row stores its calendar Event ID, and rows with an ID are meant to be skipped.

Duplicates usually mean the Event ID column got cleared or lost during an edit. Delete the extra
events, then check the table still has IDs in that column.

If your Google account also **auto-imports a Canvas calendar** by iCal, that's a separate feed —
you'll see each deadline twice. That's expected. Hide the auto-imported calendar in Google
Calendar; leave the curated `Canvas Deadlines` one visible.

---

## Scheduled tasks aren't running

- **Desktop app must be open** when the task fires. Closed laptop means a skipped run.
- **Scheduled tasks are in beta**, rolling out from Max downward — you may not have the feature yet.
- Check the task isn't paused.

---

## It missed an assignment

Two common causes:

- The daily check only scans the **dashboard and To-Do list**, by design — it's a fast surprise
  check, not a full sweep. The weekly review is the thorough one.
- Some teachers post work as a **Page or Announcement** rather than an Assignment, so it has no
  due date for Canvas to report. Ask directly: *"check the announcements and modules in [course]
  for anything with a deadline."*

---

## Canvas looks different at my school

Canvas installs vary. The tools navigate to standard paths like `/courses`,
`/courses/<id>/assignments`, and `/courses/<id>/modules`. If your school hides or renames sections,
tell Claude where things actually are and it can work from that.

If your Canvas URL changed, update the **Canvas base URL** line in the config section of the
`Canvas Review Deadlines` doc.

---

## Can I use this on the Free plan?

No. Reading Canvas requires browser control, which requires a paid plan. There's no workaround —
it's a Claude platform limit, not a project limitation.

You *can* upload the skill on Free, and Claude can still help you organize deadlines you type in
yourself. It just can't read Canvas for you.

---

## Does my school allow API tokens after all?

Open Canvas → **Account → Settings** and look for **"+ New Access Token"**. If it's there, you
don't need this project's browser workaround — use
[canvas-mcp](https://github.com/lucanardinocchi/canvas-mcp), which is a cleaner path.
