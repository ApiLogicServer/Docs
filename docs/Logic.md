!!! pied-piper ":bulb: TL;DR - Logic: multi-table derivations and constraints, using Rules and Python"

    Logic addresses __multi-table derivations and constraints__, using Rules and Python.  **Rules** are:

    1. **Declared** with WebGenAI or IDE and Code Completion - 40X more concise 
    2. **Activated** on server start
    3. **Executed** - *automatically* - on updates (using SQLAlchemy events)
    4. **Debugged** in your IDE, and with the console log

    For more on WebGenAI, [click here](WebGenAI.md){:target="_blank" rel="noopener"}.


## Rule Types
The table shows excerpts only; see the ```ApiLogicProject``` (Northwind) sample for full syntax.

| Rule            | Summary                                                                                    | Example                                                                                                        | Notes                                                                                                                                     |
| :-------------- | :----------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| Constraint      | Boolean function must be True<br>else transaction rolled back                              | ```row.Balance <= row.CreditLimit```<br><br>```row.Salary >= Decimal('1.20') * old_row.Salary```               | Multi-field<br>```old_row```                                                                                                              |
| Formula         | Function computes column value                                                             | ```row.UnitPrice * row.Quantity```<br><br>```row.OrderHeader.ShippedDate```                                    | lambda, or function<br>Parent ```(OrderHeader)``` references                                                                              |
| Sum             | Derive parent-attribute as sum of designated child attribute; optional child qualification | ```Rule.sum(derive=Customer.Balance, as_sum_of=Order.AmountTotal,where=lambda row: row.ShippedDate is None)``` | Parent attribute can be hybrid (virtual)<br>scalable: pruning, adjustment                                                                 |
| Count           | Derive parent-attribute as count of child rows; optional child qualification               | ```Rule.count(derive=Order.OrderDetailCount, as_count_of=OrderDetail)```                                       | counts are useful as child existence checks                                                                                               |
| Copy            | Child value set from Parent                                                                | ```OrderDetail.ProductPrice = copy(Product.Price)```                                                           | Unlike formula references, parent changes are not propagated<br>e.g, Order totals for Monday are not affected by a Tuesday price increase |
| Event           | Python Function                                                                            | on insert, call ```congratulate_sales_rep```                                                                   | See [Extensibility](Logic-Why.md#extend-python) for a information on early, row and commit events                                         |
| Parent Check    | Ensure Parent row exists                                                                   | Orders must have a Customer                                                                                    | See [Referential Integrity](https://github.com/valhuber/LogicBank/wiki/Referential-Integrity)                                             |
| Allocation      | Allocate a provider amount to recipients                                                   | allocate a payment to outstanding orders                                                                       | See [Allocation](https://github.com/valhuber/LogicBank/wiki/Sample-Project---Allocation) for an example                                   |
| Copy Row        | Create child row by copying parent                                                         | audit Employee Salary changes to EmployeeAudit                                                                 | See [Rule Extensibility](https://github.com/valhuber/LogicBank/wiki/Rule-Extensibility)                                                   |


&nbsp;

## Declaring Rules

The table below illustrates that:

* You can declare rules in Natural Language (Nat Lang) using your Browser and [WebGenAI](WebGenAI.md){:target="_blank" rel="noopener"} and/or your IDE.  
* Rules are stored in your project depending on how they were defined

<br>

| Using    | Lang     | Access Using                                                                                                 | Usage                                                                                                                                                                                                                              |
| :------- | :------- | :----------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Browser  | Nat Lang | [WebGenAI](WebGenAI-CLI.md#natural-language-logic){:target="_blank" rel="noopener"}                          | On export, Python rules are stored in `logic/wg_rules` - [details here](WebGenAI-CLI.md#wg_rules-and-ide-rules){:target="_blank" rel="noopener"}                                                                                   |
| Your IDE | Nat Lang | [`als genai-logic`](WebGenAI-CLI.md#ide-nat-language-docslogic){:target="_blank" rel="noopener"} CLI Command | Translates Nat Lang `docs/logic` to `logic/logic_discovery` - [details here](IDE-Customize.md/#discoverability-logic-services){:target="_blank" rel="noopener"}                                                                    |
| Your IDE | Nat Lang | IDE AI Chat                                                                                                  | Request Nat Lang logic in AI Chat; paste translated Python result into `logic/declare_logic.py` <br>or `logic/logic_discovery` - [details here](IDE-Customize.md/#discoverability-logic-services){:target="_blank" rel="noopener"} |
| Your IDE | Python   | IDE code completion                                                                                          | Rules expressed in Python as a [DSL](Tech-DSL.md/#python-as-a-dsl){:target="_blank" rel="noopener"}<br><br>Nat Lang rules translated to these                                                                                      |

&nbsp;

### GenAI: Natural Language Logic

You can use Natural Language to create logic during project creation, or for existing projects.  For example: `The Customer's balance is the sum of the Order amount_total where date_shipped is null`.

* For more information on using Natural Language Logic, [see Natural Language Logic](WebGenAI-CLI.md#natural-language-logic){:target="_blank" rel="noopener"}.
* For more information on Managing IDE logic and Natural Language Logic, [see WebGenAI Rules and IDE Rules](WebGenAI-CLI.md#wg_rules-and-ide-rules){:target="_blank" rel="noopener"}.

Think of Natural Language Logic as a translation process down onto underlying rules -- ***not*** a code generator.

> It is important to learn the rules described here, and to verify proper translation of Natural Language Logic.

&nbsp;

### IDE: GenAI-Logic CLI

You can use Natural Language in your IDE.  See [IDE: Natural Language](WebGenAI-CLI.md#ide-nat-language-docslogic){:target="_blank" rel="noopener"}.

&nbsp;

### IDE: AI Chat

The options above use ChatGPT, which requires a paid API key.  You may already have a AI chat enabled in your IDE.  As of release 14.04, projects contain `docs/training`, which enable some products to translate Natural Language logic into Python rules.

For example, the diagram below illustrates the use of VSCode/CoPilot:

1. Declare your Natural Language in a prompt, and press Enter
2. CoPilot translated Natural Language Logic to Python rules
3. Paste them into your code, in either `logic/declare_logic.py` or (preferred) a Use-Case specific file such as `logic/logic_discovery/check_credit.py`:

![copilot](images/sample-ai/copilot/copilot-logic-chat.png)

&nbsp;

### IDE: With Code Completion

You can also use your IDE with Code Completion to add rules, and their arguments.

![Add Rules Code Completion](images/vscode/code-completion.png)

&nbsp;

## Iterative Rules

Logic definition is an incremental process.  You can start with a few rules, and add more as needed.  There is no need to define all rules at once, or rebuild the project.

Note rules are automatically ordered and invoked, so you can add new ones in any location.

Similarly, you can change rules without worrying about the order of execution.

&nbsp;

## Learning Rules

Inside the larger process above, here is the best way to learn how to use rules:

1. **Rule Summary**: review the Rule Types table above; there are a small number of rules, since their power lies in chaining

    * **Alert:** Logic consists of rules and Python.  You will quickly learn to use logic events; focus on the *rules as the preferred* approach, using Python (events, etc) as a *fallback*.

2. Review the **Rule Patterns**, below

3. Use the _case study_ approach to learn about using rules, by exploring the examples in the report, below.

4. Be aware of [Rule Extensibility](https://github.com/valhuber/LogicBank/wiki/Rule-Extensibility).

> Pre-req: before learning rules, use the [Tutorial](Tutorial.md){:target="_blank" rel="noopener"} to familiarize yourself with basic capabilities and procedures.

&nbsp;&nbsp;

### Rule Patterns

Rules support *chaining:* a rule may change a value that triggers other rules, including across tables.  Mastering such ***multi-table logic*** is the key to using rules effectively.  The most typical examples are described below.

| Pattern | Notes | Example
| :------------- | :-----| :---- |
| **Chain Up** | parent sums and counts mean that child row changes can ***adjust*** parents | [Derive Balance](Behave-Logic-Report.md/#scenario-good-order-custom-service){:target="_blank" rel="noopener"} |
| **Constrain a Derived Result** | constraints may require derived values | [Balance < creditLimit](Behave-Logic-Report.md#scenario-bad-order-custom-service){:target="_blank" rel="noopener"} |
| **Chain Down** | child copy and parent references mean that parent row changes can ***cascade*** to children | [Ship Order](Behave-Logic-Report.md#scenario-set-shipped-adjust-logic-reuse){:target="_blank" rel="noopener"} |
| **State Transition Logic** | `old_row` useful comparing old/current values | [Meaningful Raise](Behave-Logic-Report.md#scenario-raise-must-be-meaningful){:target="_blank" rel="noopener"} |
| **Counts as Existence Checks** | Use counts to check if any children exist | [Don't Ship Empty Orders](Behave-Logic-Report.md#scenario-bad-ship-of-empty-order){:target="_blank" rel="noopener"} |
| **Auditing** | Note the Copy Row rule (and alternatives) | [Salary Audit](Behave-Logic-Report.md#scenario-audit-salary-change){:target="_blank" rel="noopener"} |
| **Ready Flag** | Multi-session editing, then , when ready...<br>adjust related data / enforce constraints | [Make Order Ready](Behave-Logic-Report.md/#scenario-order-made-ready){:target="_blank" rel="noopener"} |
| **Events for Lib Access** | Events enable Python, use of standard libs (e.g., Kafka) | [Ship Order](Behave-Logic-Report.md#scenario-good-order-custom-service){:target="_blank" rel="noopener"} |
| **Request Pattern** | Create Row to run service, per logic, e.g. MCP request:<br> _"find overdue orders, and send an email offering a discount"_    | See [MCP Send Mail](Integration-MCP.md#3a-logic-request-pattern)     |

&nbsp;

### Rules Case Study

The best way to learn the rules is by a Case Study approach:

1. Print this page, for reference

2. Print the [Database Diagram](Sample-Database.md){:target="_blank" rel="noopener"}

    * Most of the examples are drawn from this database

3. For each Rule Pattern, above:

    * Click the Example link in the table above to open the Behave Logic Report

        * Aside: later, you can prepare such documentation for your own projects, ([like this](Behave.md){:target="_blank" rel="noopener"}).

    * Review the Scenario -- take these as your requirements

    * Spend 5 minutes (perhaps in pairs) and **cocktail-napkin design** your solution, using
    
        * The data model diagram
        * List of Rule Types, and 
        * Rule Patterns

    * Reveal the solution: open the disclosure box: "Tests - and their logic - are transparent.. click to see Logic"


&nbsp;

## Learning Natural Language

As noted above, it is important to be clear on the rules generated for logic.  Use the examples below to test your understanding.

WebGenAI provides the [Logic Editor](WebGenAI.md#using-the-logic-editor){:target="_blank" rel="noopener"} so you can see/edit the translation:

![logic Editor](images/web_genai/logic/logic-editor.png)

### Natural Language Patterns
| Pattern | Notes | Example
| :------------- | :-----| :---- |
| Formal vs Informal | You can: *Customer.balance = Sum(Order.amount_total where date_shipped is null)* | Or, more simply: *The Customer's balance is the sum of the Order amount_total where date_shipped is null* 
| Integration Logic | Kafka | *Send the Order to Kafka topic 'order_shipping' if the date_shipped is not None*
| Multi-rule Logic | See Multi-rule Logic - Generated Rules, below | *Sum of employee salaries cannot exceed department budget*
| Conditional Derivations | See Conditional Derivation - Generated Rules, below | Provide a 10% discount when buying more than 10 carbon neutral products<br>The Item carbon neutral is copied from the Product carbon neutral
| Cardinality Patterns<br>- *Qualified Any* | See Cardinality Patterns - Generated Rules, below  | Products have Notices, with severity 0-5.<br>Raise and error if product is orderable == True and there are any severity 5 Notices, or more than 3 Notices.


<details markdown>

<summary> Multi-rule Logic - Generated Rules </summary>
```python title='Logic Recognizes "conditional derivations"'
## Aggregate the total salaries of employees for each department.
Rule.sum(derive=Department.total_salaries, as_sum_of=Employee.salary)

## Ensure the sum of employee salaries does not exceed the department budget
Rule.constraint(validate=Department, as_condition=lambda row: row.total_salaries <= row.budget, error_msg="xxx")
## End Logic from GenAI
```
</details>

&nbsp;

<details markdown>

<summary> Conditional Derivation - Generated Rules </summary>
```python title='Logic Recognizes "conditional derivations"'
## Provide a 10% discount when buying more than 10 carbon neutral products.
Rule.formula(derive=Item.amount,
             as_expression=lambda row: 0.9 * row.unit_price * row.quantity \
                if row.Product.is_carbon_neutral and row.quantity > 10
                else row.unit_price * row.quantity)
## End Logic from GenAI
```
</details>

&nbsp;
<details markdown>

<summary> Cardinality Patterns - Generated Rules </summary>
```python title='Logic Recognizes "qualified any"'
    ## Logic from GenAI: (or, use your IDE w/ code completion)

    ## Derive product notice count from related notices.
    Rule.count(derive=Product.notice_count, as_count_of=Notice)

    ## Derive count of severity 5 notices for products.
    Rule.count(derive=Product.class_5_notice_count, as_count_of=Notice, where=lambda row: row.severity == 5)

    ## Ensure product is not orderable if conditions on notices are met.
    Rule.constraint(validate=Product,
    as_condition=lambda row: not (row.orderable and (row.class_5_notice_count > 0 or row.notice_count > 3)),
    error_msg="Orderable product contains severity 5 or excessive notices.")

    ## End Logic from GenAI
```
</details>

&nbsp;

### Natural Language Examples

WebGenAI was trained to understand the Natural Language Logic problems shown below.  These automate many of the rule patters described above.

Please see [Natural Language Logic](WebGenAI-CLI.md#natural-language-logic){:target="_blank" rel="noopener"}.

| Example | Notes |
| :------------- | :------------- |
| Airport - at least 10 tables<br>A flight's passengers must be less than its Airplane's seating capacity |
| System for Departments and Employees.<br>Sum of employee salaries cannot exceed department budget |
| Create a system with Employees and their Skills.<br>More than One Employee can have the same Skill.<br>EmployeeSkill.rating = Skill.rating<br>An Employee's skill-rating is the sum of the Employee Skills rating, plus 2 * years of service. |
| Students have probations and sick days.<br>Signal an error if a Student's can-graduate is True, and there are more 2 probations, or more than 100 sick days.
| Applicant have felonies and bankruptcies.<br>Signal error if is-hirable is true and there are more than 3 bankruptcies, or 2 felonies.
| Students have Grades and belong to Clubs.<br>Copy the name from Club to Student Club<br>The student's service activity is the count of Student Clubs where name contains 'service'. <br>Signal error if student is eligible for the honor society == True, and their grade point average is under 3.5, or they have less than 2 service activities
| Products have Notices, with severity 0-5.<br>Raise and error if product is orderable == True and there are any severity 5 Notices, or more than 3 Notices.
| Create a system with customers, orders, items and products.<br>Include a notes field for orders.<br><br>Use Case: enforce the Check Credit for ready orders:<br>1. Customer.balance <= credit_limit<br>2. Customer.balance = Sum(Order.amount_total where date_shipped is null and ready is True)<br>3. Order.amount_total = Sum(Item.amount)<br>4. Item.amount = quantity * unit_price<br>5. Store the Item.unit_price as a copy from Product.unit_price<br><br>Use Case: Compute Products ordered<br>1. Item.ready = Order.ready<br>2. Product.total_ordered = sum(Item.quantity) where ready == True<br>3. Product.reorder_required = quantity_on_hand <= total_ordered<br><br>Use Case: No Empty Orders<br>1. Order.item_count = Count(Items)<br>2. When setting the date_shipped, item_count must be > 0. | Ready Flag
| Teachers, courses which have offerings, and students who have offerings.<br><br>Use Case: capacity<br>teachers cannot be assigned to more than 5 courses<br>students cannot have more enrollments than 6<br><br>Use Case: budget control<br>courses have a charge, which is copied to enrollments charge<br>a student's total enrollment charges cannot exceed their budget

&nbsp;
