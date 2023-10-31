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
