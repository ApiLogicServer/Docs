
## What Are the Rules
The table shows excerpts only; see the ```ApiLogicProject``` (Northwind) sample for full syntax.

| Rule | Summary   | Example | Notes |
| :-------------: |:-------------:| :-----:| :-----:|
| Constraint     | Boolean function must be True<br>else transaction rolled back | ```row.Balance <= row.CreditLimit```<br>```row.Salary >= Decimal('1.20') * old_row.Salary``` | Multi-field<br>```old_row``` |
| Formula | Function computes column value | ```row.UnitPrice * row.Quantity```<br>```row.OrderHeader.ShippedDate``` | lambda, or function<br>Parent ```(OrderHeader)``` references |
| Sum | Derive parent-attribute as sum of designated child attribute; optional child qualification | ```Rule.sum(derive=Customer.Balance, as_sum_of=Order.AmountTotal,where=lambda row: row.ShippedDate is None)``` | Parent attribute can be hybrid (virtual)<br>scalable: pruning, adjustment |
| Count | Derive parent-attribute as count of child rows; optional child qualification | ```Rule.sum(derive=Customer.Balance, as_sum_of=Order.AmountTotal,where=lambda row: row.ShippedDate is None)``` | Parent attribute can be hybrid (virtual)<br>scalable: pruning, adjustment |
| Copy      | Child value set from Parent     | ```OrderDetail.ProductPrice = copy(Product.Price)``` | Unlike formula references, parent changes are not propagated<br>e.g, Order totals for Monday are not affected by a Tuesday price increase |
| Event      | Python Function    | on insert, call ```congratulate_sales_rep``` | See [Extensibility](Logic-Why.md#extend-python) for a information on early, row and commit events |
| Parent Check      | Ensure Parent row exists | Orders must have a Customer | See [Referential Integrity](https://github.com/valhuber/LogicBank/wiki/Referential-Integrity) |
| Allocation      | Allocate a provider amount to recipients | allocate a payment to outstanding orders | See [Allocation](https://github.com/valhuber/LogicBank/wiki/Sample-Project---Allocation) for an example |
| Copy Row      | Create child row by copying parent | audit Employee Salary changes to EmployeeAudit | See [Rule Extensibility](https://github.com/valhuber/LogicBank/wiki/Rule-Extensibility) |

&nbsp;


## Learning Rules

Inside the larger process above, here is the best way to learn how to use rules:

1. **Rule Summary**: review the table above; there are a small number of rules, since their power lies in chaining

    * **Alert:** Logic consists of rules and Python.  You will quickly learn to use logic events; focus on the *rules as the preferred* approach, using Python (events, etc) as a *fallback*.

2. Review the **Rule Patterns**, below

3. Use the _case study_ approach to learn about using rules, by exploring the examples in the report, below.

4. Be aware of [Rule Extensibility](https://github.com/valhuber/LogicBank/wiki/Rule-Extensibility).

&nbsp;&nbsp;


### Rule Patterns

| Pattern | Notes | Example
| :------------- | :-----| :---- |
| **Chain Up** | parent sums and counts mean that child row changes can ***adjust*** parents | [Derive Balance](Behave-Logic-Report.md#scenario-bad-order-custom-service)
| **Chain Down** | child copy and parent references mean that parent row changes can ***cascade*** to children | [Ship Order](Behave-Logic-Report.md#scenario-set-shipped-adjust-logic-reuse) 
| **Constrain a Derived Result** | constraints may require derived values | [Balance < creditLimit](Behave-Logic-Report.md#scenario-bad-order-custom-service)
| **Auditing** | Note the Copy Row rule | [Salary Audit](Behave-Logic-Report.md#scenario-audit-salary-change)
| **old_row** | useful for state transition logic | [Meaningful Raise](Behave-Logic-Report.md#scenario-audit-salary-change.md)

&nbsp;

### Case Study

The best way to learn the rules is by a Case Study approach:

1. Print this page, for reference

2. Print the [Database Diagram](Sample-Database.md){:target="_blank" rel="noopener"}

    * Most of the examples are drawn from this database

3. See the [Behave Logic Report](Behave-Logic-Report.md){:target="_blank" rel="noopener"}

4. For each scenario

    * Take the Scenario as your requirements

    * Spend 5 minutes, paper-designing your solution

    * Reveal the solution: open the disclosure box: "Tests - and their logic - are transparent.. click to see Logic"

