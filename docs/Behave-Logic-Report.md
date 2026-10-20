!!! pied-piper ":bulb: TL;DR - Executable Test Suite, Documentation"

      You can optionally use the Behave test framework to (here is an [Agile Approach for using Behave](Logic-Tutorial.md)) to capture requirements, and execute a test suite.  
      
      * As shown below, you can then create a wiki **Behave Logic Report** report that documents your requirements (**Features**), and the tests (**Scenarios**) that confirm their proper operation.

        * **Integrated Logic Documentation:** the report integrates your logic, including a logic report showing your logic (rules and Python), and a Logic Log that shows exactly how the rules executed.  Logic Doc is transparent to business users, so can further contribute to Agile Collaboration.



&nbsp;
&nbsp;

## Northwind Sample

This is the sample project from API Logic Server, based on the [Northwind database](https://apilogicserver.github.io/Docs/Sample-Database/) (sqlite database located in the `database` folder - no installation required):

![Sample Database](https://apilogicserver.github.io/Docs/images/model/sample-database.png)

> 

The sample Scenarios below were chosen to illustrate the basic patterns of using
rules. Open the disclosure box ("Tests - and their logic...") to see the implementation and notes.

The following report was created during test suite execution.

&nbsp;

# Behave Logic Report

**Project:** ApiLogicProject &nbsp;|&nbsp; **Generated:** October 19, 2026 21:53 &nbsp;|&nbsp; **Rules:** 27 &nbsp;|&nbsp; **Test scenarios:** 25 &nbsp;|&nbsp; **Generator:** Behave Logic Report 2.0


&nbsp;
&nbsp;

## Contents

- [Requirements Traceability To Rules](#requirements-traceability-to-rules)
- [Data Model](#data-model)
- [Security (RBAC)](#security-rbac)
- [Messages and APIs](#messages-and-apis)
- [Tests and Results](#tests-and-results)


&nbsp;
&nbsp;

## Requirements Traceability To Rules

Traceability here is **forward** (requirement, to the rules, handlers and grants that implement it, to the tests that exercise it) and **backward** (implementation and tests, to the requirement they serve). Anything with no requirement is listed as untraced, and every requirement with no implementation or no test is listed as a gap. Links are made by the `Feature:` names and `§N` tags that requirements, code and tests carry.


&nbsp;

### Coverage summary

| Measure | Result |
|---|---|
| Requirements | 0 |
| Implemented (at least one file) | 0 of 0 |
| Tested (at least one scenario) | 0 of 0 |
| Implementation not traced to a requirement | `logic/logic_discovery/employee_auditing/employee_audit.py`, `logic/logic_discovery/employee_state_transition_logic/raise_over_20_percent.py`, `logic/logic_discovery/integration.py`, `logic/logic_discovery/order_clone/clone_order.py`, `logic/logic_discovery/order_place/app_integration.py`, `logic/logic_discovery/order_place/check_credit.py`, `logic/logic_discovery/order_ship_inventory_reorder/units_in_stock.py`, `logic/logic_discovery/simple_constraints.py`, `api/api_discovery/authentication_expose_api_models.py`, `api/api_discovery/dashboard_services.py`, `api/api_discovery/sales_by_category.py`, `security/declare_security.py`, `logic/logic_discovery/system/all_classes_stamping.py` |
| Tests not traced to a requirement | Application Integration, Authorization, Optimistic Locking, Place Order, Salary Change, Tests Successful |
| Test results (last run) | ✅ 25 passed, 0 failed |
| Scenarios with a logic log | 13 of 25 (plus the scaffold's shared log, which is included) |
| Rules seen in at least one scenario's log | 25 of 26 - not seen: `Order: ship_ready_orders_only()` (1 rule(s) cannot be matched to the engine's log) |

_Test results are read from `logs/behave.log`, so they are only as current as that run. Not recorded here: which version of a requirement the code was built against, and which clause of a requirement a given rule serves._


&nbsp;

### Traceability matrix

No requirements found, so there is nothing to trace yet. Requirements live in `docs/requirements/<name>/requirements.md`; tell your AI assistant `implement reqs <name>` to turn them into rules, and name the same `Feature:` in the logic file and the tests so this report can link them.


&nbsp;

### Rule coverage by tests

| Rule | Requirement | Seen in |
|---|---|---|
| `Employee: raise_over_20_percent()` | (none) | 1: Raise Must be Meaningful |
| `Customer.after_flush_row_event → fn_customer_workflow()` | (none) | 5: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +2 more |
| `Employee.after_flush_row_event → fn_employee_workflow()` | (none) | 1: Audit Salary Change |
| `Order.row_event → clone_order()` | (none) | 8: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +5 more |
| `Order.after_flush_row_event → send_order_to_shipping()` | (none) | 6: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +3 more |
| `Order.commit_row_event → congratulate_sales_rep()` | (none) | 6: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +3 more |
| `Customer: Balance <= CreditLimit` | (none) | 3: Bad Order Custom Service; Alter Item Qty to exceed credit; Clone Existing Order |
| `Customer.Balance = sum(Order.AmountTotal) where ShippedDate is None and Ready == True` | (none) | 9: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +6 more |
| `Order.AmountTotal = sum(OrderDetail.Amount)` | (none) | 6: Good Order Custom Service; Bad Order Custom Service; Alter Item Qty to exceed credit; +3 more |
| `OrderDetail.Amount = UnitPrice * Quantity` | (none) | 4: Good Order Custom Service; Bad Order Custom Service; Alter Item Qty to exceed credit; +1 more |
| `OrderDetail.UnitPrice = copy of Product.UnitPrice` | (none) | 3: Good Order Custom Service; Bad Order Custom Service; Clone Existing Order |
| `Customer.UnpaidOrderCount = count(Order) where ShippedDate is None` | (none) | 9: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +6 more |
| `Customer.OrderCount = count(Order)` | (none) | 9: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +6 more |
| `Order.OrderDetailCount = count(OrderDetail)` | (none) | 6: Good Order Custom Service; Bad Order Custom Service; Alter Item Qty to exceed credit; +3 more |
| `Order.OrderDate = datetime.datetime.now()` | (none) | 3: Good Order Custom Service; Bad Order Custom Service; Clone Existing Order |
| `Customer.early_row_event → customer_defaults()` | (none) | 8: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +5 more |
| `Order.early_row_event → order_defaults()` | (none) | 9: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +6 more |
| `OrderDetail.early_row_event → order_detail_defaults()` | (none) | 6: Good Order Custom Service; Bad Order Custom Service; Alter Item Qty to exceed credit; +3 more |
| `Order: ship_ready_orders_only()` | (none) | ⚠ not seen in any scenario's log |
| `Order.commit_row_event → do_not_ship_empty_orders()` | (none) | 6: Order Made Not Ready; Order Made Ready; Good Order Custom Service; +3 more |
| `Product.UnitsInStock = units_in_stock()` | (none) | 3: Good Order Custom Service; Set Shipped - adjust logic reuse; Reset Shipped - adjust logic reuse |
| `Product.UnitsShipped = sum(OrderDetail.Quantity) where ShippedDate is None` | (none) | 3: Good Order Custom Service; Set Shipped - adjust logic reuse; Reset Shipped - adjust logic reuse |
| `OrderDetail.ShippedDate = ` | (none) | 5: Good Order Custom Service; Bad Order Custom Service; Set Shipped - adjust logic reuse; +2 more |
| `Customer: CompanyName != 'x'` | (none) | 3: Bad Order Custom Service; Alter Item Qty to exceed credit; Clone Existing Order |
| `Employee: LastName != 'x'` | (none) | 1: Raise Must be Meaningful |
| `Category: valid_category_description()` | (none) | 1: Transaction Processing (shared log) |
| `all classes.early_row_event → handle_all()` | (none) | n/a - cannot be matched to the engine's log |

_"Seen" means the engine reported running the rule in that scenario's logic log. A scenario can only contribute if it has a log (see the coverage summary): a test that does not open one writes into whichever log was open last, and its rules are then credited to that scenario, or to the shared log. An event's function runs on every commit of its class, and its own condition decides whether it acts, so seen does not mean it took effect. A constraint appears in the log only when it rejects a transaction, so it is seen only in scenarios that make it reject. "Not seen" therefore means no log shows it, not that no test ran it._


&nbsp;

### Requirements in detail

**27 rules** in 8 files: 13 declarative (sum, count, copy, formula and constraint expressions), 4 backed by a Python function, 10 events (Python). _Declarative rules are read directly from their declarations; functions and events are Python, so the report shows each one's docstring, not an analysis of its code._

Each requirement is followed by the rules and handlers in the files that implement it. Logic diagrams are shown (click to expand) where they exist.
<details markdown>
<summary>How to create or refresh the logic diagrams</summary>

Needs Graphviz (`brew install graphviz`). Tell your AI assistant:

```
create logic diagram for each requirement
```

or run this from the Manager root (`genai-logic`):

```
python system/ApiLogicServer-Internal-Dev/logic_diagram_gv.py tests/ApiLogicProject --each
```

Each diagram is saved under `docs/requirements/<name>/logic_diagrams/`. Then regenerate this report (`python behave_logic_report.py run`, from `test/api_logic_server_behave`).

</details>

&nbsp;


#### Rules not traced to a requirement

| Rule / item | Type | Logic | Description | Where |
|---|---|---|---|---|
| `Employee: raise_over_20_percent()` | constraint | Python function | (no docstring) | [raise_over_20_percent.py](../../../logic/logic_discovery/employee_state_transition_logic/raise_over_20_percent.py) |
| `Customer.after_flush_row_event → fn_customer_workflow()` | after_flush_row_event | event (Python) | #als: Send N8N message Webhook Workflow: When Customer is inserted/updated - post n8n Webhook and call sendgrid email system | [integration.py](../../../logic/logic_discovery/integration.py) |
| `Employee.after_flush_row_event → fn_employee_workflow()` | after_flush_row_event | event (Python) | Workflow: When Employee is inserted = post n8n Webhook and call sendgrid email system | [integration.py](../../../logic/logic_discovery/integration.py) |
| `Order.row_event → clone_order()` | row_event | event (Python) | #als: clone multi-row business object | [clone_order.py](../../../logic/logic_discovery/order_clone/clone_order.py) |
| `Order.after_flush_row_event → send_order_to_shipping()` | after_flush_row_event | event (Python) | #als: Send Kafka message formatted by OrderShipping RowDictMapper | [app_integration.py](../../../logic/logic_discovery/order_place/app_integration.py) |
| `Order.commit_row_event → congratulate_sales_rep()` | commit_row_event | event (Python) | use events for sending email, messages, etc. | [app_integration.py](../../../logic/logic_discovery/order_place/app_integration.py) |
| `Customer: Balance <= CreditLimit` | constraint | declarative | Error: balance ({round(row.Balance, 2)}) exceeds credit ({round(row.CreditLimit, 2)}) | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Customer.Balance = sum(Order.AmountTotal) where ShippedDate is None and Ready == True` | sum | declarative |  | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Order.AmountTotal = sum(OrderDetail.Amount)` | sum | declarative |  | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `OrderDetail.Amount = UnitPrice * Quantity` | formula | declarative |  | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `OrderDetail.UnitPrice = copy of Product.UnitPrice` | copy | declarative |  | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Customer.UnpaidOrderCount = count(Order) where ShippedDate is None` | count | declarative |  | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Customer.OrderCount = count(Order)` | count | declarative |  | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Order.OrderDetailCount = count(OrderDetail)` | count | declarative |  | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Order.OrderDate = datetime.datetime.now()` | formula | declarative |  | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Customer.early_row_event → customer_defaults()` | early_row_event | event (Python) | (no docstring) | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Order.early_row_event → order_defaults()` | early_row_event | event (Python) | (no docstring) | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `OrderDetail.early_row_event → order_detail_defaults()` | early_row_event | event (Python) | (no docstring) | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Order: ship_ready_orders_only()` | constraint | Python function | (no docstring) | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Order.commit_row_event → do_not_ship_empty_orders()` | commit_row_event | event (Python) | (no docstring) | [check_credit.py](../../../logic/logic_discovery/order_place/check_credit.py) |
| `Product.UnitsInStock = units_in_stock()` | formula | Python function | (no docstring) | [units_in_stock.py](../../../logic/logic_discovery/order_ship_inventory_reorder/units_in_stock.py) |
| `Product.UnitsShipped = sum(OrderDetail.Quantity) where ShippedDate is None` | sum | declarative |  | [units_in_stock.py](../../../logic/logic_discovery/order_ship_inventory_reorder/units_in_stock.py) |
| `OrderDetail.ShippedDate = ` | formula | declarative |  | [units_in_stock.py](../../../logic/logic_discovery/order_ship_inventory_reorder/units_in_stock.py) |
| `Customer: CompanyName != 'x'` | constraint | declarative | Error: CustomerName cannot be 'x' | [simple_constraints.py](../../../logic/logic_discovery/simple_constraints.py) |
| `Employee: LastName != 'x'` | constraint | declarative | Error: LastName cannot be 'x' | [simple_constraints.py](../../../logic/logic_discovery/simple_constraints.py) |
| `Category: valid_category_description()` | constraint | Python function | (no docstring) | [simple_constraints.py](../../../logic/logic_discovery/simple_constraints.py) |
| `all classes.early_row_event → handle_all()` | early_row_event_all_classes | event (Python) | Generic handler - executed for every row update across all classes. | [all_classes_stamping.py](../../../logic/logic_discovery/system/all_classes_stamping.py) |


&nbsp;
&nbsp;

## Data Model

![db diagram](db_diagram.generated.svg)

_Generated from `docs/db.dbml` (parents above children; shaded rows are derived by rules). To use your own layout, save it as `docs/db_diagram.png`._


&nbsp;

### Derived columns

| Table | Column | Rule | Definition |
|---|---|---|---|
| Customer | Balance | sum | `Customer.Balance = sum(Order.AmountTotal) where ShippedDate is None and Ready == True` |
| Order | AmountTotal | sum | `Order.AmountTotal = sum(OrderDetail.Amount)` |
| OrderDetail | Amount | formula | `OrderDetail.Amount = UnitPrice * Quantity` |
| OrderDetail | UnitPrice | copy | `OrderDetail.UnitPrice = copy of Product.UnitPrice` |
| Customer | UnpaidOrderCount | count | `Customer.UnpaidOrderCount = count(Order) where ShippedDate is None` |
| Customer | OrderCount | count | `Customer.OrderCount = count(Order)` |
| Order | OrderDetailCount | count | `Order.OrderDetailCount = count(OrderDetail)` |
| Order | OrderDate | formula | `Order.OrderDate = datetime.datetime.now()` |
| Product | UnitsInStock | formula | `Product.UnitsInStock = units_in_stock()` |
| Product | UnitsShipped | sum | `Product.UnitsShipped = sum(OrderDetail.Quantity) where ShippedDate is None` |
| OrderDetail | ShippedDate | formula | `OrderDetail.ShippedDate = ` |


&nbsp;
&nbsp;

## Security (RBAC)

**Security enabled: yes** (`SECURITY_ENABLED` in `config/default.env`).


&nbsp;

### Roles and CRUD (DefaultRolePermission)

| Role | Read | Insert | Update | Delete |
|---|---|---|---|---|
| tenant | ✅ | — | — | ✅ |
| renter | ✅ | — | — | — |
| manager | ✅ | — | — | — |
| sales | ✅ | — | — | — |
| public | ✅ | — | — | — |


&nbsp;

### Row-level grants (Grant)

| Table | Role | Filter | Requirement |
|---|---|---|---|
| Customer | customer | `Id == Security.current_user().id` |  |
| Customer | sales | `CreditLimit > 300` |  |
| Customer | sales | `ContactName == Mike (see security/declare_security.py)` |  |
| Customer | public | `Customer.Id != 'ANATR'` |  |


&nbsp;
&nbsp;

## Messages and APIs

| Direction | Channel | Name | Handler | Tables created | Message shape | Requirement |
|---|---|---|---|---|---|---|
| ⬅ out | Kafka | `customer` | Customer.after_flush_row_event → fn_customer_workflow() - #als: Send N8N message Webhook Workflow: When Customer is inserted/updated - post n8n Webhook and call sendgrid email system |  |  |  |
| ⬅ out | Kafka | `order_shipping` | Order.after_flush_row_event → send_order_to_shipping() - #als: Send Kafka message formatted by OrderShipping RowDictMapper |  |  |  |
| ➡ in | HTTP | `GET,OPTIONS /dashboard` | `dashboard()` - (no docstring) |  |  |  |
| ➡ in | HTTP | `GET,OPTIONS /chart_graphics/<path:path>` | `chart_graphics()` - (no docstring) |  |  |  |
| ➡ in | HTTP | `GET /sales_by_category` | `sales_by_category()` - Illustrates: * Complex query with multiple joins |  |  |  |

_Topics and endpoints are read from the discovery folders. The condition that triggers an outbound message lives in Python (see the rules under each requirement); here it is described by the handler's docstring. "Tables created" lists rows the handler's code constructs, following its calls within the project; blank means none were found, not that none exist._


&nbsp;
&nbsp;

## Tests and Results

**✅ 25 scenario(s): 25 passed, 0 failed** (from the last run, `logs/behave.log`).

These are Behave scenarios. Each one drives the running API the way any client would (create an order, change a quantity, ship it) and checks the result.

**The logic log** is what makes them more than pass/fail. Business rules run inside the server on every commit, so the server records exactly what they did, and this report embeds that record for each scenario. Two things to look for:

1. **It shows every rule that runs.** Each line is one rule execution, with the row's state, old and new values. You see not just that a test passed, but which rules ran and what each one changed.
2. **The nesting shows multi-table chaining.** Indentation follows the cascade: a change to an Item adjusts its Order, which adjusts its Customer.

<details markdown>
<summary>How to read the logic log</summary>

Open a scenario's "Rules exercised and logic log" block to see it. The log is shown in full, attribute values included, because those values are what you diagnose from when a rule produces an unexpected result.

To read a log line:

```
....Order[16] {Update - Adjusting order: amount_total} id: 16, customer_id: 19, amount_total:  [0.0-->] 90.0
```

- The leading dots are the depth in the cascade: Item (2 dots), its Order (4), its Customer (6).
- `Order[16]` is the row; `{...}` is the rule or action that ran; the rest is the row's attribute values at that step.
- `[0.0-->] 90.0` marks a value the rules changed, with its old and new value.
- The log is in phases: **ROW LOGIC** (derivations and constraints, as rows change), **COMMIT LOGIC** (checks that need the finished aggregates), and **AFTER_FLUSH LOGIC** (events that need database-assigned keys, such as the Kafka publish).

More: [Logic Log](https://apilogicserver.github.io/Docs/Logic-Debug/#logic-log).

</details>

&nbsp;

<details markdown>
<summary>How to add more tests, and run them</summary>

**1. Have AI create them.** This project's context tells your AI assistant how (`.github/copilot-instructions.md`, `docs/training/testing.md`). Just say:

```
create tests from rules
```

The assistant reads `database/models.py`, the logic files and the custom APIs, then writes `.feature` files and step implementations under `test/api_logic_server_behave/features/`. It suggests how to run them; it does not run them for you.

**2. You can also define tests manually.** Add a `<name>.feature` file (Gherkin) under `test/api_logic_server_behave/features/` and its steps under `features/steps/`. The steps call the running API, so tests exercise the same rules as any client. See `docs/training/testing.md` for the patterns that keep tests repeatable.

**Then run them** (server running, from `test/api_logic_server_behave`):

```
python behave_run.py --outfile=logs/behave.log
python behave_logic_report.py run
```

</details>

&nbsp;
&nbsp;

### Feature: Application Integration  

&nbsp;
&nbsp;

#### Scenario: GET Customer ✅
&emsp;  Scenario: GET Customer  
&emsp;&emsp;    Given Customer Account: VINET  
&emsp;&emsp;    When GET Orders API  
&emsp;&emsp;    Then VINET retrieved  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

#### Scenario: GET Department ✅
&emsp;  Scenario: GET Department  
&emsp;&emsp;    Given Department 2  
&emsp;&emsp;    When GET Department with SubDepartments API  
&emsp;&emsp;    Then SubDepartments returned  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

### Feature: Authorization  

&nbsp;
&nbsp;

#### Scenario: Grant ✅
&emsp;  Scenario: Grant  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When u1 GETs Categories  
&emsp;&emsp;    Then Only 1 is returned  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

#### Scenario: Multi-tenant ✅
&emsp;  Scenario: Multi-tenant  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When sam GETs Customers  
&emsp;&emsp;    Then only 3 are returned  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

#### Scenario: Global Filters ✅
&emsp;  Scenario: Global Filters  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When sam GETs Departments  
&emsp;&emsp;    Then only 8 are returned  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

#### Scenario: Global Filters With Grants ✅
&emsp;  Scenario: Global Filters With Grants  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When s1 GETs Customers  
&emsp;&emsp;    Then only 1 customer is returned  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

#### Scenario: CRUD Permissions ✅
&emsp;  Scenario: CRUD Permissions  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When r1 deletes a Shipper  
&emsp;&emsp;    Then Operation is Refused  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

### Feature: Optimistic Locking  

&nbsp;
&nbsp;

#### Scenario: Get Category ✅
&emsp;  Scenario: Get Category  
&emsp;&emsp;    Given Category: 1  
&emsp;&emsp;    When Get Cat1  
&emsp;&emsp;    Then Expected Cat1 Checksum  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

#### Scenario: Valid Checksum ✅
&emsp;  Scenario: Valid Checksum  
&emsp;&emsp;    Given Category: 1  
&emsp;&emsp;    When Patch Valid Checksum  
&emsp;&emsp;    Then Valid Checksum, Invalid Description  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

#### Scenario: Missing Checksum ✅
&emsp;  Scenario: Missing Checksum  
&emsp;&emsp;    Given Category: 1  
&emsp;&emsp;    When Patch Missing Checksum  
&emsp;&emsp;    Then Valid Checksum, Invalid Description  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

#### Scenario: Invalid Checksum ✅
&emsp;  Scenario: Invalid Checksum  
&emsp;&emsp;    Given Category: 1  
&emsp;&emsp;    When Patch Invalid Checksum  
&emsp;&emsp;    Then Invalid Checksum  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._

&nbsp;
&nbsp;

### Feature: Place Order  

&nbsp;
&nbsp;

#### Scenario: Order Made Not Ready ✅
&emsp;  Scenario: Order Made Not Ready  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Ready Flag is Reset  
&emsp;&emsp;    Then Logic Decreases Balance  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Order Made Not Ready
   
We reset `Order.Ready`.

This removes the order from contingent derivations (e.g., the `Customer.Balance`),
and constraints.

> **Key Takeaway:** adjustment from change in qualification condition



&nbsp;
&nbsp;


**Rules Used** in Scenario: Order Made Not Ready
```
  Customer  
    1. RowEvent Customer.customer_defaults()  
    2. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    3. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    4. Derive Customer.OrderCount as Count(Order Where  - None)  
    5. RowEvent Customer.fn_customer_workflow()  
  Order  
    6. RowEvent Order.congratulate_sales_rep()  
    7. RowEvent Order.do_not_ship_empty_orders()  
    8. RowEvent Order.clone_order()  
    9. RowEvent Order.send_order_to_shipping()  
    10. RowEvent Order.order_defaults()  
```
**Logic Log** in Scenario: Order Made Not Ready (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10ca34950) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,398 - logic_logger - INFO
..Order[11011] {Update - client} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [True-->] False, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3afa50  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,398 - logic_logger - INFO
..Order[11011] {Prune Formula: OrderDate [[]]} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [True-->] False, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3afa50  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,398 - logic_logger - INFO
....Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1142.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10c941470  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,399 - logic_logger - INFO
Logic Phase:		COMMIT LOGIC		(session=0x10ca34950)   										 - 2026-10-19 21:53:16,399 - logic_logger - INFO
..Order[11011] {Commit Event} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [True-->] False, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3afa50  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,399 - logic_logger - INFO
..Order[11011] {Commit Event} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [True-->] False, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3afa50  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,399 - logic_logger - INFO
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10ca34950)   										 - 2026-10-19 21:53:16,400 - logic_logger - INFO
....Customer[ALFKI] {AfterFlush Event} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1142.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10c941470  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,400 - logic_logger - INFO
....Customer[ALFKI] {1. /integration.py: Kafka, sending logic_row=logic_row [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1142.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10c941470  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,401 - logic_logger - INFO
....Customer[ALFKI] {3. logic_discovery/integration.py: Kafka, sending with declarative mapping (row_dict_mapper=Customer_Orders) [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1142.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10c941470  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,401 - logic_logger - INFO
..Order[11011] {AfterFlush Event} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [True-->] False, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3afa50  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,401 - logic_logger - INFO
..Order[11011] {send_order_to_shipping - sent order to shipping and N8N/sendgrid} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [True-->] False, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3afa50  session: 0x10ca34950  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,401 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Order Made Ready ✅
&emsp;  Scenario: Order Made Ready  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Ready Flag is Set  
&emsp;&emsp;    Then Logic Increases Balance  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Order Made Ready
   
This illustrates the _ready flag_ pattern:
1. Add a ready flag to the Order
2. Make logic contingent on the ready flag:
    * Customer.Balance is increased only if the Order is ready
    * Empty Orders are not rejected

This enables the user to submit multiple transactions (add order details, alter them etc),
before making the order ready (like a checkout).

Until then, Customer's Balance adjustments, or empty orders constraints do not fire.

> **Key Takeaway:** the ready flag defers constraints/derivations until the user is ready.

> **Key Takeaway:** adjustment from change in qualification condition



&nbsp;
&nbsp;


**Rules Used** in Scenario: Order Made Ready
```
  Customer  
    1. RowEvent Customer.customer_defaults()  
    2. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    3. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    4. Derive Customer.OrderCount as Count(Order Where  - None)  
    5. RowEvent Customer.fn_customer_workflow()  
  Order  
    6. RowEvent Order.congratulate_sales_rep()  
    7. RowEvent Order.do_not_ship_empty_orders()  
    8. RowEvent Order.clone_order()  
    9. RowEvent Order.send_order_to_shipping()  
    10. RowEvent Order.order_defaults()  
```
**Logic Log** in Scenario: Order Made Ready (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10c001250) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,420 - logic_logger - INFO
..Order[11011] {Update - client} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [False-->] True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3af650  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,420 - logic_logger - INFO
..Order[11011] {Prune Formula: OrderDate [[]]} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [False-->] True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3af650  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,420 - logic_logger - INFO
....Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1142.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10ca3add0  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,420 - logic_logger - INFO
Logic Phase:		COMMIT LOGIC		(session=0x10c001250)   										 - 2026-10-19 21:53:16,421 - logic_logger - INFO
..Order[11011] {Commit Event} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [False-->] True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3af650  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,421 - logic_logger - INFO
..Order[11011] {Commit Event} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [False-->] True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3af650  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,421 - logic_logger - INFO
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c001250)   										 - 2026-10-19 21:53:16,421 - logic_logger - INFO
....Customer[ALFKI] {AfterFlush Event} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1142.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10ca3add0  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,421 - logic_logger - INFO
....Customer[ALFKI] {1. /integration.py: Kafka, sending logic_row=logic_row [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1142.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10ca3add0  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,421 - logic_logger - INFO
....Customer[ALFKI] {3. logic_discovery/integration.py: Kafka, sending with declarative mapping (row_dict_mapper=Customer_Orders) [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1142.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10ca3add0  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,422 - logic_logger - INFO
..Order[11011] {AfterFlush Event} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [False-->] True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3af650  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,422 - logic_logger - INFO
..Order[11011] {Sending Order to Shipping [Note: **Kafka not enabled** ]} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [False-->] True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3af650  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,423 - logic_logger - INFO
..Order[11011] {send_order_to_shipping - sent order to shipping and N8N/sendgrid} Id: 11011, CustomerId: ALFKI, EmployeeId: 3, OrderDate: 2014-04-09, RequiredDate: 2014-05-07, ShippedDate: None, ShipVia: 1, Freight: 1.2100000000, ShipName: Alfred's Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 960.00, Country: None, City: None, Ready:  [False-->] True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c3af650  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,424 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Good Order Custom Service ✅
&emsp;  Scenario: Good Order Custom Service  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Good Order Placed  
&emsp;&emsp;    Then Logic adjusts Balance (demo: chain up)  
&emsp;&emsp;    Then Logic adjusts Products Reordered  
&emsp;&emsp;    Then Logic sends email to salesrep  
&emsp;&emsp;    Then Logic sends kafka message  
&emsp;&emsp;    Then Logic adjusts aggregates down on delete order  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Good Order Custom Service
   
Familiar logic patterns:

* Constrain a derived result (Check Credit)
* Chain up, to adjust parent sum/count aggregates (AmountTotal, Balance)
* Events for Lib Access (Kafka, email messages)

Logic Design ("Cocktail Napkin Design")

* Customer.Balance <= CreditLimit
* Customer.Balance = Sum(Order.AmountTotal where unshipped)
* Order.AmountTotal = Sum(OrderDetail.Amount)
* OrderDetail.Amount = Quantity * UnitPrice
* OrderDetail.UnitPrice = copy from Product

We place an Order with an Order Detail.  It's one transaction.

Note how the `Order.AmountTotal` and `Customer.Balance` are *adjusted* as Order Details are processed.
Similarly, the `Product.UnitsShipped` is adjusted, and used to recompute `UnitsInStock`

<figure><img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/behave/declare-logic.png?raw=true"></figure>

> **Key Takeaway:** sum/count aggregates (e.g., `Customer.Balance`) automate ***chain up*** multi-table transactions.

**Events - Extensible Logic**

Inspect the log for __Hi, Andrew - Congratulate Nancy on their new order__. 

The `congratulate_sales_rep` event illustrates logic 
[Extensibility](https://apilogicserver.github.io/Docs/Logic/#extensibility-python-events) 
- using Python to provide logic not covered by rules, 
like non-database operations such as sending email or messages.

<figure><img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/behave/send-email.png?raw=true"></figure>

There are actually multiple kinds of events:

* *Before* row logic
* *After* row logic
* On *commit,* after all row logic has completed (as here), so that your code "sees" the full logic results

Events are passed the `row` and `old_row`, as well as `logic_row` which enables you to test the actual operation, chaining nest level, etc.

You can set breakpoints in events, and inspect these.

#als: Behave Test, Invoking API from Python



&nbsp;
&nbsp;


**Rules Used** in Scenario: Good Order Custom Service
```
  Customer  
    1. RowEvent Customer.fn_customer_workflow()  
    2. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    3. RowEvent Customer.customer_defaults()  
    4. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    5. Derive Customer.OrderCount as Count(Order Where  - None)  
  Order  
    6. RowEvent Order.do_not_ship_empty_orders()  
    7. RowEvent Order.clone_order()  
    8. Derive Order.OrderDetailCount as Count(OrderDetail Where  - None)  
    9. RowEvent Order.congratulate_sales_rep()  
    10. Derive Order.OrderDate as Formula (1): as_expression=lambda row: datetime.datetime.now())  
    11. RowEvent Order.send_order_to_shipping()  
    12. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where  - None)  
    13. RowEvent Order.order_defaults()  
  OrderDetail  
    14. Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...]  
    15. Derive OrderDetail.UnitPrice as Copy(Product.UnitPrice)  
    16. Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDate  
    17. RowEvent OrderDetail.order_detail_defaults()  
  Product  
    18. Derive Product.UnitsShipped as Sum(OrderDetail.Quantity Where lambda row: row.ShippedDate is None))  
    19. Derive Product.UnitsInStock as Formula (1): <function>  
```
**Logic Log** in Scenario: Good Order Custom Service (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10c3afe50) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,442 - logic_logger - INFO
..Order[None] {Insert - client} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: True, OrderDetailCount: None, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,442 - logic_logger - INFO
..Order[None] {server_defaults: OrderDetailCount } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,442 - logic_logger - INFO
..Order[None] {server aggregate_defaults: AmountTotal OrderDetailCount } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 0, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,442 - logic_logger - INFO
..Order[None] {Formula OrderDate} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 0, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,443 - logic_logger - INFO
....Customer[ALFKI] {Update - Adjusting Customer: UnpaidOrderCount, OrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance: 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10c7b3230  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,443 - logic_logger - INFO
..OrderDetail[None] {Insert - client} Id: None, OrderId: None, ProductId: 1, UnitPrice: None, Quantity: 1, Discount: 0, Amount: None, ShippedDate: None  row: 0x10c902cb0  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,444 - logic_logger - INFO
..OrderDetail[None] {copy_rules for role: Product - UnitPrice} Id: None, OrderId: None, ProductId: 1, UnitPrice: 18.0000000000, Quantity: 1, Discount: 0, Amount: None, ShippedDate: None  row: 0x10c902cb0  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,444 - logic_logger - INFO
..OrderDetail[None] {Formula Amount} Id: None, OrderId: None, ProductId: 1, UnitPrice: 18.0000000000, Quantity: 1, Discount: 0, Amount: 18.0000000000, ShippedDate: None  row: 0x10c902cb0  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,444 - logic_logger - INFO
....Order[None] {Update - Adjusting Order: AmountTotal, OrderDetailCount} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 18.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,445 - logic_logger - INFO
....Order[None] {Event nesting suppressed: order_defaults} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 18.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,445 - logic_logger - INFO
....Order[None] {Prune Formula: OrderDate [[]]} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 18.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,445 - logic_logger - INFO
......Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2120.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10c7b3230  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,445 - logic_logger - INFO
......Customer[ALFKI] {Event nesting suppressed: customer_defaults} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2120.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10c7b3230  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,445 - logic_logger - INFO
....Order[None] {Event nesting suppressed: clone_order} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 18.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,445 - logic_logger - INFO
....Product[1] {Update - Adjusting Product: UnitsShipped} Id: 1, ProductName: Chai, SupplierId: 1, CategoryId: 1, QuantityPerUnit: 10 boxes x 20 bags, UnitPrice: 18.0000000000, UnitsInStock: 39, UnitsOnOrder: 0, ReorderLevel: 10, Discontinued: 0, UnitsShipped:  [0-->] 1  row: 0x10c857490  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,445 - logic_logger - INFO
....Product[1] {Formula UnitsInStock} Id: 1, ProductName: Chai, SupplierId: 1, CategoryId: 1, QuantityPerUnit: 10 boxes x 20 bags, UnitPrice: 18.0000000000, UnitsInStock:  [39-->] 38, UnitsOnOrder: 0, ReorderLevel: 10, Discontinued: 0, UnitsShipped:  [0-->] 1  row: 0x10c857490  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,445 - logic_logger - INFO
..OrderDetail[None] {Insert - client} Id: None, OrderId: None, ProductId: 2, UnitPrice: None, Quantity: 2, Discount: 0, Amount: None, ShippedDate: None  row: 0x10ca7ba70  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,446 - logic_logger - INFO
..OrderDetail[None] {copy_rules for role: Product - UnitPrice} Id: None, OrderId: None, ProductId: 2, UnitPrice: 19.0000000000, Quantity: 2, Discount: 0, Amount: None, ShippedDate: None  row: 0x10ca7ba70  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,446 - logic_logger - INFO
..OrderDetail[None] {Formula Amount} Id: None, OrderId: None, ProductId: 2, UnitPrice: 19.0000000000, Quantity: 2, Discount: 0, Amount: 38.0000000000, ShippedDate: None  row: 0x10ca7ba70  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,446 - logic_logger - INFO
....Order[None] {Update - Adjusting Order: AmountTotal, OrderDetailCount} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [18.0000000000-->] 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [1-->] 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,446 - logic_logger - INFO
....Order[None] {Event nesting suppressed: order_defaults} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [18.0000000000-->] 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [1-->] 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,446 - logic_logger - INFO
....Order[None] {Prune Formula: OrderDate [[]]} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [18.0000000000-->] 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [1-->] 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,446 - logic_logger - INFO
......Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2120.0000000000-->] 2158.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10c7b3230  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,446 - logic_logger - INFO
......Customer[ALFKI] {Event nesting suppressed: customer_defaults} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2120.0000000000-->] 2158.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10c7b3230  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,446 - logic_logger - INFO
....Order[None] {Event nesting suppressed: clone_order} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [18.0000000000-->] 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [1-->] 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,447 - logic_logger - INFO
....Product[2] {Update - Adjusting Product: UnitsShipped} Id: 2, ProductName: Chang, SupplierId: 1, CategoryId: 1, QuantityPerUnit: 24 - 12 oz bottles, UnitPrice: 19.0000000000, UnitsInStock: 17, UnitsOnOrder: 40, ReorderLevel: 25, Discontinued: 0, UnitsShipped:  [0-->] 2  row: 0x10c857960  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,447 - logic_logger - INFO
....Product[2] {Formula UnitsInStock} Id: 2, ProductName: Chang, SupplierId: 1, CategoryId: 1, QuantityPerUnit: 24 - 12 oz bottles, UnitPrice: 19.0000000000, UnitsInStock:  [17-->] 15, UnitsOnOrder: 40, ReorderLevel: 25, Discontinued: 0, UnitsShipped:  [0-->] 2  row: 0x10c857960  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,447 - logic_logger - INFO
Logic Phase:		COMMIT LOGIC		(session=0x10c3afe50)   										 - 2026-10-19 21:53:16,447 - logic_logger - INFO
..Order[None] {Commit Event} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,447 - logic_logger - INFO
..Order[None] {Hi, Andrew - Congratulate Nancy on their new order} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,448 - logic_logger - INFO
..Order[None] {Illustrate database access} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,448 - logic_logger - INFO
..Order[None] {Commit Event} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,448 - logic_logger - INFO
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c3afe50)   										 - 2026-10-19 21:53:16,450 - logic_logger - INFO
....Customer[ALFKI] {AfterFlush Event} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2158.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10c7b3230  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,450 - logic_logger - INFO
....Customer[ALFKI] {1. /integration.py: Kafka, sending logic_row=logic_row [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2158.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10c7b3230  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,450 - logic_logger - INFO
....Customer[ALFKI] {3. logic_discovery/integration.py: Kafka, sending with declarative mapping (row_dict_mapper=Customer_Orders) [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2158.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10c7b3230  session: 0x10c3afe50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,450 - logic_logger - INFO
..Order[11078] {AfterFlush Event} Id: 11078, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,450 - logic_logger - INFO
..Order[11078] {Sending Order to Shipping [Note: **Kafka not enabled** ]} Id: 11078, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,450 - logic_logger - INFO
..Order[11078] {send_order_to_shipping - sent order to shipping and N8N/sendgrid} Id: 11078, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.443609, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c001250  session: 0x10c3afe50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,450 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Bad Ship of Empty Order ✅
&emsp;  Scenario: Bad Ship of Empty Order  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order Shipped with no Items  
&emsp;&emsp;    Then Rejected per Do Not Ship Empty Orders  

_No rules fired in this scenario's logic log._

&nbsp;
&nbsp;

#### Scenario: Bad Order Custom Service ✅
&emsp;  Scenario: Bad Order Custom Service  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order Placed with excessive quantity  
&emsp;&emsp;    Then Rejected per Check Credit  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Bad Order Custom Service
   
Reuse the rules for Good Order...

Familiar logic patterns:

* Constrain a derived result
* Chain up, to adjust parent sum/count aggregates

Logic Design ("Cocktail Napkin Design")

* Customer.Balance <= CreditLimit
* Customer.Balance = Sum(Order.AmountTotal where unshipped)
* Order.AmountTotal = Sum(OrderDetail.Amount)
* OrderDetail.Amount = Quantity * UnitPrice
* OrderDetail.UnitPrice = copy from Product



&nbsp;
&nbsp;


**Rules Used** in Scenario: Bad Order Custom Service
```
  Customer  
    1. RowEvent Customer.customer_defaults()  
    2. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    3. Constraint Function: None  
    4. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    5. Derive Customer.OrderCount as Count(Order Where  - None)  
  Order  
    6. Derive Order.OrderDetailCount as Count(OrderDetail Where  - None)  
    7. Derive Order.OrderDate as Formula (1): as_expression=lambda row: datetime.datetime.now())  
    8. RowEvent Order.clone_order()  
    9. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where  - None)  
    10. RowEvent Order.order_defaults()  
  OrderDetail  
    11. Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...]  
    12. Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDate  
    13. RowEvent OrderDetail.order_detail_defaults()  
    14. Derive OrderDetail.UnitPrice as Copy(Product.UnitPrice)  
```
**Logic Log** in Scenario: Bad Order Custom Service (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10ca35d50) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,501 - logic_logger - INFO
..Order[None] {Insert - client} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: True, OrderDetailCount: None, CloneFromOrder: None  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,501 - logic_logger - INFO
..Order[None] {server_defaults: OrderDetailCount } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,502 - logic_logger - INFO
..Order[None] {server aggregate_defaults: AmountTotal OrderDetailCount } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 0, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,502 - logic_logger - INFO
..Order[None] {Formula OrderDate} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.502735, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 0, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,502 - logic_logger - INFO
....Customer[ALFKI] {Update - Adjusting Customer: UnpaidOrderCount, OrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance: 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10cb4e5f0  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,502 - logic_logger - INFO
..OrderDetail[None] {Insert - client} Id: None, OrderId: None, ProductId: 1, UnitPrice: None, Quantity: 1111, Discount: 0, Amount: None, ShippedDate: None  row: 0x10cb5d130  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,503 - logic_logger - INFO
..OrderDetail[None] {copy_rules for role: Product - UnitPrice} Id: None, OrderId: None, ProductId: 1, UnitPrice: 18.0000000000, Quantity: 1111, Discount: 0, Amount: None, ShippedDate: None  row: 0x10cb5d130  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,503 - logic_logger - INFO
..OrderDetail[None] {Formula Amount} Id: None, OrderId: None, ProductId: 1, UnitPrice: 18.0000000000, Quantity: 1111, Discount: 0, Amount: 19998.0000000000, ShippedDate: None  row: 0x10cb5d130  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,503 - logic_logger - INFO
....Order[None] {Update - Adjusting Order: AmountTotal, OrderDetailCount} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.502735, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 19998.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,503 - logic_logger - INFO
....Order[None] {Event nesting suppressed: order_defaults} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.502735, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 19998.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,503 - logic_logger - INFO
....Order[None] {Prune Formula: OrderDate [[]]} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.502735, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 19998.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,504 - logic_logger - INFO
......Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 22100.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cb4e5f0  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,504 - logic_logger - INFO
......Customer[ALFKI] {Event nesting suppressed: customer_defaults} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 22100.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cb4e5f0  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,504 - logic_logger - INFO
......Customer[ALFKI] {Constraint Failure: balance (22100.00) exceeds credit (2300.00)} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 22100.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cb4e5f0  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,504 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Alter Item Qty to exceed credit ✅
&emsp;  Scenario: Alter Item Qty to exceed credit  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order Detail Quantity altered very high  
&emsp;&emsp;    Then Rejected per Check Credit  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Alter Item Qty to exceed credit
   
Same constraint as above.

> **Key Takeaway:** Automatic Reuse (_design one, solve many_)


&nbsp;
&nbsp;


**Rules Used** in Scenario: Alter Item Qty to exceed credit
```
  Customer  
    1. RowEvent Customer.customer_defaults()  
    2. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    3. Constraint Function: None  
    4. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    5. Derive Customer.OrderCount as Count(Order Where  - None)  
  Order  
    6. Derive Order.OrderDetailCount as Count(OrderDetail Where  - None)  
    7. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where  - None)  
    8. RowEvent Order.order_defaults()  
  OrderDetail  
    9. Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...]  
    10. RowEvent OrderDetail.order_detail_defaults()  
```
**Logic Log** in Scenario: Alter Item Qty to exceed credit (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10ca35e50) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,515 - logic_logger - INFO
..OrderDetail[1040] {Update - client} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity:  [15-->] 1110, Discount: 0.25, Amount: 684.0000000000, ShippedDate: None  row: 0x10cb5edf0  session: 0x10ca35e50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,516 - logic_logger - INFO
..OrderDetail[1040] {Formula Amount} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity:  [15-->] 1110, Discount: 0.25, Amount:  [684.0000000000-->] 50616.0000000000, ShippedDate: None  row: 0x10cb5edf0  session: 0x10ca35e50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,516 - logic_logger - INFO
..OrderDetail[1040] {Prune Formula: ShippedDate [['Order.ShippedDate']]} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity:  [15-->] 1110, Discount: 0.25, Amount:  [684.0000000000-->] 50616.0000000000, ShippedDate: None  row: 0x10cb5edf0  session: 0x10ca35e50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,516 - logic_logger - INFO
....Order[10643] {Update - Adjusting Order: AmountTotal} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal:  [1086.00-->] 51018.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35a50  session: 0x10ca35e50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,516 - logic_logger - INFO
....Order[10643] {Prune Formula: OrderDate [[]]} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal:  [1086.00-->] 51018.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35a50  session: 0x10ca35e50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,516 - logic_logger - INFO
......Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 52034.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10cb43690  session: 0x10ca35e50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,517 - logic_logger - INFO
......Customer[ALFKI] {Constraint Failure: balance (52034.00) exceeds credit (2300.00)} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 52034.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10cb43690  session: 0x10ca35e50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,517 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Alter Required Date - adjust logic pruned ✅
&emsp;  Scenario: Alter Required Date - adjust logic pruned  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order RequiredDate altered (2013-10-13)  
&emsp;&emsp;    Then Balance not adjusted  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Alter Required Date - adjust logic pruned
   
We set `Order.RequiredDate`.

This is a normal update.  Nothing depends on the columns altered, so this has no effect on the related Customer, Order Details or Products.  Contrast this to the *Cascade Update Test* and the *Custom Service* test, where logic chaining affects related rows.  Only the commit event fires.

> **Key Takeaway:** rule pruning automatically avoids unnecessary SQL overhead.



&nbsp;
&nbsp;


**Rules Used** in Scenario: Alter Required Date - adjust logic pruned
```
  Customer  
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    2. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    3. Derive Customer.OrderCount as Count(Order Where  - None)  
  Order  
    4. RowEvent Order.congratulate_sales_rep()  
    5. RowEvent Order.do_not_ship_empty_orders()  
    6. RowEvent Order.clone_order()  
    7. RowEvent Order.send_order_to_shipping()  
    8. RowEvent Order.order_defaults()  
```
**Logic Log** in Scenario: Alter Required Date - adjust logic pruned (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10ca34c50) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,529 - logic_logger - INFO
..Order[10643] {Update - client} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-10-13-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35850  session: 0x10ca34c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,530 - logic_logger - INFO
..Order[10643] {Prune Formula: OrderDate [[]]} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-10-13-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35850  session: 0x10ca34c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,530 - logic_logger - INFO
Logic Phase:		COMMIT LOGIC		(session=0x10ca34c50)   										 - 2026-10-19 21:53:16,530 - logic_logger - INFO
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-10-13-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35850  session: 0x10ca34c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,530 - logic_logger - INFO
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-10-13-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35850  session: 0x10ca34c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,530 - logic_logger - INFO
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10ca34c50)   										 - 2026-10-19 21:53:16,530 - logic_logger - INFO
..Order[10643] {AfterFlush Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-10-13-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35850  session: 0x10ca34c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,530 - logic_logger - INFO
..Order[10643] {send_order_to_shipping - sent order to shipping and N8N/sendgrid} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-10-13-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35850  session: 0x10ca34c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,530 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Set Shipped - adjust logic reuse ✅
&emsp;  Scenario: Set Shipped - adjust logic reuse  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order ShippedDate altered (2013-10-13)  
&emsp;&emsp;    Then Balance reduced 1086  
&emsp;&emsp;    Then Product[46] UnitsInStock adjusted  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Set Shipped - adjust logic reuse
   

Logic Patterns:

* Chain Down

Logic Design ("Cocktail Napkin Design")

* Formula: OrderDetail.ShippedDate = Order.ShippedDate

We set `Order.ShippedDate`.

This cascades to the Order Details, per the `derive=models.OrderDetail.ShippedDate` rule.

This chains to adjust the `Product.UnitsShipped` and recomputes `UnitsInStock`, as above

<figure><img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/behave/order-shipped-date.png?raw=true"></figure>


> **Key Takeaway:** parent references (e.g., `OrderDetail.ShippedDate`) automate ***chain-down*** multi-table transactions.

> **Key Takeaway:** Automatic Reuse (_design one, solve many_)



&nbsp;
&nbsp;


**Rules Used** in Scenario: Set Shipped - adjust logic reuse
```
  Customer  
    1. RowEvent Customer.customer_defaults()  
    2. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    3. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    4. Derive Customer.OrderCount as Count(Order Where  - None)  
    5. RowEvent Customer.fn_customer_workflow()  
  Order  
    6. Derive Order.OrderDetailCount as Count(OrderDetail Where  - None)  
    7. RowEvent Order.congratulate_sales_rep()  
    8. RowEvent Order.do_not_ship_empty_orders()  
    9. RowEvent Order.clone_order()  
    10. RowEvent Order.send_order_to_shipping()  
    11. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where  - None)  
    12. RowEvent Order.order_defaults()  
  OrderDetail  
    13. Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDate  
    14. RowEvent OrderDetail.order_detail_defaults()  
  Product  
    15. Derive Product.UnitsShipped as Sum(OrderDetail.Quantity Where lambda row: row.ShippedDate is None))  
    16. Derive Product.UnitsInStock as Formula (1): <function>  
```
**Logic Log** in Scenario: Set Shipped - adjust logic reuse (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10ca35650) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,551 - logic_logger - INFO
..Order[10643] {Update - client} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca34750  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,551 - logic_logger - INFO
..Order[10643] {Prune Formula: OrderDate [[]]} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca34750  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,552 - logic_logger - INFO
....Customer[ALFKI] {Update - Adjusting Customer: Balance, UnpaidOrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1016.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [10-->] 9, Client_id: 1  row: 0x10cb42c10  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,552 - logic_logger - INFO
....OrderDetail[1040] {Update - Cascading Order.ShippedDate (,...)} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity: 15, Discount: 0.25, Amount: 684.0000000000, ShippedDate: None  row: 0x10cbdd090  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,552 - logic_logger - INFO
....OrderDetail[1040] {Prune Formula: Amount [['UnitPrice', 'Quantity']]} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity: 15, Discount: 0.25, Amount: 684.0000000000, ShippedDate: None  row: 0x10cbdd090  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,553 - logic_logger - INFO
....OrderDetail[1040] {Formula ShippedDate} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity: 15, Discount: 0.25, Amount: 684.0000000000, ShippedDate:  [None-->] 2013-10-13  row: 0x10cbdd090  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,553 - logic_logger - INFO
......Product[28] {Update - Adjusting Product: UnitsShipped} Id: 28, ProductName: Rössle Sauerkraut, SupplierId: 12, CategoryId: 7, QuantityPerUnit: 25 - 825 g cans, UnitPrice: 45.6000000000, UnitsInStock: 26, UnitsOnOrder: 0, ReorderLevel: 0, Discontinued: 1, UnitsShipped:  [0-->] -15  row: 0x10cb8c940  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,553 - logic_logger - INFO
......Product[28] {Formula UnitsInStock} Id: 28, ProductName: Rössle Sauerkraut, SupplierId: 12, CategoryId: 7, QuantityPerUnit: 25 - 825 g cans, UnitPrice: 45.6000000000, UnitsInStock:  [26-->] 41, UnitsOnOrder: 0, ReorderLevel: 0, Discontinued: 1, UnitsShipped:  [0-->] -15  row: 0x10cb8c940  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,553 - logic_logger - INFO
....OrderDetail[1041] {Update - Cascading Order.ShippedDate (,...)} Id: 1041, OrderId: 10643, ProductId: 39, UnitPrice: 18.0000000000, Quantity: 21, Discount: 0.25, Amount: 378.0000000000, ShippedDate: None  row: 0x10cbdcff0  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,553 - logic_logger - INFO
....OrderDetail[1041] {Prune Formula: Amount [['UnitPrice', 'Quantity']]} Id: 1041, OrderId: 10643, ProductId: 39, UnitPrice: 18.0000000000, Quantity: 21, Discount: 0.25, Amount: 378.0000000000, ShippedDate: None  row: 0x10cbdcff0  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,553 - logic_logger - INFO
....OrderDetail[1041] {Formula ShippedDate} Id: 1041, OrderId: 10643, ProductId: 39, UnitPrice: 18.0000000000, Quantity: 21, Discount: 0.25, Amount: 378.0000000000, ShippedDate:  [None-->] 2013-10-13  row: 0x10cbdcff0  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,553 - logic_logger - INFO
......Product[39] {Update - Adjusting Product: UnitsShipped} Id: 39, ProductName: Chartreuse verte, SupplierId: 18, CategoryId: 1, QuantityPerUnit: 750 cc per bottle, UnitPrice: 18.0000000000, UnitsInStock: 69, UnitsOnOrder: 0, ReorderLevel: 5, Discontinued: 0, UnitsShipped:  [0-->] -21  row: 0x10cb8c730  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,554 - logic_logger - INFO
......Product[39] {Formula UnitsInStock} Id: 39, ProductName: Chartreuse verte, SupplierId: 18, CategoryId: 1, QuantityPerUnit: 750 cc per bottle, UnitPrice: 18.0000000000, UnitsInStock:  [69-->] 90, UnitsOnOrder: 0, ReorderLevel: 5, Discontinued: 0, UnitsShipped:  [0-->] -21  row: 0x10cb8c730  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,554 - logic_logger - INFO
....OrderDetail[1042] {Update - Cascading Order.ShippedDate (,...)} Id: 1042, OrderId: 10643, ProductId: 46, UnitPrice: 12.0000000000, Quantity: 2, Discount: 0.25, Amount: 24.0000000000, ShippedDate: None  row: 0x10cbdc4b0  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,554 - logic_logger - INFO
....OrderDetail[1042] {Prune Formula: Amount [['UnitPrice', 'Quantity']]} Id: 1042, OrderId: 10643, ProductId: 46, UnitPrice: 12.0000000000, Quantity: 2, Discount: 0.25, Amount: 24.0000000000, ShippedDate: None  row: 0x10cbdc4b0  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,554 - logic_logger - INFO
....OrderDetail[1042] {Formula ShippedDate} Id: 1042, OrderId: 10643, ProductId: 46, UnitPrice: 12.0000000000, Quantity: 2, Discount: 0.25, Amount: 24.0000000000, ShippedDate:  [None-->] 2013-10-13  row: 0x10cbdc4b0  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,554 - logic_logger - INFO
......Product[46] {Update - Adjusting Product: UnitsShipped} Id: 46, ProductName: Spegesild, SupplierId: 21, CategoryId: 8, QuantityPerUnit: 4 - 450 g glasses, UnitPrice: 12.0000000000, UnitsInStock: 95, UnitsOnOrder: 0, ReorderLevel: 0, Discontinued: 0, UnitsShipped:  [0-->] -2  row: 0x10cb8c310  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,554 - logic_logger - INFO
......Product[46] {Formula UnitsInStock} Id: 46, ProductName: Spegesild, SupplierId: 21, CategoryId: 8, QuantityPerUnit: 4 - 450 g glasses, UnitPrice: 12.0000000000, UnitsInStock:  [95-->] 97, UnitsOnOrder: 0, ReorderLevel: 0, Discontinued: 0, UnitsShipped:  [0-->] -2  row: 0x10cb8c310  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,554 - logic_logger - INFO
Logic Phase:		COMMIT LOGIC		(session=0x10ca35650)   										 - 2026-10-19 21:53:16,554 - logic_logger - INFO
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca34750  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,554 - logic_logger - INFO
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca34750  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,555 - logic_logger - INFO
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10ca35650)   										 - 2026-10-19 21:53:16,555 - logic_logger - INFO
....Customer[ALFKI] {AfterFlush Event} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1016.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [10-->] 9, Client_id: 1  row: 0x10cb42c10  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,555 - logic_logger - INFO
....Customer[ALFKI] {1. /integration.py: Kafka, sending logic_row=logic_row [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1016.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [10-->] 9, Client_id: 1  row: 0x10cb42c10  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,555 - logic_logger - INFO
....Customer[ALFKI] {3. logic_discovery/integration.py: Kafka, sending with declarative mapping (row_dict_mapper=Customer_Orders) [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1016.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [10-->] 9, Client_id: 1  row: 0x10cb42c10  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,556 - logic_logger - INFO
..Order[10643] {AfterFlush Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca34750  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,556 - logic_logger - INFO
..Order[10643] {send_order_to_shipping - sent order to shipping and N8N/sendgrid} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca34750  session: 0x10ca35650  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,556 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Reset Shipped - adjust logic reuse ✅
&emsp;  Scenario: Reset Shipped - adjust logic reuse  
&emsp;&emsp;    Given Shipped Order  
&emsp;&emsp;    When Order ShippedDate set to None  
&emsp;&emsp;    Then Logic adjusts Balance by -1086  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Reset Shipped - adjust logic reuse
   
Same logic as above.

> **Key Takeaway:** Automatic Reuse (_design one, solve many_)


&nbsp;
&nbsp;


**Rules Used** in Scenario: Reset Shipped - adjust logic reuse
```
  Customer  
    1. RowEvent Customer.customer_defaults()  
    2. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    3. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    4. Derive Customer.OrderCount as Count(Order Where  - None)  
    5. RowEvent Customer.fn_customer_workflow()  
  Order  
    6. Derive Order.OrderDetailCount as Count(OrderDetail Where  - None)  
    7. RowEvent Order.congratulate_sales_rep()  
    8. RowEvent Order.do_not_ship_empty_orders()  
    9. RowEvent Order.clone_order()  
    10. RowEvent Order.send_order_to_shipping()  
    11. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where  - None)  
    12. RowEvent Order.order_defaults()  
  OrderDetail  
    13. Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDate  
    14. RowEvent OrderDetail.order_detail_defaults()  
  Product  
    15. Derive Product.UnitsShipped as Sum(OrderDetail.Quantity Where lambda row: row.ShippedDate is None))  
    16. Derive Product.UnitsInStock as Formula (1): <function>  
```
**Logic Log** in Scenario: Reset Shipped - adjust logic reuse (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10ca35750) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,579 - logic_logger - INFO
..Order[10643] {Update - client} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35550  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,579 - logic_logger - INFO
..Order[10643] {Prune Formula: OrderDate [[]]} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35550  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,579 - logic_logger - INFO
....Customer[ALFKI] {Update - Adjusting Customer: Balance, UnpaidOrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1016.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [9-->] 10, Client_id: 1  row: 0x10cbec3d0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,579 - logic_logger - INFO
....OrderDetail[1040] {Update - Cascading Order.ShippedDate (,...)} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity: 15, Discount: 0.25, Amount: 684.0000000000, ShippedDate: 2013-10-13  row: 0x10cbdf250  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,580 - logic_logger - INFO
....OrderDetail[1040] {Prune Formula: Amount [['UnitPrice', 'Quantity']]} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity: 15, Discount: 0.25, Amount: 684.0000000000, ShippedDate: 2013-10-13  row: 0x10cbdf250  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,580 - logic_logger - INFO
....OrderDetail[1040] {Formula ShippedDate} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity: 15, Discount: 0.25, Amount: 684.0000000000, ShippedDate:  [2013-10-13-->] None  row: 0x10cbdf250  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,580 - logic_logger - INFO
......Product[28] {Update - Adjusting Product: UnitsShipped} Id: 28, ProductName: Rössle Sauerkraut, SupplierId: 12, CategoryId: 7, QuantityPerUnit: 25 - 825 g cans, UnitPrice: 45.6000000000, UnitsInStock: 41, UnitsOnOrder: 0, ReorderLevel: 0, Discontinued: 1, UnitsShipped:  [-15-->] 0  row: 0x10cb8ccb0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
......Product[28] {Formula UnitsInStock} Id: 28, ProductName: Rössle Sauerkraut, SupplierId: 12, CategoryId: 7, QuantityPerUnit: 25 - 825 g cans, UnitPrice: 45.6000000000, UnitsInStock:  [41-->] 26, UnitsOnOrder: 0, ReorderLevel: 0, Discontinued: 1, UnitsShipped:  [-15-->] 0  row: 0x10cb8ccb0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
....OrderDetail[1041] {Update - Cascading Order.ShippedDate (,...)} Id: 1041, OrderId: 10643, ProductId: 39, UnitPrice: 18.0000000000, Quantity: 21, Discount: 0.25, Amount: 378.0000000000, ShippedDate: 2013-10-13  row: 0x10cbdf1b0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
....OrderDetail[1041] {Prune Formula: Amount [['UnitPrice', 'Quantity']]} Id: 1041, OrderId: 10643, ProductId: 39, UnitPrice: 18.0000000000, Quantity: 21, Discount: 0.25, Amount: 378.0000000000, ShippedDate: 2013-10-13  row: 0x10cbdf1b0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
....OrderDetail[1041] {Formula ShippedDate} Id: 1041, OrderId: 10643, ProductId: 39, UnitPrice: 18.0000000000, Quantity: 21, Discount: 0.25, Amount: 378.0000000000, ShippedDate:  [2013-10-13-->] None  row: 0x10cbdf1b0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
......Product[39] {Update - Adjusting Product: UnitsShipped} Id: 39, ProductName: Chartreuse verte, SupplierId: 18, CategoryId: 1, QuantityPerUnit: 750 cc per bottle, UnitPrice: 18.0000000000, UnitsInStock: 90, UnitsOnOrder: 0, ReorderLevel: 5, Discontinued: 0, UnitsShipped:  [-21-->] 0  row: 0x10cb8cec0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
......Product[39] {Formula UnitsInStock} Id: 39, ProductName: Chartreuse verte, SupplierId: 18, CategoryId: 1, QuantityPerUnit: 750 cc per bottle, UnitPrice: 18.0000000000, UnitsInStock:  [90-->] 69, UnitsOnOrder: 0, ReorderLevel: 5, Discontinued: 0, UnitsShipped:  [-21-->] 0  row: 0x10cb8cec0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
....OrderDetail[1042] {Update - Cascading Order.ShippedDate (,...)} Id: 1042, OrderId: 10643, ProductId: 46, UnitPrice: 12.0000000000, Quantity: 2, Discount: 0.25, Amount: 24.0000000000, ShippedDate: 2013-10-13  row: 0x10cbde670  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
....OrderDetail[1042] {Prune Formula: Amount [['UnitPrice', 'Quantity']]} Id: 1042, OrderId: 10643, ProductId: 46, UnitPrice: 12.0000000000, Quantity: 2, Discount: 0.25, Amount: 24.0000000000, ShippedDate: 2013-10-13  row: 0x10cbde670  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
....OrderDetail[1042] {Formula ShippedDate} Id: 1042, OrderId: 10643, ProductId: 46, UnitPrice: 12.0000000000, Quantity: 2, Discount: 0.25, Amount: 24.0000000000, ShippedDate:  [2013-10-13-->] None  row: 0x10cbde670  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,581 - logic_logger - INFO
......Product[46] {Update - Adjusting Product: UnitsShipped} Id: 46, ProductName: Spegesild, SupplierId: 21, CategoryId: 8, QuantityPerUnit: 4 - 450 g glasses, UnitPrice: 12.0000000000, UnitsInStock: 97, UnitsOnOrder: 0, ReorderLevel: 0, Discontinued: 0, UnitsShipped:  [-2-->] 0  row: 0x10cb8d0d0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,582 - logic_logger - INFO
......Product[46] {Formula UnitsInStock} Id: 46, ProductName: Spegesild, SupplierId: 21, CategoryId: 8, QuantityPerUnit: 4 - 450 g glasses, UnitPrice: 12.0000000000, UnitsInStock:  [97-->] 95, UnitsOnOrder: 0, ReorderLevel: 0, Discontinued: 0, UnitsShipped:  [-2-->] 0  row: 0x10cb8d0d0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,582 - logic_logger - INFO
Logic Phase:		COMMIT LOGIC		(session=0x10ca35750)   										 - 2026-10-19 21:53:16,582 - logic_logger - INFO
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35550  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,582 - logic_logger - INFO
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35550  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,582 - logic_logger - INFO
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10ca35750)   										 - 2026-10-19 21:53:16,582 - logic_logger - INFO
....Customer[ALFKI] {AfterFlush Event} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1016.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [9-->] 10, Client_id: 1  row: 0x10cbec3d0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,583 - logic_logger - INFO
....Customer[ALFKI] {1. /integration.py: Kafka, sending logic_row=logic_row [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1016.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [9-->] 10, Client_id: 1  row: 0x10cbec3d0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,583 - logic_logger - INFO
....Customer[ALFKI] {3. logic_discovery/integration.py: Kafka, sending with declarative mapping (row_dict_mapper=Customer_Orders) [Note: **Kafka not enabled** ]} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1016.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [9-->] 10, Client_id: 1  row: 0x10cbec3d0  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,583 - logic_logger - INFO
..Order[10643] {AfterFlush Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35550  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,583 - logic_logger - INFO
..Order[10643] {send_order_to_shipping - sent order to shipping and N8N/sendgrid} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10ca35550  session: 0x10ca35750  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,583 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Clone Existing Order ✅
&emsp;  Scenario: Clone Existing Order  
&emsp;&emsp;    Given Shipped Order  
&emsp;&emsp;    When Cloning Existing Order  
&emsp;&emsp;    Then Logic Copies ClonedFrom OrderDetails  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Clone Existing Order
   
We create an order, setting CloneFromOrder.

This copies the CloneFromOrder OrderDetails to our new Order.

The copy operation is automated using `logic_row.copy_children()`:

1. `place_order.feature` defines the test

2. `place_order.py` implements the test.  It uses the API to Post an Order, setting `CloneFromOrder` to trigger the copy logic

3. `declare_logic.py` implements the logic, by invoking `logic_row.copy_children()`.  `which` defines which children to copy, here just `OrderDetailList`

<figure><img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/behave/clone-order.png?raw=true"></figure>

`CopyChildren` For more information, [see here](https://github.com/valhuber/LogicBank/wiki/Copy-Children)

    Useful in row event handlers to copy multiple children types to self from copy_from children.

    child-spec := < ‘child-list-name’ | < ‘child-list-name = parent-list-name’ >
    child-list-spec := [child-spec | (child-spec, child-list-spec)]

    Eg. RowEvent on Order
        which = ["OrderDetailList"]
        logic_row.copy_children(copy_from=row.parent, which_children=which)

    Eg, test/copy_children:
        child_list_spec = [
            ("MileStoneList",
                ["DeliverableList"]  # for each Milestone, get the Deliverables
            ),
            "StaffList"
        ]

> **Key Takeaway:** copy_children provides a deep-copy service.



&nbsp;
&nbsp;


**Rules Used** in Scenario: Clone Existing Order
```
  Customer  
    1. RowEvent Customer.customer_defaults()  
    2. Derive Customer.Balance as Sum(Order.AmountTotal Where lambda row: row.ShippedDate is None and row.Ready == True)  # adjusts - *not* a sql select sum...)  
    3. Constraint Function: None  
    4. Derive Customer.UnpaidOrderCount as Count(Order Where lambda row: row.ShippedDate is None)  # *not* a sql select sum...)  
    5. Derive Customer.OrderCount as Count(Order Where  - None)  
  Order  
    6. Derive Order.OrderDetailCount as Count(OrderDetail Where  - None)  
    7. Derive Order.OrderDate as Formula (1): as_expression=lambda row: datetime.datetime.now())  
    8. RowEvent Order.clone_order()  
    9. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where  - None)  
    10. RowEvent Order.order_defaults()  
  OrderDetail  
    11. Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...]  
    12. Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDate  
    13. RowEvent OrderDetail.order_detail_defaults()  
    14. Derive OrderDetail.UnitPrice as Copy(Product.UnitPrice)  
```
**Logic Log** in Scenario: Clone Existing Order (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10ca35d50) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,600 - logic_logger - INFO
..Order[None] {Insert - client} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: True, OrderDetailCount: None, CloneFromOrder: 10643  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,600 - logic_logger - INFO
..Order[None] {server_defaults: OrderDetailCount } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: 10643  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,600 - logic_logger - INFO
..Order[None] {server aggregate_defaults: AmountTotal OrderDetailCount } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 0, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: 10643  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,600 - logic_logger - INFO
..Order[None] {Formula OrderDate} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.602064, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 0, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: 10643  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,602 - logic_logger - INFO
....Customer[ALFKI] {Update - Adjusting Customer: UnpaidOrderCount, OrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance: 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10cbfea50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,602 - logic_logger - INFO
..Order[None] {Begin copy_children} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.602064, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 0, Country: None, City: None, Ready: True, OrderDetailCount: 0, CloneFromOrder: 10643  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,602 - logic_logger - INFO
....OrderDetail[None] {server_defaults: Quantity Discount } Id: None, OrderId: None, ProductId: None, UnitPrice: None, Quantity: 1, Discount: 0.0, Amount: None, ShippedDate: None  row: 0x10cc15130  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,602 - logic_logger - INFO
....OrderDetail[None] {Insert - Copy Children OrderDetailList} Id: None, OrderId: None, ProductId: 28, UnitPrice: None, Quantity: 15, Discount: 0.25, Amount: None, ShippedDate: None  row: 0x10cc15130  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,603 - logic_logger - INFO
....OrderDetail[None] {copy_rules for role: Product - UnitPrice} Id: None, OrderId: None, ProductId: 28, UnitPrice: 45.6000000000, Quantity: 15, Discount: 0.25, Amount: None, ShippedDate: None  row: 0x10cc15130  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,603 - logic_logger - INFO
....OrderDetail[None] {Formula Amount} Id: None, OrderId: None, ProductId: 28, UnitPrice: 45.6000000000, Quantity: 15, Discount: 0.25, Amount: 684.0000000000, ShippedDate: None  row: 0x10cc15130  session: 0x10ca35d50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,603 - logic_logger - INFO
......Order[None] {Update - Adjusting Order: AmountTotal, OrderDetailCount} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.602064, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 684.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: 10643  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,603 - logic_logger - INFO
......Order[None] {Event nesting suppressed: order_defaults} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.602064, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 684.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: 10643  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,603 - logic_logger - INFO
......Order[None] {Prune Formula: OrderDate [[]]} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2026-10-19 21:53:16.602064, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [0-->] 684.0000000000, Country: None, City: None, Ready: True, OrderDetailCount:  [0-->] 1, CloneFromOrder: 10643  row: 0x10ca34b50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,603 - logic_logger - INFO
........Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2786.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cbfea50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,603 - logic_logger - INFO
........Customer[ALFKI] {Event nesting suppressed: customer_defaults} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2786.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cbfea50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,604 - logic_logger - INFO
........Customer[ALFKI] {Constraint Failure: balance (2786.00) exceeds credit (2300.00)} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2786.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cbfea50  session: 0x10ca35d50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,604 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

### Feature: Salary Change  

&nbsp;
&nbsp;

#### Scenario: Audit Salary Change ✅
&emsp;  Scenario: Audit Salary Change  
&emsp;&emsp;    Given Employee 5 (Buchanan) - Salary 95k  
&emsp;&emsp;    When Patch Salary to 200k  
&emsp;&emsp;    Then Salary_audit row created  

<details markdown>
<summary>Rules exercised and logic log (2 transactions)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Audit Salary Change
   
Logic Patterns:

* Auditing

Logic Design ("Cocktail Napkin Design")

* copy_row(copy_to=models.EmployeeAudit...)

Observe the logic log to see that it creates audit rows:

1. **Discouraged:** you can implement auditing with events.  But auditing is a common pattern, and this can lead to repetitive, tedious code
2. **Preferred:** approaches use [extensible rules](https://github.com/valhuber/LogicBank/wiki/Rule-Extensibility#generic-event-handlers).

Generic event handlers can also reduce redundant code, illustrated in the time/date stamping `handle_all` logic.

This is due to the `copy_row` rule.  Contrast this to the *tedious* `audit_by_event` alternative:

<figure><img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/behave/salary_change.png?raw=true"></figure>

> **Key Takeaway:** use **extensible own rule types** to automate pattern you identify; events can result in tedious amounts of code.



&nbsp;
&nbsp;


**Rules Used** in Scenario: Audit Salary Change
```
  Employee  
    1. RowEvent Employee.fn_employee_workflow()  
```
**Logic Log** in Scenario: Audit Salary Change (2 transactions)
```
Logic Phase:		ROW LOGIC		(session=0x10ca35c50) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,611 - logic_logger - INFO
..Employee[5] {Update - client} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: http://localhost:5656/ui/images/Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 200000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None, Email: steven@nw.com  row: 0x10c938e90  session: 0x10ca35c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,611 - logic_logger - INFO
..Employee[5] {BEGIN Copy to: EmployeeAudit} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: http://localhost:5656/ui/images/Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 200000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None, Email: steven@nw.com  row: 0x10c938e90  session: 0x10ca35c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,611 - logic_logger - INFO
....EmployeeAudit[None] {Insert - Copy EmployeeAudit} Id: None, Title: Sales Manager, Salary: 200000, LastName: Buchanan, FirstName: Steven, EmployeeId: None, CreatedOn: None, UpdatedOn: None, CreatedBy: None, UpdatedBy: None  row: 0x10cb8da70  session: 0x10ca35c50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,612 - logic_logger - INFO
....EmployeeAudit[None] {early_row_event_all_classes - handle_all did stamping} Id: None, Title: Sales Manager, Salary: 200000, LastName: Buchanan, FirstName: Steven, EmployeeId: None, CreatedOn: 2026-10-19 21:53:16.612044, UpdatedOn: None, CreatedBy: aneu, UpdatedBy: None  row: 0x10cb8da70  session: 0x10ca35c50  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,612 - logic_logger - INFO
Logic Phase:		COMMIT LOGIC		(session=0x10ca35c50)   										 - 2026-10-19 21:53:16,612 - logic_logger - INFO
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10ca35c50)   										 - 2026-10-19 21:53:16,612 - logic_logger - INFO
..Employee[5] {AfterFlush Event} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: http://localhost:5656/ui/images/Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 200000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None, Email: steven@nw.com  row: 0x10c938e90  session: 0x10ca35c50  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,612 - logic_logger - INFO


Logic Phase:		ROW LOGIC		(session=0x10c001250) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,628 - logic_logger - INFO
..Employee[5] {Update - client} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: http://localhost:5656/ui/images/Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [200000.0000000000-->] 95000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None, Email: steven@nw.com  row: 0x10c79e3f0  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,628 - logic_logger - INFO
..Employee[5] {BEGIN Copy to: EmployeeAudit} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: http://localhost:5656/ui/images/Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [200000.0000000000-->] 95000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None, Email: steven@nw.com  row: 0x10c79e3f0  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,628 - logic_logger - INFO
....EmployeeAudit[None] {Insert - Copy EmployeeAudit} Id: None, Title: Sales Manager, Salary: 95000, LastName: Buchanan, FirstName: Steven, EmployeeId: None, CreatedOn: None, UpdatedOn: None, CreatedBy: None, UpdatedBy: None  row: 0x10c857c20  session: 0x10c001250  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,628 - logic_logger - INFO
....EmployeeAudit[None] {early_row_event_all_classes - handle_all did stamping} Id: None, Title: Sales Manager, Salary: 95000, LastName: Buchanan, FirstName: Steven, EmployeeId: None, CreatedOn: 2026-10-19 21:53:16.628839, UpdatedOn: None, CreatedBy: aneu, UpdatedBy: None  row: 0x10c857c20  session: 0x10c001250  ins_upd_dlt: ins, initial: ins - 2026-10-19 21:53:16,628 - logic_logger - INFO
Logic Phase:		COMMIT LOGIC		(session=0x10c001250)   										 - 2026-10-19 21:53:16,628 - logic_logger - INFO
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c001250)   										 - 2026-10-19 21:53:16,629 - logic_logger - INFO
..Employee[5] {AfterFlush Event} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: http://localhost:5656/ui/images/Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [200000.0000000000-->] 95000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None, Email: steven@nw.com  row: 0x10c79e3f0  session: 0x10c001250  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,629 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

#### Scenario: Manage ProperSalary ✅
&emsp;  Scenario: Manage ProperSalary  
&emsp;&emsp;    Given Employee 5 (Buchanan) - Salary 95k  
&emsp;&emsp;    When Retrieve Employee Row  
&emsp;&emsp;    Then Verify Contains ProperSalary  

_No rules fired in this scenario's logic log._

&nbsp;
&nbsp;

#### Scenario: Raise Must be Meaningful ✅
&emsp;  Scenario: Raise Must be Meaningful  
&emsp;&emsp;    Given Employee 5 (Buchanan) - Salary 95k  
&emsp;&emsp;    When Patch Salary to 96k  
&emsp;&emsp;    Then Reject - Raise too small  

<details markdown>
<summary>Rules exercised and logic log (1 transaction)</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Raise Must be Meaningful
   
Logic Patterns:

* State Transition Logic

Logic Design ("Cocktail Napkin Design")

* Rule.constraint(validate=Employee, calling=raise_over_20_percent...)

Observe the use of `old_row
`
> **Key Takeaway:** State Transition Logic enabled per `old_row`



&nbsp;
&nbsp;


**Rules Used** in Scenario: Raise Must be Meaningful
```
  Employee  
    1. Constraint Function: <function declare_logic.<locals>.raise_over_20_percent at 0x10bf48a40>  
```
**Logic Log** in Scenario: Raise Must be Meaningful (1 transaction)
```
Logic Phase:		ROW LOGIC		(session=0x10c3ae350) (sqlalchemy before_flush)			 - 2026-10-19 21:53:16,642 - logic_logger - INFO
..Employee[5] {Update - client} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: http://localhost:5656/ui/images/Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 96000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None, Email: steven@nw.com  row: 0x10c9382b0  session: 0x10c3ae350  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,642 - logic_logger - INFO
..Employee[5] {Constraint Failure: Buchanan needs a more meaningful raise} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: http://localhost:5656/ui/images/Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 96000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None, Email: steven@nw.com  row: 0x10c9382b0  session: 0x10c3ae350  ins_upd_dlt: upd, initial: upd - 2026-10-19 21:53:16,643 - logic_logger - INFO

```
</details>

&nbsp;
&nbsp;

### Feature: Tests Successful  

&nbsp;
&nbsp;

#### Scenario: Run Tests ✅
&emsp;  Scenario: Run Tests  
&emsp;&emsp;    Given Database and Set of Tests  
&emsp;&emsp;    When Run Configuration: Behave Tests  
&emsp;&emsp;    Then No Errors  

_No logic log for this scenario: the test does not open one, so no rules are shown for it (see "How to add more tests")._
&nbsp;&nbsp;  
/Users/val/dev/ApiLogicServer/ApiLogicServer-dev/build_and_test/genai-logic/tests/ApiLogicProject/test/api_logic_server_behave/behave_run.py completed at October 19, 2026 21:53:16  
