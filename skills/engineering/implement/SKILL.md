---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

If this completes the spec (every other ticket's `Stage:` is `landed` or `void`, or there were no tickets), fill the spec's **实际流程图** and **实际变更** placeholders from the real code. Call out every divergence from the expected flow and planned API changes; if a divergence changed a documented decision, reconcile `CONTEXT.md` / the relevant ADR.

Commit your work to the current branch.
