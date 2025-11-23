---
title: Logic Using AI
notes: Combining deterministic and probabilistic logic
version: 1.1, 22 Nov 2025
---

<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

!!! pied-piper ":bulb: **Unified Logic Model** — Combine deterministic rules with AI-powered creative reasoning"

    Business logic often requires **both** kinds of reasoning:
    
    - **Deterministic Logic** — "Customer balance must not exceed credit limit".  Such "classic" logic does not invoke AI at runtime.
    - **Creative Logic** — "Which supplier can still deliver if the strait is blocked?".  Such logic invokes AI at runtime to compute values.  Since AI is probabalistic, you  typically constrain the computed values with deterministic logic, and provide for audit trails to verify proper operation.
    
    GenAI-Logic enables you to **express both in the same natural language prompt**, and **execute them together** with proper governance.

    Modern business systems require **both deterministic rules** (repeatable, governed, auditable) and **probabilistic AI decisions** (adaptive, context‑aware).  
    GenAI‑Logic unifies these into a single natural‑language model where:

    - **AI chooses** the best candidate (probabilistic reasoning)  
    - **Rules enforce** constraints (deterministic governance)  
    - **Request tables record** every AI decision (full audit trail)  
    - **Events integrate** AI results into rule chaining  
    - **The DSL expresses** all logic in one declarative layer

**Under Construction**

---

## Example: Best Supplier
For example, consider the following database:

![basic_demo_data_model](images/basic_demo/basic_demo_data_model.png)

We wish to check credit (deterministic rules), but also choose the 'best' supplier based on external factors expressed in natural language.  We can't reasonably program that, but it's a *perfect* situation for creative / probabalistic 

```python title="Unified Deterministic and Probabilistic Logic"
Use case: Check Credit

1. The Customer's balance is less than the credit limit
2. The Customer's balance is the sum of the Order amount_total where date_shipped is null
3. The Order's amount_total is the sum of the Item amount
4. The Item amount is the quantity * unit_price
5. The Product count suppliers is the sum of the Product Suppliers
6. Use AI to Set Item field unit_price by finding the optimal Product Supplier
   based on cost, lead time, and world conditions
```

### Logic Operation

1. AI selects best supplier  
2. Item.unit_price updated  
3. Item.amount recalculated  
4. Order.amount_total updated  
5. Customer.balance updated  
6. Credit limit checked  

Outcome: **governed creativity** — AI adapts, rules enforce correctness.  To see how to run this sample, [click here](Integration-MCP-AI-Example.md){:target="_blank" rel="noopener"}.

![logic log](images/integration/mcp/logic-log.png)
---

## 10‑Second Mental Model
```
Receiver (needs value)
    ↓ asks AI
Provider Candidates
    ↓ evaluated by AI
AI Handler
    ↓ fills
Request Row (audit)
    ↓ extracted by rule/event
Receiver updated
```

AI decides; rules ensure correctness.

---

## Two Kinds of Logic

### Deterministic Logic
Used when outcomes must be **repeatable and verifiable**.

Examples:
- Credit limit validation  
- Summed totals (Item → Order → Customer)  
- Tax rules  
- Inventory adjustments  

Characteristics:
- Always same output  
- Fully testable  
- Automatic chaining  
- Auditability built‑in  

Example DSL:
```
Customer.balance = sum(Order.amount_total where date_shipped is null)
Order.amount_total = sum(Item.amount)
Item.amount = quantity * unit_price
Customer.balance must not exceed credit_limit
```

### Probabilistic (Creative) Logic
Used when judgment or optimization is required.

Examples:
- Selecting best supplier  
- Selecting warehouse  
- Picking payment processor  
- Assigning support agent  

Pattern:
> AI selects the best Provider row from a list of candidates and returns 1+ fields to the Receiver.

Example DSL:
```
Use AI to set Item.unit_price by finding the optimal ProductSupplier
based on cost, lead time, and world conditions.
```

---

## The “Get Values from Best Candidate” Pattern

### Why It Exists
Some attributes cannot be computed — they must be **chosen** from candidates (supplier, warehouse, agent…).

This pattern provides:
- AI‑powered selection  
- Deterministic guardrails  
- Complete audit trail  
- Clean rule/event integration  
- Works for single or multiple fields  

---

## Pattern Components

| Component | Role | Example |
|----------|------|---------|
| **Receiver** | Needs values | Item |
| **Provider List** | Candidates | ProductSupplierList |
| **Request Table** | Context + audit + results | SysSupplierReq |
| **AI Handler** | Makes selection | select_supplier_via_ai() |
| **Wrapper** | Encapsulates pattern | get_supplier_selection_from_ai() |
| **Integration** | Event/formula populates fields | Early event on Item |

---

## Diagram: Request Pattern Lifecycle
```
Item insert/update
       ↓
Wrapper creates SysSupplierReq
       ↓
Insert triggers AI Handler
       ↓
AI evaluates ProductSupplierList
       ↓
AI populates chosen_* fields + reason text
       ↓
Event extracts chosen_unit_price → Item.unit_price
       ↓
Rules recompute amounts, totals, balances
```

---

## Request Object – Complete Audit Trail

Each AI decision records:

**Standard Audit Fields**
- request (prompt context)
- reason (AI justification)
- created_on  
- fallback_used  

**Parent Context**
- item_id  
- product_id  

**AI Results**
- chosen_supplier_id  
- chosen_unit_price  

These fields tell **exactly** what AI saw, why it chose, and what it returned.

---

## When to Use the Pattern

### Good Fit (✓)
- Selecting from multiple candidates  
- Multi‑criteria optimization  
- Decisions influenced by external factors  
- Need for audit trail  
- Need for fallback safety  

### Not a Fit (✗)
- Pure calculations  
- Predictions with no candidates  
- Classification problems  
- Deterministic rules  


---

## Configuration

Note:

* this creates a table in your database
* you will need to configure an environment variable `APILOGICSERVER_CHATGPT_APIKEY`.  If this is omitted, the system falls back to selecting the minimum cost supplier.

---

## Benefits of the Unified Model

### 1. Natural Language for All Logic
One DSL expresses:
- deterministic rules  
- creative AI decisions  
- guardrails  

### 2. Governance
- audit trail per decision  
- fallback strategies  
- deterministic constraints  
- human review of DSL  

### 3. Seamless Integration
AI results behave like any other logic:
- rule chaining  
- rollback  
- testability with mocks  

### 4. Business Agility
- prompts updated instantly  
- no code‑level changes  
- world‑condition aware  
- enterprise‑grade safety  


---

## Business Logic Agent

The Business Logic Agent unifies the major elements of GenAI-Logic:

- **Natural-language intent**  
  Developers describe both deterministic and creative logic in plain language.

- **Deterministic logic generation**  
  Natural-language intent is translated into DSL rules that are maintainable, debuggable, and governed.

- **Probabilistic (AI) logic generation**  
  The same intent can also configure AI calls for tasks that require selecting a best candidate.

- **Governed execution**  
  AI outputs participate in normal rule chaining, are subject to deterministic guardrails, and are fully audited through request tables.

The result is a coordinated system where **AI and rules operate together**:  
creative decisions from AI, enforced and audited by deterministic logic.
