# Tool Catalog

The set of **tools** this skill exposes — the browser-native, no-token counterpart to an MCP
server's tool list. Think of it the way an MCP client thinks of a connected server: a catalog of
discrete, well-specified capabilities to **invoke on demand**.

The difference from a real MCP server (like [canvas-mcp](https://github.com/lucanardinocchi/canvas-mcp))
is the *transport*: instead of calling the Canvas REST API with a token, each tool here is
**executed by browser control** against the user's already-logged-in Canvas session.

> **Two hard invariants for every tool below:**
> 1. **Read-only.** No tool submits work, uploads files, posts to discussions, or changes any
>    Canvas setting. Ever.
> 2. **No fabrication.** If the browser isn't connected or Canvas isn't reachable, the tool stops
>    and says so — it never invents Canvas content.

Each tool is specified as **Inputs → Returns → Safety → How it runs**. `<BASE>` means the Canvas
base URL from the config header in the `Canvas Review Deadlines` Drive doc.

---

## Courses

### `list_courses`
List active/enrolled courses.
- **Inputs:** *(none)* — optional `include_past` (bool, default false).
- **Returns:** course names + Canvas course IDs.
- **Safety:** read-only.
- **How it runs:** open `<BASE>/` (Dashboard) or `<BASE>/courses`; read the active course cards /
  the "All Courses" list.

---

## Assignments

### `list_assignments`
List assignments for a course.
- **Inputs:** `course` (name or ID); optional `filter` (`upcoming` | `all`, default `upcoming`).
- **Returns:** assignment titles, due dates, and IDs.
- **Safety:** read-only.
- **How it runs:** open `<BASE>/courses/<course>/assignments`; read the list, honoring the filter.

### `get_assignment`
Read the full detail of one assignment.
- **Inputs:** `course` (name or ID), `assignment` (ID or title).
- **Returns:** the complete instructions body, due date, points, and linked resources/files.
- **Safety:** read-only.
- **How it runs:** open `<BASE>/courses/<course>/assignments/<id>`; read the entire description
  (not just the title), plus any attached files, Pages, or module links.

### `get_rubric`
Read an assignment's grading rubric / criteria.
- **Inputs:** `course` (name or ID), `assignment` (ID or title).
- **Returns:** each rubric criterion, its point values, and level descriptions.
- **Safety:** read-only.
- **How it runs:** on the assignment page, expand "Show Rubric" (or open the rubric panel);
  transcribe the criteria table. If no rubric is attached, say so.

### `get_submission_feedback`
Read submission status, grade, and instructor feedback for an assignment.
- **Inputs:** `course` (name or ID), `assignment` (ID or title).
- **Returns:** submitted/not-submitted status, score/grade if released, and any instructor
  comments or inline/rubric feedback.
- **Safety:** read-only.
- **How it runs:** open the submission details page
  `<BASE>/courses/<course>/assignments/<id>/submissions/<USER_ID>`, where `<USER_ID>` is the
  Canvas user ID from the config header. If the config has no user ID, navigate to the assignment
  page and follow its submission-details link instead. Read the grade, comment thread, and rubric
  assessment. Note if the grade is not yet released.

---

## Course content

### `list_modules`
Browse a course's modules and their materials in order.
- **Inputs:** `course` (name or ID).
- **Returns:** module names in sequence, each with its items (Pages, files, assignments, quizzes)
  and completion state where shown.
- **Safety:** read-only.
- **How it runs:** open `<BASE>/courses/<course>/modules`; read each module and its ordered items.

### `list_announcements`
Read recent course announcements.
- **Inputs:** `course` (name or ID); optional `since` (date, default last 7 days).
- **Returns:** announcement titles, dates, and bodies.
- **Safety:** read-only.
- **How it runs:** open `<BASE>/courses/<course>/announcements`; read entries in the window.

---

## Search / cross-course

### `get_upcoming_work`
Everything due across ALL active courses in a window — the core of the weekly review.
- **Inputs:** optional `days` (int, default 7).
- **Returns:** a due-date-sorted timeline of every assignment due within the window, each with its
  course, due date, and a one-line requirement digest.
- **Safety:** read-only.
- **How it runs:** run `list_courses`, then for each course `list_assignments` (filter `upcoming`)
  and `get_assignment` for anything inside the window; merge and sort by due date.

### `find_new_tasks`
Detect *surprise* homework posted since the last run — the core of the daily check.
- **Inputs:** *(none)* — diffs against the deadlines table in the Drive doc.
- **Returns:** only assignments visible on Canvas that are **not** already in the table (empty
  result ⇒ "no new tasks").
- **Safety:** read-only.
- **How it runs:** quick scan of the Dashboard / To-Do / upcoming list (no assignment bodies);
  compare against the deadlines table; for genuinely new items, follow up with `get_assignment`.

---

## Persistence / integration

### `sync_deadlines`
Persist known deadlines to Google so any Claude surface can read them. **This is the
integration** — the bridge that replaces a missing Canvas API.
- **Inputs:** the current deadlines table.
- **Returns:** a Google Calendar event per deadline + an updated Google Drive doc.
- **Safety:** writes to **the user's own Google Calendar/Drive only** — never to Canvas.
- **How it runs:** read the Calendar ID and timezone from the config header. For each row with an
  empty Event ID, create an event titled `Course — Assignment due`, with the Canvas URL + digest
  in the description; write the returned Event ID back into the row (**the duplicate guard** —
  never create an event for a row that already has one). Then overwrite the `Canvas Review
  Deadlines` doc with the config header, the current table, and the latest summary.

---

## Coverage vs. canvas-mcp

How this browser catalog maps to [canvas-mcp](https://github.com/lucanardinocchi/canvas-mcp)'s
token-based tools:

| canvas-mcp tool | Here | Notes |
|---|---|---|
| `list_courses` | ✅ `list_courses` | |
| `get_course` | ✅ via `list_courses` / `list_modules` | course detail read from its pages |
| `list_assignments` | ✅ `list_assignments` | |
| `get_assignment` | ✅ `get_assignment` | |
| `get_rubric` | ✅ `get_rubric` | |
| `get_submission` | ✅ `get_submission_feedback` | status + grade + feedback |
| `list_modules` | ✅ `list_modules` | |
| `list_announcements` | ✅ `list_announcements` | |
| `get_upcoming_assignments` | ✅ `get_upcoming_work` | |
| `get_all_upcoming_work` | ✅ `get_upcoming_work` | (all courses by default) |
| `find_assignments_by_due_date` | ✅ `get_upcoming_work` (`days`) | date-window variant |
| `get_overdue_assignments` | ➖ partial | table marks rows `past`; no dedicated scan yet |
| `search_course_content` | ➖ not yet | candidate for a future tool |
| `list_discussions` | ❌ excluded | out of scope |
| `get_discussion_entries` | ❌ excluded | out of scope |
| `post_discussion_entry` | ❌ **excluded (write)** | read-only invariant |
| `reply_to_discussion` | ❌ **excluded (write)** | read-only invariant |
| `submit_assignment` | ❌ **excluded (write)** | read-only invariant |
| `upload_file` | ❌ **excluded (write)** | read-only invariant |

**Legend:** ✅ covered · ➖ partial / planned · ❌ intentionally excluded.
All Canvas **write** actions are excluded by design — see the read-only invariant above.
