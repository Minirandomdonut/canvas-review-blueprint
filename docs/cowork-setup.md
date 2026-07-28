# Setup walkthrough

Every click, in order. About five minutes.

If you'd rather skim, the short version is in the [README](../README.md#quick-start).

---

## What you need first

- **A paid Claude plan** — Pro, Max, Team, or Enterprise. The Free plan cannot read Canvas.
- **The Claude desktop app** (macOS or Windows) — browser control only works with it open.
- **Google Chrome** (or Edge/Brave/Arc), logged into Canvas.
- **A Google account.**

---

## Step 1 — Turn on code execution

Skills won't appear until this is on.

1. Go to [claude.ai](https://claude.ai).
2. **Settings → Capabilities**.
3. Turn on **Code execution and file creation**.

> On a Team or Enterprise plan, your admin has to enable both *Code execution* and *Skills* at the
> organization level before you'll see the option.

---

## Step 2 — Upload the skill

1. Download `canvas-review.zip` from the
   [Releases page](https://github.com/Minirandomdonut/canvas-review-blueprint/releases).
   Don't unzip it.
2. On claude.ai, go to **Customize → Skills**.
3. Click **Upload skill** and choose the `.zip`.
4. It appears in your list as **canvas-review**. Make sure it's toggled **on**.

Custom skills you upload are private to your account.

<details>
<summary>Building the zip yourself instead of downloading it</summary>

```bash
git clone https://github.com/Minirandomdonut/canvas-review-blueprint.git
cd canvas-review-blueprint
./build.sh
```

The zip lands at `dist/canvas-review.zip`.
</details>

---

## Step 3 — Connect Google Calendar and Drive

This is where your deadlines get saved, so it isn't optional.

1. On claude.ai, open your **connector settings**.
2. Connect **Google Calendar** and **Google Drive**.
3. Approve the permission prompts.

---

## Step 4 — Install Claude in Chrome

1. Install the [Claude in Chrome extension](https://claude.com/claude-for-chrome).
2. Sign in with the same Claude account.
3. Open Canvas in that browser and **log in**. Leave the tab open.

---

## Step 5 — Run setup

1. Open the **Claude desktop app**.
2. Switch to **Cowork**.
3. Say:

   > Set up my Canvas tracker.

Claude will ask you two things:

- **Your Canvas web address** — copy it from the address bar with Canvas open. It looks like
  `https://canvas.yourschool.edu` or `https://yourschool.instructure.com`.
- **Your timezone.**

Then it checks whether you already have a calendar named **Canvas Deadlines**. If you don't, it
asks you to make one — this is the only part Claude can't do for you, because the Google Calendar
connector can create events but not calendars:

> Open [calendar.google.com](https://calendar.google.com) → click the **+** next to "Other
> calendars" in the left sidebar → **Create new calendar** → name it exactly **`Canvas Deadlines`**
> → set your timezone → **Create calendar**.

Takes about thirty seconds. **You never have to copy the calendar ID** — Claude looks it up by
name once the calendar exists.

Everything else is automatic: Claude finds your Canvas user ID and creates a Google Drive doc
called **Canvas Review Deadlines** holding both your settings and your deadline list.

The first time it opens Chrome, you'll get a **browser-control permission prompt** — approve it.

Try it:

> What's due this week?

---

## Scheduled tasks

To make it run automatically.

1. In the desktop app, go to **Cowork → Scheduled → New task**.
2. Choose **Create with Claude** and describe what you want, for example:

   > Every Sunday evening, run my weekly Canvas review.

   Or choose **Set up manually** and paste a prompt from
   [`routines.md`](../skill/canvas-review/references/routines.md).

3. Recommended pair:

   | Task | When | What it does |
   |---|---|---|
   | Weekly review | Sunday evening | Full read of everything due in the next 7 days |
   | Daily check | Weekday afternoons | Quick scan for surprise homework |

4. **Run the weekly task once with "Run now"** while you're watching, so you can approve the
   browser-control prompt. After that it won't stall waiting for you.

### Two things to know

- **The desktop app must be open** when a task fires, because browser control needs it. If your
  laptop is closed, the run is skipped.
- **Scheduled tasks are in beta** and rolling out from Max downward, so you may not see the
  feature yet depending on your plan.

### Pausing over a break

Over summer or a long holiday, pause both tasks so they aren't running against empty courses. Ask
Claude to create a one-time task that re-enables them the day term restarts.

---

## Using it from your phone

Once the sync has run, your deadlines are in Google Calendar — so they show up on your phone
automatically.

You can also ask Claude on web or mobile things like *"what Canvas work do I have coming up?"* and
it can read the Drive doc through the Google connector. It can't read Canvas *live* from your
phone (that needs the desktop app and Chrome), but it can read everything the last sync saved.

---

## Something not working?

See [troubleshooting.md](troubleshooting.md).
