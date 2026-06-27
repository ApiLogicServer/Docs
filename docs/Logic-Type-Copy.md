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

### Multiple Relationships to the Same Parent

If the child and parent classes are connected by more than one relationship, `Rule.copy` cannot infer which one to follow, and raises `Ambiguous Relationship`. Resolve this with `child_role_name`, naming the relationship attribute declared on the **child** class - see [Logic-Type-Sum: Multiple Relationships to the Same Parent](Logic-Type-Sum.md#multiple-relationships-to-the-same-parent){:target="_blank" rel="noopener"} for the full explanation and example.

```python
Rule.copy(derive=models.Employee.works_for_dept_name_copy, from_parent=models.Department.name,
          child_role_name="works_for_dept")
```
