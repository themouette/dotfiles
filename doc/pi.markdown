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
- `/review-pr <PR-number-or-URL>` — review a coworker's PR with the
  code-review-reporter agent (fetches read-only, never touches the working
  tree; posts a PR comment only after explicit approval).

## Agents

Subagents in `pi/agents/`:

- `plan-reviewer` — reviews a plan for security issues, inconsistencies, blind
  spots, missing tests, and refactoring opportunities.
- `plan-splitter` — decomposes a large plan into small, safe, human-reviewable
  PRs. Loads per-repo steering from local-only context files in
  `~/.pi/agent/plan-splitter-contexts/*.md`.
- `code-review-reporter` — post-change review report (test gaps, security,
  structure, dead code). Report only, never implements. For changesets whose
  deliverable is substantially behavior-pinning tests, it refers the exhaustive
  counterfactual analysis to `test-strength-reviewer` instead of doing it
  itself.
- `test-strength-reviewer` — counterfactual (mutation-style) review of
  behavior-pinning test suites (regression nets, contract pins,
  characterization suites). For each claimed contract, constructs the regression
  that keeps every assertion green and reports the holes. Report only, never
  implements, never posts.

Agents are generic and inherit the session default model. Project-specific
conventions come from the repo's `AGENTS.md` (via context inheritance) and the
local context files — never baked into the published agents.
