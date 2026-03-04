# jtools

A set of Jira CLI helper functions for your terminal. Built on top of [go-jira](https://github.com/ankitpokhrel/jira-cli), jtools adds short, memorable commands and a powerful search interface so you spend less time writing JQL and more time shipping.

---

## Requirements

- [jira-cli](https://github.com/ankitpokhrel/jira-cli) installed and authenticated
- zsh shell
- macOS (BSD `date` is required by `jstatus` for date arithmetic)

---

## Installation

```sh
make install
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
| `jmine` | Your issues in the current sprint |
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

# Open a specific issue in browser
jopen PROJ-123
```
