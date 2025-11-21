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

Every AI decision is recorded in a **request table** with three types of fields:

**Standard AI Audit (same for all AI requests)**
```python
id = Column(Integer, primary_key=True)
request = Column(String(2000))        # AI prompt sent
reason = Column(String(500))          # AI reasoning returned
created_on = Column(DateTime)         # When decision was made
fallback_used = Column(Boolean)       # Did AI fail and use fallback?
```

**Parent Context Links (FKs to triggering entities)**
```python
item_id = Column(ForeignKey('item.id'))      # Which Item?
product_id = Column(ForeignKey('product.id')) # Which Product?
```

**AI Results (values selected by AI)**
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
Use AI to Set Item field unit_price by finding the optimal Product Supplier based on cost, lead time, and world conditions

IF Product has no suppliers, THEN copy from Product.unit_price
```

### Implementation

**Request Table:**
```python
class SysSupplierReq(Base):
    __tablename__ = 'sys_supplier_req'
    
    # Standard AI Audit
    id = Column(Integer, primary_key=True)
    request = Column(String(2000))
    reason = Column(String(500))
    created_on = Column(DateTime, default=datetime.datetime.utcnow)
    fallback_used = Column(Boolean, default=False)
    
    # Parent Context Links
    item_id = Column(Integer, ForeignKey("item.id"))
    product_id = Column(Integer, ForeignKey("product.id"))
    
    # AI Results
    chosen_supplier_id = Column(Integer, ForeignKey("supplier.id"))
    chosen_unit_price = Column(DECIMAL)
```

**AI Handler (in ai_requests/supplier_selection.py):**
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

def get_supplier_selection_from_ai(product_id: int, item_id: int, logic_row: LogicRow):
    """Wrapper that hides Request Pattern. Returns populated SysSupplierReq object."""
    supplier_req_logic_row = logic_row.new_logic_row(models.SysSupplierReq)
    supplier_req = supplier_req_logic_row.row
    
    supplier_req.product_id = product_id
    supplier_req.item_id = item_id
    
    supplier_req_logic_row.insert(reason="AI supplier selection request")
    
    return supplier_req

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

**Item Event Handler (in check_credit.py):**
```python
def declare_logic():
    # Other rules...
    Rule.early_row_event(on_class=models.Item, calling=set_item_unit_price_from_supplier)

def set_item_unit_price_from_supplier(row: models.Item, old_row: models.Item, logic_row):
    """
    Early event: Sets unit_price using AI if suppliers exist, else uses fallback.
    
    Fires on insert AND when product_id changes (copy rule semantics).
    """
    from logic.logic_discovery.ai_requests.supplier_selection import get_supplier_selection_from_ai
    
    # Process on insert OR when product_id changes
    if not (logic_row.is_inserted() or row.product_id != old_row.product_id):
        return
    
    product = row.product
    
    # FALLBACK LOGIC when AI shouldn't/can't run:
    # Try reasonable default (copy from parent matching field), else fail-fast
    if product.count_suppliers == 0:
        # Reasonable default: copy from parent.unit_price (matching field name)
        if hasattr(product, 'unit_price') and product.unit_price is not None:
            logic_row.log(f"No suppliers for {product.name}, using product default price")
            row.unit_price = product.unit_price
            return
        else:
            # No obvious fallback - fail-fast with explicit TODO
            raise NotImplementedError(
                "TODO_AI_FALLBACK: Define fallback for Item.unit_price when no suppliers exist. "
                "Options: (1) Use a default constant, (2) Leave NULL if optional, "
                "(3) Raise error if required field, (4) Copy from another source"
            )
    
    # Product has suppliers - call AI wrapper (hides Request Pattern)
    logic_row.log(f"Product {product.name} has {product.count_suppliers} suppliers, requesting AI selection")
    supplier_req = get_supplier_selection_from_ai(
        product_id=row.product_id,
        item_id=row.id,
        logic_row=logic_row
    )
    
    # Extract AI-selected value(s)
    row.unit_price = supplier_req.chosen_unit_price
```

### Fallback Strategy: Reasonable Default → Fail-Fast

**CRITICAL:** AI rules need fallback logic for cases when AI shouldn't/can't run.

**Strategy:**
1. **Try reasonable default**: Copy from parent field with matching name
2. **If no obvious default**: Raise `NotImplementedError` with `TODO_AI_FALLBACK` marker
3. **Never silently fail**: Force developer decision at generation time, not runtime

**Benefits:**
- ✅ Prevents silent production failures
- ✅ Code won't run until developer addresses edge cases
- ✅ Clear markers for what needs attention
- ✅ Works in dev/test, fails explicitly before production

**For multi-value AI results**: Apply per-field fallback strategy. Common: copy from parent matching field names. For fields with no obvious fallback, use `TODO_AI_FALLBACK`.

**Example:** In the code above, when `product.count_suppliers == 0`:
- First tries: `product.unit_price` (matching field name)
- If not available: Raises `NotImplementedError` with clear options

### What Happens at Runtime

1. **Item is inserted** — Early event fires on Item
2. **Event checks suppliers** — If none, apply fallback; if yes, call wrapper
3. **Wrapper creates request** — Inserts `SysSupplierReq` row (hides Request Pattern)
4. **AI handler fires** — Evaluates suppliers, selects best one
5. **Request populated** — `chosen_supplier_id`, `chosen_unit_price`, and `reason` stored
6. **Wrapper returns object** — Event receives populated SysSupplierReq
7. **Event extracts value** — Sets `row.unit_price = supplier_req.chosen_unit_price`
8. **Rules cascade** — Item amount → Order total → Customer balance
9. **Constraint checks** — Credit limit enforced

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

**Wrapper Function (Same as Case 1):**
```python
def get_supplier_selection_from_ai(product_id: int, item_id: int, logic_row: LogicRow):
    """Returns populated SysSupplierReq object."""
    supplier_req_logic_row = logic_row.new_logic_row(models.SysSupplierReq)
    supplier_req = supplier_req_logic_row.row
    
    supplier_req.product_id = product_id
    supplier_req.item_id = item_id
    
    supplier_req_logic_row.insert(reason="AI supplier selection request")
    
    return supplier_req
```

**Event Integration (Multiple Values):**
```python
def assign_dropship_supplier(row: models.Order, old_row, logic_row: LogicRow):
    """
    Early event: AI selects supplier and populates multiple Order fields.
    """
    from logic.logic_discovery.ai_requests.supplier_selection import get_supplier_selection_from_ai
    
    if not logic_row.is_inserted() or not row.is_dropship:
        return
    
    # Call wrapper - returns populated request object
    req = get_supplier_selection_from_ai(
        product_id=row.items[0].product_id,
        item_id=row.items[0].id,
        logic_row=logic_row
    )
    
    # Extract multiple values from request object
    row.fulfillment_supplier_id = req.chosen_supplier_id  # Value 1
    row.estimated_cost = req.chosen_unit_price            # Value 2
    row.promised_delivery_days = req.chosen_lead_time     # Value 3
    
    logic_row.log(f"Drop-ship assigned to supplier {req.chosen_supplier_id}, "
                  f"cost=${req.chosen_unit_price}, delivery={req.chosen_lead_time} days")

Rule.early_row_event(on_class=Order, calling=assign_dropship_supplier)
```

&nbsp;

## Pattern Flexibility: One Implementation, Multiple Use Cases

The wrapper returns a populated request object, enabling flexible value extraction:

| Integration Type | How Used | Values Accessed | Example |
|------------------|----------|-----------------|---------|------|
| **Single Value** | Extract one field | `req.chosen_unit_price` | `Item.unit_price` |
| **Multiple Values** | Extract multiple fields | `req.chosen_supplier_id`, `req.chosen_unit_price`, `req.chosen_lead_time` | `Order.supplier_id`, `cost`, `lead_time` |

**Key Benefit:** Wrapper returns full object; caller decides what to extract.

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
- [ ] Standard AI Audit: (id, request, reason, created_on, fallback_used)
- [ ] Parent Context Links: FKs from prompt (item_id, product_id, etc.)
- [ ] AI Results: Result columns via like-named mapping (chosen_*)

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

&nbsp;

---

# Appendix: Pattern Internals

This section provides deeper architectural insights into how the pattern works and why it's designed this way.

&nbsp;

## A. Request Table Field Discovery

The request table's three field types aren't arbitrary — they can be **automatically derived**:

**Standard AI Audit (Generic Fields)**
- Always the same for ANY AI request
- Provides complete audit trail
- Fields: `id`, `request`, `reason`, `created_on`, `fallback_used`

**Parent Context Links (Foreign Keys)**
- Derived from **prompt analysis**
- Identifies which objects are involved
- Example: "Item unit_price" → needs `item_id`, `product_id`

**AI Results (Selected Values)**
- Inferred from **provider table introspection**
- Uses like-named mapping convention
- Example: Provider has `supplier_id`, `unit_cost` → Request gets `chosen_supplier_id`, `chosen_unit_price`

**Key Insight:** Future implementations could **auto-generate the entire request table** from:
1. Prompt text (identifies context entities)
2. Provider table schema (identifies available values)
3. Standard constants (always included)

&nbsp;

## B. Pattern Name Rationale

**"Get Values from Best Candidate"** was chosen to precisely capture what the pattern does:

**"Get Values"**
- Extracting **existing data** from candidates
- NOT computing new values or forecasting
- Emphasizes data retrieval over calculation

**"Best Candidate"**
- Selection/optimization decision by AI
- Implies judgment and criteria evaluation
- Distinguishes from random or sequential selection

**"(from Candidate List)"**
- Multiple options to choose from
- Not applicable to single-value computations
- Emphasizes the selection aspect

**What This Pattern Is NOT:**
- ❌ "Compute a value" — No candidates involved, pure calculation
- ❌ "Transform data" — No selection decision
- ❌ "Aggregate results" — No single best choice

&nbsp;

## C. AI as Function Call

The wrapper function's key innovation is making AI behave **functionally**:

```python
# Looks like a regular function call
price = get_supplier_price_from_ai(item, logic_row)
```

**What happens under the hood:**
1. Creates request record (audit trail)
2. Triggers AI handler via insert event
3. AI evaluates candidates and selects best
4. Returns computed value immediately

**From the formula's perspective:**
- It's just a function that returns a price
- AI complexity is completely encapsulated
- Audit trails happen automatically
- Fallback strategies are invisible

**This enables:**
- Seamless integration with declarative rules
- No special "AI" handling in business logic
- Clean separation of concerns
- Testability through simple mocking

&nbsp;

## D. Result Values vs. Audit Trail

An important architectural distinction in the supplier selection example:

**Used in Business Logic:**
- `chosen_unit_price` → Sets `Item.unit_price` (formula)
- Participates in rule chaining (Item.amount → Order.amount_total → Customer.balance)

**Audit Trail Only:**
- `chosen_supplier_id` → NOT used in downstream logic
- Provides visibility: "Which supplier did AI pick?"
- Enables analysis and debugging
- Supports regulatory compliance

**Why This Matters:**

This distinction kept the pattern as a **scalar function** (formula-compatible) rather than requiring an event handler. If business logic needed BOTH supplier_id AND unit_price, we'd use the multi-value pattern (event + tuple destructuring).

**Design Principle:** Capture everything AI decides, but only return what business logic needs.

&nbsp;

## E. Implementation: Generic vs. Hardwired

Current `compute_ai_value()` implementation status:

**✅ Already Generic (Introspection-Based):**
- Candidate discovery via relationship navigation
- Field introspection via SQLAlchemy
- Relationship traversal (e.g., `supplier.name`, `supplier.region`)
- Graceful fallback strategies

**❌ Still Hardwired (Needs Generalization):**
- Result column mapping in `_map_ai_response()`:
  ```python
  row.chosen_supplier_id = int(chosen_id)      # Hardcoded field names
  row.chosen_unit_price = Decimal(chosen_price)
  ```
- Fallback mapping in `_apply_fallback()`:
  ```python
  if hasattr(chosen, 'supplier_id'):     # Supplier-specific
      row.chosen_supplier_id = ...
  ```
- Prompt building in `_build_prompt()`:
  ```python
  "You are optimizing supplier selection."  # Domain-specific text
  ```

**Future Enhancement:**

Full introspection of `chosen_*` columns on request table would make the pattern completely generic:

```python
# Discover result columns dynamically
for column in inspect(row.__class__).columns:
    if column.key.startswith('chosen_'):
        # Map from AI response automatically
        source_field = column.key.replace('chosen_', '')
        row[column.key] = ai_response[source_field]
```

&nbsp;

## F. Test Context Priority

`compute_ai_value()` checks `config/ai_test_context.yaml` **before** checking for OpenAI API key. This design choice enables:

**Priority Order:**
1. **Test context** (if exists) → Use predetermined values
2. **OpenAI API** (if key available) → Real AI decision
3. **Fallback strategy** → Deterministic selection

**Benefits:**

**Deterministic Testing**
- Same input → Same output (reproducible)
- No variance from AI responses
- Predictable test outcomes

**CI/CD Integration**
- Run tests without OpenAI API key
- No network dependencies
- Fast execution (no API latency)

**Offline Development**
- Work without internet connection
- No API costs during development
- Faster iteration cycles

**Example Test Context:**
```yaml
# config/ai_test_context.yaml
selected_supplier_id: 2
selected_unit_price: 105.0
reasoning: "Test context: predetermined supplier selection"
world_conditions: "Test scenario: normal operations"
```

**Result:** Full test coverage of AI-driven logic without actual AI calls.

&nbsp;

## G. Why Object Return Pattern?

The wrapper returns the full request object, elegantly solving the single/multi-value dilemma:

**Design Problem:**
- Some use cases need ONE value (unit_price)
- Other use cases need MULTIPLE values (supplier_id, unit_price, lead_time)
- Don't want separate implementations

**Solution: Return Full Object**
```python
def get_supplier_selection_from_ai(product_id, item_id, logic_row):
    # ... create and populate request ...
    return supplier_req  # Returns full SysSupplierReq object
```

**Single-Value Consumption (Early Event):**
```python
def set_item_unit_price_from_supplier(row, old_row, logic_row):
    req = get_supplier_selection_from_ai(row.product_id, row.id, logic_row)
    row.unit_price = req.chosen_unit_price  # Extract one field
```

**Multi-Value Consumption (Early Event):**
```python
def assign_supplier(row, old_row, logic_row):
    req = get_supplier_selection_from_ai(row.product_id, row.id, logic_row)
    row.supplier_id = req.chosen_supplier_id      # Extract multiple fields
    row.unit_price = req.chosen_unit_price
    row.lead_time = req.chosen_lead_time
```

**Key Benefits:**
- ✅ One implementation serves all use cases
- ✅ Caller extracts what it needs
- ✅ Request object always available for audit
- ✅ Natural object-oriented pattern
- ✅ Easy to add new fields without changing wrapper

**Alternative Rejected:** Returning just a scalar value would require separate implementations for single/multi-value cases, violating DRY principle.

&nbsp;

---

**End of Appendix**
