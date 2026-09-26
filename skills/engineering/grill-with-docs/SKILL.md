---
name: grill-with-docs
description: A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go.
disable-model-invocation: true
---

Call the Skill tool twice, for "grilling" and "domain-modeling".

## When the grilling converges, write the plan with flow diagrams

When the grilling converges, write the plan to `plan.md` (or the project's `.scratch/<feature>/PLAN.md` convention). The plan MUST embed two Mermaid flowcharts so it is directly viewable without a follow-up request:

- **预期流程图 (Expected flow)**: drawn now from the agreed design. Cover the main journey plus the branches / decision points resolved during the grilling. Use the canonical terms from `CONTEXT.md` for node labels so the diagram and glossary stay in sync.
- **实际流程图 (Actual flow)**: a clearly-marked placeholder section, filled in *after implementation completes* with what was actually built. When you reach that point: draw it from the real code, call out any divergence from the expected flow, and if a divergence changed a documented decision, reconcile `CONTEXT.md` / the relevant ADR.

## The plan MUST also carry an API change summary

Alongside the two flowcharts, embed an **API 变化小结** section with the same plan-vs-actual pairing:

- **计划变更 (Planned)**: written now, from the agreed design.
- **实际变更 (Actual)**: a marked placeholder, filled in *after implementation completes* from the real code; call out any divergence from the planned list.

One line per endpoint, `METHOD /path` followed by a one-sentence field delta. Examples:

- `GET /api/v3/archives` — 每个列表项新增三个可选字段：`is_self_created`、`source_display_name`、`has_purchasable_report`
- `GET /api/v3/hepan/invitations` — 新增可选 query 参数 `status`；响应结构不变

Keep it to the field / parameter delta and the response-shape delta. For a **brand-new or deleted endpoint**, name the endpoint and what it does — do not enumerate its fields. This section is the contract-facing diff a client developer reads before touching their models, so it must be complete: every endpoint the change touches appears, even when the delta is "response shape unchanged".
