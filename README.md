# jtools

A set of Jira CLI helper functions for your terminal. Built on top of [go-jira](https://github.com/ankitpokhrel/jira-cli), jtools adds short, memorable commands and a powerful search interface so you spend less time writing JQL and more time shipping.

---

## Requirements

- [jira-cli](https://github.com/ankitpokhrel/jira-cli) installed and authenticated
- zsh shell
- macOS or Linux (`jstatus` uses BSD `date` on macOS and GNU `date` on Linux)

---

## Installation

Clone the repository and install script:

```sh
git clone https://github.com/lukszar/jtools && cd jtools && make install
```

This copies the scripts to `~/.jtools` and adds `source ~/.jtools` to your `~/.zprofile`.

Then reload your shell:

```sh
source ~/.zprofile
```

Or open a new terminal window.

---

## Commands

| Command | Description |
|---|---|
| `jmine` | Your issues in the current sprint (includes previously assigned) |
| `jnow` | Your open (not done) issues in the current sprint |
| `jsprint` | All issues in the current sprint |
| `jsearch` / `jfind` | Search issues with filters (see below) |
| `jstatus` | Sprint dashboard: progress, days left, status counts |
| `jrefi` | Tasks in "In Refinement" status that are not yet estimated |
| `jdoctor` | Highlights tasks requiring attention |
| `jopen <KEY>` | Open an issue in the browser |
| `jhelp` | Print this reference in the terminal |

---

## jsearch / jfind

The main search command. Accepts search terms and flags that can be freely combined.

### Short flags

Can be combined into a single argument, e.g. `-mot`:

| Flag | Description |
|---|---|
| `-t` | Search in title (summary) only |
| `-d` | Search in description only |
| `-s` / `-c` | Current sprint only |
| `-m` | Assigned to me only |
| `-o` | Open issues only (not Done) |
| `-f` | Fuzzy: split a single quoted string into multiple search terms |

### Issue type flags

| Flag | Description |
|---|---|
| `--task` | Filter by type: Task |
| `--bug` | Filter by type: Bug |
| `--epic` | Filter by type: Epic |
| `--story` | Filter by type: Story |

### Search terms

Pass one or more quoted strings — all terms must match:

```sh
jsearch "iOS" "login"     # issues containing both words
jsearch -f "iOS login"    # same, using a single fuzzy string
```

When no `-t` or `-d` flag is given, both title and description are searched.

---

## jdoctor

Runs three checks and reports tasks that need attention:

1. **Unassigned** — In Progress or Blocked tasks with no assignee
2. **Not estimated** — In Progress tasks with no estimation
3. **No description** — In Progress tasks with an empty description

```sh
jdoctor
```

---

## jrefi

Lists tasks currently in **"In Refinement"** status that have not been estimated yet — useful for refinement session prep.

```sh
jrefi
```

---

## Examples

```sh
# My open tasks in current sprint
jsearch -mos --task

# Bugs mentioning "crash" assigned to me
jsearch -mo --bug "crash"

# Search title only for two keywords
jsearch -t "iOS" "SCREEN"

# Same using fuzzy flag
jsearch -tf "iOS SCREEN"

# All epics in current sprint
jsearch --epic -s

# All stories in current sprint
jsearch --story -s

# Open a specific issue in browser
jopen PROJ-123
```

---

## Troubleshooting

**`jira: command not found`**
Install jira-cli: https://github.com/ankitpokhrel/jira-cli

**`No active sprint found` in jstatus**
Your Jira board may not have an active sprint, or jira-cli may not be pointed at the right project. Run `jira sprint list` to check.

**`jstatus` shows 0 for all counts**
This was a bug in older versions fixed in the current release. If you installed before the fix, run `make install` again to update.

**Commands not found after install**
Run `source ~/.zprofile` or open a new terminal window.

---

## Customization

Two commands — `jrefi` and `jdoctor` — use Jira fields and statuses that are specific to a particular team setup. You will likely need to adapt them to match your own Jira configuration.

### `Estimation` field

`jrefi` and `jdoctor` filter on `Estimation is EMPTY`. `Estimation` is a custom field; your Jira instance probably uses a different name. Common alternatives:

- `story_points`
- `Story Points`
- `sp`

To find the correct field name, open any issue in the Jira UI, look at the estimation field name, or ask your Jira admin. Then edit `~/.jtools` and replace `Estimation` with the correct field name in these lines:

```
# jdoctor (~line 231)
jira issue list --jql 'statusCategory = "In Progress" AND issuetype = Task AND Estimation is EMPTY'

# jrefi (~line 245)
jira issue list --jql 'statusCategory != Done AND status = "In Refinement" AND Estimation is EMPTY'
```

### `"In Refinement"` status

`jrefi` filters by `status = "In Refinement"`. This is a custom workflow status. Replace it with whatever your team calls the refinement stage (e.g. `"Backlog"`, `"Ready for Refinement"`, `"Refining"`).

Edit `~/.jtools` and update this line in `jrefi`:

```
jira issue list --jql 'statusCategory != Done AND status = "In Refinement" AND Estimation is EMPTY'
```
