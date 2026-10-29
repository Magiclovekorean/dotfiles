---
description: Group changes into semantic commits and push
---

Group all current changes into meaningful semantic commits and push the current branch.

Optional context for commit messages: `$ARGUMENTS`

Rules:

- First inspect the full repository state:
  - `git status --short`
  - `git diff --stat`
  - `git diff`
  - `git log --oneline -10`
- Identify related file groups by intent: feature, fix, refactor, tests, docs, chore, release, or config.
- Create multiple commits when there are independent changes. Do not mix unrelated changes in the same commit.
- If `$ARGUMENTS` is not empty, use it as context to adjust commit messages, but do not force that text if it does not accurately describe the changes.
- Use clear, semantic, concise commit messages that follow the repo's recent style.
- Before committing, check for sensitive or suspicious files (`.env`, tokens, credentials, keys, secrets). If any appear, stop and ask.
- Include new, modified, and deleted files that belong to each group.
- Do not revert existing changes.
- Do not use `--no-verify`.
- Do not amend commits.
- Do not force push.
- If a commit closes a GitHub issue, end the commit body with `Closes #<number>`. Pushing then auto-closes the issue on GitHub.

Flow:

1. Show the proposed commit plan with the files included in each commit.
2. If the grouping is clear, continue. If there is real ambiguity, ask before committing.
3. Before committing, ask the user whether any of the planned commits should close an issue:
   - If the user wants one, ask (or accept from `$ARGUMENTS`) the issue number(s).
   - Check `gh issue list` / `gh issue view <n>` if needed to confirm the issue is open and matches the change.
4. For each group:
   - Add only the files for that group with `git add <files>`.
   - Create the commit with a semantic message; when it closes an issue, append `Closes #<number>` as the last line of the commit body.
5. Once all commits have been created, run:
   `git push`
6. When finished, summarize the commits created and the branch that was pushed, and note any issues auto-closed.
