!!! pied-piper ":bulb: TL;DR - Specify expression / function that must be true after the transaction settles, else exception"

    Commit Constraints declare an expression (lambda) or function that must be true for a transaction to complete - like [Constraints](Logic-Type-Constraint.md), but checked once, *after* the transaction's rule cascade has fully settled, instead of inline as each row is processed. You also provide a message that is returned in the exception that is raised if the expression is not true.

    Use a Commit Constraint instead of a Constraint when your condition depends on a derived value (e.g., a `Rule.count` or `Rule.sum`) that isn't final until sibling rows in the *same transaction* have been processed - most commonly, min-cardinality rules like *"Order must have at least one Item."*

## Why not just use Constraint?

A plain `Constraint` is checked inline, as part of processing each row during the transaction's rule cascade - including a row's own insert. That's a problem for min-cardinality rules: if you insert an `Order` and its `OrderDetail` rows in the same transaction, the `Order`'s own insert-time logic can run before its `OrderDetail` rows have been processed, so a `Constraint` checking `row.item_count > 0` can see a stale count of 0 - even though the Items are about to be added in that same commit.

`Rule.commit_constraint` avoids this: it's checked once per affected row, after the whole transaction's cascade has settled - so it always sees the final, correct value.

## Provide expression as lambda

```python
Rule.count(derive=Order.item_count, as_count_of=OrderDetail)

Rule.commit_constraint(validate=Order,
                as_condition=lambda row: row.item_count > 0,
                error_msg="Order {row.Id} must have at least one item")
```

Note the argument is the row, providing access to the attributes - same as `Constraint`. You can stop in the debugger and examine values when the lambda is invoked.

## Provide function - old_row, verb

For more complex cases, you can provide a function instead of `as_condition`, using `calling=`. Note the arguments include `old_row` and `logic_row`. The latter provides access to the verb, so you can make your logic apply only to the desired verbs - same signature as `Constraint`'s function form.

```python
def check_item_count(row: Order, old_row: Order, logic_row: LogicRow):
    return row.item_count > 0

Rule.commit_constraint(validate=Order, calling=check_item_count,
                error_msg="Order {row.Id} must have at least one item")
```

## When it runs

| | Constraint | Commit Constraint |
| :--- | :--- | :--- |
| Checked | Inline, per row, as each row is processed during the flush cascade | Once per affected row, after the transaction's cascade has fully settled |
| Sees | The row's state *at the moment it's processed* - may be mid-cascade | The row's final, settled state |
| Good for | Ordinary single/multi-field validations (e.g., `row.Balance <= row.CreditLimit`) | Min-cardinality / "existence" rules whose derived value isn't final until sibling inserts/deletes in the same transaction have chained through (e.g., `row.item_count > 0`) |

&nbsp;

See the `min_cardinality` example in the [LogicBank repo](https://github.com/valhuber/LogicBank/tree/main/examples/min_cardinality) for a complete, runnable worked example (Order/OrderDetail, with regression tests for insert-with-items, insert-without-items, and delete-last-item).
