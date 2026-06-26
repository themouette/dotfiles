---
description: Orchestrate the full development workflow for a plan file — explore context, manage state, review the plan, assess PR scope, implement, and address code review findings.
---

# /dev — Development Workflow

Plan file: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user to provide a plan file path before doing anything else.

---

## Step 1 — Explore context

Use the **Explore** subagent to scan the directory containing the plan file, and its parent directories up to 2 levels up. Collect:

- **Main plan**: a `.md` file whose name (case-insensitive, without extension) is exactly `plan`, `main-plan`, or `main plan`, or starts with `main`. Examples: `PLAN.md`, `main-plan.md`, `Main Plan.md`.
- **Subplans**: `.md` files whose name starts with a digit (e.g. `1-`, `2-`) or contains `pr1-`, `pr2-`, `pr3-`, etc. The provided plan file itself may be one of these.
- **Research files**: any other `.md` files in the same directory that are not STATE.md, not the main plan, and not a subplan.
- **State file**: a file named exactly `STATE.md` located either next to the main plan or next to the provided plan file.

Report all found files with their full paths before continuing.

---

## Step 2 — State file

Determine the correct location for `STATE.md`:
- If a main plan was found: `STATE.md` lives in the same directory as the main plan.
- Otherwise: `STATE.md` lives in the same directory as the provided plan file.

**If STATE.md does not exist**, create it with the following content, listing all discovered subplans (one row each):

All paths in STATE.md are relative to the directory where STATE.md lives. For files in the same directory, use bare filenames (e.g. `PLAN.md`, `1-feature.md`). For files in subdirectories, use a relative path from STATE.md's location (e.g. `sub/1-feature.md`).

```markdown
# State

Main plan: [PLAN.md](PLAN.md)

| Subplan | Status | PR | PR Status | Notes |
|---------|--------|----|-----------|-------|
| [1-feature.md](1-feature.md) | Draft | — | — | |

## 1-feature.md

- [ ] Plan reviewed
- [ ] PR scope assessed
- [ ] Implemented
- [ ] Code reviewed
- [ ] Findings addressed
- [ ] PR created
```

Valid Status values: `Draft`, `In Review`, `Plan Reviewed`, `Assessed`, `Split`, `In Progress`, `Done`, `Blocked`

If no main plan was found, omit the "Main plan:" line.

**If STATE.md already exists**, read it silently to understand the current project state. Do not display its contents to the user unprompted.

---

## Step 3 — Plan review

**Check STATE.md first**: if the current plan's row in STATE.md has status `Plan Reviewed`, `In Progress`, `Done`, or `Blocked`, skip Steps 3 and 4 entirely. Tell the user the plan is already marked as reviewed and ask if they want to force a re-review before continuing.

Use the **plan-reviewer** subagent to review the plan at `$ARGUMENTS`.

In the prompt to plan-reviewer, include:
- The full path and content of the plan to review (`$ARGUMENTS`)
- The full path and content of the main plan (if found and different from `$ARGUMENTS`)
- The full path and content of `STATE.md`
- The full paths and content of any research files found

Ask plan-reviewer to take into account how this plan fits within the broader context (main plan, sibling subplans listed in STATE.md) when assessing completeness and consistency.

---

## Step 4 — Confirm and update plan

After receiving the plan-reviewer findings:

1. Analyze the findings and present a concise summary to the user:
   - Top issues grouped by severity
   - Whether the plan is ready to implement as-is or needs changes
   - Which issues, if any, could be addressed by updating the plan vs. require user decision

2. Ask the user: **"Do you want me to call the Plan agent to update the plan based on these findings?"**

   - **If yes**: Use the **Plan** subagent to produce an updated version of the plan at `$ARGUMENTS`. Provide it with:
     - The original plan content
     - The plan-reviewer findings
     - The main plan content (if any) as context
     - Instruction: address the identified issues while preserving the plan's existing structure and intent; do not add scope beyond what the findings require.
     After the Plan agent responds, show the user what changed and write the updated plan to disk.

   - **If no**: Stop here. Summarize the key findings for the user's reference.

3. **In both cases**, once the user has responded, update the plan's row in STATE.md to status `Plan Reviewed`
   and check the `Plan reviewed` checkbox in the plan's section.

4. **If the plan was updated** (user chose yes above), check whether sibling plans need to be updated as a result. Spawn one **general-purpose** subagent per sibling plan **in parallel** (do not wait for one to finish before starting the next). Each subagent receives:
   - The full content of the updated plan
   - The full content of the sibling plan
   - Task: identify whether the sibling plan is affected by the changes (e.g. changed interfaces, shifted scope, new dependencies, removed steps) and if so, list the specific sections or assumptions that need updating and why.

   Collect all responses, then present a consolidated summary to the user:
   - Which sibling plans need changes and why
   - Which are unaffected

   Only consider sibling plans whose status in STATE.md is `Draft`, `In Review`, `Plan Reviewed`, or `Assessed` — skip any sibling already at `In Progress`, `Done`, or `Blocked`, as those are past the point where a plan update is safe.

   If any sibling plans need updating, ask the user: **"Do you want me to update the affected sibling plans now?"** If yes, apply updates one plan at a time (using the **Plan** subagent for each), following the same confirmation pattern as Step 4.

---

## Step 5 — PR size assessment

**Check STATE.md first**: if the current plan's row in STATE.md has status `Assessed`, `Split`, `In Progress`, `Done`, or `Blocked`, skip this step. Tell the user the plan has already been assessed and ask if they want to force a re-assessment before continuing.

Use the **plan-splitter** subagent to assess whether the plan at `$ARGUMENTS` can be implemented in a single PR or should be split into smaller ones. In a **single call**, provide it with:
- The full path and content of the plan to assess (`$ARGUMENTS`)
- The full path and content of the main plan (if found and different from `$ARGUMENTS`)
- The full path and content of `STATE.md`
- The full paths and content of any research files found

Expect a complete assessment back in that single call — do not prompt plan-splitter for follow-up output.

- **If a single PR is sufficient**: update STATE.md status to `Assessed`, check the `PR scope assessed` checkbox in the plan's section, then proceed to Step 6.
- **If splitting is recommended**: present the proposed split to the user — show each proposed PR with its scope and rationale. Ask: **"The plan-splitter recommends splitting this into N PRs. Do you want to split it before implementing, or proceed as a single PR?"**
  - If the user chooses to split: create the subplan files as proposed — each file must begin with the `branch:` and `base:` frontmatter from the phase's File block. Add them to STATE.md (each with its own step-tracking section). Update the original plan's status to `Split` and check its `PR scope assessed` checkbox. Then stop. The user should run `/dev` on each subplan individually.
  - If the user chooses to proceed as a single PR: update STATE.md status to `Assessed`, check the `PR scope assessed` checkbox in the plan's section, then continue to Step 6.

---

## Step 6 — Implementation

Update STATE.md: set the plan's status to `In Progress`.

Use the **claude** subagent to implement the plan at `$ARGUMENTS`. In the prompt, include:
- The full plan content
- Instruction to follow the plan step by step and commit logical units of work as they are completed
- Instruction to **not** create a PR — commits only
- Instruction to run the project's linter and formatter (if any) after all commits and fix any violations before finishing

After the subagent completes, check the `Implemented` checkbox in the plan's section.

---

## Step 7 — Code review

Use the **code-review-reporter** subagent on the current branch to review all changes made during implementation.

After the subagent completes, check the `Code reviewed` checkbox in the plan's section.

---

## Step 8 — Address findings

Analyze the code-review-reporter report. Categorize each finding:

- **Clear, actionable issues** (bugs, security vulnerabilities, obvious quality problems): implement the fix directly without asking. Each fix must be its own atomic commit — do not bundle multiple findings into a single commit.
- **Ambiguous findings or decisions required** (design trade-offs, scope questions, unclear intent): collect these and present them to the user in a single batch. Wait for the user's input before acting on any of them. Apply each resulting fix as its own atomic commit as well.
- **Out-of-scope work or refactoring opportunities** (improvements that don't strictly belong in this PR and would make the review harder — e.g. pre-existing tech debt in touched areas, structural refactors, tangential cleanups): collect these separately. Present them to the user and ask: **"These items are out of scope for this PR. Do you want to create a follow-up subplan for them?"**

  If yes, create an intermediary plan file placed after the current plan in the sequence (e.g. if the current plan is `2-feature.md` and the next is `3-other.md`, create `2b-refactor.md`). The file should describe the deferred work clearly. Then:
  - Add the new subplan to STATE.md (inserted between the current plan and the next one)
  - Delegate the following updates **in parallel** using the subagent mechanism already defined in Step 4 item 4:
    - Update the main plan to reference the new subplan
    - Update the next plan in sequence to note that the new subplan is a prerequisite or predecessor

After addressing all findings, run the project's linter and formatter again if any files were modified, and fix any new violations before continuing.

Report:
- What was fixed automatically
- What was left for the user (if anything)
- Whether any fixes need a follow-up review pass

Update STATE.md: check the `Findings addressed` checkbox in the plan's section.

---

## Step 9 — Create draft PR

Once all findings from Step 8 are resolved, create a **draft** PR for the branch using `gh pr create --draft`.

The PR description must include a **"Related PRs"** section listing all sibling PRs in the group (i.e., other subplans from STATE.md that already have a PR URL). For each sibling, use the GitHub shorthand `#PRNUMBER` (extracted from the PR URL) and a one-line description of its scope. If no sibling PRs exist yet, omit the section.

Example:
```
## Related PRs
- #42 — Add database schema migrations
- #43 — Implement API endpoints
```

Then update STATE.md:
- Set the PR column to the PR URL
- Set PR Status to `Draft`
- Check the `PR created` checkbox in the plan's section

Finally, update the descriptions of all sibling PRs in STATE.md whose PR Status is `Draft` or `Ready for Review` to add or refresh their own "Related PRs" section to include this newly created PR, using `#PRNUMBER` shorthand for all PR references.

---

## Rules

- Complete each step fully before starting the next.
- Never skip Step 1 — the context it provides is required by all subsequent steps.
- If the plan file at `$ARGUMENTS` does not exist, stop and tell the user immediately.
- Do not modify the plan file (Step 4) without explicit user confirmation.
- Do not start implementation (Step 6) if the plan status in STATE.md is not `Plan Reviewed` — remind the user to complete the review loop first, or force-skip only if they explicitly ask.
- **Context check**: after Step 5 completes, estimate how much of the context window has been consumed. If it is above 50%, do not proceed — instead, tell the user:

  > Context is above 50% used. To avoid the workflow stalling mid-run, I recommend clearing context and resuming from this step.
  > Run: `/dev $ARGUMENTS`
  > STATE.md is up to date, so the workflow will resume from the correct point.

  Then ask: **"Clear context and resume, or continue anyway?"** Only proceed if the user chooses to continue.
