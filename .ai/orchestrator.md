# Orchestrator Contract

The orchestrator owns the task lifecycle.

Agents perform role-specific work.
The orchestrator coordinates agents, Git state, task artifacts, and workflow transitions.

## Responsibilities

The orchestrator is responsible for:

- creating tasks
- assigning task IDs
- updating task status
- invoking Planner, Implementer, and Reviewer roles
- persisting Planner and Reviewer outputs
- committing workflow artifacts
- creating and removing Git worktrees
- creating task branches
- ensuring implementation happens in isolation
- moving tasks between `active` and `done`
- merging or cherry-picking approved changes
- cleaning up task branches and worktrees

Agents must not perform these lifecycle operations unless explicitly instructed.

## Task lifecycle

### 1. Create task

Create:

`.ai/tasks/active/<task-id>/task.yaml`

Initial state:

`planned`

The task definition must contain at least:

- id
- title
- status
- goal
- acceptance criteria

Commit the task definition before planning begins.

### 2. Planning

Run the Planner against the primary repository checkout in read-only mode.

The Planner reads:

- `AGENTS.md`
- `.ai/workflow.yaml`
- `.ai/tasks/active/<task-id>/task.yaml`

The Planner must not modify repository files.

Persist the normalized Planner result as:

`.ai/tasks/active/<task-id>/plan.md`

Commit `plan.md` before creating the implementation worktree.

### 3. Start implementation

Update task status:

`planned -> implementing`

Commit the status transition.

Create an isolated task branch and worktree from the current primary branch state.

Recommended branch:

`agent/<task-id>`

Recommended worktree:

`~/Developer/AgentWorktrees/<repository>/<task-id>`

The implementation worktree must therefore contain:

- the task definition
- the approved plan
- the workflow rules
- all commits made before implementation started

### 4. Implementation

Run the Implementer inside the task worktree.

The Implementer reads:

- `AGENTS.md`
- `.ai/workflow.yaml`
- `.ai/tasks/active/<task-id>/task.yaml`
- `.ai/tasks/active/<task-id>/plan.md`

The Implementer:

- modifies only task-related project files
- performs proportionate validation
- does not commit
- does not change task lifecycle state

### 5. Review

Update task status:

`implementing -> review`

The Reviewer runs against the same task worktree.

The Reviewer:

- must not modify files
- reviews the complete uncommitted diff
- validates acceptance criteria
- performs proportionate validation

If actionable findings exist:

`review -> implementing`

The Implementer receives the findings and fixes the same worktree.

Then review runs again.

### 6. Approval

If the Reviewer returns:

`APPROVED`

the orchestrator transitions:

`review -> approved`

Persist the Reviewer result as:

`.ai/tasks/active/<task-id>/review.md`

### 7. Integrate

After approval:

1. Commit the implementation in the task branch.
2. Integrate the approved commit into the primary branch.
3. Prefer an explicit commit SHA when cherry-picking.
4. Record the resulting primary-branch commit in `task.yaml`.

The primary checkout must be clean before integration.

### 8. Complete task

Update:

`approved -> done`

Add task result metadata, including:

- review result
- resulting commit

Move:

`.ai/tasks/active/<task-id>`

to:

`.ai/tasks/done/<task-id>`

Commit the completed task metadata.

### 9. Cleanup

After successful integration and task completion:

- remove the task worktree
- delete the task branch

A task branch may require force deletion after cherry-pick because Git does not consider cherry-picked commits merged by ancestry.

## Artifact ownership

`task.yaml`
- owned by the orchestrator
- task intent, acceptance criteria, lifecycle state, final result

`plan.md`
- produced by Planner
- persisted by orchestrator

`review.md`
- produced by Reviewer
- persisted by orchestrator

Application source changes
- produced by Implementer

## Commit boundaries

Prefer separate commits for workflow state and implementation where practical.

Typical sequence:

1. Create task
2. Add implementation plan
3. Start implementation
4. Approved implementation commit
5. Complete task

Exact commit structure may evolve, but task artifacts must be committed before creating an implementation worktree that depends on them.
