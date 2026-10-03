# Governance for Enterprise Systems — Manager README Video Script

*Script for the walkthrough of the Manager README. Target: under 10 minutes (~1,300 spoken words). Revised draft.*

---

## 0. Opening (0:00–0:30)

Governance took the number one spot in this year's NASCIO survey of state CIOs.

Governance is often regarded as a  **process** — reviews, sign-offs, a committee. Here it's **automated**.

I want to look at one narrow question: when AI writes your business logic, can anyone read it, trust it, and maintain it?

---

## 1. The Ideal (0:30–2:00)

Ideally, you supply a prompt, and it runs.

Here are five plain-English requirements for a credit check: a customer's balance is the sum of their unshipped orders, and it can't exceed the credit limit.

A few minutes later, you have a running app — screens, an enterprise-class API, and the logic. Think of it as hello world, for logic.

This constraint message is the result of a three-table transaction. That's **governance in action**.

What failed here was an edit to an existing order. The requirement said "when placing an order." Nobody wrote an update-time check. The rules just apply.

Let's explore how that logic was implemented.

---

## 2. AI Alone (2:00–3:45)

AI is genuinely good at UI, data mapping, boilerplate. Business logic is the exception.

We gave AI the same five requirements, without rules. It generated about two hundred lines of procedural code, against five rules. For a real system, there's orders of magnitude more.

On inspection, we found bugs. Change an item's product, and the price wasn't re-copied. Move an order to another customer, and the old customer's balance stayed stale.

Then we tried a typical spec — written the way a developer naturally writes it. Two frontier models, no rules. Both built the insert path. Neither built update or delete. The logic wasn't buggy so much as absent.

And regenerating for maintenance re-introduces the risk, and uses real resources.

We're deeply impressed with AI. This is about closing the gap it has here: logic.

So — how do we keep the speed and simplicity of AI, with the governance enterprises require?

---

## 3. Trustworthy and Auditable - AI Driven Rules

What we want is governed systems you can read, trust, and maintain. That's what AI Driven Rules deliver. It has three parts:

First, AI translates intent — from plain English, Gherkin, even regulation text. That means you keep your existing methodologies, which promotes adoption.

Second, Context Engineering. It's injected into every project, and it directs the same AI to generate spreadsheet-like rules instead of code. Rules are the governance: deterministic, applied to every path.

Third, the rules engine enforces them at runtime. It listens to the database's ORM events, so every source — APIs, messages, agents — and every path — insert, update, delete — goes through the same commit point. There's no second door.

It's a bit like a DBMS - the rules are the DDL, the rules engine is the database server.

---

## 4. Declarative Rules Are Trustworthy 

With procedural code, it's not always clear whether the code is called at all. If it is, it has to be sequenced properly. The hardest part is dependency management: when something changes, are the side effects handled?

Declarative removes those issues. The engine discovers the dependencies, orders the logic correctly, and chains the side effects — like a spreadsheet.

Shuffle the rules into any order, rerun, and it's still correct. There's no call to `check_credit` anywhere — nothing calls it. Rules are declarative ("what"), not procedural ("how").

So if you see a rule, you can trust that it runs, and in the right order.

With rules, seeing really is believing.

---

## 5. Rules are the Governance you can Read and Trust

Natural-language requirements are — and should be — a sketch, not complete. That's exactly what you want to hand to a capable collaborator: not every detail spelled out, just enough for them to do what you meant, not merely what you said. AI is good at that. No artificial syntax to learn.

But that same incompleteness is why natural-language requirements can't be the system of record. An auditor needs something rigorous and complete to check against.

Rules can be that record. They're readable — a fraction of the procedural equivalent. And they're trustworthy: an auditor isn't tracing execution paths or dependency chains, or wondering whether some code never got called.

Governance by architecture, not by discipline. Discipline means every developer, on every change, has to remember the right pattern. Architecture means the software does it automatically.

---

## 6. Project Governance

Every requirement leaves things unsaid, so the AI has to resolve some ambiguity. That carries a responsibility: tell you what it assumed.

The **AI Alerts** report lists those judgment calls. And for anything with no safe default, it stops — no code written, a marker left, the options listed for a person to decide. You review the judgment calls, not the code.

A **logic flow diagram**, generated from the running rules, lets a compliance reviewer check the implementation in minutes.

The **Health Check** report provides metrics on rule utilization.

And the **test report** traces requirement, to test, to rule, to the execution log — before and after values — in one place.

---

## 7. Governance at Scale

Governance depends on rules — they're what you can read, trust, and audit. But the discipline to keep using rules, not procedural code, is hard to sustain across teams. Someone has to walk the floor, bird-dogging and catching the reversions, and when the bird-dog goes away, the procedural code sneaks back in.

Here, the architecture produces the rules. Whatever the requirement format, Context Engineering directs the AI to generate rules, not code. No team has to remember to choose them. Rules are what comes out.

That typical spec again: native AI built the insert path and dropped update and delete. Fed to this pipeline, it produced five rules covering all nine paths. Same input, same AI. The difference was the architecture.

And every project gets the same reports, so governance is visible across the portfolio — without reading a line of code.

---

## 8. Enterprise Architecture, in Brief

The system is a scalable server, deployed as a standard container, and the same rules govern everything that touches it.

The APIs are discoverable through **MCP**, so a business user can ask for new functionality, like emailing customers with overdue orders, without IT support, and still be subject to the rules.

Logic-enabled APIs provide the perfect backdrop for creating custom UIs using your favorite **vibe tools**.  Built-in support for **RBAC** ensures users see only the rows authorized for their roles.

If requested, **Logic Using AI** can reason at runtime. "Find the optimal supplier" can reason about world conditions, like a Suez Canal blockage. But the AI only proposes. The same deterministic rules decide, and the decision is audited.

---

## 9. Enterprise Results

Prompt-to-app tools build the screens. Here are three enterprise-class projects created with governed business logic, using each team's existing requirement methodology. And the results are fast.

Look at the customs surtax prompt: it reads like business language, not rules. A practitioner tried it, it worked, and his estimate was that it replaced a project of about a person-year.

The allocation system was built by hand — reportedly four developers over two years — and it didn't deliver. Here it comes from a prompt.

CLVS, the dangerous-goods screening, was a multi-year effort that missed audit failures the rules caught.

Three different inputs, and all three came out the same way: governed rules, no bypass.

---

## 10. Business Users and IT Collaboration

Since AI can translate virtually any intent, your team can continue to use **existing methodologies.**

Business Users can use natural language, with a business oriented view provided by the **same IDE** the developers use.  So, hitting a complexity wall does not mean a restart and finger-pointing - developers can build out the system using familiar tools.  **Collaboration, not finger-pointing.**

There's no proprietary studio and no rigid structure. You keep your own methodology, and you never face a blank page: ask the AI for just enough guidance, when you need it — or ask it to interview you to work out the requirements.

And the rule a business user reads and the rule a developer debugs are the same lines, in the same file, in the same IDE. Standard Python, standard tooling. One artifact, one team.

---

## 11. Close

It's free and open source; the README walks through all of this.