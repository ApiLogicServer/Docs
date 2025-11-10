---
title: Logic: Alternative GenAI Approaches
narrative: NL fork -> (Procedural vs Declarative+Engine); run A/B experiment; analyze long-term sustainability (correctness, maintenance, auditability)
version: 0.6 11/9/25
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

Procedural code must enumerate *all* change paths. Missing any path causes silent logic gaps that destroy databse integrity (e.g., balance not updated).

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

```python title='Declarative Rules DSL Code created from requirements'
In this experiment, the declarative version — just 5 rules — showed no omissions; the engine derived all required propagation paths automatically.

Rule.sum(derive=models.Customer.balance, as_sum_of=models.Order.amount_total, where=lambda row: row.date_shipped is None)

The experiment highlights a significant architectural advantage for Declarative GenAI in this type of dependency management.
Rule.formula(derive=models.Item.amount, as_expression=lambda row: row.quantity * row.unit_price)

Rule.copy(derive=models.Item.unit_price, from_parent=models.Product.unit_price)
Even advanced LLMs cannot guarantee completeness of enumerated procedural paths — coverage can be tested but not proven. The difference is architectural:
---

 AI reduces typing cost, but it does not eliminate the engineering need to ensure multi‑table dependency coverage.
We asked Copilot to implement the same NL logic procedurally.  
The procedural version arrived confidently: about 220 lines that looked reasonable on first inspection.

Rules tend to remain stable, while engine improvements accumulate automatically.

1. **Reassign Order → different Customer**  
   The new Customer’s balance increased, but the old Customer’s balance never decreased.

2. **Reassign Item → different Product**  
   The `unit_price` updated on the new Product, but was never re-copied after reassignment.

Both were routine dependency paths — and both were quietly missed.

When asked why, Copilot offered an unexpectedly candid analysis: 

> Determining all dependency paths—especially old/new parent combinations—is difficult.  
> A declarative rules engine handles these dependencies more reliably. 

It even produced a small comparative write-up of its own, seemingly a bit alarmed at the result:

> [Copilot’s story: What Happened Here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/logic/procedural/declarative-vs-procedural-comparison.md#what-happened-here)

The declarative version — just 5 rules — had no omissions; the engine derived all required propagation paths automatically.


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

At this point the experiment suggests a clear architectural advantage for Declarative GenAI.

Given rapid AI evolution, we asked: *is this advantage temporary, or inherent?*

Model scale improves pattern generation but **does not** provide deterministic dependency execution.  
Enumerating all update paths in procedural code remains combinatorial; declarative rules paired with an engine externalize dependency semantics in a way that continues to hold as models advance.

## Model Improvement

Better models improve pattern generation, not dependency execution.

Declarative logic reduces hallucination exposure by narrowing the model’s role to generating rule intent while execution semantics remain deterministic in the engine.

### Why model improvement alone is not sufficient

Even a perfect LLM cannot prove completeness of enumerated procedural paths. The difference is architectural:

| Approach | Guarantee Scope |
|---------|------------------|
| Procedural (AI‑generated) | Enumerates some dependency paths; cannot prove completeness over all FK and transitive change variants |
| Declarative + Engine | Engine derives full dependency graph and enforces all declared rules within each transaction (ordered and atomic) |

> Research note: LLMs show consistent weaknesses in multi‑step reasoning and state tracking, the same failure mode seen in dependency propagation. See “Alice in Wonderland: Simple Tasks Showing Complete Reasoning Breakdown in State‑Of‑the‑Art Large Language Models” (arXiv:2406.02061).

---
## Maintenance Reality

A common misconception is that future maintenance simply means updating the NL description and regenerating everything. That assumes all system behavior can be expressed declaratively. In practice, **there is always some portion of application behavior that requires hand-coded logic** — integrations, compliance checks, side effects, performance tuning, and domain-specific edge cases.

These behaviors cannot be safely regenerated from NL because they depend on operational context (APIs, security, timing, retries, idempotency, compensation, external state). Regeneration risks overwriting patches and breaking local adaptations.

Because some behavior must always live in code, developers must understand and safely extend the existing system. Large procedural artifacts increase the reasoning surface and create drift risk; declarative rules externalize business intent and confine complexity to a small, stable surface. The engine guarantees dependency propagation, while code handles the unavoidable parts that NL cannot describe.

Even with AI generation, systems accumulate changes: new attributes, integration hooks, compliance checks, and performance tweaks. Because something always changes, *developers must safely understand and extend existing logic.*

Observed in this experiment:

- Procedural surface ≈220 lines (5 rules of intent expanded into handlers).
- Two routine FK path defects (old‑parent decrement; `unit_price` re‑copy).
- Path completeness is not mechanically provable; omissions surface at runtime.

Therefore:

- AI reduces typing cost; it does not remove the need to prove multi‑table dependency coverage.
- Larger generated artifacts increase cognitive load and drift risk (regeneration may obscure patches).
- Declarative rules externalize intent; the engine guarantees ordering, propagation, and delta updates, reducing the reasoning surface for safe change.

---

## Architectural Boundary

Declarative logic separates:

- **Intent** (rules)  
- **Execution** (engine)  

Rules remain stable; engine improvements accumulate automatically.

> Real-world observation: In Versata deployments, switching from procedural recalculation to declarative delta-based rules produced significant performance improvements, including cases where multi-minute recalcs fell to seconds

Rules express intent and remain stable; the deterministic engine executes them consistently and can improve performance without regenerating logic.

### Common Questions

- **Why isn’t regeneration enough?**  
  Regenerating procedural code doesn’t ensure all dependency paths are covered.  
  Declarative rules avoid this by letting the engine derive paths automatically.

- **Will larger models eventually fix this?**  
  Bigger models improve intent interpretation, not deterministic propagation.  
  Old/new parent handling is an execution concern, not a model capability.

- **Can’t we just rely on tests?**  
  Tests find gaps but cannot prove coverage across all relationship variants.  
  A rules engine guarantees ordering, propagation, and constraint checks.

- **Does this help real maintenance?**  
  Yes. Rules capture intent in one place; the engine ensures correct execution.  
  This keeps the change surface small even as domains evolve.


---

## Making Changes

Key questions become easier:

- **What does this do now?**  
  Rules provide a single, centralized description.  Procedural code is more like an archeaological expedition.

- **Where do I make a change?**  
  Update or add rules without tracing scattered procedural effects.  Be confident it will be called, and in the proper order.

---

## Residual Code

Custom logic (events, integrations) always exists.  
Declarative rules ensure the correctness-critical core remains deterministic.

---

# The Business Logic Agent I

Enterprise systems require *both* probabilistic reasoning (AI) and deterministic execution (engines).  
AI is outstanding at interpreting intent; engines guarantee correctness.

Microsoft expresses this directly.  
As **Charles Lamanna** (CVP, Business & Industry Copilot) put it:

> “Sometimes customers don’t want the model to freestyle.  
> They want hard-coded business rules.”  
> — VentureBeat, March 26, 2025

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
> Declarative logic doesn’t replace AI — it completes it.


# The Business Logic Agent II

Declarative GenAI becomes practical when we separate **what AI is good at** from **what engines are designed for**.

**1. AI is probabilistic — excellent at NL → structured meaning**

Large language models excel at interpreting requirements and expressing them as **concise declarative rules**.  
This is a pattern-recognition task — exactly where probabilistic systems shine.

This aligns with Microsoft’s current agent strategy.  
As **Charles Lamanna** (Microsoft CVP, Business & Industry Copilot) explained:

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

**AI expresses meaning; the engine executes it with guaranteed correctness.**

Declarative logic does not replace AI — it completes it.  
It converts probabilistic generation into deterministic, auditable, multi-table system behavior.




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

Declarative logic doesn’t compete with AI — it completes it. It converts probabilistic generation into deterministic, auditable execution by shifting from path enumeration to rule enforcement.


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
