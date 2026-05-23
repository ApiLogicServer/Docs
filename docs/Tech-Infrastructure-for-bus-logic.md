AI has earned its place in software development.

It’s fast, fluent in natural language, and surprisingly good at generating code.

Anyone who’s used it for real work has also seen the pattern: the code looks reasonable, the structure is clean — and yet subtle bugs show up in production.

This isn’t a complaint. It’s an observation. And it points to something structural.

The tension explains why both camps are right.

AI skeptics see correctness failures and conclude the technology can’t be trusted.

AI enthusiasts see impressive output and conclude the tools just need better prompts.

They’re reacting to the same reality from different sides.

To understand why, we ran a small experiment.





The Experiment

We gave GitHub Copilot a simple spec:

On Placing Orders, Check Credit:
   1. Customer's balance < credit limit
   2. Balance = sum of unshipped Order totals
   3. Order total = sum of Item amounts
   4. Item amount = quantity * unit_price
   5. Unit_price from Product
Five rules. Fits on a cocktail napkin.

Copilot generated 220 lines of procedural code. Clean, reasonable structure.

We asked: "What if the order's customer_id changes?" Bug found, fixed.

"What if the item's product_id changes?" Another bug found, fixed.

Then - unprompted - Copilot (Claude Sonnet 4.5) analyzed its own failure:

"The issue arises from transitive dependencies that cannot be reliably inferred from procedural control flow... Business logic is not a coding problem. It's a dependency graph problem."

That's not an indictment of AI. It's a diagnosis. And a diagnosis points to a cure.





Why AI Is Brittle Here

That napkin spec isn't one use case. It's twelve.

Place Order needs these rules. So does Ship Order - balance changes when orders ship. So does Change Item Quantity. Delete Item. Reassign Order to Different Customer. And six more you haven't thought of yet.

Procedural code encodes dependencies per path. Each path needs explicit handling. Miss one, governance breaks silently.

AI generates code by pattern matching - looking at code structure to infer what comes next. But dependency graphs aren't patterns. They're transitive chains where a change to Item ripples to Order ripples to Customer ripples to credit check. Pattern matching can't reliably trace these - as Copilot itself diagnosed.

This isn't about AI capability. It's about paradigm fit.



The Fix: Distill Intent Into Rules

What if you could express the napkin spec directly - and have the system figure out all twelve use cases automatically

Article content
Logic -> DSL -> Rules Engine
Five rules. Not functions - invariants about the data.

Your requirements contain pearls of wisdom - truths about how the business actually works. But they're buried in path-specific language: "when placing an order, check credit."

The DSL distills those pearls into crystals - precise, structured rules that apply everywhere. "Balance must always equal sum of unshipped orders" isn't about placing orders. It's about the data: balance. It applies to every path that touches orders - including ones you haven't designed yet.

You designed one use case. You solved twelve.

You've seen this before.

Think about spreadsheets. You don't write code to handle "what if cell B5 changes." You declare that B10 = SUM(B1:B9), and the spreadsheet handles dependencies automatically. Insert a row, delete a row, change a value - it just works.

Every business runs on spreadsheets precisely because of this. Nobody writes procedural code to recalculate their financials.

That's what the rules engine does for business logic. Same principle, applied to multi-table transactions. The cocktail napkin becomes executable - not translated into something else, but run directly.





How It Works

The DSL routes around AI's structural limitation:

Article content
AI proposes intent - natural language → rules (AI is great at this)
DSL disambiguates - "price from Product" becomes Rule.copy, not a reference. Human in the loop if unclear.
Engine executes deterministically - dependencies computed automatically, not pattern-matched

The engine handles what AI can't:

Automatic ordering - dependencies computed from rule types, not traced through code paths
All paths covered - Place Order, Ship Order, agent action, future paths - same rules fire
Commit-time enforcement - rules live on data, not in execution paths. Every transaction passes through one gate - the commit funnel.
Performance - pruning skips unaffected rules; adjustment logic uses deltas instead of re-aggregation. This can result in orders of magnitude better performance.



This is infrastructure - not a tool

Article content
An Appliance that governs all sources, all paths with Rules
Think of it as a Business Logic Appliance: a deployable runtime you plug under your orchestration layer. MCP, workflows, APIs, agents - they all flow through it. You keep your architecture. The appliance governs what may commit.

Like a toaster in a kitchen - you don't think about how it works. You plug it in, it does its job. Every enterprise architecture needs this layer. Most don't have it yet.

And it's not a black box: rule traces show exactly what fired, set breakpoints on rules, standard Python, standard IDE.

Because rules map directly to requirements, you get automatic traceability. AI generates tests from the rules. Run them, get a report linking each requirement → rules → test results. Compliance teams can prove governance - not just assert it.





The Resolution

AI skeptics are right: AI-generated code has subtle bugs that break governance.

AI enthusiasts are right: AI is transformative for translating NL intent and generating structure.

Both are true. The resolution is architectural:

AI generates rules, not procedural code. A deterministic engine handles dependencies. Enforcement happens at commit.

AI does what it's brilliant at - understanding intent, working in natural language, generating structure. The engine does what AI can't - tracking transitive dependencies, guaranteeing completeness, enforcing invariants.

AI alone generates broken code. AI + Declarative Rules generates working systems.

That's not a criticism. That's architecture.





One More Thing: AI at Runtime

Rules can include agentic logic. "Select optimal supplier based on cost, lead time, and world conditions" - that's probabilistic reasoning, and it has to be.

But what might an agent produce? Anything.

That's where commit-time governance matters. The agent proposes. Deterministic rules decide what may persist. Agentic reasoning is enclosed by invariants - customer balance still can't exceed credit limit, no matter what the agent recommends.

This is how you deploy agents safely: let them reason freely, govern what commits.





It's cocktail time somewhere

This architecture is available now - free and open source.

Design one use case. Govern twelve automatically.

[genai-logic.com]

