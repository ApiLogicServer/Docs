# Executable Requirements

Most requirements documents describe a system that will be built. Then the system gets built — differently. The document drifts. Nobody updates it.

What if the requirements *were* the system?

## The Prompt Is the Spec

A business analyst writes this — exactly as they'd describe the logic in a meeting:

```gherkin
Feature: Check Credit

  Scenario: Place an order
    Given a customer with a credit limit
    When an order is placed
    Then copy the price from the product
    And multiply by quantity to get the item amount
    And sum item amounts to get the order total
    And sum order totals to get the customer balance
    And reject if balance exceeds the credit limit
```

AI reads it and produces two things: five declarative rules, and a complete test suite.

```python
# AI distills path-specific intent into path-independent rules
Rule.copy(derive=Item.unit_price, from_parent=Product.unit_price)
Rule.formula(derive=Item.amount,
             as_expression=lambda row: row.quantity * row.unit_price)
Rule.sum(derive=Order.amount_total, as_sum_of=Item.amount)
Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total,
         where=lambda row: row.date_shipped is None)
Rule.constraint(validate=Customer,
                as_condition=lambda row: row.balance <= row.credit_limit)
```

The test suite covers eight scenarios. The Gherkin specified one.

Delete an order — nobody mentioned that. Ship an order — nobody mentioned that. An inbound Kafka message, an agent update — not in the spec. All green. Because the rules are on the *data*, not the path. Every transaction source — API, UI, message, agent — passes through the same commit gate and inherits the same rules automatically.

This isn't prompt quality. It's architecture.

## Shared Logic Across Integration Styles

The same rules govern every path — including external integrations. A second prompt proves it:

```gherkin
Feature: B2B Order Integration

  Scenario: Accept order from external partner
    Given an inbound B2B order in partner format
      | Account        | Alice   |
      | Notes          | Urgent  |
      | Items.Name     | Widget  |
      | Items.Quantity | 3       |
    When the order is received via the Custom API
    Then map Account to Customer by name
    And map Items.Name to Product by name
    And create the order with all Check Credit rules enforced
```

AI generates the custom endpoint and field mappings. No new logic is written. The B2B API inherits the same five rules as every other path.

## What You Get

One business prompt. AI delivers:

- **Standard JSON:API** — filtering, sorting, pagination, optimistic locking
- **Admin app** — multi-table, automatic joins, ready on day one
- **Declarative rules** — enforced on every path, at commit, with no bypass
- **B2B API and Kafka integration** — same rules, no new logic
- **Behave test suite** — generated from the rules, not written by hand
- **Logic Report** — requirement → rule → execution trace
- **Standard project** — Python, your IDE, your source control, container-ready

The Logic Report closes the loop: every transaction shows which rules fired, in what order, with before and after values. Compliance can prove governance — not just assert it.

## The Insight

These prompts are not a description of what got built. They are the actual requirements, in a form AI can execute directly. This is a real project: your IDE, your Python, your source control. The prompts create it instantly — but you own it fully and iterate from there.

Instead of Word documents that describe a system and then drift from it, requirements can be structured prompts — precise enough for AI to execute, readable enough for business and IT to agree on.

**The spec and the running system are the same artifact. They can't drift.**

---

*Try it: [Install GenAI-Logic →](https://apilogicserver.github.io/Docs/Install-Express/)*
