---
name: to-spec
description: "Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of what you've already discussed."
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec. Do NOT interview the user; just synthesize what you already know.

The issue tracker and triage label vocabulary should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's domain glossary vocabulary throughout the spec, and respect any ADRs in the area you're touching.

2. Sketch out the seams at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

Check with the user that these seams match their expectations.

3. Write the spec using the template below, then publish it to the project issue tracker. Apply the `ready-for-agent` triage label - no need for additional triage.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.

## 流程图

Two Mermaid flowcharts, embedded inline so the spec is viewable without a follow-up request. Label nodes with the canonical terms from the domain glossary.

- **预期流程图 (Expected flow)**: drawn now from the agreed design. Cover the main journey plus the branches / decision points resolved in the conversation.
- **实际流程图 (Actual flow)**: a clearly-marked placeholder, filled in by `/implement` once the whole spec is built (see that skill).

## API 变化小结

A **hand-off note**: the user copies it verbatim to a client developer (iOS / web) who has never read the spec. It says **which endpoints changed, what changed, and the business rules the client must follow**; field-level detail (request / response fields, examples, error codes) lives in Swagger, so point there instead of repeating it. Both halves use the same shape:

- **计划变更 (Planned)**: written now, from the agreed design.
- **实际变更 (Actual)**: a clearly-marked placeholder, filled in by `/implement` (or the orchestrator's closeout PR) once the whole spec is built, with every path, field, value and copy string read from the code.

Shape of each half:

- One line above both halves: who it is for, and that field detail is in Swagger (search by path).
- **前置说明**: fixed values the client must pass (e.g. the only valid `campaign_key`), and a short plain-language statement of any business rule the client needs to understand what it shows, including client-side preconditions the server relies on (a header, a device id, an app-version).
- **<client> 需要接的**: a table `接口 | 变化 | 要点`. 变化 is a few words (新增 / 请求加可选 `x` / 响应加可选 `y`); 要点 is when to call it and the rules Swagger cannot express (what to show when, what not to compute itself, idempotency, what must not break). Endpoints sharing one change share one row.
- Non-HTTP contracts (push notifications, deep links) are not in Swagger, so in 实际变更 give the full payload JSON as the device receives it and what the client must add to handle it.
- **不需要 <client> 处理**: one line each for other clients' endpoints, admin endpoints, and touched-but-unchanged endpoints. If no endpoint is touched at all, write "无 API 变化" instead of the sections.
- Write in the client's words: no ticket / stage numbers, no "同计划", no internal state or module names unless the client sees them on the wire.
- 实际变更 ends with 「与计划的差异」: each divergence from 计划变更 in one line, or 「无」.

Endpoint paths are contract, not file paths: they belong here despite the no-file-paths rule above.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>
