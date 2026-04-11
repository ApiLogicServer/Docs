---
title: Executable Requirements
source: docs/executable-requirements.md
version: 1.5, 4/10/2026
---

<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

# Executable Requirements

The Holy Grail of enterprise software development has always been simple to state: what was specified is what runs — verifiably, always. Every methodology for fifty years has attempted it. Structured analysis. UML. BDD. Agile. All useful. None delivered.

The reason is architectural. Requirements are descriptive — they express intent. Code is prescriptive — it executes. The gap between them is where projects fail, audits struggle, and governance erodes. Nobody has closed it.

Until now — not by generating better code from requirements, but by making the requirements themselves the executable artifact.

## Requirements are the Code

A business analyst writes this — exactly as they'd describe the logic in a meeting:

```gherkin
Feature: Check Credit

  Scenario: Place an order
    Given a customer with a credit limit
    When an order is placed
    Then copy the price from the product
    And multiply by quantity to get the item amount
    And sum item amounts to get the order total
    And sum unpaid order totals to get the customer balance
    And reject if balance exceeds the credit limit
```

This is standard Gherkin — the format enterprise teams already use for testing and specification. No new methodology. No new tools. Your team writes this today.

AI reads it and produces five declarative rules and a complete test suite — a governed starting point your team owns and iterates from. Not a one-shot deployment. Not magic. A real project in your IDE, your Python, your source control, where developers refine rules, users validate behavior, and governance holds through every change.

## Governance That Can't Be Bypassed

The generated test suite covers eight scenarios. The Gherkin specified one.

Delete an order — nobody mentioned that. Ship an order — nobody mentioned that. An agent updates a quantity — not in the spec. All green. Because the rules are on the *data*, not the path. They don't know or care which scenario triggered the transaction. A new developer adds an endpoint next month. A new agent connects next year. Both inherit the same rules — automatically, with no additional work.

You designed one scenario. The architecture governed all of them.

This is the commitment every enterprise needs and almost none have: governance that holds as the system grows, not because developers remember to apply it, but because there is no architectural path that bypasses it.

## Governance Across Every Integration

The rules don't just govern every scenario — they govern every access path. Same rules, whether the transaction arrives via API, UI, agent, or message broker. A second prompt proves it:

```gherkin
Feature: B2B Order Integration

  Scenario: Accept order from external partner
    Given an inbound B2B order in partner format (message_formats/order_b2b.json)
    When the order is received via a Custom API endpoint named OrderB2B
    Then map Account to Customer by name
    And map Items.Name to Product by name
    And map Items.QuantityOrdered to Item.quantity
    And create the order with all Check Credit rules enforced
```

AI generates the custom endpoint and field mappings. No new logic is written. The B2B API inherits the same rules as every other path — as does the Kafka subscriber, the admin UI, and any agent that connects tomorrow.

Every transaction source converges on one commit gate. The rules decide what persists. There is no path that bypasses them.

## What You Get

Five rules replace over 200 lines of procedural code. From one requirements file, AI delivers:

- **Standard JSON:API** — filtering, sorting, pagination, optimistic locking
- **Admin app** — multi-table, automatic joins, ready on day one
- **Declarative rules** — enforced on every path, at commit, with no bypass
- **B2B API and Kafka integration** — raw message persisted first, parse failures recoverable, nothing lost
- **Behave test suite** — generated from the rules, not written by hand
- **Logic Report** — requirement → rule → execution trace
- **Standard project** — Python, your IDE, your source control, container-ready

![Logic Report](images/ui-vibe/assistant/rules-report.png)

The Logic Report is readable by everyone — developers, business users, auditors. Each scenario shows the Gherkin that specified it, the rules that governed it, and the execution trace that proves it. The chain is complete and automatic — requirement → rule → test → execution log. As rules are refined through iteration, the report reflects exactly what runs. Compliance can prove governance. Not assert it. Prove it.

## Governed by Architecture, Not AI

A reasonable question: if AI is generating all of this, what governs the AI?

![Governance Architecture](images/ui-vibe/assistant/$$Gov-Arch.png)

NL intent goes in on the left. Context Engineering directs AI to produce Data Rules — not procedural code. Those rules load into the Rules Engine at startup; dependencies computed deterministically, not inferred at runtime. The Commit Listener hooks into the ORM. Every transaction — API, agent, workflow, message — passes through one control point. Nothing bypasses it.

This is not a prompt engineering story. It is infrastructure — as structural and as mandatory as the database itself.

## The Insight

These are not prompts that describe what to build. They are the requirements, in a form precise enough for AI to execute and plain enough for business and IT to agree on.

The rules are readable. The rules are what runs. The rules are what auditors review.

**The rules are the spec. And rules can't drift from what they enforce.**

---

*Try it: [Install GenAI-Logic →](https://apilogicserver.github.io/Docs/Install-Express/)*
