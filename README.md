# Agent Skills

A personal collection of reusable **agent skills** (Markdown instruction packs) for
AI coding agents. Built for [OpenCode](https://opencode.ai) and portable to any
tools that read the [`SKILL.md` folder convention](https://agentskills.io)
(Claude Code, Amp, general "agent skills" harnesses).

A skill is just a folder containing a `SKILL.md` with frontmatter
(`name`, `description`) plus any supporting files (references, scripts, templates)
that live beside it. The agent sees the one-line `description` and loads the full
instructions when relevant — or when you ask for it.

## Repo layout

```text
skills/
├── code-review/
│   └── SKILL.md            # the instructions (frontmatter: name, description)
├── impeccable/
│   ├── SKILL.md
│   └── references/…        # supporting files ride along; paths inside
│   └── scripts/…           #   SKILL.md are relative to this folder
├── tdd/
└── …                       # 30 skills total — see the catalog below
```

The **skill ID is the folder name** (lowercase kebab-case, used when invoking).

## Quick start on a new machine

```bash
git clone git@github.com:kodix75/skills.git ~/agent-skills
```

### Recommended — OpenCode, zero copying

Point OpenCode's config at the clone; updates are then just a `git pull`:

```jsonc
// ~/.config/opencode/opencode.json
{
  "$schema": "https://opencode.ai/config.json",
  "skills": ["~/agent-skills/skills"]
}
```

Run `/reload` in OpenCode after pulling changes.

### Alternative — `install.sh` copy mode

```bash
./install.sh                 # → ~/.config/opencode/skills   (OpenCode global)
./install.sh agents          # → ~/.agents/skills            (also read by OpenCode, Claude Code, …)
./install.sh claude          # → ~/.claude/skills            (Claude Code)
./install.sh /path/to/repo/.opencode/skills   # project-scoped install
```

Copy mode never deletes anything; re-run after `git pull` to refresh.

## Where OpenCode looks for skills

| Scope                 | Location                                  |
| --------------------- | ----------------------------------------- |
| Global                | `~/.config/opencode/skills`               |
| Global compatibility  | `~/.claude/skills`, `~/.agents/skills`    |
| Project               | `.opencode/skills`                        |
| Project compatibility | `.claude/skills`, `.agents/skills`        |
| Extra sources         | `skills` array in any `opencode.json(c)`  |

A skill may also be a single flat file at a source root (`skills/name.md`);
this repo uses folders everywhere so supporting files stay portable.
If two sources define the same ID, the **last-registered source wins**
(explicit config entries beat all defaults).

## Trigger modes

- **Model-invoked** — the agent sees the description and loads the skill when the
  task matches (e.g. `tdd`, `code-review`, `impeccable`).
- **Manual** — frontmatter sets `disable-model-invocation: true`, so the agent is
  *not* offered it; you invoke it explicitly by mentioning `@<skill-id>` in your
  prompt (e.g. `@to-spec`, `@grill-me`). They behave like slash commands.

## Catalog

### Engineering workflow (manual, `@`-invoked)

| Skill | What it does |
| ----- | ------------ |
| `setup-matt-pocock-skills` | Per-repo setup for the workflow skills: issue tracker, triage labels, domain docs. Run once first. |
| `to-spec` | Turn the current conversation into a spec and publish it to the issue tracker. |
| `to-tickets` | Break a plan/spec into tracer-bullet tickets with blocking edges. |
| `to-questionnaire` | Turn an undecidable question into a questionnaire for someone else. |
| `triage` | Move issues/PRs through a triage state machine; writes agent-ready briefs. |
| `implement` | Implement a piece of work from a spec or tickets. |
| `implement-spec` | Implement a whole spec across parallel subagent worktrees, ticket graph-based. |
| `improve-codebase-architecture` | Scan for architectural "deepening" opportunities; picks one to grill through. |
| `wayfinder` | Plan work too large for one session as a shared map of decision tickets. |
| `retro` | Retrospective on a coding session. |
| `handoff` | Compact the conversation into a handoff doc for another agent. |
| `grill-me` / `grill-with-docs` | Relentless interview on a plan; docs variant also writes ADRs/glossary as you go. |
| `wait-what` | Agent re-pitches its last message to you more clearly. |
| `ask-matt` | Router: asks which of these skills fits your situation. |

### Quality & craft (model-invoked, auto)

| Skill | What it does |
| ----- | ------------ |
| `tdd` | Test-driven development, red-green-refactor. |
| `code-review` | Parallel standards+spec review since a fixed point. |
| `diagnosing-bugs` | Structured diagnosis loop for hard bugs / regressions. |
| `grilling` | Stress-test a plan or decision with sharp questions. |
| `pr` | Write a PR body. |
| `prototype` | Build a throwaway prototype to answer a design question. |
| `impeccable` | Design/polish frontend interfaces (large bundle: references, scripts). |
| `codebase-design` | Vocabulary for deep-module interface design. |
| `domain-modeling` | Build the project's domain model (glossary, ADRs). |
| `research` | Background investigation against primary sources → markdown report. |

### Meta & utilities

| Skill | What it does |
| ----- | ------------ |
| `find-skills` | Discover and install skills from external sources. |
| `task-observer` | Observes sessions and logs skill-improvement observations (ships with references/, scripts/, original repo packaging). |
| `wizard` | Generates interactive bash wizards for human-only steps. |
| `teach` | Teaches the user a concept inside the workspace (manual). |
| `writing-for-agents` | How to write skills/AGENTS.md/CLAUDE.md so agents follow them. |

## Adding a new skill

```bash
mkdir -p skills/my-new-skill
cat > skills/my-new-skill/SKILL.md <<'EOF'
---
name: my-new-skill
description: One clear sentence: what it does and WHEN to use it.
---

# My new skill

Instructions for the agent…
EOF
git commit -am "Add my-new-skill" && git push
```

- Keep IDs lowercase-kebab-case and equal to the folder name.
- Without a `description` the model never sees the skill.
- Add `disable-model-invocation: true` to make it manual (`@id`-invoked).
- Scripts/templates go beside `SKILL.md`; reference them with relative paths.

## Updating

```bash
cd ~/agent-skills && git pull
```

Config-array installs pick it up after `/reload`; copy installs: re-run `./install.sh <target>`.

## Credits & license

- Most engineering-workflow skills come from **Matt Pocock's** skills collection,
  configured per-repo via `setup-matt-pocock-skills`.
- `task-observer` is from
  [rebelytics/one-skill-to-rule-them-all](https://github.com/rebelytics/one-skill-to-rule-them-all)
  (Eoghan Henn & contributors, CC BY 4.0).
- The rest are from community bundles and personal additions — each skill folder
  keeps its original references; re-check licenses before making this repo public.

Currently a private, personal-use repository.

## Troubleshooting

- **Skill missing in the agent list** — check the folder name (that's the ID),
  that the file is exactly `SKILL.md`, and that the source directory is reachable
  from one of the locations above (or listed in `skills`).
- **Old version keeps loading** — a later-registered source defines the same ID;
  the explicit `skills` config entries override `~/.agents/skills` copies.
- **Model never picks it up** — needs a good `description`; or it's marked
  `disable-model-invocation: true` and must be invoked with `@skill-id`.
- After changing files, `/reload` in OpenCode config changes are watched, but new
  skill folders from a `git pull` are safest confirmed with `/reload`.
