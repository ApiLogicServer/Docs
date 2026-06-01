---
title: "Executable Governed Requirements - TLDR"
author: Val Huber
date: 2026-05-29
version: 6
---

# XGR — Executable Governable Requirements

---

## The Governance Gap

AI deserves the credit it is getting for turning prompts into running software. As impressive as it is, Enterprise Architects have concerns about deploying such systems because of governance:

- **Bugs** — dependency bugs, logic inconsistent across multiple paths
- **Not auditable** — results are hard to read, hard to maintain, and impossible to audit at scale

Governance failures cost enterprises millions in penalties, remediation, and audit — and that was before AI agents began writing directly to production data.

> The root cause: a 40x explosion in volume — technical debt that breeds bugs, and complexity that hides whether rules are enforced at all, leaving the enterprise exposed to regulatory fines and contractual penalties.

## Requirements to Declarative Rules, Not Procedural Code

The solution is to use AI for what it is genuinely good at — translating intent — but direct it to produce rules, not code. The difference is visible in the side-by-side comparison shown below:

- **Declarative Rules:** five rules that *are* the requirement — readable, auditable, always enforced on every path (a spreadsheet for business logic)
- **Procedural Code:** ~200 lines, with lurking dependency bugs and no guaranteed execution path

![Declarative rules versus procedural code — same requirement, two outputs. Five rules on the left, ~200 lines on the right.](images/articles/XGR/why-rules.png)

## How It Works

XGR extends AI with two components:

1. **Context Engineering** — directs AI to accept requirements in the forms analysts already use, and produce rules rather than code.

2. **Purpose-built rules engine** — monitors every database commit, ensuring all required rules run on every path, with no bypass and no dependency errors.

![Governance Architecture — design-time rules funnel into a commit-time enforcement gate.](images/architecture/logic-architecture-exec.png)

## Two Proofs

The architecture has been demonstrated from two directions.  These are working POCs at Fortune 500 customers in regulated industries.

**From Requirements: the Check Credit example.** A plain-English five-line requirement, compiled into five declarative rules, enforced on every commit. Analysts write what they already write. The pipeline does not change. What changes is that the result is governed — all rules automatically invoked, no bypass, no dependency errors, auditable.

**From Regulations: the CBSA Steel Derivative Goods Surtax.** A nine-line prompt citing a Canadian regulation directly — no schema, no field mapping, no specs. The output was a complete, working, tested system including: MCP-discoverable enterprise API (so AI agents can find and use it natively), Kafka integration, role-based security, auto-generated test suite, and container deployment. All from one prompt.

And critically: **every component inherits governance automatically**, including components added later. A new endpoint inherits the rules. A new agent hits the same gate. A new developer cannot bypass what is enforced at the commit boundary.

This answers the question every CIO is asking: *won't AI agents bypass my controls?* The structural answer is no. The agent's only path to persistence is through the gate.

For regulated industries, the compliance gain is larger than the speed story. The traditional chain — *regulation → requirements → specs → code → enforcement → audit* — has a defect at every handoff. XGR compresses it to a single step, with the regulator's text as the source of truth.

## Tooling for Governance at Scale

A single governed system is a proof of concept. The argument that matters is whether an organization can make governed-by-architecture the norm across hundreds of services, dozens of teams, and requirements arriving from every direction.

Three auto-generated artifacts make this practical at portfolio scale.

### 1. The Governance Report — portfolio health

Governance by architecture only holds if teams are actually using rules rather than reverting to procedural code. A built-in health check scores each project on two dimensions: **Coverage** (are the right tables governed?) and **Integrity** (do the rules pass anti-pattern checks?). Run it across the portfolio and adoption becomes visible without reading a line of code.

This is what management asks for and rarely gets: *show me where governance is strong, where it is weak, and the trend over time.*

### 2. The Logic Diagram — per-requirement structure

Every developer knows a database diagram. There has been no equivalent artifact for the business rules governing that data — until now.

![Logic Diagram — auto-generated, one per requirement. Requirement at top, rules at bottom, dependency graph in between.](images/articles/XGR/logic-diagram.png)

The diagram for the Check Credit requirement shows the full dependency chain the engine will execute: product price copies into item price, formula computes item amount, sum rolls up to order total, sum rolls up conditionally to customer balance. A compliance officer can look at one of these and verify, in under a minute, that the rules implement the requirement.

One diagram per requirement. Generated automatically. Readable by the people whose job is to review them.

### 3. The Logic Report — per-test execution

The Logic Diagram shows structure. The Logic Report shows what actually ran.

![Logic Report — auto-generated per scenario. Gherkin scenario at top, rules that participated, execution trace showing the constraint failure.](images/articles/XGR/Test%20Report.png)

For each test scenario, the report shows three things: the Gherkin scenario the analyst wrote, the specific rules that ran, and the actual execution trace — including, in this example, the constraint failure that rejected the transaction at the commit boundary.

This closes a traceability gap the industry has been working on for decades: **Requirement → Rule → Execution Log**, in one file, generated automatically, with the analyst's own words at the top.

The compliance audit becomes three steps:

1. Confirm the rules correctly implement the requirement. (Read the Logic Diagram.)
2. Confirm the rules ran on the transactions they should have. (Read the Logic Report.)
3. Spot-check a sample. (The execution log is right there.)

Compliance proven, not asserted.

---

## Technology Notes

**The rules engine is open source, proven infrastructure.** The commit-boundary enforcement architecture was first deployed commercially in the Versata engine in the late 1990s, and later in Live API Creator — the kind of infrastructure that takes a decade to get right, now rebuilt for the AI era. Every governed system runs on it continuously — this is infrastructure in the same sense as a database, not a tool you use once. For more, [click here](genai-logic.com).

**Context Engineering ensures rules, not code.** Directing AI to produce declarative rules rather than procedural code requires more than a well-crafted prompt. The current implementation is 8,000+ lines of curated, tested guidance, refined against real systems. It is why the pipeline produces rules by default — closing the procedural off-ramp that caused previous generations of declarative tooling to erode.

**The governance problem is now the top CIO priority.** AI agents touch production data. New endpoints, integrations, and developers arrive continuously. Every new path is another potential bypass. Regulatory penalties run into the millions per incident, remediation often costs more than the fine, and audit under the traditional model is not tractable at scale. XGR makes the audit tractable. That is the business case, independent of the speed story.

---

*Val Huber is co-founder and architect of GenAI-Logic, and previously CTO at Versata.*

---

**Read more**

- Val Huber, *[AI Makes Requirements Executable. Governance Makes Them Deployable.](https://medium.com/)* — the full argument, with architecture detail and case studies
- W. Ries, *[Governance by Architecture, Not Discipline](https://medium.com/)* — the architectural argument this work builds on
- Val Huber, *[Declarative Rules vs. Procedural Logic: A Reproducible Comparison](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md)* — the A/B comparison referenced above

---
