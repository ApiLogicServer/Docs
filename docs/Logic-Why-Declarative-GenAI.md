---
title: Logic: Alternative GenAI Approaches
narrative: NL fork -> (Procedural vs Declarative+Engine); run A/B experiment; analyze long-term sustainability (correctness, maintenance, auditability)
version: 0.7 11/10/25
tone: professional, analytical (light on iconography).
tags: [genai, declarative, business-logic, architecture, experiment not a pitch]
status: draft
---

# Logic: GenAI Approaches

This page compares two architectural approaches for implementing business logic from natural-language (NL) requirements.

The comparison is two-fold:

* Experimental: implement both approaches, and compare how each handle dependency paths, change propagation, maintenance, and correctness.  
* Analytical: explore how both approaches will most likely fare over time, addressing business changes and rapid advancements in AI technology.


---

# 1. Alternatives

In both cases, the implementations must analyze the transaction (what actually changed) and provide (multi-table) dependency management to recompute related values and verify constraints.

## Procedural GenAI

```
+----------------+          +------------------+
|   NL Prompt    | -------> | Executable Code  |
+----------------+          +------------------+
```

Procedural code tries to enumerate change paths; missing one silently breaks logic (e.g., balance not updated).

---

## Declarative GenAI

```
+----------------+        +-------------------+        +------------------------+
|   NL Prompt    | -----> | Declarative Rules | -----> | Rules Engine Execution |
+----------------+        +-------------------+        +------------------------+
```

The model generates a compact declarative ruleset.

Execution correctness follows from implicit dependencies in declared logic, not from enumerated procedural branches.

---

# 2. Experiment

We ran an A/B experiment using Copilot to generate:
Procedural code must attempt to enumerate the relevant change paths. Missing any path can create silent logic gaps (e.g., balance not updated).
- **Declarative rules** (5 rules)  

With the following sample:

```bash title='Sample NL Logic'
1. Customer balance must be ≤ credit_limit  
2. Customer.balance = sum(Order.amount_total where date_shipped is null)  
3. Order.amount_total = sum(Item.amount)  
4. Item.amount = quantity × unit_price  
5. Item.unit_price ← Product.unit_price  
```

Then we reviewed the generated code.

## Declarative GenAI: 5 rules

```python title='Declarative Rules (experiment)'
Rule.constraint(validate=models.Customer,
   as_condition=lambda row: row.balance is None or row.credit_limit is None or row.balance <= row.credit_limit,
   error_msg="Customer balance ({row.balance}) exceeds credit limit ({row.credit_limit})")

Rule.sum(derive=models.Customer.balance, as_sum_of=models.Order.amount_total,
      where=lambda row: row.date_shipped is None)
Rule.sum(derive=models.Order.amount_total, as_sum_of=models.Item.amount)
Rule.formula(derive=models.Item.amount, as_expression=lambda row: row.quantity * row.unit_price)
Rule.copy(derive=models.Item.unit_price, from_parent=models.Product.unit_price)
```

In this experiment the 5 rules yielded complete propagation (no missed paths); the engine derived ordering and old/new parent updates automatically.

Procedural version: ≈220 lines. Two missed paths:

1. Reassign Order → different Customer (old Customer balance not decremented)
2. Reassign Item → different Product (`unit_price` not re-copied)

Copilot’s own summary: determining all dependency paths—especially old/new parent combinations—is difficult; a rules engine handles them more reliably. Full notes: [What Happened Here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/logic/procedural/declarative-vs-procedural-comparison.md#what-happened-here)


---

## Results & Comparison

| Aspect                 | Procedural                                     | Declarative |
|------------------------|-------------------------------------------------|-------------|
| Lines                  | ≈220                                            | 5           |
| Defects                | **2 bugs** — missed old-parent update; missed price re-copy | **0 bugs**   |
| Path completeness      | Unverifiable                                    | Derived     |
| Old/new parent handling| Manual                                          | Automatic   |
| Cascading recalcs      | Manual                                          | Engine-managed |
| Maintenance            | Distributed                                     | Centralized |
| Business transparency  | Low                                             | High        |
| Hallucination exposure | Higher                                          | Lower       |
| Incremental updates    | Often full recompute                            | Delta-only  |

---

_Developer reality_: inherit ≈220 lines you didn’t write, with subtle path bugs and minor hallucination artifacts; locating and fixing issues is harder than adjusting 5 rules.

_Coverage_: path completeness cannot be proven; omissions surface only when exercised. Tests detect gaps but cannot certify all FK variants; the engine derives affected paths every transaction.

---


![Figure 3 – Declarative vs Procedural Logic Comparison](images/logic/declarative-vs-procedural-comparison.png)

---

# 3. Analysis

At this point the experiment suggests a significant architectural advantage in this context for Declarative GenAI.

Given rapid AI evolution, we asked: *is this advantage temporary, or inherent?*


## Improved Models Are Unlikely to Address Quality Issues

The bugs we observed were serious, and difficult to find in a large code base.  But, will this continue to be the case as models rapidly improve?

Better models definitely improve pattern generation, but the quality issue is about deterministic dependency execution.
Old/new parent handling, ordered constraint checks, and multi-table propagation are execution semantics, not language-model capabilities.

Even a perfect LLM cannot guarantee completeness of enumerated procedural paths.
Procedural logic can be tested but not certified as complete; a rules engine
derives the full dependency graph and enforces declared rules within each
transaction.

> **Research note:** LLMs show consistent weaknesses in multi-step reasoning and state tracking—the same failure mode seen in dependency propagation. See: “Alice in Wonderland: Simple Tasks Showing Complete Reasoning Breakdown in State-Of-the-Art Large Language Models” (arXiv:2406.02061).

<details markdown>

<summary>More research on AI and Complex Transitive Dependencies</summary>

<br>

A study titled “LMs: Understanding Code Syntax and Semantics for Code Analysis” found that while large language models (LLMs) excel at syntax, they struggle with semantics — especially dynamic semantics, which includes behavior over time, dependencies and state changes. 
[Click here](https://arxiv.org/abs/2305.12138?utm_source=chatgpt.com){:target="_blank" rel="noopener"}.


A survey of AI usage in business found that AI still has limits in understanding domain-specific business rules, complex dependencies, verifying all cases, etc. 
[Click here](https://www.sciencedirect.com/science/article/pii/S219985312400132X?utm_source=chatgpt.com){:target="_blank" rel="noopener"}.

Industry commentary (e.g., from SonarSource) states explicitly: “AI models have limitations in understanding complex business logic or domain-specific requirements.” 
[Click here](https://www.sonarsource.com/resources/library/ai-code-generation-benefits-risks/?utm_source=chatgpt.com){:target="_blank" rel="noopener"}.

</details>
---

## Maintenance Remains a Challenge in a Large Code Base

Some logic will always be code (integrations, side effects, compliance hooks).

* Procedural GenAI: creates ~40× more generated code (≈220 vs 5). It becomes an archaeological expedition to understand the code, and determine where to insert changes.

* Declarative GenAI: add / change a rule - anywhere - and be confident the rule is always invoked, and in the right order.  This makes maintenance easier, faster, and more reliable.



## Architectural Boundary

Declarative logic separates:

Models generate intent; engines ensure deterministic execution.

- **Intent** (rules)  
- **Execution** (engine)  

> Real-world observation: In Versata deployments, switching from procedural recalculation to declarative delta-based rules produced significant performance improvements, including cases where multi-minute recalcs fell to seconds

Rules express intent and remain stable; the deterministic engine executes them consistently and can improve performance without regenerating logic.

### Rules as Probabilistic Guardrails

This boundary does not exclude AI from logic.  
It clarifies its role: AI handles probabilistic interpretation, while the engine performs deterministic execution.  
Deterministic rules act as guardrails that define when AI should run and how its outputs are governed (see [this article](https://medium.com/@valjhuber/probabilistic-and-deterministic-logic-9a38f98d24a8)).

This creates the balanced architecture enterprises require: AI for interpretation, engines for correctness.


### Common Questions

- **Why isn’t regeneration enough?**  
  Regenerating procedural code doesn’t ensure all dependency paths are covered.  
  Declarative rules avoid this by letting the engine derive paths automatically.

- **Will larger models eventually fix this?**  
  Bigger models improve intent interpretation, not deterministic propagation.  
  Old/new parent handling is an execution concern, not a model capability.

- **Can’t we just rely on tests?**  
  Tests find gaps but cannot prove coverage across all relationship variants.  
  A rules engine enforces ordering, propagation, and constraint checks on every transaction.

- **Does this help real maintenance?**  
  Yes. Rules capture intent in one place; the engine ensures correct execution.  
  This keeps the change surface small even as domains evolve.


---

# The Business Logic Agent: Concept

Enterprise systems require *both* probabilistic reasoning (AI) and deterministic execution (engines).  
AI is outstanding at interpreting intent; engines guarantee correctness.

Microsoft expresses this directly.  
As **Charles Lamanna** (CVP, Business & Industry Copilot) put it:

> “Sometimes customers don’t want the model to freestyle.  
> They want hard-coded business rules.”  
> — VentureBeat, August 26, 2025

That is the hybrid every enterprise asks for:

- **Probabilistic** → understand meaning  
- **Deterministic** → enforce behavior  

This is not a model-quality issue.  
It’s an **architectural boundary**:

- Models generate *rules* (intent)  
- Engines execute *logic* (correctness)

Just as an NL request should *call* a DBMS — not *build* one —  
NL business logic should call a rules engine, not emit procedural dependency code.

The NL → Rules → Engine pipeline is the **Business Logic Agent**:

> **AI expresses meaning; the engine guarantees correctness.**  
>  
> Declarative logic complements AI by providing deterministic execution.


# The Business Logic Agent: Architecture

Declarative GenAI becomes practical when we separate **what AI is good at** from **what engines are designed for**.

**1. AI is probabilistic — excellent at NL → structured meaning**

Large language models excel at interpreting requirements and expressing them as **concise declarative rules**.  
This is a pattern-recognition task — exactly where probabilistic systems shine.

This aligns with Microsoft’s current agent strategy.  

> “Sometimes customers don’t want the model to freestyle.  
> They don’t want the AI to make its own decisions.  
> **They want to have hard-coded business rules.**”  
> — VentureBeat interview, March 26, 2025

Lamanna describes the enterprise need for **deterministic business logic** alongside flexible AI reasoning — the exact hybrid architecture implemented here.

---

**2. Deterministic logic lies outside model comfort zones — so engines must handle it**

Multi-table propagation, old/new parent adjustments, ordered constraint checking, and delta-based recomputation require **deterministic execution semantics**, not probabilistic generation.

This is not a limitation of current AI.  
It is an **architectural boundary**:

- **Models generate intent**  
- **Engines guarantee correctness**

Just as you expect a natural-language query to **call a DBMS**, not **create a DBMS**,  
you expect NL business logic to **call a rules engine**, not emit procedural dependency code.

Even advanced models cannot “get better” at enumerating all dependency paths — procedural coverage cannot be proven, only tested.  
Engines, by contrast, derive and enforce full propagation paths automatically.

---

**3. Declarative rules sit exactly at this boundary**

- AI generates the rules (probabilistic → intent)  
- The engine evaluates and enforces them (deterministic → correctness)

This forms the hybrid execution model enterprises now require:

- **Probabilistic** → interpret meaning  
- **Deterministic** → enforce behavior  

This is also the model Microsoft now advocates with its agent flows:  
**deterministic business rules + flexible AI capabilities** (Lamanna, Microsoft CVP).

---

**4. The NL → Rules → Engine pipeline *is* the Business Logic Agent**


Declarative logic complements AI by providing deterministic, governable execution.  


---

# Summary

Procedural GenAI must enumerate dependency paths: error-prone, difficult to verify, and sensitive to omissions.

Declarative GenAI expresses logic concisely as rules; the engine derives and enforces required paths deterministically.

This:

- reduces hallucination impact  
- improves maintainability  
- enhances transparency  
- supports incremental updates  

Natural language provides intent.  
Declarative rules capture logic.  
The engine ensures execution.

> Declarative GenAI complements AI by providing deterministic execution.

---

# Appendix 1: Artifacts

| Item                         | Purpose                  | Location |
|------------------------------|--------------------------|---------|
| Declarative rules            | Intent specification     | `basic_demo/logic/logic_discovery/check_credit.py` |
| Procedural sample            | Generated code           | `basic_demo/logic/procedural/credit_service.py` |
| Full comparison              | Experiment notes         | GitHub link above |
| MCP demo                     | Copilot → rules → constraint | `Integration-MCP-AI-Example.md` |
| Deterministic logic rationale | Background               | `Tech-Prob-Deterministic/` |

---

# Appendix 2: See it live (next steps)

- **[Product Tour](Sample-Basic-Tour.md)**  
- **[MCP Integration](Integration-MCP.md)**  
- **[Admin App Tour](Admin-Tour.md)**  
- **[Automatic Multi-Table API](API.md)**  