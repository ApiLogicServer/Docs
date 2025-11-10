---
title: Logic: Alternative GenAI Approaches
narrative: NL fork -> (Procedural vs Declarative+Engine); run A/B experiment; analyze long-term sustainability (correctness, maintenance, auditability)
version: 0.6 11/9/25
tone: professional, analytical (light on iconography)
tags: [genai, declarative, business-logic, architecture, experiment]
status: draft
---

# Logic: GenAI Approaches

This page compares two architectural approaches for implementing business logic from natural-language (NL) requirements.

The focus is analytical: how each approach handles dependency paths, change propagation, maintenance, and correctness.

## 30 second summary

GenAI models can generate procedural code, but maintaining correct multi-table business logic as systems evolve requires anticipating all dependency paths.

The architectural fork is straightforward:

**Procedural GenAI**: generate procedural code that must enumerate dependency paths  
**Declarative GenAI**: generate declarative rules that a deterministic engine evaluates using an explicit dependency graph.

In practice, anticipating all paths is difficult to do reliably in procedural form.

---

## Why This Matters (for enterprises)

- Incorrect invoices and pricing when rollups are missed  
- Wrong credit approvals when balances don’t fully recompute  
- Silent gaps when foreign keys change (old/new parent updates)  
- Local patches multiply; drift and regressions increase  
- Compliance/auditability degrade; maintenance costs rise  

---

## Experiment at a Glance

|                     | Declarative (Rules) | Procedural (Generated Code) |
|---------------------|---------------------|------------------------------|
| Size                | 5 rules             | ~220 lines                   |
| Defects found       | 0                   | 2                            |
| Dependency coverage | Derived              | Missed old-parent; missed re-copy |

---

## How this powers the platform

This architectural choice underpins Enterprise Vibe Automation:

- generating complete business systems (Database + API + Admin UI + Logic) in minutes,  
- with logic that remains correct as the system evolves.

See the **[Product Tour](Sample-Basic-Tour.md)**,  
the **[Admin App](Admin-Tour.md)**,  
and the **[Automatic API](API.md)**.

---

## A useful analogy: spreadsheets → transactions

Spreadsheets transformed financial analysis by letting analysts declare formulas over cells; the spreadsheet engine handled recalculation order and propagated changes automatically. Declarative rules provide the same leap for multi‑table transactions:

- You declare intent (constraints, sums, copies, formulas).  
- The engine derives the dependency graph, orders evaluation, and applies only deltas — all within the transaction.  

Conceptually: rules do for transactional correctness what spreadsheets did for analytical modeling — they externalize dependency semantics so humans express intent, and the runtime guarantees consistent recomputation.

This is a parallel, not a competition: spreadsheets excel at analysis; rules+engine govern live transactional updates with ACID guarantees and an audit trail.

---

## Sample NL Logic (the 5 rules)

1. Customer balance must be ≤ credit_limit  
2. Customer.balance = sum(Order.amount_total where date_shipped is null)  
3. Order.amount_total = sum(Item.amount)  
4. Item.amount = quantity × unit_price  
5. Item.unit_price ← Product.unit_price  

---

## Methodology

1. Provide NL requirements (5 rules) to Copilot.  
2. Capture initial output (procedural vs declarative).  
3. Ask targeted questions about routine updates:  
   - Reassign Order to different Customer  
   - Reassign Item to different Product  
4. Observe defects reported by Copilot.  
5. Compare size, defect count, dependency coverage.  

Rationale: FK change scenarios reliably reveal whether dependency paths were fully anticipated.

---

# 1. Alternatives

## Procedural GenAI

```
+----------------+          +------------------+
|   NL Prompt    | -------> | Executable Code  |
+----------------+          +------------------+
```

The generated code must:

- Implement handlers  
- Manage dependency paths  
- Handle old/new parent adjustments  
- Recompute related values  
- Maintain correctness through maintenance cycles  

Because dependency structure is implicit in code, completeness depends on anticipating every change scenario.

---

## Declarative GenAI

```
+----------------+        +-------------------+        +------------------------+
|   NL Prompt    | -----> | Declarative Rules | -----> | Rules Engine Execution |
+----------------+        +-------------------+        +------------------------+
```

The model generates a compact declarative ruleset.

Execution correctness follows from declared dependencies, not from enumerated procedural branches.

The engine:

- Derives dependency graph  
- Computes ordering  
- Applies deltas  
- Manages old/new parent updates  
- Enforces constraints  

This yields a clear, centralized description of intended behavior.

---

# 2. Experiment

We ran an A/B experiment using Copilot to generate:

- **Procedural code** (~220 lines)  
- **Declarative rules** (5 rules)  

Then we interrogated the procedural implementation using ordinary FK changes.

## Results

Copilot generated ~220 lines of procedural code.  
When evaluated, Copilot found **two defects in its own output**.

### Declarative GenAI (5 Rules)

```python
Rule.constraint(
    validate=models.Customer,
    as_condition=lambda row:
        row.balance is None or
        row.credit_limit is None or
        row.balance <= row.credit_limit,
    error_msg="Customer balance ({row.balance}) exceeds credit limit ({row.credit_limit})"
)

Rule.sum(
    derive=models.Customer.balance,
    as_sum_of=models.Order.amount_total,
    where=lambda row: row.date_shipped is None
)

Rule.sum(
    derive=models.Order.amount_total,
    as_sum_of=models.Item.amount
)

Rule.formula(
    derive=models.Item.amount,
    as_expression=lambda row: row.quantity * row.unit_price
)

Rule.copy(
    derive=models.Item.unit_price,
    from_parent=models.Product.unit_price
)
```

---

### Procedural GenAI (220 lines)

**Two defects surfaced immediately:**

1. **Reassign Order → different Customer**  
   - Old Customer balance was not decremented.

2. **Reassign Item → different Product**  
   - `unit_price` was not re-copied.

Copilot’s summary:

> Determining all dependency paths—especially old/new parent combinations—is difficult.  
> A declarative rules engine handles these dependencies more reliably.

Detailed comparison:  
[What Happened Here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/logic/procedural/declarative-vs-procedural-comparison.md#what-happened-here)

---

## Summary of Experiment

| Approach     | Lines | Defects | Notes |
|--------------|-------|---------|-------|
| Procedural   | ≈220  | 2       | Missed old-parent update; missed price re-copy |
| Declarative  | 5     | 0       | Engine derives all paths |

---

## Observed Facts: AI‑Generated Procedural Logic

- Code volume in this experiment was ≈220 lines vs 5 rules.
- Two defects appeared during routine FK changes (old‑parent decrement, re‑copy unit_price).
- Occasional unused imports or minor inconsistencies were present (hallucination‑adjacent noise).
- Path completeness is not mechanically verifiable; missing paths typically surface when executed against real transactions.
- Tests detect omissions but cannot prove coverage; the rules engine derives affected paths each transaction.
- Developers express concern about reviewing and maintaining large generated artifacts, especially across regeneration cycles.

---

## Comparison (Qualitative)

| Aspect                  | Procedural | Declarative |
|-------------------------|------------|-------------|
| Artifact size           | Large      | Small       |
| Path completeness       | Unverifiable | Derived   |
| Maintenance             | Distributed | Centralized |
| Old/new parent handling | Manual      | Automatic |
| Cascading recalcs       | Manual      | Engine-managed |
| Business transparency   | Low         | High       |
| Hallucination exposure  | Higher      | Lower      |
| Incremental updates     | Often full recompute | Delta-only |

---

## Visual Summary

![Figure 3 – Declarative vs Procedural Logic Comparison](images/logic/declarative-vs-procedural-comparison.png)

---

# Business Logic Agent (foundation)

GenAI expresses intent as rules; the deterministic engine enforces dependencies, order, and constraints for every transaction.  
The agent orchestrates NL → rules, while the engine enforces dependency ordering, deltas, and constraints.

See: **[MCP Integration](Integration-MCP.md)**

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

Research note: LLMs show consistent weaknesses in multi‑step reasoning and state tracking, the same failure mode seen in dependency propagation. See “Alice in Wonderland: Simple Tasks Showing Complete Reasoning Breakdown in State‑Of‑the‑Art Large Language Models” (arXiv:2406.02061).

---

## Architectural Boundary

Declarative logic separates:

- **Intent** (rules)  
- **Execution** (engine)  

Rules remain stable; engine improvements accumulate automatically.

Real-world note: Versata deployments replacing procedural recalc logic with declarative delta-based logic reduced transaction time **from ~3 minutes to a few seconds**.

Declarative rules also provide transparent behavior for validation and audit.

### Objections & Responses (condensed)

- **“AI can just regenerate the code.”** Regeneration does not validate coverage; missing dependency paths fail silently until a transaction exposes them.
- **“We’ll add tests.”** Tests detect omissions; a rules engine prevents them by automatically deriving affected paths (no enumeration required).
- **“Bigger models will learn this.”** Model scale improves pattern reproduction, not runtime old/new parent propagation semantics.
- **“Our domain is small.”** Growth compounds relationships; refactors reopen latent gaps without a semantic engine.
- **“We use hooks/ORM events already.”** Hooks still rely on manual enumeration of old/new parent adjustments — same failure mode.

---

## Maintenance

Key questions become easier:

- **What does this do now?**  
  Rules provide a single, centralized description.

- **Where do I make a change?**  
  Update or add rules without tracing scattered procedural effects.

---

## Residual Code

Custom logic (events, integrations) always exists.  
Declarative rules ensure the correctness-critical core remains deterministic.

---

# 4. Artifacts

| Item                         | Purpose                  | Location |
|------------------------------|--------------------------|---------|
| Declarative rules            | Intent specification     | `basic_demo/logic/logic_discovery/check_credit.py` |
| Procedural sample            | Generated code           | `basic_demo/logic/procedural/credit_service.py` |
| Full comparison              | Experiment notes         | GitHub link above |
| MCP demo                     | Copilot → rules → constraint | `Integration-MCP-AI-Example.md` |
| Deterministic logic rationale | Background               | `Tech-Prob-Deterministic/` |

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
