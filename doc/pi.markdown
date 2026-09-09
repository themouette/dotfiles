Pi
===

Configuration for [pi](https://pi.dev), the coding agent.

Run `./install pi-dev` to link the configuration into `~/.pi/agent/`:

- `pi/settings.json` → `~/.pi/agent/settings.json`
- `pi/mcp.json` → `~/.pi/agent/mcp.json`
- `pi/prompts/` → `~/.pi/agent/prompts/` (slash commands)
- `pi/agents/` → `~/.pi/agent/agents/` (subagents)
- `pi/session-cost.json` → `~/.pi/agent/session-cost.json` (only when `DATADOG_ROOT` is set)

Note: `models.json` and `extensions/` are machine-local and intentionally not
synced or published.

## Commands

Prompt templates in `pi/prompts/` become slash commands:

- `/dev <plan-file>` — full development workflow: explore context, track state
  in `STATE.md`, plan review, PR size assessment, implementation, code review,
  findings, draft PR.
- `/brief <brief-file>` — turn a brief into `main.md` plus `subplan/` files
  ready for `/dev`.

## Agents

Subagents in `pi/agents/`:

- `plan-reviewer` — reviews a plan for security issues, inconsistencies, blind
  spots, missing tests, and refactoring opportunities.
- `plan-splitter` — decomposes a large plan into small, safe, human-reviewable
  PRs. Loads per-repo steering from local-only context files in
  `~/.pi/agent/plan-splitter-contexts/*.md`.
- `code-review-reporter` — post-change review report (test gaps, security,
  structure, dead code). Report only, never implements.

Agents are generic and inherit the session default model. Project-specific
conventions come from the repo's `AGENTS.md` (via context inheritance) and the
local context files — never baked into the published agents.
