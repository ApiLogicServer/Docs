## AI Taught the Wrong Lesson.

Funny story. A while back I asked my AI assistant for an example of a business rule, just to show someone how it's done. It gave me this:

```
On Placing Orders,
Derive item amount as quantity times Product Price
Add that to the Order Total Amount
Add that to the Customer Balance
Ensure that is less that the Credit Limit
```

I gasped. Here was AI teaching people the wrong paradigm — procedural code, wired to one event.

The whole point of a rule is that it **isn't** wired to anything. It declares what a value *is*, not when to compute it.

### Then It Passed the Test Anyway.

And yet, models had been improving. So I tried it anyway. I created a project, submitted that same procedural text, and asked for rules. Five came back:

```python
Rule.copy(derive=Item.unit_price, from_parent=Product.unit_price)
Rule.formula(derive=Item.amount, as_expression=lambda row: row.quantity * row.unit_price)
Rule.sum(derive=Order.amount_total, as_sum_of=Item.amount)
Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None)
Rule.constraint(validate=Customer, as_condition=lambda row: row.balance <= row.credit_limit, ...)
```

Declarative. None of them wired to "placing an order." (One of these 5 lines has a mistake in it — more on that at the end.)

That's not a style preference — it's the whole point. "On Placing Orders" only covers placing an order. These 5 rules cover **every path** to the same data:

- change an item's quantity after the fact
- delete an item
- ship the order
- move an item to a different order
- move an order to a different customer

Same 5 rules, every time — because they're declared on `Item.amount`, `Order.amount_total`, and `Customer.balance` themselves, not on the moment someone places an order.

Think of a spreadsheet. `B10 = SUM(B1:B9)` doesn't get called when a value changes — it just reacts. Nobody writes a handler for "what if row 4 changes" versus "what if row 7 changes." The formula is declared once, on the data, and it's correct no matter which cell moves. That's what these 5 rules are doing with `Order.amount_total` and `Customer.balance` — the same automatic reaction, just across tables instead of cells.

AI hadn't just avoided the wrong lesson. It had translated its way past it — into something that actually covers every path, not just the one it was shown.

## That's How Developers Actually Write Specs.

Then I watched a video that's picked up real traction fast — someone arguing that AI coding failures aren't a skill issue, they're an architecture issue, and "you're holding it wrong" is a dodge, not an answer.

That's when it hit me: "On Placing Orders, derive X, add it to Y, check it against Z" is a typical spec. Developers describe requirements as a sequence of things that happen, because that's how people naturally talk through a process.

So what happens when a developer hands an AI assistant a spec written exactly this way? No rules engine underneath, nothing translating it first — just the plain, ordinary spec, and trust that whatever comes back is correct.

I agree with the video's argument. But agreeing isn't proof. So I ran the test — the exact same prompt, verbatim, handed to two frontier models:

```
Note: this is a test of native AI coding ability — please do not use ApiLogicServer,
GenAI-Logic, LogicBank, or any other code-generation or business-rules/rules-engine
framework. Just plain hand-written code (standard web framework + ORM of your choice).

Using basic_demo.sqlite, build a system (api + web app) that lets us enter orders.

Here's what needs to happen when someone places an order:

- For each line item on the order, look up the product's price and multiply by the quantity to get the item's amount.
- Add up the item amounts to get the order's total.
- Add the order total to the customer's balance.
- Before we let the order go through, check that the customer's balance doesn't go over their credit limit — if it would, reject the order.
```

Same schema. Same wording. No ApiLogicServer, no rules engine — told explicitly not to use either. Plain hand-written code, their choice of stack.

## Only the Insert Path Was Built

Both wrote the same shape of system:

```python
def place_order(db, customer_id, notes, line_items):
    ...
    new_balance = (customer.balance or Decimal("0")) + order_total
    if new_balance > customer.credit_limit:
        raise OrderRejected(...)
    order.amount_total = order_total
    customer.balance = new_balance
    db.commit()
```

One function, wired to order creation. No update path. No delete path.

`Customer.balance` isn't a value the system tracks — it's a running total, incremented when an order comes in and never touched again.

I probed it:

- Changed an item's quantity
- Deleted an item
- Reassigned an order to a different customer
- Reassigned an item to a different product

**Every case, both models, left stale data behind.** No error. Nothing to catch it. The logic wasn't buggy so much as absent — it existed for exactly one path and nowhere else.

## Same Prompt, Every Path Covered

I ran the identical prompt through GenAI-Logic. Five rules came out:

```python
Rule.copy(derive=Item.unit_price, from_parent=Product.unit_price)
Rule.formula(derive=Item.amount, as_expression=lambda row: row.quantity * row.unit_price)
Rule.sum(derive=Order.amount_total, as_sum_of=Item.amount)
Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total)
Rule.constraint(validate=Customer, as_condition=lambda row: row.balance <= row.credit_limit, ...)
```

None of them says "placing an order." Checked live against a running server, all four cases came back correct:

- Change the quantity → the total updates
- Delete the item → the balance drops back
- Move the order to a new customer → old balance down, new balance up
- Move the item to a new product → the price re-copies

## Architecture Instead of Tribal Knowledge

Code quality was never the variable. What matters is what the code is attached to.

Procedural logic answers "what happens when X happens" — and only covers the X it was told about.

A rule is declared on the data itself, so it applies to every path automatically: insert, update, delete, reassignment, all of it, for free.

That's the case for domain expertise showing up as **architecture instead of tribal knowledge**. The judgment that catches "you forgot the old parent" doesn't have to live in one senior developer's head, reapplied by hand, project after project. It can live in the engine, applied the same way every time — with or without a smarter model underneath it.

There's a name for this: **Governance by Architecture, Not Discipline.** Governance by discipline means trusting every developer to make the right integrity call, every time, on every path — including the paths nobody thought to test. Governance by architecture means the system enforces it whether anyone thought to or not.

Concretely, that's two pieces:

- **A rule engine that understands the dependencies** — it knows `Customer.balance` depends on `Order.amount_total` depends on `Item.amount`, so it re-derives all of it, automatically, on every write, whether or not the code in front of it ever mentions "placing an order."
- **Context Engineering that instructs the same AI to write rules, not code** — the same model that wrote the frankencode above, pointed at a rules engine instead of a blank file, writes 5 rules.

This test is what that looks like when it fails. Two frontier models. Zero paths remembered beyond the one in the prompt. No careless developer to blame, either — there was no developer. Just the model, on its own, asked to do the one thing discipline-based governance has always asked of a person: remember every path, every time.

It didn't. Nothing does, forever, reliably. That's not a knock on the models. It's just what happens when the plan was "remember everything," and the thing doing the remembering — human or AI — is still a thing that forgets.

## One More Thing — AI Still Gets It Wrong

Here's the mistake I flagged back at the start: the very first rule set in this article included `where=lambda row: row.date_shipped is None` on the `Customer.balance` rule — a shipped-orders filter this prompt never asked for. Compare it to the second rule set, later in this piece, for the same requirement — that clause is gone. I caught it and dropped it, but not before it sat there, unremarked, in what I'd already called "declarative."

Nobody said anything about shipping. AI added it anyway, echoing a different example it had seen before.

That's a real error. AI makes them.

But look at where it was sitting: one clause, on one line, in a 5-line rule set, in plain English terms — *"sum of Order amount_total where date_shipped is null."* I read it, recognized it didn't belong, and removed it. Took a few seconds.

**That's a separate argument from reuse.** Rules cover every path automatically — but readability is what lets you catch AI when it gets one wrong.

That's how 5 lines of logic become 5 rules — not ~200 lines of frankencode you can't read, spread across handlers and queries, with the same mistake buried three calls deep where nobody will ever find it.

You can't govern what you can't read.

AI will keep making mistakes. The question is whether you can find them before your customer does.
