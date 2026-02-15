# The Hardest Thing We Ever Taught Developers — AI Just Does It Automatically

*By Val Huber*

---

## The Versata Challenge

When I was CTO at Versata, we built a product providing declarative rules. The technology was powerful — rules attached to data, automatically enforced at commit, reused across every path without any additional work. Once developers got it, they loved it.

But getting them there? That was the hard part.

We called it "thinking spreadsheet."

Every developer who walked in the door thought procedurally. Ask them to implement a credit check and they'd write: *"When placing an order, multiply price × quantity, add to order total, compare to credit limit, reject if exceeded."*

That's path-dependent logic. It solves one use case — placing an order. Ship an order? Different path, rewrite the logic. Agent updates an order? Another path, another rewrite. The logic is buried in execution flows, duplicated across every new use case, invisible to governance.

The declarative way is different. Instead of *"when placing an order, check credit,"* you declare: *"Customer balance is always the sum of unpaid orders and must never exceed the credit limit."*

That's it. One rule. It doesn't know about placing orders, or shipping orders, or agents, or Vibe apps. It knows about data. And because it knows about data, it applies automatically to every path that touches that data — including paths that don't exist yet.  40x reduction in business logic code, routinely.

That mental shift — from *"when this happens, do that"* to *"this is always true about the data"* — was the single hardest thing we taught. Some developers got it in a day. Some took weeks. A few never fully made it.

It was the adoption barrier we lived with for years.

---

## The Test

Recently, we were testing GenAI-Logic with an AI assistant — using it as a new user would, asking it to demonstrate the system.

We asked: *"Show me a rule."*

The AI responded with something like: *"On placing an order, multiply price × quantity, add that to the order total..."*

Procedural. Path-dependent. Exactly like every developer we ever trained at Versata.

Faceplant.  **Not** what we wanted AI to be teaching!

But then — the AI redeemed itself, and then some. It distilled path-dependent procedural logic into proper DSL (Domain Specific Language) Python code: declarative, data-bound invariants, not procedural execution paths. And it produced:

```python
Rule.sum(models.Customer.balance, 
         models.Order.amount_total,
         where=lambda row: row.ShippedDate is None)

Rule.constraint(models.Customer, 
                as_condition=lambda row: row.balance <= row.credit_limit)
```

*Customer balance is the sum of unpaid orders. Balance must not exceed credit limit.*

Path-independent. Automatically enforced at commit. Reused across every current and future path — placing orders, shipping orders, agent actions, MCP requests, Vibe apps.

The AI had done, spontaneously, what took us years to teach developers at Versata.

---

## Why This Matters

The AI didn't do this because it's clever about declarative programming (though it is). It did this because the DSL *guided it there*. The rule types — `sum`, `formula`, `constraint`, `copy` — are inherently declarative. They describe invariants about data, not steps in a process. When the AI learned the DSL, it absorbed the declarative mental model along with the syntax.

The learning curve that blocked declarative adoption for decades just disappeared.

Developers no longer need to make the mental shift themselves. They express intent naturally — procedurally, informally, the way humans think. GenAI-Logic distills that intent into path-independent rules. The AI handles the translation. The developer reviews and approves.

This is what "distilled" means in our architecture. Not partitioned — moved from one place to another. *Distilled* — extracted from informal human thought, concentrated into precise executable invariants, enforced automatically at commit across every path.

---

## The Deeper Consequence

Think about what this means for enterprise AI adoption.

Every organization has business logic buried in procedural code — in application layers, in execution paths, in the institutional knowledge of developers who understand the system. AI coding assistants (Cursor, Copilot, Claude) generate more of it every day. Fast, capable, prolific — and producing logic that's path-dependent, hard to audit, impossible to govern systematically.

The problem isn't that AI generates bad code. The problem is that procedural code — however well-written — cannot provide the automatic reuse and commit-time governance that enterprise systems require. Every new path needs its own logic. Every agent invents new paths. Governance becomes whack-a-mole.

Declarative rules solve this structurally. But declarative adoption historically required the mental shift — the "think spreadsheet" moment — that we spent years teaching at Versata.

AI eliminates that barrier. It meets developers where they are, in procedural natural language, and distills it into declarative rules. The developer gets the productivity of AI-assisted development. The enterprise gets the governance of commit-time invariants. Neither has to compromise.

---

## The Spreadsheet Insight, For Everyone

Every business runs on spreadsheets. Not because finance teams learned to "think declaratively" — but because spreadsheets made declarative natural. You declare `B10 = SUM(B1:B9)` and the system handles every dependency, every change, every edge case automatically. Nobody writes procedural code to recalculate financials.

That same principle — automatic reuse over all cases, dependencies managed by the system — is what declarative rules bring to multi-table transactions.

Versata proved it worked. GenAI-Logic brings it to the agentic AI era. And now AI assistants make the adoption barrier essentially zero.

The hardest thing we ever taught developers, AI just does automatically.

*Design Once. Govern All Paths. Correct By Construction.*

**Think SpreadSheet.  Or not.**

---

*Val Huber is the founder of GenAI-Logic and former CTO of Versata, where he led engineering for a $3B IPO. GenAI-Logic provides governed agentic business logic infrastructure for enterprise AI systems.*
