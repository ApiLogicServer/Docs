!!! pied-piper ":bulb: TL;DR - n-fold Reduction of Backend Logic With Declarative (Spreadsheet-like) Rules"

    For transaction systems, backend **multi-table constraint and derivation logic** is often nearly *half* the system.  API Logic Server automates such logic with unique **declarative (spreadsheet-like) rules**, which can be extended with Python. 
    
    **Declare in Python**, **debug** with your IDE, **extend** with Python events as needed.

    Rules are **40X more concise than code**.

    Rules help **automate maintenance**, since they are automatically called and ordered.

    Rules are **architected for re-use, automatically applied** to all UI Apps, Services, and your custom APIs.

    Rules are **architected for scalable multi-table performance**, with automatic *pruning* and use of *adjustment* logic to avoid expensive aggregate / multi-row queries.

    * Such optimizations can easily represent *multiple orders of magnitude* - contrast to [Rete engines, ORM services and `iterator` verbs](#scalability-prune-and-optimize)

This page describes:

* how "code explosion" makes logic important to your project
* how you use rules: delcare, extend, debug
* how the rules operate: watch, react, chain
* several key aspects of rules, and
* how rules compare to similar-looking technologies

&nbsp;

## Problem: Code Explosion

In conventional approaches, such logic is **nearly half the system,** due to code explosion.  A typical design specification of 5 lines explodes into [200 lines of legacy code](https://github.com/valhuber/LogicBank/wiki/by-code){:target="_blank" rel="noopener"}.

Let's imagine we have a "cocktail napkin spec" for checking credit, shown (in blue) in the diagram below.  How might we enforce such logic?

* In UI controllers - this is the most common choice.  It's actually the worst choice, since it offers little re-use between forms, and does not apply to non-UI cases such as API-based application integration.

* Centralized in the server - in the past, we might have written triggers, but a modern software architecture centralizes such logic in an App Server tier.  If you are using an ORM such as SQLAlchemy, you can _ensure sharing_ with `before_flush` events as shown below.

After we've determined _where_ to put the code, we then have to _write_ it.  Our simple 5 line cocktail napkin specification explodes into [200 lines of legacy code](https://github.com/valhuber/LogicBank/wiki/by-code){:target="_blank" rel="noopener"}):

<figure><img src="https://github.com/valhuber/LogicBank/raw/main/images/overview/rules-vs-code.png"></figure>

It's also incredibly repetitive - you often get the feeling you're doing the same thing over and over.

And you're right.  It's because backend logic follows patterns of "what" is supposed to happen.
And your code is the "how". 

!!! note "So, API Logic Server provides Declarative Business Rules for multi-table derivations and constraints"
    Rules typically automate over **95% of such logic,** and are **40X more concise**.  You can think of rules as conceptually similar to [spreadsheet cell formulas](Logic-Operation.md#basic-idea-like-a-spreadsheet){:target="_blank" rel="noopener"}, applied to your database.  

&nbsp;

## Rules: Declare, Extend, Debug

Use your IDE to declare rules, extend them with Python, and debug them as described below.

&nbsp;

### Declare: Python

For this typical check credit design (in blue), the __5 rules shown below (lines 90-105) represent the same logic as [200 lines of code](https://github.com/valhuber/LogicBank/wiki/by-code){:target="_blank" rel="noopener"}__:

![5 rules not 200 lines](images/logic/5-rules-cocktail.png)


<details markdown>

  <summary>See the code here</summary>
  
```python
"""
Logic Design ("Cocktail Napkin Design") for User Story Check Credit
    Customer.Balance <= CreditLimit
    Customer.Balance = Sum(Order.AmountTotal where unshipped and ready)
    Order.AmountTotal = Sum(OrderDetail.Amount)
    OrderDetail.Amount = Quantity * UnitPrice
    OrderDetail.UnitPrice = copy from Product
"""

Rule.constraint(validate=models.Customer,       # logic design translates directly into rules
    as_condition=lambda row: row.Balance <= row.CreditLimit,
    error_msg="balance ({row.Balance}) exceeds credit ({row.CreditLimit})")

Rule.sum(derive=models.Customer.Balance,        # adjust iff AmountTotal or ShippedDate or CustomerID changes
    as_sum_of=models.Order.AmountTotal,
    where=lambda row: row.ShippedDate is None and row.Ready == True  # adjusts - *not* a sql select sum...

Rule.sum(derive=models.Order.AmountTotal,       # adjust iff Amount or OrderID changes
    as_sum_of=models.OrderDetail.Amount)

Rule.formula(derive=models.OrderDetail.Amount,  # compute price * qty
    as_expression=lambda row: row.UnitPrice * row.Quantity)

Rule.copy(derive=models.OrderDetail.UnitPrice,  # get Product Price (e,g., on insert, or ProductId change)
    from_parent=models.Product.UnitPrice)

"""
    Demonstrate that logic == Rules + Python (for extensibility)
"""
def congratulate_sales_rep(row: models.Order, old_row: models.Order, logic_row: LogicRow):
    """ use events for sending email, messages, etc. """
    if logic_row.ins_upd_dlt == "ins":  # logic engine fills parents for insert
        sales_rep = row.Employee
        if sales_rep is None:
            logic_row.log("no salesrep for this order")
        elif sales_rep.Manager is None:
            logic_row.log("no manager for this order's salesrep")
        else:
            logic_row.log(f'Hi, {sales_rep.Manager.FirstName} - '
                            f'Congratulate {sales_rep.FirstName} on their new order')

Rule.commit_row_event(on_class=models.Order, calling=congratulate_sales_rep)
```
</details>


Notes:

1. Rather than learn a new studio, use your **IDE code completion services** for logic declaration - just type `Rule.`   Your IDE and Python combine to enable [Python as a DSL](Tech-DSL.md){:target="_blank" rel="noopener"}. 

2. See here for the [list of rule types](Logic.md){:target="_blank" rel="noopener"}, and recommended training for learning to use rules.

3. Unlike procedural code, you neither "call" the rules, nor order their execution

    * The Logic Bank rule engine watches SQLAlchemy updates, and ensures the relevant rules are optimized and executed in the proper order per system-discovered rule dependencies.

&nbsp;

### Extend: Python

While 95% is certainly remarkable, it's not 100%.  Automating most of the logic is of no value unless there are provisions to address the remainder.

That provision is standard Python, provided as standard events:  ***Logic = Rules + Python.***  (See lines 87-100 in the `event` example, below).  This will be typically be used for non-database oriented logic such as files and messages, and for extremely complex database logic.

The system provides [`logic_row`](Logic-Use.md#logicrow-old_row-verb-etc){:target="_blank" rel="noopener"} to access the `old_row`, determine the verb, etc.  For more information, see [Logic Row](Logic-Use.md#logicrow-old_row-verb-etc){:target="_blank" rel="noopener"}.

<details markdown>

  <summary>`event` example</summary>

![venv](images/vscode/venv.png)

  > If code completion isn't working, ensure your `venv` setup is correct - consult the [Trouble Shooting](Troubleshooting.md#code-completion-fails){:target="_blank" rel="noopener"} Guide.

</details>

&nbsp;

### Debug: your IDE

Test your logic by making updates using the Admin App, Swagger API documentation, cURL, etc.

As shown in [Logic Debugging](Logic-Use.md#logic-debugging){:target="_blank" rel="noopener"}, you can use your IDE debugger to logic rules.  In addition, logic execution creates a useful Logic Log, showing the rules that execute, the row state, and nesting.

&nbsp;

### Iterate: alter rules

To iterate (debug cycles and maintenance), simply alter the rules and add new ones - in any order.  The system ensures they will be called, in the proper order.  This helps to ensure correctness, and eliminates the need to determine *where* to insert new logic.

&nbsp;

### Documentation and Testing

Use any standard test framework for system testing.  One option is to use the [Behave framework](Behave.md){:target="_blank" rel="noopener"} to capture requirements as tests, and then execute your test suite.  API Logic server can generate a wiki [Behave Logic Report](Behave-Logic-Report.md){:target="_blank" rel="noopener"}, reflecting the requirements, including the rules that execute in each test.

&nbsp;

## Watch, React, Chain

The LogicBank rule engine opertes by plugging into SQLAlchemy `beforeFLush` events, to:

* **watch** for changes -  at the ___attribute___ level; for changed attributes...
* **react** by running rules that referenced changed attributes, which can...
* **chain** to still other attributes that refer to _those_ changes.  

    * Note these might be in **different tables,** providing automation for _multi-table logic_
    * Special optimizations are provided for performance, as [described below](#scalability-prune-and-optimize).

For more information, see [Logic Operation](Logic-Operation.md#watch-react-chain){:target="_blank" rel="noopener"}.

&nbsp;

## Key Aspects of Logic

While conciseness is the most immediately obvious aspect of logic, rules provide deeper value as summarized below.

| Concept | Rule Automation | Why It Matters|
| :--- |:---|:---|
| Re-use | Automatic re-use over all resources and actions | __Velocity / Conciseness:__ Eliminates logic replication over multiple UI controllers or services. |
| Invocation | Automatic logic execution, on referenced data changes |__Quality:__ Eliminates the _"code was there but not called"_ problem.<br><br>Rules are _active,_ transforming ‘dumb’ database objects into _smart_ business objects |
| Execution Order | Automatic ordering based on dependencies |__Maintenance:__ Eliminates the _"where do I insert this code"_ problem - the bulk of maintenance effort. |
| Dependency Management | Automatic chaining |__Conciseness:__ Eliminates the code that tests _"what's changed"_ to invoke relevant logic |
| Multi-Table Chaining | Multi-Table Transactions |__Simplicity:__ Eliminates and optimizes data access code |
| Persistence | Automatic optimization |__Performance:__ Unlike Rete engines which have no concept of old values, transaction logic can prune rules for unchanged data, and optimize for adjustment logic based on the difference between old/new values.  This can literally result in sub-second performance instead of multiple minutes, and can be tuned without recoding.. |

See also the [FAQs](FAQ-RETE.md){:target="_blank" rel="noopener"}.

&nbsp;

### Concise: Dependencies

Consider the rule `Customer.Balance = Sum(Order.AmountTotal where unshipped)`.  In a procedural system, you would write dependency mangement code, checking:

* Did the `Order.AmountTotal` change?
* Did the `Order.DateShippedDate` change?
* Was the Order inserted?
* Was the Order deleted?
* Did the `Order.CustomerId` (foreign key) change?

**In a declarative system, dependency management is automated,** eliminating this effort.  This is a signifcant reason that rulea are n-fold more concise as explained at the top of this page.

&nbsp;

### Automatic Ordering

While the conciseness of rules is probably their most striking aspect, automatic ordering provides significant value in automating maintenance.  In a procedural system, introducing a change requires *archaeology:* read the existing code to determine where to insert the new code.

**In a declarative system, ordering is automated.**  The system parses your _derivation rules_ to determine dependencies, and uses this to order execution.  This occurs once per session on activation, so rule declaration changes automatically determine a new order.  

This is significant for iterative development and maintenance, eliminating the *archaeology time* spent determining _where do I insert this new logic_.

&nbsp;

### Automatic Reuse

In a procedural system, reuse is achieved with careful *manual* design.  **In a declarative system, reuse occurs *automatically,*** at multiple levels:

* **Architectural Reuse:** rules are defined for your data, *not* a specific page or service.  They therefore to apply to all transaction sources.

    * Internally, the LogicBank rule engine plugs into SQLAlchemy `beforeFlush` events.

* **Use Case Reuse:** just as a spreadsheet reacts
to inserts, updates and deletes to a summed column,
rules automate _adding_, _deleting_ and _updating_ orders.
This results in a "design one / solve many" scenario.

Our cocktail napkin spec is conceptually similar to a set of spreadsheet-like rules that govern how to derive and constrain our data.  And by conceiving of the rules as associated with the _data_ (instead of a UI button), rules conceived for Place Order _automatically_ address these related transactions:

*   add order
* [**Ship Order**](Behave-Logic-Report.md#scenario-set-shipped-adjust-logic-reuse){:target="_blank" rel="noopener"} illustrates *cascade*, another form of multi-table logic
*   delete order
*   assign order to different customer
*   re-assign an Order Detail to a different Product, with a different quantity
*   add/delete Order Detail


&nbsp;

### Scalability: Prune and Optimize

In a procedural system, you write code to read and write rows, optimize such access, and bundle transactions.  **In a declarative system, persistence is automated - and optimized.**  

!!! note "When Performance Matters"

    Modern computers are incredibly fast, and modern architectures can provide clustering.  Productive languages (like Python) should no longer be a concern.

    That said, it is still important to consider algorithms that can incur substantial database / network overhead.  That is why the issues discussed here are important.  Experience has shown these can result in response times of ***seconds instead of minutes.***

For example, the balance rule:

* is **pruned** if only a non-referenced column is altered (e.g., Shipping Address)
* is **optimized** into a 1-row _adjustment_ update instead of an expensive SQL aggregate

For more on how logic automates and optimizes multi-table transactions,
[click here](https://github.com/valhuber/LogicBank/wiki#scalability-automatic-pruning-and-optimization){:target="_blank" rel="noopener"}.

&nbsp;

## FAQ: Similar Looking Alternatives

At first glance, declarative logic looks quite similar to other familiar approaches.  But while the code may *look* similar, the differences are quite significant.

For example, consider the rule:
``` title="Customer Balance Rule Example"
Customer.Balance = Sum(Order.AmountTotal where unshipped and ready)
```

&nbsp;

### SQL: declarative read, not logic

SQL itself has a `select sum()` that looks equivalent.  It's a *declarative read* that you call from your *procedural code*.

So, the difference is not the syntax, it's that the ***calling code is procedural.***  Procedural Logic robs you of all the advantages noted above: not concise, not ordered to facilitate maintenance, and error prone.

The `sum` rule is, in fact, not a "read" at all.  It's an ***end condition**, that the system guarantees will be true* when the transaction is committed.  Declarative logic is a set of such rules managed by the system - you neither call nor order them.

&nbsp;

### Iterator Verb: declarative logic?

Python (and several Low Code scripting languages) provide power verbs like:

```python title="Iterator Verb (caution: poor practice)"
balance = sum(order.amount_total for order in customer.orders if order.date_shipped is None)
```

The code above implies an expensive multi-row query to read the orders for a customer.  There are several problems:

* It's often not declarative - if you must write code that determines *when* to call this (aka **dependency management**), your logic is *procedural,* not declarative.
* It's expensive if there are many orders
* It doesn't even work if `order.amount_total` is not stored.  Adding up all the `Item.Amount` values - for *each* of the orders - makes it n times more expensive.

&nbsp;

### Visual Programming

Flowchart-like diagrams are attractive, and quite approopriate for process logc (a complement to transaction logic).  But it is highly procedural, so the 200 lines of procedural code turns into 200 nodes in a diagram.  Declarative rules are a far more appropriate technology for transaction logic.

&nbsp;

### Rete: too coarse

Rete engines provide similar inference rules.   Experienced developers know they can be useful (e.g., Decision Tables), but should be avoided for multi-table logic.  This is because they do not - *cannot* - provide *adjustment* logic.  For more information, see [RETE](FAQ-RETE.md){:target="_blank" rel="noopener"}.

&nbsp;

### ORM: too coarse

Some ORMs (Object Relational Managers), such as Hibernate, allow similar verbs.  But again, experienced developers avoid these because they perform poorly:

1. They are too coarse: a `select sum` is issued when *any* order change is made (no pruning)
2. Cost: as above, it's expensive if there are many orders
