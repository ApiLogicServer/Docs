!!! pied-piper ":bulb: TL;DR - Derive attribute using other attributes of current/parent class"

    Formula rules are lambda expressions or functions that can reference other attributes of current/parent class.  They are declared in the `declare_logic()` function in `logic/declare_logic.py`.
    
    Execution **order is system-determined** based on dependencies.

    Changes to **referenced parent attributes are propagated** to all child rows.  Contrast this to the `Copy` rule, for parent references where you do not want propagation.

    Formulas may be **pruned** if there are no changes to the referenced attributes.

&nbsp;

## Provide expression as lamda

Simple formulas are most easily expressed as lambda functions:

```python
Rule.formula(derive=models.OrderDetail.Amount,  # compute price * qty
        as_expression=lambda row: row.UnitPrice * row.Quantity)
```

&nbsp;

## Provide expression as function

```python
   def derive_amount(row: models.Item, old_row: models.Item, logic_row: LogicRow):
       amount = row.Quantity * row.UnitPrice
       if row.Product.CarbonNeutral and row.Quantity >= 10:
           amount = amount * Decimal(0.9)
       return amount


   Rule.formula(derive=models.Item.Amount, calling=derive_amount)
```

&nbsp;

## How parent references are detected

Pruning and parent-change propagation both depend on the system recognizing which parent attributes a formula references - it does this by scanning the rule's own source text for `row.<parent>.<attribute>`, e.g. `row.Product.CarbonNeutral` above.

If a `calling=` function's parent access happens **inside a helper function it calls** (rather than appearing directly in the function you pass to `calling=`), the scan won't see it - the formula will be wrongly pruned on updates, and won't recompute when the parent attribute changes. Fix this by adding a `# deps:` comment naming the references directly in the function body - the scan reads comments too:

```python
def _quantity(row, old_row, logic_row):
    # deps: row.OrderLine.Quantity row.OrderLine.DateServed
    return _derive_quantity(row, logic_row)  # parent access happens inside here

Rule.formula(derive=models.Movement.Quantity, calling=_quantity)
```

&nbsp;
