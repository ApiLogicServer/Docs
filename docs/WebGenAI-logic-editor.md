!!! pied-piper ":bulb: TL;DR - Edit Logic in Natural Language"

    Backend Logic is nearly half the effort in a transactional system.  Instead of procedural code, WeGenAI provides declarative rules that are 40X more concise.  They can be expressed in Python, or Natural Language as described here.

&nbsp;

## Overview: Adding Logic

It's usually a good idea to create your project with an initial focus on structure: tables, columns, relationships.  As you review and iterate, you will likely want to introduce multi-table derivations and constraints. 

You can use normal iterations, or the Logic Editor.

&nbsp;

### Using Iterations

You can iterate your project, and declare your logic:

```
Enforce Check Credit:
1. Customer.balance <= credit_limit
2. Customer.balance = Sum(Order.amount_total where date_shipped is null)
3. Order.amount_total = Sum(Item.amount)
4. Item.amount = quantity * unit_price
5. Store the Item.unit_price as a copy from Product.unit_price
```

&nbsp;

### Using the Logic Editor

You can also the the Logic Editor:

![logic Editor](images/web_genai/logic/logic-editor.png)

Create logic by clicking **Rule Prompt**, or **Suggest**.  For each element, you can **reject** or **accept**.

* When you accept, the system translates the logic prompt (Natural Language) into Code (a Logic Bank Rule expressed in Python), shown in back.

Errors shown in red.  Correct errors in Natural Language using the **black icon button** by providing a new / altered prompt.

Logic may introduce new attributes.  These must be added to the data model, using **Update Data Model**.  When you run, this will update the database and test data.

&nbsp;

## Debugging Logic

Logic can fail to load at runtime.  The system will

* restart the project with rules disabled, so you can still see your data.  You should generally not update when logic is in error.

* report the errors back to the Logic Editor, where you can correct them.

Logic can also fail when you make an update.  Review the log to see the state of the row(s) as each rule fires.
