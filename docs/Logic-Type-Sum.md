!!! pied-piper ":bulb: TL;DR - Derive parent-attribute as sum of designated child attribute; optional child qualification"

    Sum derivations enable you to aggregate child data.  They are declared in the `declare_logic()` function in `logic/declare_logic.py`.

    Sums are **efficient:** child changes result in a 1 row **adjustment** update, not an expensive `select sum`.  And, they are pruned entirely if child does not alter the summed field or the qualification condition.

&nbsp;

## Defining Sums

You declare sums in xxx:

```python
Rule.sum(derive=models.Customer.Balance,        # adjust iff AmountTotal or ShippedDate or CustomerID changes
        as_sum_of=models.Order.AmountTotal,
        where=lambda row: row.ShippedDate is None)  # adjusts - *not* a sql select sum...
```

## Insert Parent option

In most cases, the parent must exist or an exception will be thrown.  However, you may wish to create "group by" aggregates rows; see the [Budget App](Tech-Budget-App.md){:target="_blank" rel="noopener"}.

You can achieve this effect with the `insert_parent` parameter:

```python
Rule.sum(derive=models.YrTotal.budget_total, as_sum_of=models.CategoryTotal.budget_total,insert_parent=use_parent_insert)
```