---
title: Logic Using AI
notes: Combining deterministic and probabilistic logic
version: 1.0, Nov 2025
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
    - **Creative Logic** — "Which supplier can still deliver if the strait is blocked?".  Such logic invokes AI at runtime to compute values.  Since AI is probabalistic, you  typically constrain the computed values with deterministic logic.
    
    GenAI-Logic enables you to **express both in the same natural language prompt**, and **execute them together** with proper governance.

**Under Construction**

&nbsp;

## Two Kinds of Logic

Not all business logic is the same. Understanding the distinction helps you choose the right tool for each situation.

### Deterministic Logic

Some logic must be **consistent, verifiable, and repeatable** — the same inputs always produce the same outputs.

**Examples:**

- Credit limit validation
- Order total calculation (sum of line items)
- Customer balance updates (aggregate unpaid orders)
- Tax calculations based on fixed rules

**Characteristics:**

- ✅ Always produces the same result
- ✅ Can be tested exhaustively
- ✅ Full audit trail of calculations
- ✅ Multi-table chaining handled automatically

**Natural Language Expression:**

```
The Customer's balance is the sum of Order amount_total where date_shipped is null
The Order's amount_total is the sum of Item amount
The Item amount is quantity * unit_price
The Customer's balance must not exceed credit_limit
```

These translate directly into **declarative rules** that the LogicBank engine enforces automatically.

&nbsp;

### Creative (Probabilistic) Logic

Other logic benefits from **judgment, context awareness, and adaptive reasoning** — where optimization or external factors influence the decision.

**The Underlying Pattern:**

> AI selects a "Provider Row" from a Provider Candidate List, setting 1 or more values into a "Receiver Row"

**Examples:**

| Use Case: AI selects from Provider Candidate List | Receiver Row | Provider Row | Values Transferred |
|----------|---------------|--------------|-------------------|
| **Optimal supplier selection** based on cost, lead time, and world conditions | `Item` | `Supplier` (via `ProductSupplierList`) | `unit_price`, `lead_time_days`, `supplier_id` |

**Additional Examples (hypothetical domains):**

| Use Case | Receiver Row | Provider Row | Values Transferred |
|----------|---------------|--------------|-------------------|
| Best warehouse for fulfillment | `Order` | `Warehouse` | `warehouse_id`, `shipping_cost`, `distance` |
| Preferred payment processor | `Transaction` | `PaymentProcessor` | `processor_id`, `fee_rate`, `processing_time` |
| Resource allocation (support tickets) | `Ticket` | `Agent` | `agent_id`, `estimated_resolution_time`, `expertise_level` |

**Characteristics:**

- 🎯 Leverages AI's ability to weigh multiple factors
- 🎯 Adapts to changing external conditions
- 🎯 Selects from candidates rather than computing values
- 🎯 Still requires governance (guardrails)

**Natural Language Expression:**

```
Use AI to select optimal supplier based on:
  - Unit cost
  - Lead time reliability
  - Current world conditions (e.g., shipping disruptions)
```

This delegates the **selection decision** to AI while keeping the result **auditable and governed** by deterministic rules.

&nbsp;

## Why Both Matter: Governable Creativity

**The Real Power:** Combining both approaches in a single unified model.

### Example: Order Processing with AI-Selected Supplier

```python title="Unified Deterministic and Probabilistic Logic"
Use case: Check Credit

1. The Customer's balance is less than the credit limit
2. The Customer's balance is the sum of the Order amount_total where date_shipped is null
3. The Order's amount_total is the sum of the Item amount
4. The Item amount is the quantity * unit_price
5. The Product count suppliers is the sum of the Product Suppliers
6. Item unit_price is derived as follows:
       - IF Product has suppliers,
             use AI to select optimal supplier based on cost, lead time, and world conditions
       - ELSE copy from Product.unit_price
```

**What happens:**

1. **AI makes creative decision** — Selects supplier considering multiple factors including real-time conditions
2. **Deterministic rules cascade** — Updates Item amount → Order total → Customer balance
3. **Guardrail enforces constraint** — Credit limit validation prevents bad transactions

**Result:** You get the **adaptability of AI** with the **reliability of rules**.

&nbsp;

## The "Get Values from Best Candidate" Pattern

This pattern handles scenarios where AI selects an optimal choice from a list of candidates and returns value(s) for use in business logic.

### Pattern Components

| Component | Description | Example |
|-----------|-------------|---------|
| **Receiver** | Object that needs value(s) | `Item`, `Order` |
| **Provider** | Candidate objects with source values | `Supplier` (via `ProductSupplierList`) |
| **Request Table** | Stores context, results, and audit trail | `SysSupplierReq` |
| **AI Handler** | Makes selection and populates request | `supplier_id_from_ai()` |
| **Wrapper Function** | Encapsulates pattern, returns values | `get_supplier_price_from_ai()` |
| **Integration** | How values reach receiver | Formula (single) or Event (multiple) |

### Request Pattern: Complete Audit Trail

Every AI decision is recorded in a **request table** with three categories of fields:

**Category A: Constants (same for all AI requests)**
```python
id = Column(Integer, primary_key=True)
request = Column(String(2000))        # AI prompt sent
reason = Column(String(500))          # AI reasoning returned
created_on = Column(DateTime)         # When decision was made
fallback_used = Column(Boolean)       # Did AI fail and use fallback?
```

**Category B: Context (from the prompt)**
```python
item_id = Column(ForeignKey('item.id'))      # Which Item?
product_id = Column(ForeignKey('product.id')) # Which Product?
```

**Category C: Results (from AI selection)**
```python
chosen_supplier_id = Column(ForeignKey('supplier.id'))  # Selected supplier
chosen_unit_price = Column(DECIMAL)                     # Their price
chosen_lead_time = Column(Integer)                      # Their lead time
```

&nbsp;

## Case 1: Single-Value Pattern (Implemented)

**Use Case:** Item needs unit_price from AI-selected supplier.

![basic_demo_data_model](images/basic_demo/basic_demo_data_model.png)

### Natural Language Prompt

```
Item unit_price is derived as follows:
  - IF Product has suppliers,
        use AI to select optimal supplier based on cost, lead time, and world conditions
  - ELSE copy from Product.unit_price
```

### Implementation

**Request Table:**
```python
class SysSupplierReq(Base):
    __tablename__ = 'sys_supplier_req'
    
    # Category A: Audit fields
    id = Column(Integer, primary_key=True)
    request = Column(String(2000))
    reason = Column(String(500))
    created_on = Column(DateTime, default=datetime.datetime.utcnow)
    fallback_used = Column(Boolean, default=False)
    
    # Category B: Context
    item_id = Column(Integer, ForeignKey("item.id"))
    product_id = Column(Integer, ForeignKey("product.id"))
    
    # Category C: Result
    chosen_supplier_id = Column(Integer, ForeignKey("supplier.id"))
    chosen_unit_price = Column(DECIMAL)
```

**AI Handler:**
```python
def declare_logic():
    """Register AI supplier selection handler."""
    Rule.early_row_event(
        on_class=models.SysSupplierReq,
        calling=supplier_id_from_ai
    )

def supplier_id_from_ai(row: models.SysSupplierReq, old_row, logic_row: LogicRow):
    """AI selects optimal supplier."""
    if not logic_row.is_inserted():
        return
    
    # Introspection-based AI value computation
    compute_ai_value(
        row=row,
        logic_row=logic_row,
        candidates='product.ProductSupplierList',
        optimize_for='fastest reliable delivery while keeping costs reasonable, considering world conditions',
        fallback='min:unit_cost'
    )

#### compute_ai_value() API Reference

```python
compute_ai_value(
    row,              # Request table row to populate with results
    logic_row,        # LogicBank LogicRow for logging and DB operations
    candidates,       # Relationship path to candidate objects (e.g., 'product.ProductSupplierList')
    optimize_for,     # Natural language optimization goal
    fallback          # Strategy when AI unavailable or fails
)
```

**Parameters:**

- **`row`** — The request table instance (e.g., `SysSupplierReq`) where results will be stored
- **`logic_row`** — LogicBank's LogicRow for logging and transaction management
- **`candidates`** — Dot-notation path to navigate SQLAlchemy relationship (e.g., `'order.customer.PreferredSupplierList'`)
- **`optimize_for`** — Natural language describing business objective (sent to AI)
- **`fallback`** — Strategy when OpenAI API unavailable:
  - `'min:field_name'` — Select candidate with minimum value for field
  - `'max:field_name'` — Select candidate with maximum value for field
  - `'first'` — Use first candidate in list

**What it does automatically:**

1. Checks test context first (for reproducible testing)
2. Navigates relationship path to get candidate objects
3. Introspects all candidate fields via SQLAlchemy
4. Introspects request table `chosen_*` result columns
5. Maps AI response to result columns (e.g., `chosen_supplier_id` ← `supplier_id`)
6. Loads world conditions from `config/ai_test_context.yaml`
7. Calls OpenAI API with structured prompt
8. Handles graceful fallback when no API key
9. Converts types (Decimal for money, int for IDs)
10. Stores complete audit trail in request row

**Error Handling:**

When AI call fails (no API key, network error, etc.):
- Uses fallback strategy to select candidate
- Sets `fallback_used = True` in request row
- Logs reason for fallback in `reason` field
- Transaction continues normally (no exception)
```

**Wrapper Function (Returns Scalar):**
```python
def get_supplier_price_from_ai(row, logic_row: LogicRow):
    """
    Returns optimal supplier price using AI.
    Creates a SysSupplierReq which triggers the AI handler.
    """
    # Create request
    supplier_req_logic_row = logic_row.new_logic_row(models.SysSupplierReq)
    supplier_req = supplier_req_logic_row.row
    
    # Set context
    supplier_req.product_id = row.product_id
    supplier_req.item_id = row.id
    
    # Insert triggers AI
    supplier_req_logic_row.insert(reason="AI supplier selection request")
    
    # Return computed value
    return supplier_req.chosen_unit_price
```

**Formula Integration:**
```python
Rule.formula(
    derive=Item.unit_price, 
    calling=get_supplier_price_from_ai
)
```

### What Happens at Runtime

1. **Item is created** — Formula needs unit_price
2. **Wrapper creates request** — Inserts `SysSupplierReq` row
3. **AI handler fires** — Evaluates suppliers, selects best one
4. **Request populated** — `chosen_supplier_id`, `chosen_unit_price`, and `reason` stored
5. **Value returned** — Formula receives price, sets `Item.unit_price`
6. **Rules cascade** — Item amount → Order total → Customer balance
7. **Constraint checks** — Credit limit enforced

**Complete audit trail:** Every AI decision is logged with full context and reasoning.

&nbsp;

## Prompt Format Specification

### Writing Prompts for Multi-Value Selection

When AI needs to set multiple receiver fields, the prompt must explicitly list them:

**Format:**
```
Use AI to select optimal <Provider>.
Set <Receiver> fields:
  - field1                    # Like-named (auto-inferred from provider)
  - field2 = provider_field2  # Explicit mapping (names differ)
  - field3                    # Like-named
```

**Rules:**

1. **Always list receiver fields** — Makes intent clear, no ambiguity
2. **Like-named inference** — If receiver and provider field names match, just list the name
3. **Explicit mapping** — Use `=` only when names differ between receiver and provider
4. **Mixed approach** — Combine both styles in same prompt

**Examples:**

```
# All like-named (provider has matching field names)
Set Order fields: supplier_id, unit_cost, lead_time_days

# All explicit (names differ)
Set Order fields:
  - fulfillment_supplier_id = supplier_id
  - estimated_cost = unit_cost
  - promised_delivery_days = lead_time_days

# Mixed (some match, some don't)
Set Order fields:
  - supplier_id
  - estimated_cost = unit_cost
  - lead_time_days
```

**Why this matters:** AI introspects the provider table to find matching fields. Like-named inference keeps prompts concise while explicit mapping handles mismatched names.

&nbsp;

## Case 2: Multi-Value Pattern

!!! note "Implementation Status"
    The multi-value pattern uses the same infrastructure as Case 1 (implemented and tested). The enhanced wrapper function returning a tuple enables both single-value (formula) and multi-value (event) consumption. The example below shows how to extend the pattern for multiple values.

**Use Case:** Order needs multiple values (supplier_id, cost, lead_time) from AI selection.

### Natural Language Prompt

```
Use case: Direct-from-Supplier Order Fulfillment

When Order is placed for drop-ship Product:
  Use AI to select optimal supplier.
  Set Order fields:
    - fulfillment_supplier_id = supplier_id
    - estimated_cost = unit_cost
    - promised_delivery_days = lead_time_days
  Optimize for: best cost with reliable delivery considering lead time
```

### Implementation Enhancement

**Extended Request Table:**
```python
class SysSupplierReq(Base):
    # ... existing fields (A: audit, B: context) ...
    
    # Category C: Multiple results
    chosen_supplier_id = Column(Integer, ForeignKey("supplier.id"))
    chosen_unit_price = Column(DECIMAL)
    chosen_lead_time = Column(Integer)  # NEW: Additional value
```

**Enhanced Wrapper (Returns Tuple):**
```python
def get_supplier_assignment_from_ai(row, logic_row: LogicRow):
    """
    Returns (primary_value, request_row) tuple.
    Enables access to all chosen values.
    """
    supplier_req_logic_row = logic_row.new_logic_row(models.SysSupplierReq)
    supplier_req = supplier_req_logic_row.row
    
    supplier_req.order_id = row.id
    supplier_req.product_id = row.items[0].product_id
    
    supplier_req_logic_row.insert(reason="AI supplier assignment for drop-ship")
    
    # Return tuple: (primary_value, full_request_row)
    return (supplier_req.chosen_unit_price, supplier_req)
```

**Event Integration (Multiple Values):**
```python
def assign_dropship_supplier(row: models.Order, old_row, logic_row: LogicRow):
    """
    Early event: AI selects supplier and populates multiple Order fields.
    """
    if not row.is_dropship:
        return
    
    # Destructure tuple to get all values
    cost, req = get_supplier_assignment_from_ai(row, logic_row)
    
    # Set multiple fields from AI decision
    row.fulfillment_supplier_id = req.chosen_supplier_id  # Value 1
    row.estimated_cost = cost                              # Value 2
    row.promised_delivery_days = req.chosen_lead_time      # Value 3
    
    logic_row.log(f"Drop-ship assigned to supplier {req.chosen_supplier_id}, "
                  f"cost=${cost}, delivery={req.chosen_lead_time} days")

Rule.early_row_event(on_class=Order, calling=assign_dropship_supplier)
```

**Formula Integration Still Works:**
```python
# Extract just the primary value (index [0] of tuple)
Rule.formula(
    derive=Item.unit_price, 
    calling=lambda row, logic_row: get_supplier_assignment_from_ai(row, logic_row)[0]
)
```

&nbsp;

## Pattern Flexibility: One Implementation, Two Use Cases

The tuple return pattern `(primary_value, request_row)` elegantly supports both scenarios:

| Integration Type | How Used | Values Accessed | Example |
|------------------|----------|-----------------|---------|
| **Formula** | Extract `[0]` | Single scalar | `Item.unit_price` |
| **Event** | Destructure tuple | Multiple fields | `Order.supplier_id`, `cost`, `lead_time` |

**Key Benefit:** One AI request serves both single-value and multi-value needs.

&nbsp;

## When to Use This Pattern

### ✅ Good Fit

- **Selection from candidates** — Multiple options to choose from
- **AI-driven optimization** — Decision based on multiple weighted criteria
- **Value extraction** — Getting attribute(s) from chosen candidate
- **Audit requirement** — Need to track what AI decided and why

**Examples:**

- ✅ Optimal supplier selection
- ✅ Best warehouse for fulfillment
- ✅ Preferred payment processor
- ✅ Routing assignment (driver, route, carrier)
- ✅ Resource allocation (assign ticket to agent)

### ❌ Not Applicable

- ❌ Pure computation without candidates (dynamic pricing, risk scoring)
- ❌ Forecasting/prediction (no candidate selection)
- ❌ Classification without candidate list
- ❌ Simple deterministic calculations (use regular rules)

&nbsp;

## Benefits of the Unified Approach

### 1. Natural Language for Both

Express **deterministic** and **creative** logic the same way:

```
Customer balance is the sum of Order amount_total     ← Deterministic
Item unit_price uses AI to select optimal supplier    ← Creative
Customer balance must not exceed credit_limit         ← Guardrail
```

### 2. Complete Governance

- **Audit trail** — Every AI decision logged with reasoning
- **Fallback strategies** — Graceful degradation if AI unavailable
- **Deterministic guardrails** — Rules enforce boundaries on AI outputs
- **Human in the loop** — Review DSL before execution

### 3. Seamless Integration

- AI decisions **participate in rule chaining** like any other logic
- **No special handling** — Same transaction, same rollback, same logging
- **Testable** — Use mock responses for deterministic testing

### 4. Business Agility

- **Fast changes** — Modify prompt or criteria without code changes
- **Adaptive** — AI responds to real-world conditions
- **Reliable** — Deterministic rules prevent bad outcomes

&nbsp;

## The Business Logic Agent

This unified model forms the foundation of the **Business Logic Agent** — an architectural pattern that combines:

- **Probabilistic Intent** — AI interprets natural language and makes creative decisions
- **Deterministic Enforcement** — Rules engine guarantees correctness and governance
- **MCP Discovery** — AI assistants can understand and interact with the system

![Business Logic Agent Architecture](images/integration/mcp/Bus-Logic-Agent.png)

**Not AI vs. Rules — AI and Rules working together.**

&nbsp;

## Implementation Checklist

When implementing this pattern:

### 1. Identify Components
- [ ] Receiver object (what needs values?)
- [ ] Provider relationship path (where are candidates?)
- [ ] Values needed (single or multiple?)

### 2. Design Request Table
- [ ] Category A: Standard audit fields (id, request, reason, created_on, fallback_used)
- [ ] Category B: Context FKs from prompt (item_id, product_id, etc.)
- [ ] Category C: Result columns via like-named mapping (chosen_*)

### 3. Create AI Handler
- [ ] Early row event on request table
- [ ] Call `compute_ai_value()` with candidates path
- [ ] Specify optimization criteria

### 4. Create Wrapper Function
- [ ] Use Request Pattern (`new_logic_row()`)
- [ ] Return tuple `(primary_value, request_row)`
- [ ] Document what values are available

### 5. Integrate
- [ ] Formula: Extract `[0]` for scalar value
- [ ] Event: Destructure tuple for multiple values

&nbsp;

## Related Documentation

- [Integration: MCP AI Example](Integration-MCP-AI-Example.md) — See the pattern in action
- [Logic: Rule Types](Logic.md) — Declarative rule reference
- [Architecture: What Is GenAI?](Architecture-What-Is-GenAI.md) — Understanding AI + Logic
- [Study: Declarative vs. Procedural GenAI](Logic-Why-Declarative-GenAI.md) — A/B comparison

&nbsp;

---

## Summary

Business logic naturally divides into two categories:

- **Deterministic** — Must be consistent, repeatable, verifiable
- **Creative** — Benefits from judgment, context, adaptation

GenAI-Logic lets you **express both in natural language** and **execute both together** with proper governance.

The **"Get Values from Best Candidate"** pattern provides:

✅ AI-powered selection  
✅ Complete audit trails  
✅ Deterministic guardrails  
✅ Flexible single/multi-value support  
✅ Seamless rule integration  

**Not replacing one with the other — combining the strengths of both.**
