!!! pied-piper ":bulb: TL;DR - Derive Attribute from parent -- parent changes do not propagate"

    Copy rules provide parent access, ***without* propagation.**   They are declared in the `declare_logic()` function in `logic/declare_logic.py`.

    Constrast this to Formula derivation rules which enable parent references, *with propogation*.


&nbsp;

### Declare Copy Rule

In this example, Product UnitPrice changes are not propagated to existing OrderDetails.  So, your Monday purchase is not affected by a Tuesday price change:

```python
Rule.copy(derive=models.OrderDetail.UnitPrice,  # get Product Price (e,g., on insert, or ProductId change)
        from_parent=models.Product.UnitPrice)
```
