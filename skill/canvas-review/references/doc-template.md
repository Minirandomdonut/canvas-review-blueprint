# Drive doc template (first run only)

Create the doc with the title **`Canvas Review Deadlines`** and the body below.

The marker line `CANVAS-REVIEW-CONFIG-V3` is **required** — it is how every later run finds this
doc. Drive title search is fuzzy and will happily return `Canvas Deadlines` or
`Academic Profile — Canvas Year Review` instead, so the marker is the only reliable identifier.

Use this template **only when creating the doc**. On a normal sync, read the existing doc and
carry the marker and config forward rather than rewriting from this template.

Note that Google Docs escapes Markdown punctuation on write (`##` comes back as `\#\#`). That's
expected and harmless — later runs match on the field labels, not on Markdown structure. Keep each
config field on its own line in `Label: value` form.

---

```
Canvas Review Deadlines
CANVAS-REVIEW-CONFIG-V3

This doc is created and maintained automatically by the Canvas Review skill. It is both the
config store and the state store. Keep the CANVAS-REVIEW-CONFIG-V3 marker and the Config
section intact.

## Config
- Canvas base URL: <BASE_URL>
- Canvas user ID: <USER_ID_OR_BLANK>
- Timezone: <TIMEZONE>
- Calendar ID: <CALENDAR_ID>
- Set up on: <DATE>

## Deadlines

Status meanings: upcoming = not due yet, done = submitted per Canvas, past = due date passed.
The Event ID column holds the Google Calendar event ID once posted. A row with an ID must never
get a second event.

| Course | Assignment | Due date | Status | Event ID | Notes |
|--------|-----------|----------|--------|----------|-------|

## Latest summary

(No review has run yet.)
```
