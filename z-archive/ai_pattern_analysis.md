# AI as Function Call Pattern - Analysis and Design

**Date:** November 19, 2025  
**Pattern Name:** "Get Values from Best Candidate"

---

## Executive Summary

This document captures the analysis of the AI-driven supplier selection implementation and generalizes it into a reusable pattern for probabilistic logic. The pattern enables AI to select optimal candidates from a list and return value(s) for use in business logic, with complete audit trails and graceful fallbacks.

---

## Key Insight: AI as Function Call

The supplier selection implementation demonstrates that AI calls can operate functionally:
- **Input:** Context (product_id, item_id)
- **Process:** AI selection from candidates
- **Output:** Return value(s) - like a function call
- **Side Effect:** Complete audit trail stored in request table

This "functional" behavior integrates seamlessly with declarative rules via the Request Pattern.

---

## Pattern Architecture

### Core Components

1. **Receiver** - Object that needs value(s) (e.g., Item, Order)
2. **Provider** - Candidate object with source values (e.g., Supplier via ProductSupplierList)
3. **Request Table** - Stores context, results, and audit trail (e.g., SysSupplierReq)
4. **Wrapper Function** - Encapsulates Request Pattern, returns tuple `(primary_value, request_row)`
5. **Integration Point** - Formula (single value) or Event (multiple values)

### Request Table Structure (A/B/C Categories)

**Category A: Constants (generic for ANY AI request)**
```python
id = Column(Integer, primary_key=True)
request = Column(String(2000))        # AI prompt
reason = Column(String(500))          # AI reasoning
created_on = Column(DateTime)         # Timestamp
fallback_used = Column(Boolean)       # Did AI fail?
```

**Category B: Foreign Keys (derived from prompt context)**
```python
item_id = Column(ForeignKey('item.id'))      # Context: which Item?
product_id = Column(ForeignKey('product.id')) # Context: which Product?
```

**Category C: Result Columns (inferred from Provider table)**
```python
chosen_supplier_id = Column(ForeignKey('supplier.id'))  # Maps to supplier_id
chosen_unit_price = Column(DECIMAL)                     # Maps to unit_cost
chosen_lead_time = Column(Integer)                      # Maps to lead_time_days
```

**Key Discovery:** Categories A/B/C can be automatically derived from:
- Prompt analysis (context FKs)
- Provider table introspection (result columns via like-named mapping)
- Generic constants (always the same)

---

## Existing Implementation: Single-Value Example

### Original Prompt

```
Use case: Check Credit:

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

### Implementation

**Request Table:** `SysSupplierReq`
```python
class SysSupplierReq(Base):
    __tablename__ = 'sys_supplier_req'
    
    # Category A: Constants
    id = Column(Integer, primary_key=True)
    request = Column(String(2000))
    reason = Column(String(500))
    created_on = Column(DateTime, default=datetime.datetime.utcnow, nullable=False)
    fallback_used = Column(Boolean, default=False)
    
    # Category B: Context Foreign Keys
    item_id = Column(Integer, ForeignKey("item.id"), index=True, nullable=True)
    product_id = Column(Integer, ForeignKey("product.id"), index=True, nullable=False)
    
    # Category C: Result Columns (from Supplier/ProductSupplier)
    chosen_supplier_id = Column(Integer, ForeignKey("supplier.id"))
    chosen_unit_price = Column(DECIMAL)
    
    # Relationships
    item = relationship("Item", back_populates="SysSupplierReqList")
    product = relationship("Product", back_populates="SysSupplierReqList")
    chosen_supplier = relationship("Supplier")
```

**AI Handler:** `logic/logic_discovery/ai_requests/supplier_selection.py`
```python
def declare_logic():
    """Register AI supplier selection handler."""
    Rule.early_row_event(
        on_class=models.SysSupplierReq,
        calling=supplier_id_from_ai
    )

def supplier_id_from_ai(row: models.SysSupplierReq, old_row, logic_row: LogicRow):
    """
    AI selects optimal supplier based on cost, lead time, and world conditions.
    Uses compute_ai_value() utility for introspection-based computation.
    """
    if not logic_row.is_inserted():
        return
    
    logic_row.log(f"SysSupplierReq - AI supplier selection starting")
    
    # Introspection-based AI value computation
    compute_ai_value(
        row=row,
        logic_row=logic_row,
        candidates='product.ProductSupplierList',
        optimize_for='fastest reliable delivery while keeping costs reasonable, considering world conditions',
        fallback='min:unit_cost'
    )
    
    logic_row.log(f"SysSupplierReq - AI selection complete: supplier_id={row.chosen_supplier_id}, unit_price={row.chosen_unit_price}")

def get_supplier_price_from_ai(row, logic_row: LogicRow):
    """
    Returns optimal supplier price using AI. Encapsulates Request Pattern.
    
    This is the reusable function called by Item formula.
    Creates a SysSupplierReq which triggers the AI handler above.
    """
    # Create request using new_logic_row
    supplier_req_logic_row = logic_row.new_logic_row(models.SysSupplierReq)
    supplier_req = supplier_req_logic_row.row
    
    # Set request context
    supplier_req.product_id = row.product_id
    supplier_req.item_id = row.id
    
    # Insert triggers AI handler
    supplier_req_logic_row.insert(reason="AI supplier selection request")
    
    # Return computed value (functional style)
    return supplier_req.chosen_unit_price
```

**Formula Integration:**
```python
Rule.formula(
    derive=Item.unit_price, 
    calling=get_supplier_price_from_ai
)
```

**Key Points:**
- Formula only needs unit_price (scalar value)
- `chosen_supplier_id` is audit trail only (not used in downstream logic)
- Clean functional interface: call wrapper, get price back

---

## Proposed Enhancement: Multi-Value Example

### Prompt Format

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

**Prompt Pattern Rules:**
1. **Always list receiver fields explicitly** - Makes intent clear
2. **Use like-named inference** - When receiver field matches provider field
3. **Use explicit mapping (=)** - Only when names differ
4. **Mixed approach allowed** - Some inferred, some explicit

**Examples:**
```
# All like-named (inferred)
Set Order fields: supplier_id, unit_cost, lead_time_days

# All explicit (names differ)
Set Order fields:
  - fulfillment_supplier_id = supplier_id
  - estimated_cost = unit_cost
  - delivery_days = lead_time_days

# Mixed (some match, some don't)
Set Order fields:
  - supplier_id
  - estimated_cost = unit_cost
  - lead_time_days
```

### Enhanced Implementation

**Request Table:** (Extends existing `SysSupplierReq`)
```python
class SysSupplierReq(Base):
    # ... existing fields (id, request, reason, created_on, fallback_used) ...
    # ... existing context (item_id, product_id) ...
    
    # Category C: Enhanced result columns
    chosen_supplier_id = Column(Integer, ForeignKey("supplier.id"))
    chosen_unit_price = Column(DECIMAL)
    chosen_lead_time = Column(Integer)  # NEW: Additional value from provider
```

**Enhanced Wrapper Function (Returns Tuple):**
```python
def get_supplier_assignment_from_ai(row, logic_row: LogicRow):
    """
    Returns (chosen_unit_price, supplier_req_row) tuple.
    
    The request row contains all values:
      - chosen_supplier_id
      - chosen_unit_price
      - chosen_lead_time
    
    Caller can use just the scalar value OR destructure for multiple values.
    """
    supplier_req_logic_row = logic_row.new_logic_row(models.SysSupplierReq)
    supplier_req = supplier_req_logic_row.row
    
    supplier_req.order_id = row.id
    supplier_req.product_id = row.items[0].product_id
    
    supplier_req_logic_row.insert(reason="AI supplier assignment for drop-ship")
    
    # Return tuple: (primary_value, full_request_row)
    return (supplier_req.chosen_unit_price, supplier_req)
```

**Event Handler Integration (Multi-Value):**
```python
def assign_dropship_supplier(row: models.Order, old_row, logic_row: LogicRow):
    """
    Early event: When Order is for drop-ship, AI selects supplier
    and populates multiple fields on the Order.
    """
    if not row.is_dropship:  # Hypothetical flag
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

**Formula Integration (Single-Value) - Still Works:**
```python
Rule.formula(
    derive=Item.unit_price, 
    calling=lambda row, logic_row: get_supplier_assignment_from_ai(row, logic_row)[0]
)
```

---

## Pattern Flexibility: Single vs. Multiple Values

The tuple return pattern `(primary_value, request_row)` supports both use cases:

### Single-Value Use Case (Formula)
- **Integration:** `Rule.formula()`
- **Consumption:** Extract `[0]` from tuple (scalar value)
- **Use Case:** Deriving a single column value
- **Example:** `Item.unit_price = AI-selected price`

### Multi-Value Use Case (Event)
- **Integration:** `Rule.early_row_event()`
- **Consumption:** Destructure tuple, access request_row fields
- **Use Case:** Setting multiple fields from AI decision
- **Example:** Order gets supplier_id, cost, AND lead_time

**Key Benefit:** One AI request implementation serves both patterns.

---

## Pattern Generalization

### Applicable Scenarios

This pattern works for any scenario involving:
1. **Selection from candidates** - Multiple options to choose from
2. **AI-driven decision** - Optimization based on multiple criteria
3. **Value extraction** - Getting attribute(s) from chosen candidate
4. **Audit requirement** - Need to track what AI decided and why

**Examples:**
- ✅ Optimal supplier selection
- ✅ Best warehouse for fulfillment
- ✅ Preferred payment processor
- ✅ Routing assignment (driver, route, carrier)
- ✅ Resource allocation (assign ticket to agent)

**Not Applicable:**
- ❌ Pure computation without candidates (dynamic pricing, risk scoring)
- ❌ Forecasting/prediction (no candidate selection)
- ❌ Classification without candidate list

### Pattern Name Rationale

**"Get Values from Best Candidate"** captures:
- **Get Values** - Extracting existing data (not computing new)
- **Best Candidate** - Selection/optimization decision
- **(from list)** - Multiple options to choose from

This distinguishes it from "compute a value" or "transform data" patterns.

---

## Implementation Checklist

When implementing this pattern:

1. **Identify components:**
   - [ ] Receiver object (what needs values?)
   - [ ] Provider relationship path (where are candidates?)
   - [ ] Values needed (single or multiple?)

2. **Design request table:**
   - [ ] Category A: Standard audit fields
   - [ ] Category B: Context FKs from prompt
   - [ ] Category C: Result columns via like-named mapping

3. **Create AI handler:**
   - [ ] Early row event on request table
   - [ ] Call `compute_ai_value()` with candidates path
   - [ ] Specify optimization criteria

4. **Create wrapper function:**
   - [ ] Use Request Pattern (`new_logic_row()`)
   - [ ] Return tuple `(primary_value, request_row)`
   - [ ] Document what values are available

5. **Integrate:**
   - [ ] Formula: Extract `[0]` for scalar value
   - [ ] Event: Destructure tuple for multiple values

---

## Technical Implementation Notes

### compute_ai_value() Utility

Current implementation (`logic/system/ai_value_computation.py`):
- ✅ **Generic introspection** - Discovers candidate fields automatically
- ✅ **Relationship navigation** - Follows any SQLAlchemy relationship path
- ✅ **Graceful fallback** - Works without OpenAI API key
- ✅ **Complete audit trail** - Stores prompt, response, reasoning

**Hardwired elements (need generalization):**
- ❌ Result column mapping in `_map_ai_response()` (currently supplier-specific)
- ❌ Fallback mapping in `_apply_fallback()` (hardcoded field names)
- ❌ Prompt building in `_build_prompt()` (domain-specific text)

**Future Enhancement:** Make result mapping fully introspective by discovering `chosen_*` columns on request table dynamically.

---

## Questions for Further Exploration

1. **Request table generation:** Can we auto-generate the entire request table from prompt + provider introspection?

2. **Prompt parsing:** How do we parse "Set Order fields: x=y, z" to extract mappings?

3. **Like-named inference:** Is automatic name matching too "magical"? Risk of accidental wrong mappings?

4. **Multiple candidates sources:** What if we need to select from multiple relationships (ProductSupplierList AND WarehouseList)?

5. **Computed values in mix:** Can we combine "select from candidates" with "compute additional values"?

---

## Conclusion

The "Get Values from Best Candidate" pattern provides a solid, generalizable architecture for AI-driven selection in declarative business logic. The tuple return pattern elegantly handles both single-value and multi-value use cases with a unified implementation.

**Key innovations:**
- Functional interface (AI as function call)
- Complete audit trails (request table pattern)
- Flexible integration (formula or event)
- Graceful degradation (fallback strategies)
- Natural language prompts (like-named inference)

**Next Steps:**
- Test implementation with drop-ship example
- Update training documentation with multi-value pattern
- Generalize `compute_ai_value()` for full introspection
- Develop prompt parsing for automatic implementation
