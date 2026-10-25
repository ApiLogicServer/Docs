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

## Governance: what does this system actually do?  Review Requirements?  Code?

And we've all asked the money question: *good demo - what does this system actually do?*

We cannot deploy until we can answer that.

So, what *have* we got?  We can inspect the requirements, or the code:

- **Requirements say too little.**  The **prompt is incomplete** by design (we *want* AI to fill in details and make assumptions) and the **generation is probabilistic**.
- **Code says too much.**  Business language in, hundreds of lines of procedural code out.  Review is already being called the next bottleneck.  And lurking bugs - in an [A/B test](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md), a five-line credit policy became about 200 lines of AI-generated procedural code, with two bugs in change paths it missed. 

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

### Rules Engine: enforced at commit (no-bypass, all paths)



&nbsp;

## Rules are the Governance: Execution, Documentation

Same rules, no drift.

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


