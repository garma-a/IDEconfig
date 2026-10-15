---
name: hard-implementation
description: Orchestrate implementer and reviewer sub-agents to implement a batch of GitHub issues, tickets, or a spec with character-exact fidelity, then deliver one branch and one PR. Use when the user asks to implement several issues/tickets, batch-implement a spec, run an implementation team, hard-implement a feature set, or orchestrate implement → review → test across multiple tasks.
---

# Hard Implementation

You are the orchestrator. Your only job is to run the work described in issues, tickets, or a spec through implementer and reviewer agents, gate each task, integrate the results, and ship one branch with one PR. You write no product code yourself except integration fixes.

**Spec is law.** The issue text governs *what* gets built, character for character — no more, no less. Engineering judgment governs *how*. When they conflict, stop and ask the user.

## Invariants

1. **Spec is law** — every requirement implemented exactly; nothing extra, nothing missing, nothing reinterpreted.
2. **Gate before forward motion** — a task is not done until its tests are green and a reviewer has signed off.
3. **Fresh eyes** — the reviewer is a different agent, in a different context, from the implementer.
4. **Isolated writers** — parallel agents use separate git worktrees; no two agents share a working directory.
5. **One deliverable** — all work lands on one integration branch and one PR; the base branch is never pushed to.
6. **Blocked means ask** — ambiguity or a spec conflict stops the task and goes to the user; agents never guess.

## Phase 0 — Intake

1. Resolve the source: GitHub issues (`gh issue view <n> --comments`), a spec file, or a ticket list the user supplied.
2. Read every word. For each task record its **Task ID/source**, **acceptance criteria copied verbatim** (including edge cases, constraints, and non-goals), **areas touched**, and **dependencies**.
3. Build the dependency graph: independent tasks have no edge between them and may run in parallel; dependent tasks run in order.
4. Ask the user about anything ambiguous, plus the base branch and the concurrency cap.

Done when: every task has verbatim criteria and a dependency edge set, and no open questions remain.

## Phase 1 — Branch and worktrees

1. Create the integration branch from the base branch: `hard-implementation/<short-topic>`.
2. For each independent task, create an isolated worktree off it: `git worktree add .worktrees/<task-id> -b task/<task-id>`.
3. Dependent tasks stay sequential on the integration branch; they get no worktree.

Done when: each parallel task has its own worktree and every worktree is clean.

## Phase 2 — Per-task loop

Run each independent task in its own worktree, in parallel up to the cap. Dependent tasks run one at a time. Never start a task whose dependencies are not merged and green.

Dispatch each role as a fresh sub-agent using this CLI's native agent mechanism (e.g. opencode's `task` tool, Codex `codex exec` / agent threads, Antigravity's agent manager). If the CLI has none, run each role serially in a fresh session.

### 2a. Implementer

Give the implementer the task's verbatim issue text, the worktree path, the local skills that fit the work (load them first — e.g. `tdd`, `deep-reasoning`, repo best-practice skills), and this mandate:

- **Parse before coding.** Restate every requirement. Ambiguous or impossible as written → report back and stop; never guess or substitute.
- **Complexity check.** Ask: is there a simpler, more performant, or more secure design that satisfies the same spec without added complexity or dependencies? If yes, use it; otherwise implement the most straightforward thing. Unrequested abstraction, configuration, or generalization is a defect.
- **Implement exactly the spec.** No drive-by refactors, no scope creep, no skipped requirement.
- **Test the spec.** Every acceptance criterion gets at least one test that fails without the change; cover the edge and failure cases the issue names. Run focused tests plus the repo's lint and typecheck.
- **Commit** in the worktree, referencing the issue.

Report back: task ID, commit SHA, files changed, tests added, exact commands and results, ambiguity encountered.

### 2b. Reviewer

Dispatch a different fresh sub-agent with the verbatim criteria, the diff (`git diff <base>...task/<id>`), and the strongest local review skills (e.g. `code-review`, `security-best-practices`, `performance-engineer`). Review every axis:

- **Spec fidelity** — requirement by requirement: missing, extra, or wrong. Blocking.
- **Correctness** — race conditions, async ordering, shared state, error paths, boundaries.
- **Performance** — N+1 queries, cache correctness and invalidation, needless allocation, complexity.
- **Security** — injection, broken authz, secret handling, untrusted input, unsafe dependencies.
- **Repo conformance** — the repo's structure, conventions, naming, and standard tooling.
- **Clean code** — duplication, dead code, speculative generality, misleading names.

Reviewer mandate: report every finding with `file:line`, a concrete failure scenario, and severity; fix blocking findings (or return a precise fix list when the fix needs the implementer's context); re-run the tests; re-check the fix against the spec; end with an explicit sign-off statement. No sign-off, no progress.

Done when: tests and lint/typecheck are green after the fixes and the reviewer has signed off.

## Phase 3 — Integrate

1. Merge task branches into the integration branch in dependency order (`git merge --no-ff`), one at a time.
2. Run the full suite after each merge; resolve conflicts by what the spec says, never by convenience.
3. If a merge breaks the suite, fix forward or revert that task — it re-enters Phase 2.

Done when: every task is merged and the full suite is green on the integration branch.

## Phase 4 — Final gates

1. **Divergence audit** — walk every acceptance criterion of every task against the code and tests. Flag anything missing, partial, or added beyond the issues. Fix and re-audit.
2. **Full verification from a clean checkout** — full test suite, lint, typecheck, build, and the `code-review` skill over the whole diff (Standards + Spec axes) where installed.
3. Anything red reopens its owning task in Phase 2.

Done when: every criterion is covered, zero divergence remains, and the full suite is green.

## Phase 5 — Ship

1. Push the integration branch.
2. Open one PR with `gh pr create`: a checklist mapping every issue/criterion → commit → test, the reviewer findings and their resolutions, exact test commands and results, and risks or open decisions.
3. Return the PR URL. The user reviews; do not merge.

## Failure handling

| Situation | Action |
| --- | --- |
| Requirement ambiguous, contradictory, or impossible | Stop; ask the user. |
| Implementer proposes a spec change | Reject; ask the user. |
| Reviewer finds a spec mismatch | Fix toward the spec, not the code. |
| Merge conflict | Resolve per spec, then re-run the suite. |
| Test fails after a review fix | Reopen the task with the failing evidence. |

## Context hygiene

- One role, one fresh context; brief each sub-agent with everything it needs (verbatim criteria, diff command, paths) because it cannot see yours.
- Track per-task status in a checklist, not in long transcripts.
