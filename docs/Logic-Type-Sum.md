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

## Multiple Relationships to the Same Parent

If the child and parent classes are connected by **more than one relationship** - for example, an `Employee` that can be `works_for` one `Department` and `on_loan` to another - `Rule.sum` cannot infer which relationship to follow, and raises `Ambiguous Relationship`.

Resolve this with `child_role_name`, naming the relationship attribute declared on the **child** class:

```python
Rule.sum(derive=models.Department.works_for_salary_total, as_sum_of=models.Employee.salary,
         child_role_name="works_for_dept")
Rule.sum(derive=models.Department.on_loan_salary_total, as_sum_of=models.Employee.salary,
         child_role_name="on_loan_dept")
```

`child_role_name` is only needed when ambiguity exists - the typical single-relationship case omits it entirely. The same parameter is available on `Rule.count` and `Rule.copy` for the same reason.