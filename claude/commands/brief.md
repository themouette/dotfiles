---
description: Turn a brief file into a main.md plan and subplans ready for /dev.
---

# /brief — From Brief to Plan

Brief file: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user for a brief file path before doing anything else.
If the brief file does not exist, stop and tell the user immediately.

---

## Step 1 — Read and analyse the brief

Read the brief file at `$ARGUMENTS`.

Identify:
- **Core goal**: what the feature or change is trying to achieve
- **Assumptions**: things not stated explicitly but implied by the brief
- **Open questions**: ambiguities, missing constraints, or decisions the user must make

---

## Step 2 — Draft `main.md`

Use a **Plan** subagent to produce a first draft of `main.md` in the same directory as the brief file.

`main.md` is a high-level plan — not implementation steps. It must include:

- **Goal**: one paragraph describing what is being built and why
- **Scope**: what is in scope
- **Out of scope**: what is explicitly excluded (even if implied)
- **Risks**: known risks or constraints
- **Assumptions**: things assumed true that aren't stated in the brief
- **Open questions**: anything the user must answer before implementation begins — use `> ❓` blockquotes as placeholders
- **High-level phases**: a rough outline of how the work breaks down (not PR-level — just logical groupings)

---

## Step 3 — Ask clarifying questions

If `main.md` contains open questions, present them all to the user **in one batch**. Wait for their answers.

Once the user responds, use a **Plan** subagent to update `main.md`:
- Fill in the answers
- Remove resolved `> ❓` placeholders
- Adjust scope, risks, or phases if the answers change them

If there are no open questions, skip this step.

---

## Step 4 — Run plan-splitter

Use the **plan-splitter** subagent to assess `main.md`. Provide:
- The full path and content of `main.md`

Trust plan-splitter's verdict entirely:

- **Single PR**: do not create a `subplan/` folder. Tell the user:
  > `main.md` fits in a single PR. Run `/dev main.md` to continue.

  Then stop.

- **Split into N PRs**: proceed to Step 5.

---

## Step 5 — Create subplans

Create a `subplan/` directory next to `main.md`.

For each phase from the plan-splitter output, create a file `subplan/N-short-title.md` (e.g. `subplan/1-api-types.md`). Each file must:

1. Begin with the File block frontmatter from the phase output:
   ```yaml
   ---
   branch: <branch name from plan-splitter>
   base: <base branch from plan-splitter>
   ---
   ```
2. Contain the full phase detail: PR title, PR description, expected commits, files changed, and tests.

---

## Step 6 — Hand off to /dev

Tell the user:
> Subplans are ready in `subplan/`. Run `/dev subplan/1-<title>.md` to start implementing.

List all created subplan files with their branch names.

---

## Rules

- Do not create `STATE.md` — `/dev` handles that.
- Do not begin implementation — stop after creating files.
- Do not split what plan-splitter says fits in a single PR.
- Always place `main.md` in the same directory as the brief file.
- Always place subplans under `subplan/` relative to `main.md`.
