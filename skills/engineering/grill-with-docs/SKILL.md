---
name: grill-with-docs
description: A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go.
disable-model-invocation: true
---

Run a `/grilling` session, using the `/domain-modeling` skill.

## When the grilling converges → write the plan with flow diagrams

When the grilling converges, write the plan to `plan.md` (or the project's `.scratch/<feature>/PLAN.md` convention). The plan MUST embed two Mermaid flowcharts so it is directly viewable without a follow-up request:

- **预期流程图 (Expected flow)** — drawn now from the agreed design. Cover the main journey plus the branches / decision points resolved during the grilling. Use the canonical terms from `CONTEXT.md` for node labels so the diagram and glossary stay in sync.
- **实际流程图 (Actual flow)** — a clearly-marked placeholder section, filled in *after implementation completes* with what was actually built. When you reach that point: draw it from the real code, call out any divergence from the expected flow, and if a divergence changed a documented decision, reconcile `CONTEXT.md` / the relevant ADR.
