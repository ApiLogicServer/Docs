---
title: "Executable Governed Requirements - TLDR"
author: Val Huber
date: 2026-05-29
version: 1
---

# XGR - Executable Governable Requirements

---

## AI Delivers XR... Governable?

AI richly deserves the credit it is receiving for turning prompts into running software.  As impressive as it is, Enterprise Architects doubt they are deployable due to lack of Governance:

* Bugs - dependency issues, path inconsistencies
* Auditable - results are hard to read and maintain

And that's the problem.  Translating requirements into procedural code is a 40X explosion.

## Solution: Translate into Rules, Not Code

The solution is to use AI for what it's great at - translating intent - but train it to generate rules not code.  It looks like this (the attachments contain a detailed A/B comparison):

* the left side shows the (declarative) rules: they *are* the requirements - easy to understand and maintain
* the right side is the (procedural) code: hard to read/audit, with lurking dependency and path bugs

![Declarative rules versus procedural code — same requirement, two outputs. Five rules on the left, ~200 lines on the right. The declarative side is always used, on every path, with no bypass.](images/articles/XGR/why-rules.png)

## Governance Architecture

XGR extends AI with:

1. Context Engineering that teach AI to accept requirements in the forms your are already using, and **create rules not code**
2. A purpose-built (non-RETE) rules engine that monitors all commits, ensuring that all required rules are run (**no bypass**) for **all paths**, with no dependency bugs.

This sophisticated engine (on the order of a relational query optimizer) constitutes a new, required infrastructure layer.

![Governance Architecture](images/architecture/logic-architecture-exec.png)

## Two proofs: from requirements, from regulations

The architecture has been demonstrated in two shapes, from two different sides of the requirements pipeline.

**From Requirements: the basic Check Credit example.** A plain-English five-line requirement, written the way analysts naturally write requirements, compiled into five declarative rules, enforced on every commit, governed by architecture. The Logic Diagram you'll see in the next section is generated from this example. The pipeline doesn't change — analysts write what they already write. What changes is that the result is governed - all rules automatically invoked, no bypass, no dependency errors, auditable.

**From Regulations: the CBSA Steel Derivative Goods Surtax proof-of-concept.** This is the more interesting case. The input was not a requirements document at all. It was a nine-line prompt citing the Canadian regulation directly — program code, tariff subsection, trigger conditions, four example country scenarios. No schema. No field mapping. No specs.

The output was a working, tested system — and it's worth being specific about what "system" means here, because the inventory is the point:

- A **standard Python project**, git-managed, IDE-openable, debugger-attachable
- The **Data Rules** for duty calculation, enforced by the rules engine at commit
- An **MCP-enabled enterprise-class API** — JSON:API with filtering, sorting, pagination, and optimistic locking, plus MCP discoverability so AI agents can find and use it natively
- An **Admin UI**, multi-table, ready to use out of the box; custom apps can be vibed on top of the governed API as needed
- **Kafka publish/subscribe handlers** when integration is specified — standard topics, consumer-group semantics, governed capture on the inbound side
- **RBAC via Keycloak** (or equivalent) when role-based security is specified
- An **auto-generated test suite**, with the Logic Report artifact we'll discuss shortly
- **Container deployment**, standard Python, ready for cloud or on-prem

All from one prompt. All governed by the same rules engine at the commit point. And the part that matters at portfolio scale: **every component inherits the governance automatically**, including ones added later. A new endpoint inherits the rules. A new Kafka handler ingesting messages goes through the commit listener. An MCP-discovered agent calling the API hits the same gate. A vibed custom UI calling the JSON:API is governed without the developer doing anything. Governance is not applied per-component — it is inherited from sitting above the commit boundary.

This answers the agent question every CIO is asking: *won't AI agents bypass my controls?* The structural answer is no. The agent's only path to persistence is through the gate.

This is a proof-of-concept — real, runnable, tested — with the regulation citation traceable through to the rules that enforce it. For regulated industries, the gain is larger than the speed story. The most expensive translation chain in compliance is *regulation → requirements → specs → code → enforcement → audit.* Every handoff is a defect generator.

XGR compresses that chain to a single step, with the regulator's text as the source of truth. What makes this work is the composition:

- **AI** as translator
- **Rules** as the target
- **The engine** as enforcement
- **The auto-generated artifacts** as audit


## Tooling for Governance at Scale

A single governed system is interesting. An organization that makes governed-by-architecture the norm — across hundreds of services, dozens of teams, requirements coming in from every direction — is the argument that matters at the level enterprise IT actually operates.

Three auto-generated artifacts make this work at portfolio scale. Each addresses a different governance question, and each is produced automatically — not by hand, not by discipline.

### 1. The Governance Report — portfolio health

Governance by architecture only holds if teams are actually using rules instead of reverting to procedural code. A built-in health check scores each project on two dimensions: **Coverage** (are the right tables governed by rules?) and **Integrity** (do the rules pass anti-pattern checks?). Run the report across the portfolio and adoption becomes visible across teams, without reading a line of code.

This is the layer management asks for and rarely gets: *show me where governance is strong, show me where it's weak, show me the trend.* The same tool that enforces rules also measures whether teams are using them.

### 2. The Logic Diagram — per-requirement structure

Every developer insists on a database diagram. You can't engage with a system you can't visualize. The same is true for logic — and until now, there has been no equivalent artifact for the rules that govern that data.

![Logic Diagram — auto-generated, one per requirement. Requirement at top, rules at bottom, dependency graph in between.](images/articles/XGR/logic-diagram.png)

The diagram for the Check Credit requirement shows what governance looks like statically:

* The **requirements** appear at the top in plain English, exactly as the analyst wrote it (not shown in this diagram). 
* The **rules** appear at the bottom in declarative form. 
* Between them, the **diagram** shows the four-step dependency chain the engine will execute: Product price copies into Item price, formula computes Item amount, sum rolls up to Order total, sum rolls up (conditionally) to Customer balance.

Unlike a database diagram, which shows every column on every table, the Logic Diagram shows only what governance acts on. The signal-to-noise ratio is what makes it reviewable. A compliance officer can look at one of these and verify, in under a minute, that the rules implement the requirement.

This is how review becomes practical for a large system. One diagram per requirement, generated automatically, readable by the people whose job is to review them.

### 3. The Logic Report — per-test execution

The Logic Diagram shows structure. The Logic Report shows what actually ran.

![Logic Report — auto-generated per scenario. Gherkin at top, rules used, execution log showing the constraint failure that rejected the transaction.](images/articles/XGR/Test%20Report.png)

For each test scenario, the report shows three things stacked vertically: the Gherkin scenario the analyst wrote ("Given customer with credit limit 20… when order placed with 2 Chai… then order is rejected"), the specific rules that participated in that scenario, and the actual execution trace — including, in this example, the constraint failure that rejected the transaction at the commit boundary.

This closes a traceability loop the industry has been chasing for decades: **Requirement → Rule → Execution Log**, in one file, generated automatically, with the analyst's own words at the top.

This is what makes the compliance audit tractable. The auditor no longer reads code. The audit becomes three steps:

1. Confirm the rules correctly implement the requirement. (Read the Logic Diagram.)
2. Confirm the rules ran on the transactions they should have. (Read the Logic Report.)
3. Spot-check a sample. (The execution log is right there.)

Compliance proven, not asserted.

## 

*Val Huber is co-founder and architect of GenAI-Logic, and previously CTO at Versata.*

---

**References**

- W. Ries, *[Governance by Architecture, Not Discipline](https://medium.com/)* — the architectural argument this article builds on
- Val Huber, *[Declarative Rules vs. Procedural Logic: A Reproducible Comparison](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md)* — the A/B test referenced in Failure two

---