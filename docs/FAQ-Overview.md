# Is this a BRMS, Low-Code Studio, Vibe Coding, or a 4GL?

!!! pied-piper ":bulb: TL;DR - None of the above — this is a new combination"

      GenAI-Logic gets compared to five existing categories — BRMS/Rete engines, classic low-code, vibe/freehand AI coding, 4GLs, and API generators — and the resemblance is real enough to raise the question honestly. Each comparison breaks down at the same place, though (see "At a Glance" below for the specifics on each).

      As far as we've found, GenAI-Logic is the first to combine:

      * A governed, commit-bound rules engine — automatically invoked, not called; indexed by table at load time, not evaluated as a global ruleset, optimized for transaction processing

      * AI that directs that to create rules, not code

      * One standards-based tool set for Business Users and IT — the same rules, the same generated code, whether it comes from a business user's prompt or a developer's IDE

      > Each linked page makes its own case in full. This page is the fast version.

&nbsp;

---

## At a Glance

| What about... | The short answer | Detail |
|---|---|---|
| Isn't this just a BRMS/Rete engine? | No old/new state — every rule re-reads excessive related data, every time. That's why transaction-heavy systems often move away from Rete-style engines. Case: minutes → 2 seconds, zero code changes. | [FAQ-RETE](FAQ-RETE.md) |
| Isn't this just low-code? | Classic low-code splits business users from IT — stuck extending or rewriting outside the studio (the "rewrite tax"). Here: same artifact — Python, rules — for both. ~40X more concise than procedural code. | [FAQ-Low-Code](FAQ-Low-Code.md) |
| Isn't this just AI/vibe coding? | Freehand AI-generated logic is hard to read, trust, and maintain — the same problem the opening experiment shows. GenAI-Logic directs AI to generate rules, not code. | [FAQ-AI](FAQ-AI.md) |
| Can I still vibe-code my UI? | Yes — GenAI-Logic is the governed backend underneath. Vibe the front end freely; the data and logic stay governed regardless. | [FAQ-AI](FAQ-AI.md) |
| Isn't declarative logic just a 4GL? | 4GLs are procedural, this is *declarative* — different paradigm, not a predecessor. | [Tech-4GL](Tech-4GL.md) |
| Isn't this just an API generator? | An API is the easy portion of the system. Multi-table logic is nearly half the entire project — what's missing from API-only generators. | [Logic-Why](Logic-Why.md) |
