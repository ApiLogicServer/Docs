# Governance for Enterprise Systems — Manager README Video Script

*Script for the walkthrough of the Manager README. Target: under 10 minutes (~1,300 spoken words). Revised draft.*

---

## 0. Opening (0:00–0:30)

Governance took the number one spot in this year's NASCIO survey of state CIOs.

Governance is often regarded as a  **process** — reviews, sign-offs, a committee. Here it's **automated**.

I want to look at one narrow question: when AI writes your business logic, can anyone read it, and trust it?

---

## 1. The Ideal (0:30–2:00)

Ideally, you supply a prompt, and it runs.

Here are five plain-English requirements for a credit check: a customer's balance is the sum of their unshipped orders, and it can't exceed the credit limit.

A few minutes later, you have a running app — screens, an enterprise-class API, and the logic. Think of it as hello world, for logic.

This constraint message is the result of a three-table transaction. That's **governance in action**.

Notice what failed here: an edit to an existing order. The requirement said "when placing an order." Nobody wrote an update-time check. The rules just apply.

Let's explore how that logic was implemented.

---

## 2. AI Alone (2:00–3:45)

AI is genuinely good at UI, data mapping, boilerplate. Business logic is the exception.

We gave AI the same five requirements, without rules. It generated about two hundred lines of procedural code. Open it and judge for yourself. For a real system, there's orders of magnitude more.

On inspection, we found bugs. Change an item's product, and the price wasn't re-copied. Move an order to another customer, and the old customer's balance stayed stale.

Then we tried a typical spec — written the way a developer naturally writes it. Two frontier models, no rules. Both built the insert path. Neither built update or delete. The logic wasn't buggy so much as absent.

And regenerating for maintenance re-introduces the risk, and uses real resources.

We're deeply impressed with AI. This is about closing the gap it has here: logic.

So — how do we keep the speed and simplicity of AI, with the governance enterprises require?

---

## 3. AI Driven Rules (3:45–5:15)

This AI Driven Rules architecture provides governance you can read, trust and maintain:

First, AI translates intent — from plain English, Gherkin, even regulation text. That means you keep your existing methodologies, which promotes adoption.

Second, Context Engineering. It's injected into every project, and it directs the same AI to generate spreadsheet-like rules instead of code. Rules are the governance: deterministic, applied to every path.

Third, the rules engine enforces them at runtime. It listens to the database's ORM events, so every source — APIs, messages, agents — and every path — insert, update, delete — goes through the same commit point. There's no second door.

It's a bit like a DBMS - the rules are the DDL, the rules engine is the database server.

---

## 4. Trust Derives from the Declarative Approach (5:15–6:15)

With procedural code, it's not always clear whether the code is called at all. If it is, it has to be sequenced properly. The hardest part is dependency management: when something changes, are the side effects handled?

Declarative removes those issues. The engine discovers the dependencies, orders the logic correctly, and chains the side effects — like a spreadsheet.

Shuffle these rules into any order. Rerun. Still correct. Search for a call to `check_credit` — you won't find one. Nothing calls it. Rules are declarative ("what"), not procedural ("how").

So if you see a rule, you can trust that it runs, and in the right order.

With rules, seeing really is believing.

---

## 5. The System of Record (6:15–7:45)

Natural-language requirements are — and should be — a sketch, not complete. That's exactly what you want to hand to a capable collaborator: not every detail spelled out, just enough for them to do what you meant, not merely what you said. AI is good at that. No artificial syntax to learn.

But that same incompleteness is why natural-language requirements can't be the system of record. An auditor needs something rigorous and complete to check against.

Rules can be that record. They're readable — a fraction of the procedural equivalent. And they're trustworthy: an auditor isn't tracing execution paths or dependency chains, or wondering whether some code never got called.

Governance by architecture, not by discipline. Discipline means every developer, on every change, has to remember the right pattern. Architecture means the software does it automatically.

---

## 6. Enterprise Connectivity, in Brief

The same rules govern **APIs, messages, and agents**.  The system is a scalable server, deployed as a standard container.

The APIs are discoverable through **MCP**, so a business user can ask for new functionality, like emailing customers with overdue orders, without IT support, and still be subject to the rules.

Logic-enabled APIs provide the perfect backdrop for creating custom UIs using your favorite **vibe tools**.  Built-in support for **RBAC** ensures uses see only the rows authorized for their roles.

If requested, **AI Rules** can operate runtime. "Find the optimal supplier" can reason about world conditions, like a Suez Canal blockage. But the AI only proposes. The same deterministic rules decide, and the decision is audited.## 6. Governing the AI's Own Judgment (7:45–8:45)

---

## 7. Enterprise Results



---

## 8. Project Governance

Every requirement leaves things unsaid, so the AI has to resolve some ambiguity. That carries a responsibility: tell you what it assumed.

The **AI Alerts **report lists those judgment calls. And for anything with no safe default, it stops — no code written, a marker left, the options listed for a person to decide. You review the judgment calls, not the code.

A **logic flow diagram**, generated from the running rules, lets a compliance reviewer check the implementation in minutes.

The **Health Check** report provides metrics on rule utlizatiion, across the portfolio.

And the **test report **traces requirement, to test, to rule, to the execution log — before and after values — in one place.

---

## 9. Business Users and IT Collaboration

Since AI can translate virtually any intent, your team can continue use **existing methodologies.**

Business Users can use natural language, with a business oriented view provided by the **same IDE** the developers use.  So, hitting a complexity wall does not mean a restart and finger-pointing - developers can build out the system using familar tools.  **Collaboration not finger-pointing,**

There's no proprietary studio and no rigid structure. A business user can just ask the AI for guidance — or ask it to interview them to work out the requirements.

And the rule a business user reads and the rule a developer debugs are the same lines, in the same file, in the same IDE. Standard Python, standard tooling. One artifact, one team.

---

## 10. Close

It's free and open source; the README walks through all of this.