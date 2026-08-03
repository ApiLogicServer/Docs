# Is this a BRMS, Low-Code Studio, Vibe Coding, or a 4GL?

!!! pied-piper ":bulb: TL;DR - None of the above — this is a new combination"

      GenAI-Logic gets compared to four existing categories — BRMS/Rete engines, classic low-code, vibe/freehand AI coding, and 4GLs — and the resemblance is real enough to raise the question honestly. Each comparison breaks down at the same place, though (see "At a Glance" below for the specifics on each).

      As far as we've found, GenAI-Logic is the first to combine:

      * A governed, commit-bound rules engine — automatically invoked, not called; indexed by table at load time, not evaluated as a global ruleset, optimized for transaction processing

      * AI that directs that engine, rather than freehanding the logic itself

      * One standards-based artifact for both sides — the same rules, the same generated code, whether it comes from a business user's prompt or a developer's IDE

      > Each linked page makes its own case in full. This page is the fast version.

&nbsp;

---

## At a Glance

| What about... | The short answer | Detail |
|---|---|---|
| Isn't this just a BRMS/Rete engine? | No old/new state — every rule re-reads excessive related data, every time. That's why transaction-heavy systems often move away from Rete-style engines. Case: minutes → 2 seconds, zero code changes. | [FAQ-RETE](FAQ-RETE.md) |
| Isn't this just low-code? | Classic low-code splits business users (proprietary studio) from IT (stuck extending or rewriting outside it — the "rewrite tax"). GenAI-Logic: same standards-based artifact — Python, declarative rules — for both Bus User and IT. Rules also run ~40X more concise than equivalent procedural code. | [FAQ-Low-Code](FAQ-Low-Code.md) |
| Isn't this just AI/vibe coding? | GenAI-Logic directs AI to generate rules, not code... rules you can read, trust and maintain.  This forms a solid foundation to Vibe custom UIs.| [FAQ-AI](FAQ-AI.md) |
| Isn't declarative logic just a 4GL? | 4GLs are procedural, this is *declarative* — different paradigm, not a predecessor. | [Tech-4GL](Tech-4GL.md) |
| Isn't this just an API generator? | Generating an API from a schema is the easy half. Multi-table constraint and derivation logic is typically the other half of the system — and that's exactly what's missing from API-only generators. | [Logic-Why](Logic-Why.md) |
