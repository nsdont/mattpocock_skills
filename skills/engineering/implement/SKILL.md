---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

If the spec has no tickets, fill the spec's **实际流程图** and **实际变更** placeholders from the real code once the work is done. If it has tickets, do NOT fill them here: the orchestrator fills them once, on the spec branch, after every ticket's `Stage:` is `landed` or `void` (tickets land in parallel, so no single ticket can tell it is the last). When you do fill them, call out every divergence from the expected flow and planned API changes; if a divergence changed a documented decision, reconcile `CONTEXT.md` / the relevant ADR.

Commit your work to the current branch.
