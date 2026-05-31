---
title: "Executable Governed Requirements - TLDR"
author: Val Huber
date: 2026-05-29
version: 2
audience: Managers, Business Analysts, VCs, Acquirers
---

# XGR — Executable Governable Requirements

---

## AI Delivers Running Software. But Is It Deployable?

AI deserves the credit it is getting for turning prompts into running software. As impressive as it is, Enterprise Architects doubt most AI-generated systems are deployable, for two reasons:

- **Bugs** — dependency issues, missed execution paths
- **Not auditable** — results are hard to read, hard to maintain, and impossible to audit at scale

The root problem: translating requirements into procedural code produces a 40x explosion in volume. Five lines of business intent become two hundred lines of code no one fully understands — including the AI that wrote it.

## Solution: Translate into Rules, Not Code

The solution is to use AI for what it is genuinely good at — translating intent — but direct it to produce rules, not code. The difference is visible in a side-by-side comparison:

- **Left (declarative rules):** five rules that *are* the requirement — readable, auditable, always enforced on every path
- **Right (procedural code):** ~200 lines with lurking dependency bugs and no guaranteed execution path

![Declarative rules versus procedural code — same requirement, two outputs. Five rules on the left, ~200 lines on the right.](images/articles/XGR/why-rules.png)

## How It Works

XGR extends AI with two components:

1. **Context Engineering** — directs AI to accept requirements in the forms analysts already use, and produce rules rather than code. This is not a simple prompt; it is 8,000+ lines of curated, tested guidance developed over years. It is the part that cannot be quickly replicated.

2. **A purpose-built rules engine** — monitors every database commit, ensuring all required rules run on every path, with no bypass and no dependency errors. This engine sits below the application layer, in the same architectural position as a relational query optimizer: infrastructure that every governed system depends on continuously.

![Governance Architecture — design-time rules funnel into a commit-time enforcement gate.](images/architecture/logic-architecture-exec.png)

## Two Proofs

The architecture has been demonstrated from two directions.

**From Requirements: the Check Credit example.** A plain-English five-line requirement, compiled into five declarative rules, enforced on every commit. Analysts write what they already write. The pipeline does not change. What changes is that the result is governed — all rules automatically invoked, no bypass, no dependency errors, auditable.

**From Regulations: the CBSA Steel Derivative Goods Surtax.** A nine-line prompt citing a Canadian regulation directly — no schema, no field mapping, no specs. The output was a complete, working, tested system:

- A standard Python project — git-managed, IDE-openable, debugger-attachable
- Data Rules for duty calculation, enforced by the rules engine at commit
- An enterprise-class API with MCP discoverability, so AI agents can find and use it natively
- An Admin UI, ready out of the box; custom apps can be built on top of the governed API
- Kafka integration handlers when messaging is needed
- Role-based security via Keycloak when specified
- An auto-generated test suite with full execution trace
- Container deployment, ready for cloud or on-prem

All from one prompt. And critically: **every component inherits governance automatically**, including components added later. A new endpoint inherits the rules. A new agent hits the same gate. A new developer cannot bypass what is enforced at the commit boundary.

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

## A Note for Investors and Acquirers

The two components described above — Context Engineering and the rules engine — have different competitive profiles, and both matter.

**The rules engine is infrastructure, not a feature.** It sits at the commit boundary, below the application layer. Every governed system runs on it for as long as it runs. This is the same structural position that made relational databases recurring businesses: you do not buy infrastructure once, you depend on it. The Versata engine of the late 1990s demonstrated exactly this economics at significant scale. XGR is that architecture rebuilt for the AI era, with AI as the entry point and auto-generated artifacts as the audit layer.

**Context Engineering is the durable lead.** Directing AI to produce declarative rules rather than procedural code requires more than a well-crafted prompt. The current implementation is 8,000+ curated lines, refined through years of Socratic development and real-system testing. It is the reason the funnel produces rules by default — closing the procedural off-ramp that has caused every previous generation of declarative tooling to erode back to code over time. That body of work is not quickly replicated.

**The governance problem is the 2026 CIO priority.** AI agents now touch production data. New endpoints, new integrations, and new developers arrive continuously. Every new path is another way to bypass a rule that lives somewhere else. Regulatory exposure is measurable — penalties run into the millions per incident, remediation often costs more than the fine, and audit under the traditional model (read hundreds of thousands of lines of code, determine whether rules exist, prove they execute on every path) is not tractable at scale. XGR makes the audit tractable. That is the business case, independent of the speed story.

---

*Val Huber is co-founder and architect of GenAI-Logic, and previously CTO at Versata.*

---

**Read more**

- Val Huber, *[AI Makes Requirements Executable. Governance Makes Them Deployable.](https://medium.com/)* — the full argument, with architecture detail and case studies
- W. Ries, *[Governance by Architecture, Not Discipline](https://medium.com/)* — the architectural argument this work builds on
- Val Huber, *[Declarative Rules vs. Procedural Logic: A Reproducible Comparison](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md)* — the A/B comparison referenced above

---
