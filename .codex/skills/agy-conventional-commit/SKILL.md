---
name: agy-conventional-commit
description: Use Google Antigravity CLI at `/opt/homebrew/bin/agy` to inspect a repository's pending changes and create one English Conventional Commit without pushing. Use when the user explicitly asks AGY or Antigravity to commit current changes, requests an AGY-generated Conventional Commit, or invokes this skill for a commit-only workflow.
---

# AGY Conventional Commit

Delegate the complete commit operation to the official Google Antigravity CLI. Keep Codex responsible for invoking the workflow and verifying its result. Never push as part of this skill.

## Run the workflow

1. Confirm that the request authorizes a commit. Invoking this skill explicitly is authorization to commit, but not to push.
2. Use the current repository unless the user names another one.
3. Summarize the intended change in a short scope hint from the user's request. Omit the hint when the scope is unclear.
4. Run:

   ```bash
   <skill-directory>/scripts/commit.sh \
     --repo <repository-path> \
     --intent "<scope hint>"
   ```

5. Verify the final repository state with read-only Git commands:

   ```bash
   git -C <repository-path> status --short --branch
   git -C <repository-path> log -1 --format='%H%n%s'
   git -C <repository-path> show --stat --oneline --summary HEAD
   ```

6. Report the verified commit hash, exact subject, branch, checks run, and any remaining uncommitted files.

## Guardrails

- Use `/opt/homebrew/bin/agy` directly. Do not substitute another executable or rely on `PATH`.
- Start AGY from the verified repository root with `cd`; do not pass the unsupported `--cwd` option.
- Never run `git push`, force push, fetch, pull, or any other remote-changing operation in this skill. A push requires a separate workflow and separate authorization.
- Do not install AGY, authenticate it, or weaken its permissions automatically.
- Do not use `--dangerously-skip-permissions`, amend, reset, stash, branch switching, or destructive cleanup.
- Preserve unrelated working-tree changes. If the intended commit cannot be separated safely, stop and ask the user for scope.
- Do not create an empty or duplicate commit when no intended changes remain.
- Do not claim success from AGY's prose alone. Verify the commit and working-tree state with Git.
- If AGY is unavailable, authentication is incomplete, the repository is in the middle of a merge/rebase/cherry-pick, suspected secrets may be included, or a required check fails, report the exact blocker. Do not fall back to a direct `git commit` outside AGY.

## Expected AGY behavior

The bundled script instructs AGY to:

- start from the repository root and read applicable instructions;
- inspect staged and unstaged changes before changing Git state;
- keep unrelated changes out of the commit;
- run repository-required checks and at least `git diff --check`;
- create one English Conventional Commit;
- avoid all remote operations, including push;
- verify and report the resulting local commit and working-tree state.
