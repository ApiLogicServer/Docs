!!! pied-piper ":bulb: TL;DR - Specify expression / function that must be true, else exception"

        Events are callouts to Python functions, supplying `logic_row` as a argument.  Events provide extensibility, to address non-database logic (e.g., sending email and messages), and for complex logic that cannot be addressed in rules. 

&nbsp;

## Defining Events

To define events, you must declare and implement them, as described below.

&nbsp;

### Declare Event Rule

Declare the event, identifying the class and function to call:

```python
Rule.commit_row_event(on_class=models.Order, calling=congratulate_sales_rep)
```

&nbsp;

### Implement Python Function

Implement the Python function that handles the event, accepting the supplied arguments:

![Logic Debug](images/logic/logic-debug.png)

&nbsp;

## Event Types

There are multiple event types so that you can control how your logic executes within the rule engine.

&nbsp;

### `early_row_event`

These operate before your derivation / constraint logic executes for each row.  So, for example, derivations have not been performed.

&nbsp;

### `early_row_event_all_classes`

These operate before your logic executes for each row for **any class**.  It is an excellent way to implement generic logic such as time/date stamping.  It is also used by the system to activate optimistic locking logic, as shown below.

```python

def handle_all(logic_row: LogicRow):  # OPTIMISTIC LOCKING, [TIME / DATE STAMPING]
        """
        This is generic - executed for all classes.

        Invokes optimistic locking.

        You can optionally do time and date stamping here, as shown below.

        Args:
                logic_row (LogicRow): from LogicBank - old/new row, state
        """
        if logic_row.is_updated() and logic_row.old_row is not None and logic_row.nest_level == 0:
                opt_locking.opt_lock_patch(logic_row=logic_row)
        enable_creation_stamping = True  # CreatedOn time stamping
        if enable_creation_stamping:
                row = logic_row.row
                if logic_row.ins_upd_dlt == "ins" and hasattr(row, "CreatedOn"):
                row.CreatedOn = datetime.datetime.now()
                logic_row.log("early_row_event_all_classes - handle_all sets 'Created_on"'')

Rule.early_row_event_all_classes(early_row_event_all_classes=handle_all)
```

&nbsp;

### `row_event`

These operate after your derivation / constraint logic executes for each row.  So, for example, derivations have been performed.

&nbsp;

### `commit_row_event`

These operate after logic executes for ***all*** rows.  So, for example, sums and counts have been computed.  

![Logic Debug](images/logic/logic-debug.png)

&nbsp;


