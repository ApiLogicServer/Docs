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

- **Procedural code** (~220 lines)  
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
Rule.constraint(validate=models.Customer, as_condition=lambda row: row.balance <= row.credit_limit or row.balance is None or row.credit_limit is None ,
    error_msg="Customer balance ({row.balance}) exceeds credit limit ({row.credit_limit})")

Rule.sum(derive=models.Customer.balance, as_sum_of=models.Order.amount_total, where=lambda row: row.date_shipped is None)

Rule.sum(derive=models.Order.amount_total, as_sum_of=models.Item.amount)

Rule.formula(derive=models.Item.amount, as_expression=lambda row: row.quantity * row.unit_price)

Rule.copy(derive=models.Item.unit_price, from_parent=models.Product.unit_price)
```

---

## Procedural GenAI (~220 lines, 2 bugs)

We asked Copilot to implement the same NL logic procedurally.  
The procedural version arrived confidently: about 220 lines that looked reasonable on first inspection.

Then we tried two ordinary operations:

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

Real-world note: Versata deployments replacing procedural recalc logic with declarative delta-based logic reduced transaction time **from ~3 minutes to a few seconds**.

Declarative rules also provide transparent behavior for validation and audit.

### Common Questions (condensed)

- **“AI can just regenerate the code.”** Regeneration does not validate coverage; missing dependency paths fail silently until a transaction exposes them.
- **“We’ll add tests.”** Tests detect omissions; a rules engine prevents them by automatically deriving affected paths (no enumeration required).
- **“Bigger models will learn this.”** Model scale improves pattern reproduction, not runtime old/new parent propagation semantics.
- **“Our domain is small.”** Growth compounds relationships; refactors reopen latent gaps without a semantic engine.
- **“We use hooks/ORM events already.”** Hooks still rely on manual enumeration of old/new parent adjustments — same failure mode.

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

# Artifacts

| Item                         | Purpose                  | Location |
|------------------------------|--------------------------|---------|
| Declarative rules            | Intent specification     | `basic_demo/logic/logic_discovery/check_credit.py` |
| Procedural sample            | Generated code           | `basic_demo/logic/procedural/credit_service.py` |
| Full comparison              | Experiment notes         | GitHub link above |
| MCP demo                     | Copilot → rules → constraint | `Integration-MCP-AI-Example.md` |
| Deterministic logic rationale | Background               | `Tech-Prob-Deterministic/` |

---


# The Business Logic Agent

Declarative GenAI becomes practical when we separate what AI is good at from what engines are designed for.

1. **AI excels at NL → structured meaning.**  
   Models are outstanding at translating natural-language requirements into concise declarative rules. This is a pattern-recognition task, well within current model strengths.

2. **Dependency analysis lies outside model comfort zones — so engines must handle it.**  
   Multi-table propagation, old/new parent adjustments, ordered constraint checking, and delta-based recomputation require deterministic execution semantics.  
   This is not a limitation of AI so much as an architectural boundary: these responsibilities have always belonged to engines (DBMSes, workflow engines, rules engines), not generators.<br>
   - For example, you expect an NL query to execute by *calling* a DBMS, not *creating* a DBMS.

3. **Declarative rules sit exactly at this boundary.**  
   AI generates the intent (the rules).  
   The engine guarantees correctness (ordering, propagation, constraints, deltas).  
   Developers adjust only the small portion that truly requires procedural code.

This **NL → Rules DSL → Engine** pipeline is the Business Logic Agent:  
> AI expresses meaning; the engine executes it with deterministic correctness.  
> Declarative logic does not replace AI — it completes it.


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

# See it live (next steps)

- **[Product Tour](Sample-Basic-Tour.md)**  
- **[MCP Integration](Integration-MCP.md)**  
- **[Admin App Tour](Admin-Tour.md)**  
- **[Automatic Multi-Table API](API.md)**  
