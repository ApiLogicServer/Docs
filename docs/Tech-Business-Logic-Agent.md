# Governed Agentic Business Logic (GABL)

💡 **Governed Agentic Business Logic** unifies deterministic and probabilistic logic in a single natural-language model, executed under deterministic governance and exposed as an MCP-discoverable server.

A GABL / Business Logic Agent integrates:

- **Deterministic Logic** — declarative rules that must always be correct  
- **Probabilistic Logic** — AI-driven reasoning under uncertainty  
- **Deterministic Execution** — a rules engine that ensures correctness and governance  
- **MCP Discovery** — AI assistants can safely discover and interact with system capabilities

---

## 1. Introduction

For decades, enterprise systems have depended on deterministic business logic — rules that enforce policy such as credit limits, multi-table derivations, and data consistency.

These rules were traditionally hand-coded, buried in controllers and methods, and expensive to build, test, and maintain. In most systems, deterministic logic consumes nearly half the total development cost.

AI changes both the cost model and the possibility space.

Natural language makes it practical to express deterministic rules directly — in a form that is already declarative, stating **what must be true** rather than **how to compute it**. This avoids procedural glue code, preserves business intent, and can be far more concise than the equivalent procedural implementation (for an AI-generated study, [click here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/logic/procedural/declarative-vs-procedural-comparison.md){:target="_blank" rel="noopener"}; the procedural code is [here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/logic/procedural/credit_service.py){:target="_blank" rel="noopener"})..

Beyond cost and time reduction, AI introduces something entirely new: **probabilistic logic** — reasoning, ranking, optimizing, and choosing the “best” option under uncertain conditions. This was never feasible to hand-code because it depends on natural language, context, world knowledge, and intelligent choice.

Both kinds of logic matter.  
Both are needed in modern systems.  
But they behave very differently.

This paper describes an architecture that unifies them — allowing a **single natural-language description** to produce:

- **Deterministic Logic (DL):** declarative, unambiguous business rules  
- **Probabilistic Logic (PL):** generated Python handlers that call the LLM only where needed  

…all governed by a deterministic rules engine that ensures correctness, safety, and explainability.

This is **Governed Agentic Business Logic (GABL)** — a governed agent runtime that allows AI to take real actions over enterprise data, enforced by deterministic business logic and bounded probabilistic reasoning.

---

## 2. How does AI fit in?

AI does not replace deterministic logic — it **amplifies** it.

Traditionally, business logic was hand-coded in procedural form. Even simple policies expanded into long sequences of steps: retrieve this, loop over that, compute values, manage dependencies, enforce constraints, call downstream services. A single business requirement often ballooned into hundreds of lines of procedural code.

Natural language changes this model completely.

The natural-language descriptions used here are **declarative**, not procedural:

- They state **what must be true**, not how to compute it.  
- They capture policy in a form business users can read.  
- They avoid procedural glue code.  
- They are dramatically more concise than procedural equivalents.  
- They provide a clean foundation for generation and governance.

For example:

> “The Customer’s balance is the sum of the open Orders.”

This is already declarative. It expresses the business intent, not the mechanics.

Here is a concrete example of a unified, declarative natural-language description:

### Declarative NL Logic

**Use case: Check Credit**

1. The Customer's balance is less than the credit limit  
2. The Customer's balance is the sum of the Order amount_total where date_shipped is null  
3. The Order's amount_total is the sum of the Item amount  
4. The Item amount is the quantity * unit_price  
5. The Price is copied from the Product  

**Use case: App Integration**

1. Send the Order to Kafka topic `order_shipping` if `date_shipped` is not None.

These two use cases are expressed entirely in declarative natural language — including deterministic rules (1–5) and an integration rule.

---

## 3. Declarative Logic & DSL — NL → DSL → Engine

Natural language must ultimately produce something **unambiguous and enforceable**.

That is why deterministic logic is expressed as a **declarative DSL**, not procedural code.

### Why DSL instead of codegen?

- Procedural code scatters logic across handlers and methods.  
- Regeneration overwrites fixes and disrupts iterative development.  
- Dependency bugs hide in glue code — often invisible until runtime.  
- AI struggles with ordering, before/after comparisons, and transitive dependencies.  
- A DSL keeps intent clean, centralized, and auditable.

A deterministic runtime logic engine enforces:

- dependency management  
- ordering  
- propagation (chaining)  
- constraint checking  
- pruning  
- debugging and traceability  

This is the **NL → DSL → Engine** model:

> AI captures policy, the DSL expresses it, and the engine executes it correctly.

But deterministic rules are only half the story. Modern systems also require logic we rarely attempted to hand-code — logic that depends on reasoning, exploration, and world context.

That brings us to the second mode of logic AI enables: **probabilistic logic**.

---

## 4. AI introduces a second mode of logic: Probabilistic Logic

Alongside deterministic logic, AI brings probabilistic logic — reasoning under uncertainty.

Examples include:

- choosing the best supplier given cost, lead time, risk, and world conditions  
- forecasting demand  
- ranking alternatives  
- classification and recommendation  
- optimization under competing factors  

There is no single “correct” answer. AI explores possibilities and proposes good answers, not guaranteed ones.

This is fundamentally different from deterministic rules.

---

## 5. The Business Logic Agent (BLA)

A **Business Logic Agent** is a packaged, MCP-discoverable server created from natural-language declarations.

It unifies:

- natural-language business policy (deterministic, probabilistic, and integration logic)  
- generated logic — deterministic rules (DL) and probabilistic handlers (PL)  
- deterministic execution that governs every operation and calls the LLM only where PL is declared  
- MCP exposure so AI assistants can safely discover and act on system capabilities  

The BLA provides a single governed place for business logic — created from NL, executed deterministically, and exposed to AI assistants through MCP.

### 5.1 Definition — what a BLA is

A Business Logic Agent consists of:

- unified NL declarations describing business rules and reasoning  
- generated logic — deterministic rules (DSL) and probabilistic handlers (PL)  
- deterministic execution that ensures correctness and safety  
- MCP exposure so AI assistants can discover and act on system capabilities  

The BLA is not a framework; it is a generated, governed logic component.

### 5.2 Declaration & generation (D1–D2) — how a BLA is created

The creation process begins with natural language.

**D1 — Unified Natural-Language Input**

Developers describe business policies — deterministic rules, probabilistic decisions, and integration triggers — in one incremental NL description. It supports iterative development: each new declaration extends the existing logic model (e.g., one use case at a time).

**D2 — GenAI generates deterministic and probabilistic logic**

GenAI calls the LLM to create:

- **Deterministic Logic (DL):** Python DSL rules (formulas, sums, counts, constraints, events)  
- **Probabilistic Logic (PL):** Python event handlers containing structured LLM calls  
- **Integration events:** Python calls to Kafka, etc.

These generated artifacts form the BLA’s internal logic.

### 5.3 Runtime behavior (R1–R2) — how a BLA executes

At runtime, the BLA provides governed, predictable execution.

**R1 — Deterministic execution**

The rules engine evaluates all DL:

- multi-table propagation  
- derivations  
- constraints  
- before/after events  

No LLM is invoked during deterministic execution.

**R2 — Probabilistic execution (only where declared)**

If a rule requires reasoning or optimization, the generated PL handler fires:

- it calls the LLM  
- returns a value  
- the deterministic engine validates the result before applying it  

This hybrid model lets AI reason **inside deterministic guardrails**.

### 5.4 MCP packaging — how a BLA is exposed

The BLA creates a JSON:API and is exposed as `/.well-known/mcp.json` according to the Model Context Protocol (MCP).

AI assistants acting as MCP clients can:

- discover schema and relationships  
- ask questions  
- issue validated API calls  
- receive constraint violations and deterministic messages  
- take safe action within governed rules  

All operations invoked by AI pass through the deterministic engine.

### 5.5 Creation flow — summary (D1 → D2 → R1 → R2)

This summarizes how a Business Logic Agent is created and executed:

- **D1:** Unified NL declaration  
- **D2:** GenAI generates DSL + PL  
- **R1:** Deterministic rules execute  
- **R2:** Probabilistic calls occur only where declared  

> *(Insert diagram: `Bus-Logic-Agent.png`)*

### 5.6 Using the BLA in the enterprise — architecture

Once packaged via MCP, the BLA behaves like a governed logic component in the enterprise:

- AI assistants interact through MCP  
- applications call its APIs  
- downstream systems receive integration events  
- all actions remain fully validated and auditable  

> *(Insert diagram: `Bus-Logic-Agent-Arch.png`)*

---

## 6. Example — how the model works

Here’s a simplified pattern drawn from actual AI + MCP interaction.

### Declare logic (deterministic and probabilistic NL)

**Use case: Check Credit**

1. The Customer's balance is less than the credit limit  
2. The Customer's balance is the sum of the Order amount_total where date_shipped is null  
3. The Order's amount_total is the sum of the Item amount  
4. The Item amount is the quantity * unit_price  
5. The Product count suppliers is the count of the Product Suppliers  
6. Use AI to set Item field unit_price by finding the optimal Product Supplier based on cost, lead time, and world conditions  

**Use case: App Integration**

1. Send the Order to Kafka topic `order_shipping` if `date_shipped` is not None.

### Generated DSL code

```python
Rule.constraint(validate=models.Customer,
    as_condition=lambda row: row.balance <= row.credit_limit,
    error_msg="balance ({row.balance}) exceeds credit ({row.credit_limit})")

Rule.sum(derive=models.Customer.balance,
    as_sum_of=models.Order.amount_total,
    where=lambda row: row.date_shipped is None)

Rule.sum(derive=models.Order.amount_total,
    as_sum_of=models.Item.amount)

Rule.formula(derive=models.Item.amount,
    as_expression=lambda row: row.quantity * row.unit_price)

Rule.count(derive=models.Product.count_suppliers,
    as_count_of=models.ProductSupplier)

Rule.early_row_event(on_class=models.Item,
    calling=set_item_unit_price_from_supplier)
```

### Runtime behavior

1. AI interprets the user request and issues an API call via MCP (e.g., “Update Alice’s order to 100 units.”).  
2. The deterministic engine processes the update.  
3. If declared, the PL handler invokes the LLM to determine supplier/price (e.g., avoiding a blocked state).  
4. The engine recomputes dependent values deterministically:
   - recalculates `Item.amount`  
   - updates `Order.amount_total`  
   - updates `Customer.balance`  
5. The engine applies constraints (e.g., credit limit).  
6. If policy is violated, the engine blocks the update and returns an explanation.

This is probabilistic intent inside deterministic guardrails.

---

## 7. Closing — a unified approach

Enterprise systems now operate with two modes of reasoning:

- deterministic rules that must always be correct  
- probabilistic reasoning that expands what systems can do  

By combining:

- natural-language expression  
- declarative DSL  
- deterministic execution  
- AI-driven probabilistic logic  

…we get a governable, extensible hybrid model.

Think of it as a **logic appliance** — a packaged, governed MCP server that delivers business behavior safely to AI.

The Business Logic Agent is the architectural pattern that emerges when these elements are combined: AI provides intent and exploration, and deterministic logic ensures everything remains correct, explainable, and safe.
