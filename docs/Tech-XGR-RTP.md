---
narrative
- AI demo - what does it really do
- Goldilocks
- Teaching AI
- Parseable Rules
  -- Code Org
  -- Tests
  -- Requirements Traceability
---

<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

# AI Speed and Simplicity - with Governance

## Prompt to Demo

We've all seen impressive AI demos that accept a prompt like this:

```
Check for Docker or Podman. If neither is running, continue in degraded mode (SQL security, simulated Kafka) and tell me so up front.

create project demo_eai from samples/dbs/basic_demo.sqlite

add security (degrade to SQL if Keycloak is not available)

implement requirements samples/requirements/demo_eai/docs/requirements/demo_eai

verify message subscriptions (all topics)

create logic diagram for each requirement (skip if graphviz is not available)

create tests from rules, using default names

run the tests

run the requirements traceability report
When the report is done, print this verbatim: "Next: scan these two files: logic/logic_discovery/check_credit.py (the rules) and docs/requirements/demo_eai/ad-libs.md (the judgment calls the AI made). Then open the report: demo_eai/docs/requirements/Requirements Traceability Report.md (in VS Code: open the file, then Cmd/Ctrl+Shift+V for the rendered preview)."
```

And generate a running system.

&nbsp;

## Governance: what does this system actually do? 

And we've all asked the money question: *good demo - what does this system actually do?*

We cannot deploy until we can answer that.

&nbsp;

### What Do We Review: Requirements? Code?

We can inspect the requirements, or the code:

- **Requirements say too little.**  The **prompt is incomplete** by design (we *want* AI to fill in details and make assumptions) and the **generation is probabilistic**.\

- **Code says too much.**  Business language in, hundreds of lines of procedural code out.  It looks nothing like the requirements.  Review is already being called the next bottleneck.  And lurking bugs - in an [A/B test](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md), a five-line credit policy became about 200 lines of AI-generated procedural code, with two bugs in change paths it missed. 

<< tbd - genned >>

&nbsp;

## Rules are Just Right

We need AI to generate systems that we can **Read, Trust, and Maintain**.  That means the representation needs to be complete, deterministic, and short enough to read. 

The hard part is the business logic.  Consider this part of the requirements:

```
xxx
```

Standard AI creates ~200 lines of code that we really don't want to read.

A rule-based representation maintains the business level of abstraction:

<< rules >>

&nbsp;

### Context Engineering: Rules Not Code

The same AI that generated 200 lines of code suddenly generates 5 rules...

That required 2 pieces of technology.  First, we provide context engineering that guides AI to generate rules not code:

<< CE >>

### Rules Engine: automatic execution at commit (no-bypass), automated dependencies

These are *transaction* rules.  The engine listens for database commits, compares each row's old and new state, and adjusts a parent total by the change instead of re-reading the children.  The engine fires _automatically_ on every commit, so nothing can skip it.  No-bypass trust.

* It is not a RETE-style [decision engine](https://apilogicserver.github.io/Docs/FAQ-RETE/); it is built for transaction processing, and the two are complementary.  A decision engine has to be *called*, so you must audit every caller to know the logic is enforced.

Rule execution is automatically ordered by system-discovered dependencies.  This means you can safely assume that rules are called in the right order, and that all side-effects are addressed.  So, for example, customer balances are adjusted with orders are inserted, paid, re-assigned, or deleted.

> **Seeing is believing:** if you see a rule, you can trust it will run, in the right order, with automatic dependency management.

&nbsp;

## Rules are the Governance: Execution, Documentation



### Rules Drive Test Generation

&nbsp;

### Rules and Tests Drive Requirements Traceability Report

&nbsp;

#### Orientation (for central repo)

&nbsp;

#### Requirements to Rules

&nbsp;

#### Tests to Rules

&nbsp;

## Summary: Rules are the governance

Same rules, no drift.