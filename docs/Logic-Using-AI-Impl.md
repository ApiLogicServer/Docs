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

    This describes the implementation for AI Logic created by GenAI.

**Under Construction**

&nbsp;

## Implementation Example

**Use Case:** Item needs unit_price (and optionally other values) from AI-selected supplier.

![basic_demo_data_model](images/basic_demo/basic_demo_data_model.png)

### Natural Language Prompt

```bash title='Use AI to Set Item field unit_price by finding the optimal Product Supplier'
6. Item unit_price is derived as follows:
       - IF Product has suppliers,
             use AI to select optimal supplier based on cost, lead time, and world conditions
       - ELSE copy from Product.unit_price
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
```

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
10. Populates `request` field with candidate summary (names + prices)
11. Populates `reason` field with decision explanation (selected supplier name + reasoning)

**Error Handling:**

When AI call fails (no API key, network error, etc.):
- Uses fallback strategy to select candidate
- Sets `fallback_used = True` in request row
- Populates `request` with candidate summary
- Populates `reason` with fallback explanation and selected supplier
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
    
    # CRITICAL: Check delete first - old_row is None on delete
    if logic_row.is_deleted():
        return
    
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
3. **Wrapper creates request** — Inserts `SysSupplierReq` row with context (item_id, product_id)
4. **AI handler fires** — Evaluates suppliers, selects best one
5. **Request populated** — `chosen_supplier_id`, `chosen_unit_price`, `request`, and `reason` stored
6. **Wrapper returns object** — Event receives populated SysSupplierReq
7. **Event extracts values** — Sets `row.unit_price = supplier_req.chosen_unit_price` (can extract other fields too)
8. **Rules cascade** — Item amount → Order total → Customer balance
9. **Constraint checks** — Credit limit enforced

**Complete audit trail:** Every AI decision is logged with full context and reasoning.

&nbsp;

## Extracting Multiple Values

**Use Case:** When you need multiple values from the AI selection, simply extract additional fields from the returned request object.

**Example - Extract Multiple Values:**
```python
def assign_supplier_to_item(row: models.Item, old_row, logic_row: LogicRow):
    """
    Early event: AI selects supplier and populates multiple Item fields.
    """
    from logic.logic_discovery.ai_requests.supplier_selection import get_supplier_selection_from_ai
    
    if not logic_row.is_inserted():
        return
    
    # Call wrapper - returns populated request object
    req = get_supplier_selection_from_ai(
        product_id=row.product_id,
        item_id=row.id,
        logic_row=logic_row
    )
    
    # Extract whatever values you need from request object
    row.unit_price = req.chosen_unit_price              # Value 1
    row.supplier_id = req.chosen_supplier_id            # Value 2 (optional)
    row.lead_time_days = req.chosen_lead_time           # Value 3 (optional)
    
    logic_row.log(f"Supplier {req.chosen_supplier_id} selected: "
                  f"${req.chosen_unit_price}, delivery={req.chosen_lead_time} days")

Rule.early_row_event(on_class=Item, calling=assign_supplier_to_item)
```

**Key Benefit:** Wrapper returns full request object with all AI results; caller extracts whatever fields it needs (one or many)

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
- [ ] Return request object
- [ ] Document what result fields are available

### 5. Integrate with Early Event
- [ ] Extract needed fields from returned request object
- [ ] Can extract one field or many fields as needed

&nbsp;

## Common Issues

### Delete Operations Crash

**Problem:** Early events fire on delete, but `old_row` is None.

**Solution:** Always check `is_deleted()` first:
```python
def event_handler(row, old_row, logic_row):
    if logic_row.is_deleted():
        return
    # ... rest of logic that accesses old_row ...
```

### Incomplete Audit Trail

**Problem:** Request/reason fields contain IDs or generic text, not useful for debugging.

**Solution:** Populate in AI handler with business names and values:
```python
# BAD - Not useful
request = f"Product {product_id} supplier selection"
reason = "AI selected supplier"

# GOOD - Useful for debugging
request = f"Egyptian Cotton Sheets from Acme ($105) or Global ($110)"
reason = f"Selected Acme - lower cost ($105 vs $110), reliable delivery"
```

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
✅ Flexible value extraction (one or many fields)  
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

## C. Result Values vs. Audit Trail

An important architectural distinction in the supplier selection example:

**Used in Business Logic:**
- `chosen_unit_price` → Sets `Item.unit_price` (extracted in event)
- Participates in rule chaining (Item.amount → Order.amount_total → Customer.balance)

**Audit Trail Only:**
- `chosen_supplier_id` → May or may not be used in downstream logic
- Provides visibility: "Which supplier did AI pick?"
- Enables analysis and debugging
- Supports regulatory compliance

**Why This Matters:**

The event handler extracts whatever fields it needs from the request object. Some fields may be used in business logic, others are purely for audit trail.

**Design Principle:** Capture everything AI decides in the request table; event extracts what business logic needs.

&nbsp;

## D. Implementation: Generic vs. Hardwired

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

## E. Test Context Priority

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

## F. Why Object Return Pattern?

The wrapper returns the full request object with all AI results:

**Design:**
```python
def get_supplier_selection_from_ai(product_id, item_id, logic_row):
    # ... create and populate request ...
    return supplier_req  # Returns full SysSupplierReq object
```

**Event extracts what it needs:**
```python
def set_item_unit_price_from_supplier(row, old_row, logic_row):
    req = get_supplier_selection_from_ai(row.product_id, row.id, logic_row)
    row.unit_price = req.chosen_unit_price          # Extract one field
    # row.supplier_id = req.chosen_supplier_id      # Can extract more if needed
    # row.lead_time = req.chosen_lead_time          # Flexible based on use case
```

**Key Benefits:**

- ✅ One implementation serves all use cases
- ✅ Caller extracts what it needs (one or many fields)
- ✅ Request object always available for audit
- ✅ Natural object-oriented pattern
- ✅ Easy to add new result fields without changing wrapper

&nbsp;

---

**End of Appendix**
