# Why Declarative Wins

> ### ⚡ TL;DR
> Declarative logic + runtime guarantees enforcement of the declared rules within the transaction; procedural AI‑generated code can’t prove completeness.  
> LLMs show consistent weaknesses in multi‑step reasoning and state tracking ([arXiv:2406.02061](https://arxiv.org/abs/2406.02061)).  
> Controlled replication: **5 declarative rules = 0 defects vs ≈220 procedural lines = 2 dependency‑path defects.**  
> Declarative + runtime = deterministic integrity with incremental (delta) updates — not just faster, but structurally verifiable.

---

## 1️⃣ The Root Problem

Back-end business logic is a *dependency graph* — not a linear algorithm.  
Each update can cascade through multiple entities (Item → Order → Customer).  
Procedural code must explicitly enumerate every dependency path (old/new parent,  
foreign key changes, status updates). Missing even one path causes silent data corruption.

A declarative runtime eliminates this risk:
- Rules express *intent* (e.g., `balance = sum(Order.amount_total)`).
- The engine discovers dependencies automatically.
- It orders and executes rules within the SQL transaction.
- Consistency is guaranteed by construction.

---

## 2️⃣ Evidence from Research (Citable Sources)

**LLMs struggle with multi-step reasoning and state tracking.**  
Empirical studies show performance drops sharply on tasks that require maintaining  
intermediate state or reasoning over multiple dependent steps.

- *"Alice in Wonderland: Simple Tasks Showing Complete Reasoning Breakdown in State-Of-the-Art Large Language Models"* ([arXiv:2406.02061](https://arxiv.org/abs/2406.02061))  
  demonstrates that large models achieve high accuracy on isolated reasoning tasks  
  but fail when multiple steps must share evolving state — the same failure mode  
  seen in backend dependency propagation.

- GitHub Octoverse 2025 indicates TypeScript adoption surpassing JavaScript as developers seek  
  stronger static guarantees around expanding (often AI-generated) code. (Public summary: <https://github.blog/news-insights/octoverse/> – cite specific 2025 entry when permalink published.)

> Replace the generic Octoverse link above with the permanent 2025 article URL when available; keep wording factual (avoid causal overreach unless GitHub states it explicitly).

---

## 3️⃣ Controlled Replication: Copilot vs. Declarative Rules

| Requirement | Declarative (Rules) | Copilot-Generated (Procedural) | Result |
|--------------|--------------------|--------------------------------|---------|
| 5 business rules: credit limit, order sum, item sum, formula, price copy | 5 DSL statements (`logic/logic_discovery/check_credit.py`) | ≈ 220 lines service-style code (`logic/procedural/credit_service.py`) | Declarative: 0 defects • Procedural: 2 dependency-path defects |

**Observed procedural omissions:**
1. `Order.customer_id` reassignment: old customer's balance not decremented (missing old-parent adjustment path).  
2. `Item.product_id` change: `unit_price` not re-copied (product substitution path absent).

These are *dependency-path omissions* — not syntax errors —  
and demonstrate that local code generation cannot ensure global consistency.

**Declarative result:**  
Same requirements implemented as five rules, executed by the LogicBank runtime.  
All dependencies discovered automatically, correct ordering enforced, no code regenerated.

---

## 4️⃣ Performance Observation

Declarative logic executes incrementally (Δ-based recompute).  
Internal prior production measurements (Versata-style incremental adjustment pattern) showed multi-table recalculation shrinking from minutes to seconds.  
We attribute this to dependency pruning (apply only deltas) rather than bespoke hand tuning.  
> Performance claim is internal empirical; provide a reproducible script or redact for external publication if independent replication is required.

---

## 5️⃣ Why Model Improvement Alone Is Not Sufficient

Even a perfect LLM cannot *prove completeness* of enumerated procedural paths.  
The challenge is architectural, not model accuracy:

| Approach | Guarantee Scope |
|-----------|-----------------|
| **Procedural (AI-generated)** | Enumerates some dependency paths; cannot prove completeness over all FK and transitive change variants. |
| **Declarative + Runtime** | Engine derives full dependency graph and enforces all declared rules within each transaction (atomic & ordered). |

Declarative automation therefore **eliminates an unsolvable verification problem**  
for AI-generated procedural code.

---

## 6️⃣ Strategic Implication for Microsoft

Copilot and Power Platform unify the *front end* — natural-language creation of UI and workflows.  
GenAI-Logic unifies the *back end* — natural-language creation of data, logic, and governed APIs.

Together they deliver what neither can alone:  
AI-assisted, end-to-end system generation that is both *fast* and *correct.*

---

> **Summary:**  
> Declarative logic doesn’t compete with AI — it completes it.  
> It converts probabilistic generation into deterministic, auditable execution by shifting from path enumeration to rule enforcement.

---
### Appendix: Concrete Artifacts Referenced
| Artifact | Path | Purpose |
|---------|------|---------|
| Declarative rules (5) | `basic_demo/logic/logic_discovery/check_credit.py` | Intent-level specification (credit chain) |
| Procedural sample | `basic_demo/logic/procedural/credit_service.py` | Generated/hand-edited service code (illustrates missed paths) |
| Comparison narrative | `basic_demo/logic/procedural/declarative-vs-procedural-comparison.md` | Detailed experiment write-up |
| MCP demo flow | `basic_demo/readme_ai_mcp.md` | 3-prompt reproducible Copilot → rules → enforcement demo |

> Showing Joel live: run Prompt 3 (quantity→100) to reproduce the dependency log that aligns with the chain described above.