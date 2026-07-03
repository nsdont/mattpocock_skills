---
name: grill-me
description: A relentless interview to sharpen a plan or design.
disable-model-invocation: true
---

Run a `/grilling` session.

## When the grilling converges → write the plan with flow diagrams

When we reach shared understanding and you write the plan (`plan.md`, or the project's `.scratch/<feature>/PLAN.md` convention if it has one), the plan MUST embed two Mermaid flowcharts so it's directly viewable — don't make me ask for a diagram separately afterward:

- **预期流程图 (Expected flow)** — draw it now from the agreed design. Cover the main journey plus the branches / decision points the grilling resolved. Embed the Mermaid block inline in the plan.
- **实际流程图 (Actual flow)** — leave a clearly-marked placeholder section, to be filled in *after implementation completes* with what was actually built. When you reach that point, draw it and call out any divergence from the expected flow.
