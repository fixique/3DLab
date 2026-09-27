# Agent Workflow

This repository uses an agent-assisted development workflow.

## Source of truth

- The Git repository is the source of truth.
- Active tasks are stored in `.ai/tasks/active/<task-id>/task.yaml`.
- Completed tasks are stored in `.ai/tasks/done/<task-id>/task.yaml`.
- Workflow rules are stored in `.ai/workflow.yaml`.
- Do not rely on previous conversation history for project state.
- Always inspect the repository and the assigned task definition before doing work.

## Task scope

Agents must work only on the explicitly assigned task.

For a task with ID `TXXX`, read:

- `.ai/tasks/active/TXXX/task.yaml`
- `.ai/workflow.yaml`
- this `AGENTS.md`

Do not scan completed tasks unless the current task explicitly depends on prior work.

## Roles

### Planner

Responsibilities:

- Analyze the assigned task and relevant repository state.
- Do not modify repository files.
- Prefer evidence from source inspection, builds, tests, and runtime behavior over speculation.
- Produce the smallest implementation plan that satisfies the task goal and acceptance criteria.
- Identify relevant validation steps.
- Avoid unrelated modernization and refactoring.

The planner should not implement the task.

### Implementer

Responsibilities:

- Work only on the assigned task.
- Follow the task goal, acceptance criteria, and approved plan.
- Make the smallest necessary changes.
- Avoid unrelated refactoring or modernization.
- Run relevant builds and tests.
- Validate runtime behavior when required by the task.
- Do not commit changes unless explicitly requested.

If implementation reveals that the approved plan is incorrect or incomplete, stop and report the issue instead of silently expanding the task scope.

### Reviewer

Responsibilities:

- Do not modify repository files.
- Review the complete diff for the assigned task.
- Verify that all changes are necessary and within scope.
- Validate the task acceptance criteria.
- Run relevant builds, tests, or runtime checks when useful.
- Report actionable findings ordered by severity.
- Do not suggest optional cleanup, modernization, or refactoring unless required for correctness.

If there are no actionable findings, return exactly:

APPROVED

## Git isolation

Implementation work must happen in an isolated Git worktree.

The primary developer checkout must not be modified by implementation agents.

Planner and reviewer roles may inspect the primary checkout in read-only mode.

## Workflow

Task states:

planned -> implementing -> review -> approved -> done

If review finds actionable issues:

review -> implementing

The task state must reflect the actual workflow stage.

## Validation

Validation should be derived from the task acceptance criteria.

Prefer concrete evidence such as:

- successful builds
- successful tests
- runtime verification
- simulator or device launch
- absence of relevant warnings or errors

Do not treat reasoning alone as validation when the repository provides a way to verify the behavior.

## Scope discipline

Agents must not:

- perform unrelated refactoring
- modernize APIs unless required by the task
- change project architecture without explicit task scope
- modify unrelated files
- expand the task based only on optional warnings or style preferences

When uncertain whether a change is in scope, report it instead of applying it.
