---
title: Customs Surtax Calculator
notes: gold source is docs
source: docs/Customs-readme.md
AI-Assistants: Do NOT use this file for generation - use your Context Engineering, Prompt etc.
version: 1.0 from docsite, for readme 2/16/2026
---


# Customs Surtax POC — Engineering README

**Audience:** Technical GenAI-Logic evaluators

**Project:** CBSA Steel Derivative Goods Surtax calculator, built as a proof-of-concept.

**Run Instructions:** at end

## Overview

### TL;DR - Enterprise Governance and Speed

The goal of this POC was to explore whether GenAI-Logic added significant value.  Our findings:

* An Enterprise-class system ensured *by architecture:* Governable Quality, Full-Featured

  * Logic reuse over all paths, by data-oriented rules enforced on commit
  * Full-featured Enterprise class (APIs for all objects, with enterprise features such as pagination, filtering, etc), logic enabled
* A several week effort became 30 minutes

<br>

### Two Creation Prompts

#### Subsystem Prompt
The subsystem was created by providing the following prompt to Copilot:

```text
Create a fully functional application and database
 for CBSA Steel Derivative Goods Surtax Order PC Number: 2025-0917 
 on 2025-12-11 and annexed Steel Derivative Goods Surtax Order 
 under subsection 53(2) and paragraph 79(a) of the 
 Customs Tariff program code 25267A to calculate duties and taxes 
 including provincial sales tax or HST where applicable when 
 hs codes, country of origin, customs value, and province code and ship date >= '2025-12-26' 
 and create runnable ui with examples from Germany, US, Japan and China" 
 this prompt created the tables in db.sqlite.
  Transactions are received as a CustomsEntry with multiple 
SurtaxLineItems, one per imported product HS code.
```

> See also the proposed prompt

#### Tests Prompt
```text
create behave tests from CBSA_SURTAX_GUIDE
```

<br>

### Results: system, test suite and report

#### System: API, Database, Logic, Admin App

![app](images/ui-vibe/customs/app_screenshot.png)


#### Test Suite and Report

The GenAI-Logic `create` command builds test services and Context Engineering. These enable the LLM to generate tests that proved the code worked, as well as elucidate the logic through readable test reports.


![behave rpt](images/ui-vibe/customs/behave_report_git.png)

### GenAI-Logic Architecture: Logic Automation + AI

The underlying architecture is a combination of key elements:

#### Generative AI - but that's not enough

Used extensively to create - and iterate - the system.  This occurs in the IDE, not at runtime.  

But GenAI alone is not enough.  AI pattern matching struggles with dependencies, as shown in the A/B Test (see end)

<br>

#### Logic Automation (engines for rules, api...)

The core GenAI-Logic [software architecture](https://www.genai-logic.com/product/architecture){:target="_blank" rel="noopener"} consists of:

* Runtime Engines for logic, api, admin app and data access
* CLI Services to create projects, rules, etc


![arch](images/ui-vibe/customs/Core-Architecture.png)

<br>

#### Context Engineering: Automation Aware AI

GenAI-Logic projects are [AI-Enabled](Project-AI-Enabled.md): each project contains extensive Context Engineering (markdown files) that enable AI to understand and create Logic Automation components.  

For example, markdown files explain rule syntax, so AI can translate NL Logic into declarative rules.


##### Highly Leveraged; Support Recommended

As part of your project, you can extend Context Engineering.  We did so in this project (see section 2).

Such extensions require extensive architectural background, so training and support are recommended.

<br>

#### Runtime Architecture: Container, Governed AI

The resultant projects are standard containers.  Deploy without fees.  Sample scripts are provided for Azure.

Execution does *not* use probabilistic AI services *except* for explict AI Rules; these results are strictly governed by deterministic rules at commit time


---

## 1. Project Contents

The following artifacts were generated and are present in this repository.

**Data layer** — `database/models.py` contains auto-generated SQLAlchemy models for `SurtaxOrder`, `SurtaxLineItem`, `HSCodeRate`, `CountryOrigin`, and `ProvinceTaxRate`. The schema follows standard autonumber primary key conventions.

**Business logic** — `logic/logic_discovery/cbsa_steel_surtax.py` contains 16 declarative rules covering line-item calculations (customs value, duty, surtax, PST/HST, total), sum rollups to order-level totals, surtax applicability (date and country checks), and data validation constraints. The file is auto-loaded at startup by `logic/logic_discovery/auto_discovery.py`.

**REST API** — The JSON:API server runs at `http://localhost:5656/api/`. Custom API endpoints are co-located in `api/api_discovery/` and auto-loaded by `api/api_discovery/auto_discovery.py`. No manual registration is required.

**Admin UI** — A full CRUD interface is available at `http://localhost:5656/admin-app` for manual testing and business user workshopping.

**Test suite** — `test/api_logic_server_behave/features/cbsa_surtax.feature` defines 7 Behave scenarios covering: surtax-applicable orders, pre-cutoff (no surtax) orders, non-surtax countries, multi-line rollups, and three constraint violations. Step implementations live in `test/api_logic_server_behave/features/steps/`.  

**Test Report** - the test suite creates logs we use to create a report.  To see the **report**, [click here](Customs-Logic-Report.md){:target="_blank" rel="noopener"}.

**Reference data loader** — `load_cbsa_data.py` populates HS codes, countries, and provincial tax rates from CBSA PC 2025-0917.

<br>

---

## 2. Context Engineering Revision: Subsystem Creation

This app was built across several iterations. Each iteration revealed a specific gap in Context Engineering (CE) — the curated knowledge given to the AI before generation. The gaps and their fixes are documented below.

This was a very interesting joint AI/human design; the approach:

1. Gen customs_app
2. Ask genned app to compare itself to the reference implementation - [see it here](https://github.com/KatrinaHuberJuma/customs_app){:target="_blank" rel="noopener"} - and create a comparison doc
3. Analyze the comparison doc in a long-running manager session in mgr Copilot with full CE (mgr, project, internals)
4. Ask Copilot to Revise CE (in src and venv), and update this document
5. Repeat

<br>

<details markdown>
<summary>1. No GenAI-Logic CE → poor "Fat API" demo architecture ❌</summary>

<br>

The GenAI-Logic Context Engineering (CE) materials were not loaded, so Claude built a working customs application using standard Python code generation.  The starting case was the `basic_demo` application, which introduced tables we did not need, but did not (we thought) interfere.

The result is a good demo: compiles and runs. 

This was, however, a "happy accident", illustrating that ***AI alone does not deliver an Enterprise-class architecture***, as described below.

* **Demo API (no filtering, pagination, etc)** — No Enterprise-class API with filtering, sorting, pagination, optimistic locking, etc.

* **Unshared, Path-specific logic (Quality Issues)** — Logic embedded in a single path — not automatically shared across insert/update/delete/FK-change paths.

* **Procedural — Manual Ordering (with bugs)** — Logic is *procedural* with explicit ordering. **AI uses pattern matching to order execution, which can fail for business logic** — to see the A/B study, [**click here**](https://github.com/KatrinaHuberJuma/customs_app/blob/main/logic/procedural/declarative-vs-procedural-comparison). This in fact did occur in our example.

<br>

</details>

<br>

<details markdown>
<summary><strong>2. Missing SubSystem CE → No Rules, Poor Data Model ❌</strong></summary>

<br>

So, we loaded the Context Engineering, and re-built.  Claude produced poor results on two dimensions:

* data model errors (non-autonumber primary keys for `SurtaxOrder` and `SurtaxLineItem`)
* business logic still written as procedural code rather than declarative rules

This was because the CE (Context Engineering) was provided for WebGenAI, but not Copilot.  So we created `docs/training/subsystem_creation.md` with data model and rules training.

<br>

</details>

<br>

<details markdown>
<summary><strong>3. Proper app generated correctly from prompt ✅</strong></summary>

<br>

With the revised CE in place, Claude generated a complete, correct customs application in a single pass: proper autonumber data model, 16 declarative LogicBank rules enforcing all calculations, clean separation between API routing and rule enforcement, and a Behave test suite with requirement-to-rule traceability.  This became our **reference implementation.**

> Context Engineering learning compounds. Each prior failure encoded a reusable correction. Any future project that loads this CE material starts at Step 2 — the failures were compressed into training assets, not wasted effort.

**What this means for evaluation:** The product (GenAI-Logic) provides the architectural value. The process (Context Engineering iteration) determines whether the AI can reach that architecture reliably. Both matter.

<br>

</details>

<br>


<details markdown>
<summary><strong>4. Productization revealed `basic_demo` dependence and master/detail prompt omission ❌</strong></summary>

<br>

The 'basic_demo` tables were an accidental artifact - we thought.  But when we re-genned using just the clean `starter.sqlite`, we got a poor result:

* we lost the master/detail structure that had been inferred from `basic_demo` - this needed to be added to the prompt
* `basic_demo` also showed several basic logic patterns that we needed to add to the CE, shown below

The study produced several durable CE principles now encoded in Context Engineering ()`subsystem_creation.md`, `logic_bank_api.md`, and `.copilot-instructions.md`):

* **Reference table default** — flat column + `Rule.copy`. Versioned child table only when the prompt explicitly mentions `effective_date`, rate history, or versioning.

* **`Rule.copy` is the default** for parent-value access (snapshot, safe). `Rule.formula` is the escalation (live propagation, needed less often).

* **Request Pattern scope** — integration side-effects only (email, Kafka, AI calls). Not for domain data entry where LogicBank rules derive computed columns automatically.

* **Domain insert is the pattern** — direct insert fires all LogicBank rules. No `Sys*` wrapper needed.

* **"Create runnable UI"** = seed example data + Admin App at `http://localhost:5656`. Never a custom HTML page or calculator endpoint.

* **Lookup references use FK integers** — transactional tables store `country_origin_id FK → CountryOrigin.id`, not `country_of_origin = "DE"`. FK is what makes `Rule.copy` traversable; a text code has no relationship.

* **Seed data canonical pattern** — use `alp_init.py` with Flask context active so LogicBank fires and all computed fields are correct on first load. Never shell heredocs (terminal tool garbles them).

* **Spec = floor, not ceiling** — a column list in a prompt is the minimum anchor the author needed to specify, not a complete design. Apply domain knowledge to flesh out standard fields, constraints, and sums. Prompt author omissions mean "obvious to them" — not "not required."

> Just as `basic_demo` "polluted" a clean generation, so did this readme!  The learning: AI is crafty - it will use whatever it can find, so be careful what you leave lying around.  See the front-matter, above.

</details>

<br>

<details markdown>
<summary><strong>5. Prompt is a floor, not a ceiling ❌</strong></summary>

<br>

As we added promot engineering for the schema, this changed the AI pattern to blind obedience.  For example, roll-up rules and constraints were not added.

So, we changed the CE to stipulate that the prompt is a floor, not a ceiling.

</details>

<br>

<details markdown><summary>6. Validation: Iterations Lead to Production-Quality Results ✅</summary>

Each iteration tested against the hand-crafted `customs_app` (16 rules) as the fixed ground-truth reference.

| Iteration | Key change | Rules | `Rule.copy` | `Rule.constraint` | Outcome |
|---|---|---|---|---|---|
| `customs_demo_ce_fix` | Applied Root Cause fixes to CE | 10 | 0 | 0 | Catastrophic failures gone; FK text-code problem remains |
| `customs_demo_v2` | Fixed prompt: FK integers + single `province.tax_rate` | 13 | 3 ✅ | 1 | `Rule.copy` validated; `base_duty_rate` and constraints still missing |
| `customs_demo_v3` | Added spec=floor principle to CE | 11 | 3 ✅ | 1 | Generic domain fields restored; domain-specific `base_duty_rate` cannot be recovered by CE alone |
| New release (`customs_demo`) | Added `base_duty_rate` and `quantity × unit_price` to prompt explicitly | **16 ✅** | 1 | 3 ✅ | Functionally at par with reference — all constraints, sums, and rates correct |

**The `v1a` clean-room finding.** A final test (`customs_demo_v1a`) ran the prompt with no `customs_demo` readme in context. Without the readme acting as a ghost, the result regressed to near-v3 quality — confirming that the "new release" 16-rule win was partially readme-assisted. What the CE alone **does** reliably produce: header/detail structure, flat reference table design, `Rule.copy` for duty rate, and `alp_init.py` Flask-context seed data. Constraints, single-column province, and `CountryOrigin` FK table require the prompt spec.

> **CE reliability boundary:** CE is reliable for what it explicitly encodes. If a structural outcome depends on inference — from ghost context, readme text, or ambient schema artifacts — it is non-deterministic and will not reproduce on a clean project. The practical test: can you point to the CE sentence that requires this outcome? If not, the result is fragile.

**Domain accuracy finding:** The clean-room test also caught a factual error in the hand-crafted reference — `customs_app` marks Germany, Japan, and China as surtax-applicable. PC 2025-0917 is a targeted US retaliatory levy; only US-origin goods attract the 25% surcharge. The AI, without the reference in context, modeled this correctly. Domain experts reviewing this system should verify country-of-origin applicability against the current PC annex.

</details>

<br>

> Key Takeaway: GenAI-Logic is a combination of infrastructure (API, Rules Engine), and AI.  Leveraging AI requires Context Engineering.  <br><br>This can enable major changes without a product re-release, but strong support/background is required.

<br>

---

## 3. Test Creation From Rules

**Behave** is a Python BDD (Behavior-Driven Development) test framework. Tests are written in plain English using **Gherkin** syntax (`Given / When / Then`), making them readable by non-engineers.

`Scenario: Surtax applies for post-cutoff ship date`
  `Given a SurtaxOrder for Germany to Ontario with ship_date 2026-01-15`
  `When a line item is added with hs_code 7208.10.00 quantity 1000`
  `Then the line item surtax_amount is 125000.00`

Each step maps to a Python function in `features/steps/`. GenAI-Logic adds a **Behave Logic Report** on top (`behave_logic_report.py`) that traces which rules fired per scenario — turning tests into living requirements documentation (requirement → rule → execution).

To run the Behave test suite, start the server first, then execute:

```bash
cd test/api_logic_server_behave
python behave_run.py
```

The Behave Logic Report (`test/api_logic_server_behave/behave_logic_report.py`) produces a per-scenario trace showing which rules fired, in what order, and with what before/after values. This creates a direct requirement → rule → execution traceability chain. 

For example, the scenario `Surtax applies for post-cutoff ship date with surtax country` in `features/cbsa_surtax.feature` traces through the `determine_surtax_applicability` formula rule, the `calculate_surtax_amount` formula rule, the `copy_pst_hst_rate` formula rule, and all five sum rules up to the order totals — all triggered by a single line-item insert.

<br>

---

## 4. Debugging: Standard IDE, Logging

The LogicBank logic log records before- and after-values for every attribute touched during a transaction commit. Rules in `logic/logic_discovery/cbsa_steel_surtax.py` emit structured log messages using `logic_row.log()` — for example:

```
Surtax Amount: 125000.0 (Applicable: True)
PST/HST Rate: 0.1625
Surtax Applicable: True (Ship Date: 2026-01-15, Date Check: True, Country Check: True, Cutoff: 2025-12-26)
```

To extract a clean logic trace for a specific transaction, set the log level to `DEBUG` in `config/logging.yml` and filter on the `logic_logger` name. The debug documentation for logic traces is in `docs/logic/readme`. The `test_date_fix.sh` script at the project root demonstrates extracting and validating specific logic log output.

<br>

---

## 5. Maintenance: Automated Reuse and Ordering

Changing a rule requires editing one declaration in `logic/logic_discovery/cbsa_steel_surtax.py`. The engine recomputes the dependency graph at startup and applies the change to every write path automatically — insert, update, delete, and foreign key reassignment. There is no need to find insertion points, trace execution paths, or audit every API endpoint.

The contrast with procedural code is quantified in `logic/procedural/declarative-vs-procedural-comparison`. For an equivalent order management system, the procedural approach produced 220+ lines of code with 2 critical bugs (missed cases for FK reassignment). The declarative approach produced 5 rules with 0 bugs. The customs system in this POC has 16 rules. An equivalent procedural implementation would require explicit handling of every combination of line-item insert, quantity update, price update, HS code change, country change, and ship date update — each requiring code changes in multiple functions.

<br>

---

## 6. AI Use: Human In the Loop, Determinism

While the system was *created* using AI, that was authoring only.  The expectation is that developers remain the ***human in the loop*** to verify the rules, and debug them.

The created Rules in `logic/logic_discovery/cbsa_steel_surtax.py` execute **deterministically** at transaction commit time via SQLAlchemy ORM events. There is no inference, no sampling, and no variability: given the same input state, the same output is always produced. 

All writes to the database — through the REST API, through the Behave test suite, through the Admin UI at `/admin-app`, or through any agent or script — pass through the identical rule set. The execution order is computed once at startup from the declared dependency graph, not from code paths at runtime.

### AI Rules Also Supported - With Governance
The system does support AI rules — rules that call AI at runtime (though not used here). Importantly, these are subjected to this same governance:

> AI may propose values, but rules determine what commits.

### Next Exploration: AI-Determined HS Codes

HS code classification is a well-known compliance pain point — importers frequently mis-classify goods, triggering audits and penalties. A natural next step is to add an AI Rule that determines the correct HS code from a product description, analogous to our `find-supplier` example where AI selects the best supplier from a product spec.

This raises two engineering questions worth exploring:

1. **AI Rules in a transactional workflow** — the AI inference runs at transaction time, not at authoring time. The downstream duty, surtax, and PST/HST calculations fire automatically from whatever HS code the AI resolves. The audit log captures both the inference result and the full rule chain that followed from it.

2. **Human-in-the-loop at authoring time, not inspection time** — AI distills natural-language intent into declarative rules. A compliance engineer reviews the DSL output, not the implementation it replaced. The review artifact is at the same abstraction level as the business requirement — 1 rule per derivation, not 200 lines of service code tracing execution paths — which is what makes the review tractable. Once approved, the rules execute deterministically: same input state, same output, every time, across every write path. Governance is structural, not procedural.

These two points converge: the deterministic DSL rules that govern every ordinary transaction are the *same* rules that govern AI Rules. There is no separate governance layer to design or enforce. An AI-proposed HS code enters the same commit pipeline as a human-entered one — duty, surtax, and provincial tax fire identically, with no exceptions and no bypass paths. The AI inference is bounded; the consequences are not probabilistic.

<br>

---

## 7. Automatic Invocation - Code *Cannot* Bypass Rules

Rules fire by architectural necessity, not by policy. The LogicBank engine hooks into SQLAlchemy's `before_flush` and `before_commit` events at the ORM layer, below Flask and below any API handler. There is no write path to the database that does not pass through the same hooks. 

You cannot bypass enforcement by calling a different endpoint, using a different HTTP method, writing a new API service, or modifying the database through a workflow step. This is the structural property that makes AI-proposed logic changes safe to commit: a rule change that passes validation is automatically enforced everywhere, with no additional wiring.

<br>

---

## 8. What GenAI-Logic Is Not

The rules engine enforces data integrity at write time. It is not a tool for read-only analytics or reporting — SQL views, BI tools, or direct query optimization are appropriate there. 

It is not a workflow orchestration engine: multi-step approval processes, long-running sagas, and external system coordination belong in tools like Temporal or Airflow. It does not replace complex algorithms — machine learning models, graph traversal, or combinatorial optimization are pure Python problems. 

Rules solve one specific problem well: ensuring that defined data relationships are always true, across every write path, automatically.

<br>

---

## 9. A/B Result

For the foundational order management case, 5 declarative rules replaced 220+ lines of AI-generated procedural code, and the procedural version contained 2 critical bugs that were only discovered through directed prompting:
* one for `Order.customer_id` reassignment (old customer balance not decremented) and 
* one for `Item.product_id` reassignment (unit price not re-copied from new product)

The full experiment, including the original procedural code and the AI's own analysis of why it failed, is documented in `logic/procedural/declarative-vs-procedural-comparison`.  (tL;DR: pattern-matching AI deals poorly with complex dependencies common to business logic).

---

**Bottom line:** The customs POC demonstrates that GenAI-Logic delivers correct, maintainable business logic — and that getting an AI to generate it correctly requires Context Engineering to be as precise about architecture as it is about syntax. A production CBSA implementation would start from the CE and prompt patterns documented in section 2, not from a blank slate; the iteration study exists so that starting point is already validated.

<br>

## Run Instructions

Load under 16.01.39, windows or mac.

Start the server, and enter a SurTax Order:

* Country Origin: China
* Province: ON
* Order Number: <any unique>

And a SurTaxLineItem:

* Line #: 1
* Quantity: 1
* Price: 10000
* HS Code: < the first>

ReQuery, and Verify Total Amount Due: 14125

<br>

### To Recreate

```bash
genai-logic genai --using=samples/prompts/genai_demo.prompt
```

This creates a 1-table project, and opens it.

Then, in the opened project:

1. Establish your venv
2. Initialize Copilot (*Please load `.github/.copilot-instructions.md`*)
3. Enter the prompt above

&nbsp;

&nbsp;

&nbsp;


# Appendix: Without GenAI-Logic

Mistakenly, we submitted the creation prompt without having loaded Context Engineering.  This created a working app, but without rules.

It was a happy accident -- it allowed us to ask Claude Sonnet 4.6 to contrast this with the Rules-based implementation.  We got the document below.

&nbsp;

## TL;DR

This project was created from the customs prompt **without first loading `.github/.copilot-instructions.md`**. The AI had no awareness of GenAI-Logic architecture, the Request Pattern (ROP), or LogicBank declarative rules.

The result is a working application: the endpoint returns correct answers for its intended happy-path POST, the Admin UI runs, and the code is competent Flask. For a proof-of-concept with a single entry point, it would pass a demo. The problem is architectural, not functional — and it only surfaces under real-world conditions.

**One-line verdict**: Business logic lives in the wrong layer — in a fat API service — and is not enforced by the rules engine. `declare_logic.py` itself confirms this: `declare_logic_message = "ALERT:  *** No Rules Yet ***"`.

---

## Key Findings

1. **Zero declarative rules** — `declare_logic.py` still carries `"ALERT: *** No Rules Yet ***"`. The 13 `Rule.formula/sum/copy/constraint` declarations in `customs_app` have no counterpart here.

2. **~150 lines of business logic in the wrong layer** — `duty_calculator_service.py` performs tariff lookups, rate selection, and calculations. The `early_row_event` in `duty_calculations.py` then recalculates the same amounts from already-set fields — logic runs twice, in two places, neither governing the other.

3. **Missing requirements from the original prompt** — Provincial tax (HST/PST), surtax applicability by ship date (`>= 2025-12-26`), and multi-line order structure are all explicit in the prompt used for both projects; all are absent from this implementation. (Note: this comparison is only valid if both projects were built from the same prompt. The session transcript in `session_transcript` confirms this.)

4. **Enforcement gap** — Logic only fires via the one custom endpoint. Any insert via standard JSON:API, the Admin UI, test scripts, or future integrations bypasses tariff lookup entirely and stores whatever rates the caller provides.

5. **Schema design** — A flat single record per calculation vs. `customs_app`'s normalized `SurtaxOrder` / `SurtaxLineItem` / `ProvinceTaxRate` / `CountryOrigin` / `HSCodeRate` hierarchy.

---

## Demo vs. Enterprise-Class Architecture

**It is fair to call this a demo-class architecture. Here is why.**

The distinction is not about whether the code works for a happy-path POST — it does. The distinction is about what the architecture guarantees and what breaks under real-world conditions.

### What demo-class means here

**A demo-class implementation** is one where:
- The "business logic" is a procedure wired to a single entry point
- Correctness depends on every caller going through that one path
- Adding a new entry point (a second API, a test, an integration) requires manually duplicating or calling the logic
- The system has no shared enforcement layer — rules live in the service, not in the platform

This is exactly the structure here. The duty calculation logic is in `duty_calculator_service.py`. Nothing stops a caller from POSTing a `DutyCalculation` row directly via `/api/DutyCalculation` with a `duty_amount` of `0` and a `total_amount` of `0` — both will be stored as-is. The rules engine won't correct them because there are no rules.

**An enterprise-class implementation** is one where:
- Business logic is declared once, in a shared enforcement layer
- That layer fires on every transaction, regardless of entry point
- Adding a new entry point (API, test, admin, Kafka consumer) does not require porting logic
- Constraints, derivations, and validations are guaranteed to run at commit time

`customs_app` meets this bar. `customs_appZ` does not.

### The specific failure modes this creates

| Scenario | customs_appZ | customs_app |
|---|---|---|
| Admin UI user edits a `DutyCalculation` row | Amounts become stale/wrong — no rules re-fire | Rules re-derive all amounts automatically |
| Test data script inserts a row directly | Gets whatever values were hardcoded — no lookup | Rules derive correct amounts from reference data |
| A second API endpoint is added | Must re-implement or call the service explicitly | Inherits all rules automatically |
| Provincial tax requirement is added | Requires API code change + new endpoint logic | Add one `Rule.formula` in `cbsa_steel_surtax.py` |
| Auditor asks: "prove the calculation is always enforced" | Cannot — enforcement depends on one code path | Yes — LogicBank fires on every commit, traceable in logs |

### Why "demo" is the right word, not "wrong" or "broken"

This pattern is completely normal and acceptable for:
- A proof of concept where only one UI/API exists
- A throwaway script
- A system where the single endpoint is the only ever intended entry point

It becomes a liability when the system is expected to grow, handle multiple clients, be maintained by others, or be audited — which is precisely the use case CBSA customs compliance implies. Regulatory compliance systems are among the clearest cases where "logic enforced from one place, callable from anywhere" is not optional.

The GenAI-Logic platform was built specifically to address this. The failure here is not that the AI wrote bad code — the code is competent Flask. The failure is that the AI wrote Flask code onto a platform that provides something better, because it didn't know the platform existed.

---

## 1. Root Cause

The prompt was good. It contained all the signals for a rules-based, Request Pattern implementation:

| Signal in prompt | What it implies |
|---|---|
| "calculate duties and taxes" | Computed fields → `Rule.formula` |
| "when hs codes, country, value is given" | Request fields → ROP table |
| "provincial sales tax or HST where applicable" | Conditional tax → `Rule.formula` with lookup |
| "ship date >= 2025-12-26" | Conditional surtax applicability → `Rule.formula` |
| CBSA / Customs Tariff compliance domain | Audit trail requirement |

Without context from `.copilot-instructions.md`, the AI defaulted to the most familiar pattern: **build business logic inside the API endpoint**. This is correct for generic Flask development, but wrong for GenAI-Logic.

---

## 2. Logic Architecture: Where the Rules Live

### customs_appZ (this project) — Logic in API layer

```
api/api_discovery/duty_calculator_service.py   ← 179 lines  (logic IS here)
logic/logic_discovery/duty_calculations.py     ← early_row_event  (procedural, not declarative)
logic/declare_logic.py                         ← "ALERT: *** No Rules Yet ***"
```

**`duty_calculator_service.py`** performs:
1. Database lookups (HS code, origin country, destination country, tariff rate)
2. Business decisions (which tariff applies, rate selection)
3. Record creation with pre-computed rate values
4. `session.flush()` comment: "Trigger business logic calculations"
5. Response assembly with full breakdown

Then `duty_calculations.py` fires an `early_row_event` that **recalculates the same amounts** from the already-populated rate fields — redundant execution, with logic running twice in two different places, neither governing the other.

### customs_app (reference) — Logic in rules layer

```
api/api_discovery/     ← only boilerplate stubs (new_service.py etc.)
logic/logic_discovery/cbsa_steel_surtax.py   ← 13 declarative rules
logic/declare_logic.py                       ← routes to logic_discovery (correct)
```

`cbsa_steel_surtax.py` uses:
- `Rule.formula` — derives `customs_value`, `duty_amount`, `surtax_amount`, `pst_hst_amount`, `total_amount`, `surtax_applicable`
- `Rule.copy` — copies `duty_rate` and `surtax_rate` from `HSCodeRate` parent
- `Rule.sum` — rolls up 5 line-item fields to `SurtaxOrder` totals
- `Rule.constraint` — validates ship date, quantity, unit price

**Zero business logic in any API file.**

---

## 3. Declarative vs. Procedural Rule Count

| | customs_appZ | customs_app |
|---|---|---|
| Declarative `Rule.*` statements | **0** | **13** |
| Lines of procedural logic in API | **~150** (service body) | **0** |
| `early_row_event` (procedural) | 1 (recalculates what API already set) | 1 (surtax applicability, justified) |
| `Rule.sum` rollups | 0 | 5 |
| `Rule.copy` from parent | 0 | 2 |
| `Rule.constraint` validation | 0 | 3 |

The `early_row_event` in `duty_calculations.py` is not wrong in principle, but here it is redundant — the API already computed and stored `duty_amount`, `tax_amount`, and `total_amount` before the row was flushed. The event just overwrites the same values.

---

## 4. Schema Design

### customs_appZ

```
Country
HSCode
TariffRate          ← lookup: hs_code + origin_country + destination + date range
DutyCalculation     ← flat single-row record per calculation
Customer / Product / Order / Item   ← basic_demo tables (unrelated to customs)
```

Problems:
- **Flat single record** — no line item / order hierarchy. One calculation = one row.
- **No provincial tax table** — the prompt explicitly asked for "provincial sales tax or HST where applicable". This is completely absent from the schema and the code.
- **Rates copied into record by API** — `duty_rate` and `additional_tax` are set by the service from `TariffRate` lookup, not derived by rules from a parent relationship.
- **No `surtax_applicable` flag** — ship date cutoff logic from the prompt (`>= 2025-12-26`) is not modeled.
- **basic_demo tables are present** — `Customer`, `Product`, `Order`, `Item`, `ProductSupplier` are in the database from the base project and have no relationship to the customs functionality.

### customs_app

```
ProvinceTaxRate     ← lookup by province_code
CountryOrigin       ← includes surtax_applicable flag per country
HSCodeRate          ← base_duty_rate + surtax_rate per HS code
SurtaxOrder         ← header: ship_date, country, province, totals
SurtaxLineItem      ← line items: hs_code, qty, price → all amounts derived
```

Properly normalized. Rules propagate changes up and down automatically. Adding a line item recalculates the order totals. Changing a province code recalculates all PST/HST. None of this requires API changes.

---

## 5. Enforcement Scope: When Does Logic Fire?

This is the critical architectural difference.

**customs_appZ**: Logic fires only when a client POSTs to `/api/DutyCalculatorEndpoint/CalculateDuty`. If a row is inserted via:
- Standard JSON:API (`POST /api/DutyCalculation`)
- Direct SQLAlchemy (test data, scripts, admin)
- Any future integration

...the `early_row_event` will fire (recalculating from whatever `duty_rate` / `additional_tax` values were provided), but the tariff lookup, rate selection, and surtax determination **do not run**. The caller must supply correct rate values manually or get wrong answers.

**customs_app**: Rules fire on every transaction that touches `SurtaxOrder` or `SurtaxLineItem`, from any entry point — API, test data loader, Admin UI, future integrations. This is LogicBank's core value proposition, and this project actually uses it.

---

## 6. Missing Requirements

The prompt asked for several things that `customs_appZ` did not deliver:

| Requirement from prompt | customs_appZ | customs_app |
|---|---|---|
| Provincial sales tax / HST | ❌ Not implemented | ✅ `ProvinceTaxRate`, `Rule.formula` |
| Surtax applicability by ship date | ❌ Not modeled | ✅ `Rule.formula` on `surtax_applicable` |
| Multi-line customs entries | ❌ Single flat record | ✅ `SurtaxOrder` / `SurtaxLineItem` |
| Country-level surtax flag (USMCA exemptions) | ❌ Hardcoded in `TariffRate` data | ✅ `CountryOrigin.surtax_applicable` |
| Runnable UI with examples | ✅ Admin UI auto-generated (works) | ✅ Admin UI auto-generated (works) |
| Germany, US, Japan, China examples | ✅ Test data present | ✅ Test data present |

---

## 7. What "No Rules" Costs

Because there are no `Rule.sum` rollups, there is no order-level total to display or validate — there is only ever one calculation record per API call.

Because there are no `Rule.constraint` rules, invalid data (negative values, future ship dates) can be stored without error.

Because there is no `Rule.formula` for `surtax_applicable`, the ship date cutoff from the regulation (`>= 2025-12-26`) is ignored in this implementation.

The `declare_logic_message = "ALERT:  *** No Rules Yet ***"` line was left in `declare_logic.py` by the code generator. It is accurate.

---

## 8. The Request Pattern Missed

The prompt was a textbook Request Pattern (ROP) candidate:

> "calculate [outputs] when [inputs] is given"

The correct architecture:
1. `DutyCalculation` table with request fields (`hs_code_id`, `origin_country_id`, `value_amount`, `province_code`, `ship_date`)
2. `early_row_event` performs lookups and populates response fields (`duty_rate`, `duty_amount`, `surtax_applicable`, `pst_hst_amount`, `total_amount`)
3. API is a thin wrapper: parse request → insert row → return committed row

Instead, the API **is** the business logic, and the table is just a persistence afterthought.

The session transcript (`session_transcript`) documents that this was recognized retrospectively during the same session that created the project, and the pattern was used correctly in `customs_app`.

---

## 9. Summary

| Dimension | customs_appZ | customs_app |
|---|---|---|
| Logic location | API service (wrong layer) | `logic/logic_discovery/` (correct) |
| Rule type | Procedural `early_row_event` | Declarative `Rule.formula/sum/copy/constraint` |
| Declarative rules | 0 | 13 |
| API lines doing business logic | ~150 | 0 |
| Provincial tax modeled | No | Yes |
| Surtax date cutoff enforced | No | Yes |
| Multi-line orders | No | Yes |
| Logic fires on all entry points | No | Yes |
| Missing requirements | 3 of 4 core | 0 |

This is what the platform produces when the AI does not know what platform it is working with. The application runs, the endpoint returns answers, and the Admin UI works — but the architectural contract of GenAI-Logic (logic in rules, enforced everywhere) is entirely absent.


# Proposed Fixed Prompt

Two targeted changes: (1) province → single flat rate, (2) country/province/hs_code → FK references.

```
Create a fully functional application and database
 for CBSA Steel Derivative Goods Surtax Order PC Number: 2025-0917 
 on 2025-12-11 and annexed Steel Derivative Goods Surtax Order 
 under subsection 53(2) and paragraph 79(a) of the 
 Customs Tariff program code 25267A to calculate duties and taxes.
 Lookup tables: HSCodeRate (hs_code PK, surtax_rate), 
 CountryRate (country_code PK, surtax_rate), 
 Province (province_code PK, tax_rate — a single pre-combined rate whether HST or GST+PST).
 SurtaxLineItem references these by FK: hs_code_id, country_id, province_id.
 ship date >= '2025-12-26'.
 Create runnable ui with examples from Germany, US, Japan and China.
 Transactions are received as a CustomsEntry with multiple 
 SurtaxLineItems, one per imported product HS code.
```

**Key changes:**

- `"provincial sales tax or HST where applicable"` → `"Province (province_code PK, tax_rate — a single pre-combined rate whether HST or GST+PST)"`  eliminates the conditional/multi-column trigger
- `"country of origin"` + `"province code"` + `"hs codes"` → explicit `Lookup tables: ... SurtaxLineItem references these by FK` — forces FK relationships, enables `Rule.copy`
- Constraints (`ship_date >= entry_date`, `quantity > 0`, `unit_price > 0`) still need to be added explicitly or via CE
