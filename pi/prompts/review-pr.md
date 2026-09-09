---
description: Review a coworker's PR with the code-review-reporter agent
argument-hint: "<PR-number-or-URL>"
---

# /review-pr — Review a coworker's PR

PR: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user for a PR number or URL before doing anything else.

---

## Step 1 — Resolve the PR

Run:

```bash
gh pr view $ARGUMENTS --json number,title,body,baseRefName,headRefName,author,additions,deletions,changedFiles
```

Collect the PR number, title, description, base and head refs, author, and size.

If the command fails (not in a git repo, no `gh` authentication, unknown PR), stop and tell the user immediately.

---

## Step 2 — Fetch the PR read-only

Fetch the PR head into a local ref **without touching the working tree or switching branches**:

```bash
git fetch origin pull/<N>/head:refs/remotes/pr/<N>
```

where `<N>` is the PR number from Step 1. Do NOT checkout the PR branch.

If the fetch fails, stop and tell the user.

---

## Step 3 — Delegate to code-review-reporter

Launch the **code-review-reporter** subagent. In the prompt, include:

- The PR title, description, author, and size (additions/deletions/changed files)
- The repo cwd (the current repository)
- The diff command to scope the review:
  ```bash
  git diff <baseRefName>...refs/remotes/pr/<N>
  ```
- Instruction to review **only this PR's changes** — use the diff command above instead of `git diff HEAD~1`, and read surrounding code as needed for context
- Instruction to produce its standard structured report (untested code paths, security vulnerabilities, code structure improvements, unused code, actionable conclusions)

Expect the full report back in a single call.

---

## Step 4 — Present and optionally post

Present the report to the user with a concise summary of the key findings.

Then ask: **"Do you want me to post this report as a comment on the PR?"**

- **If yes**: draft the comment in Markdown (full report, friendly framing), show it to the user for approval, then post it with:
  ```bash
  gh pr comment <N> --body-file <draft-file>
  ```
- **If no**: stop. The report stays in the conversation.

Never post to GitHub without showing the user the exact comment and getting explicit approval.

---

## Rules

- Report-only until the user explicitly approves posting — the review never mutates the PR, the branch, or the working tree.
- Do not checkout the PR branch; work from the fetched `refs/remotes/pr/<N>` ref.
- After the report is delivered (and any comment posted or declined), clean up the fetched ref unless the user asks to keep it:
  ```bash
  git update-ref -d refs/remotes/pr/<N>
  ```
- If the PR is enormous (hundreds of changed files), tell the user before launching the review and ask whether to proceed or scope it to a subset of files.
