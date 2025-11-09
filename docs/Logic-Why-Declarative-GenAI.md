title: Logic: Alternative GenAI Approaches
narrative: NL fork -> (Procedural vs Declarative+Engine); run A/B experiment; analyze long-term sustainability (correctness, maintenance, auditability)
version: 0.3 11/9/25
tags: [genai, declarative, business-logic, architecture, experiment]
status: draft

# Declarative GenAI for Business Logic: Architecture & Experiment

Natural language (NL) is now a credible, fast way to express intent. That creates an immediate architectural fork: after NL, do we (a) generate procedural code directly, trusting rapid GenAI improvement, or (b) generate a compact, declarative DSL that a runtime engine executes with formal dependency management? 

Direct code generation is a reasonable choice—models are improving quickly. But the choice materially affects correctness (missing dependency paths), maintainability (where to safely insert change), auditability, and resilience to continuing model evolution. So we tested both approaches on a realistic credit / pricing scenario, then evaluated the results in the light of current literature.

This page explains why—using a real experiment, a visual comparison, and the long‑term architectural implications.

## ⚡ TL;DR (Architecture First)
Natural language is the new starting point, and the architectural choice matters: **NL → procedural code** or **NL → DSL rules → engine**. We tested both: **5 rules (0 defects)** vs **≈220 procedural lines (2 dependency‑path defects)**. The rules engine derives and enforces the complete dependency graph inside each transaction; procedural generation lacks a formal mechanism to prove path completeness, even as models improve. Result: deterministic, auditable logic that survives maintenance cycles, with bespoke code confined to controlled extension points.

## 1. Alternatives (Architecture Setup Only)

### Procedural GenAI (Direct Code Path)
```
NL Prompt --> LLM Code Generation --> Handlers & Recalcs --> Enumerate Change Paths --> Variable Correctness
```

### Declarative GenAI (Rules + Engine Path)
```
NL Prompt --> LLM Rule Generation --> Rules Engine (derive graph, order, deltas, old/new parents) --> Deterministic Enforcement
```

_Evaluation and metrics follow only after the experiment below._

## 2. A/B Experiment (Human + AI Narrative + Evaluation)
External comparison: <https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/logic/procedural/declarative-vs-procedural-comparison.md>

### What Happened Here {#ai-narrative}

!!! quote "AI Narrative – What Happened Here"
	We asked **GitHub Copilot** to generate business logic code from natural language requirements.

	It generated **220 lines of procedural code**.

	We asked: **"What if the order's customer_id changes?"**
	Copilot found a critical bug and fixed it.

	We asked: **"What if the item's product_id changes?"**
	Copilot found another critical bug.

	Then, **unprompted**, Copilot wrote a comprehensive analysis explaining why procedural code—even AI-generated—cannot be correct for business logic.

	**What follows is that analysis, enhanced by Claude Sonnet 4.5 to make the structural impossibility explicit.**

| Approach | Lines | Defects | Defect Types |
|----------|-------|---------|--------------|
| Procedural (Copilot) | ≈220 | 2 | Missing old-parent decrement; missing unit_price re-copy on product change |
| Declarative (Rules) | 5 | 0 | — |

**Observed procedural omissions:**
1. `Order.customer_id` reassignment failed to decrement the old customer balance.
2. `Item.product_id` change failed to re-copy `unit_price` from the new Product.

**Why they occur:** Enumerating change paths (both directions of FK moves + transitive recalcs) is combinatorial; local code generation offers no completeness proof.

### Visual Comparison (Post-Experiment)

![Figure 3 – Declarative vs Procedural Logic Comparison](images/logic/declarative-vs-procedural-comparison.png)

#### Qualitative Comparison

| Aspect | NL→Code (Procedural) | NL→DSL→Engine (Declarative) |
|--------|----------------------|-----------------------------|
| Artifact Size | ≈220 lines | 5 rules |
| Defects Observed | 2 dependency-path omissions | 0 |
| Path Completeness | Unverifiable (enumerative) | Guaranteed for declared rules |
| Maintenance Focus | Trace handlers & side-effects | Adjust/add rule intent |
| Hallucination Surface | Large (many branches) | Minimal (fixed rule API) |
| Parent Reassignment | Manual dual adjustments | Automatic old/new balance updates |
| Product Substitution | Manual re-copy logic | Automatic via copy rule cascade |
| Performance | Often full recompute | Delta (incremental) updates |
| Auditability | Code review diff | Rule list + execution trace |

---

## 3. Long-Term Analysis

### 3.1 Why Model Improvement Alone Is Insufficient
Progress in models enhances *local* pattern generation; it does **not** supply a formal dependency execution framework. The distinction is architectural:
- Procedural: correctness depends on enumerating every change path explicitly (and keeping them all aligned during maintenance).
- Declarative: correctness is enforced because the engine derives and executes the dependency graph for all declared rule dependencies each transaction.

Supporting indicators:
- Multi-step reasoning challenges (see arXiv citation in the comparison doc) highlight state tracking fragility.
- Industry adoption of stronger typing (e.g., Octoverse’s TypeScript growth) signals a trend toward structural correctness aids as AI-generated code volume increases.

### 3.2 Enduring Architecture vs. Short-Term Fix

- Architecture vs. capability: Better models reduce local errors, but don’t turn enumerative code into a dependency execution framework. Engines provide the missing structure (graph derivation, ordering, old/new parent handling, constraints).
- Division of labor (future‑proof): Let AI translate NL → rules; let the engine execute semantics deterministically. As models improve, they write better rules—not replace the need for enforcement.
- Proven pattern, evolving engine: The DSL + engine approach has worked for decades at scale. Engines can keep advancing (pruning, deltas, batching) without changing rules you wrote today.
- Governance and audit: Enterprises need explainable artifacts and guarantees. Centralized rules + traceable execution satisfy compliance in ways scattered procedural handlers cannot.
- Always some bespoke code: Residual events/integration stay small and testable. The critical correctness surface lives in rules where the engine guarantees coverage.

Mini‑map (now → later):
```
Today:   NL  -->  Declarative Rules  -->  Engine (guarantees)
Future:  Better NL → Better Rules    -->  Same Guarantees (engine)
```
Implication: DSL + engine is not a stopgap—it’s the durable abstraction boundary that benefits more as GenAI improves.

### 3.3 Maintenance & Hallucination Mitigation
Two universal maintenance questions:

1. *What does this do now?* → Read 5 rules vs trace 220 lines.
2. *Where do I add/change logic safely?* → Add/modify a rule; engine re-derives order & affected parents.

Hallucinations shrink with intent-level artifacts: the model emits only rule statements; the engine provides execution semantics. Generated procedural code creates a broad surface for invented branches and edge-case gaps.

### 3.4 Pragmatic Boundary: NL Handles Most, There’s Always “Something”
Natural language + rules cover the correctness core (dependency graph, constraints). There is always residual bespoke logic (events, integration APIs, messaging). Keep it contained:

| Layer | Role | Determinism Impact |
|-------|------|--------------------|
| Declarative Rules | Sums, formulas, copies, constraints | Engine guarantees ordering & old/new parent adjustments inside the transaction |
| Events / Custom APIs | Integration & side-effects | Localized; cannot bypass rule enforcement (constraints still fire) |
| Regeneration | Re-run prompts to refine rule set | Discovery preserves extensions; no overwrite of bespoke code |

Implications:

- Correctness lives in rules, not prompts alone.
- Small code surface minimizes hallucination / drift.
- Maintenance cycle: change requirement → adjust a rule → engine re-derives graph.

## Appendix: References & Artifacts
| Artifact | Purpose | Location |
|---------|---------|----------|
| Declarative Rules (5) | Intent specification | `basic_demo/logic/logic_discovery/check_credit.py` |
| Procedural Sample | Service-style AI code | `basic_demo/logic/procedural/credit_service.py` |
| Full Comparison | Detailed experiment write-up | GitHub external link above |
| MCP Demo | Repro (Copilot → rules → constraint) | `Integration-MCP-AI-Example.md` |
| Deterministic Logic Rationale | Probabilistic vs deterministic | `Tech-Prob-Deterministic/` doc |

## Bottom Line
AI alone generates probabilistic procedural code with unverifiable path coverage. AI + Declarative Rules + Engine generates deterministic, auditable logic with guaranteed enforcement of declared business rules—and confines bespoke code to safe extension points.

This is the architectural foundation behind enterprise‑grade Vibe automation:

- Natural language for intent
- Declarative rules for correctness
- Engine for determinism
