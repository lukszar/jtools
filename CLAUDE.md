# jtools — Claude Code context

## Project structure

Single-file zsh project. All commands live in `scripts`, which is copied to `~/.jtools` on install.

```
scripts        # The only source file — edit this, then run make install to deploy
Makefile       # install / uninstall targets
README.md      # user-facing documentation
```

There are no dependencies, no build system, no tests, and no lock files.

## How to apply changes

After editing `scripts`, reinstall to pick up the changes in the active shell:

```sh
make install
source ~/.zprofile   # or open a new terminal
```

To verify a change live without reinstalling, source the file directly in the current session:

```sh
source scripts
```

## Command inventory

| Command | Type | Description |
|---|---|---|
| `jmine` | alias | Current sprint issues assigned to (or previously assigned to) me |
| `jnow` | function | My open (not Done) issues in current sprint |
| `jsprint` | function | All issues in current sprint |
| `jsearch` / `jfind` | aliases → `_jql_search` | Filtered search with flags and terms |
| `jstatus` | function | Sprint dashboard: dates, days left, counts, progress bar |
| `jrefi` | function | Unestimated tasks in the configured refinement status (`JTOOLS_REFI_STATUS`) |
| `jdoctor` | function | Flags unassigned / unestimated / no-description In Progress tasks |
| `jopen <KEY>` | function | Open issue in browser |
| `jhelp` | function | Print command reference to terminal |

## `_jql_search` internals

The core of `jsearch`. Key behaviours:

- Combined short flags (`-mot`) are expanded to individual flags before parsing
- Default search scope: both title and description (if neither `-t` nor `-d` is given)
- Fuzzy flag (`-f`) splits a single quoted string into multiple terms using zsh `${=term}`
- Multiple terms are AND-joined; title/desc alternatives within a term are OR-joined
- Double-quotes in terms are escaped before embedding in JQL to prevent syntax errors

## Team-specific configuration

Two variables at the top of `scripts` control team-specific Jira field/status names:

| Variable | Default | Used by |
|---|---|---|
| `JTOOLS_ESTIMATION_FIELD` | `Estimation` | `jrefi`, `jdoctor` |
| `JTOOLS_REFI_STATUS` | `In Refinement` | `jrefi` |

Users override these in `~/.jtoolsrc` (created manually, never committed):
```zsh
JTOOLS_ESTIMATION_FIELD="Story Points"
JTOOLS_REFI_STATUS="To Do"
```

The rc file is sourced at the bottom of the config block (top of `scripts`). Env vars exported before sourcing also work. Running `jhelp` shows the currently active values.

**Important:** both values must be valid JQL names, not UI display labels. These can differ — e.g. a board may show "Do zrobienia" but the JQL name is `"To Do"`. Field names containing spaces must still be quoted in JQL; the scripts handle this automatically by wrapping `$JTOOLS_ESTIMATION_FIELD` in double-quotes when building the query.

## `jstatus` implementation notes

- Fetches sprint metadata with `jira sprint list --table --plain --no-headers --columns ID,NAME,START,END,STATE --state active`
- Parses tab-delimited output using `awk -F'\t'`; validates `sprintEnd` is non-empty before doing date math
- Uses BSD `date -j` on macOS and GNU `date -d` on Linux for epoch conversion
- Issue counts: three separate `jira issue list` calls (one per status category: Done / In Progress / To Do); `total` is derived as their sum
- Progress bar: 20 blocks, each block = 5%; `pct` is capped at 100

## Conventions

- Pure zsh — no bash-isms, no external scripts beyond `jira` CLI
- All functions and aliases are intentionally global (no namespacing needed for a sourced file)
- Private helpers are prefixed with `_` (currently only `_jql_search`)
- Emojis are used in `jstatus`, `jdoctor`, and `jhelp` output intentionally for terminal UX — keep them
- No error handling for `jira` failures other than `2>/dev/null` redirects; the CLI's own output is sufficient

## What NOT to do

- Do not split `scripts` into multiple files — the single-file design is intentional (one `source` line at install)
- Do not add a test suite — there is no test infrastructure and none is planned
- Do not add dependencies beyond `jira` CLI
- Do not hardcode project keys, board IDs, or sprint names — all queries use `openSprints()` and `currentUser()`
