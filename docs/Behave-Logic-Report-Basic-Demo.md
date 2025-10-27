## Basic Demo Sample

This is a basic demonstration project created from a simple natural language prompt using API Logic Server's GenAI capabilities.

### Data Model

![Basic Demo Data Model](https://apilogicserver.github.io/Docs/images/basic_demo/basic_demo_data_model.jpeg)

### Creation Prompt

This project was created from the following natural language prompt:

```
Create a system with customers, orders, items and products.

Include a notes field for orders.

Use case: Check Credit    
    1. The Customer's balance is less than the credit limit
    2. The Customer's balance is the sum of the Order amount_total where date_shipped is null
    3. The Order's amount_total is the sum of the Item amount
    4. The Item amount is the quantity * unit_price
    5. The Item unit_price is copied from the Product unit_price

Use case: App Integration
    1. Send the Order to Kafka topic 'order_shipping' if the date_shipped is not None.
```

The sample Scenarios below were chosen to illustrate the basic patterns of using rules. Open the disclosure box ("Tests - and their logic...") to see the implementation and notes.

The following report was created during test suite execution.

&nbsp;

# Behave Logic Report
&nbsp;
&nbsp;
## Feature: About Sample  
  
&nbsp;
&nbsp;
### Scenario: Transaction Processing
&emsp;  Scenario: Transaction Processing  
&emsp;&emsp;    Given Sample Database  
&emsp;&emsp;    When Transactions are submitted  
&emsp;&emsp;    Then Enforce business policies with Logic (rules + code)  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Transaction Processing
```
```
**Logic Log** in Scenario: Transaction Processing
```
Logic Phase:		ROW LOGIC		(session=0x1098628b0) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,158 - logic_logger - INF
..Customer[None] {Insert - client} id: None, name: Alice 1761523857156, balance: 0, credit_limit: 1000, email: None, email_opt_out: None  row: 0x10991f6d0  session: 0x1098628b0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,158 - logic_logger - INF
..Customer[None] {server aggregate_defaults: balance } id: None, name: Alice 1761523857156, balance: 0, credit_limit: 1000, email: None, email_opt_out: None  row: 0x10991f6d0  session: 0x1098628b0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,158 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x1098628b0)   										 - 2025-10-26 17:10:57,158 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x1098628b0)   										 - 2025-10-26 17:10:57,158 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
## Feature: Order Processing with Business Logic  
  
&nbsp;
&nbsp;
### Scenario: Good Order Created via B2B API
&emsp;  Scenario: Good Order Created via B2B API  
&emsp;&emsp;    Given Customer "Alice" with balance 0 and credit limit 1000  
&emsp;&emsp;    When B2B order placed for "Alice" with 5 Widget  
&emsp;&emsp;    Then Customer balance should be 450  
    And Order amount_total should be 450  
    And Each item amount calculated correctly  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Good Order Created via B2B API
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Item  
    2. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
    3. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Good Order Created via B2B API
```
Logic Phase:		ROW LOGIC		(session=0x109863f00) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,165 - logic_logger - INF
..Product[2] {Update - client} id: 2, name: Widget, unit_price: 90.0000000000, carbon_neutral: None  row: 0x109a510f0  session: 0x109863f00  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,165 - logic_logger - INF
..Item[None] {Insert - client} id: None, order_id: None, product_id: None, quantity: 5, amount: None, unit_price: None  row: 0x109a4d3d0  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,165 - logic_logger - INF
..Item[None] {copy_rules for role: product - unit_price} id: None, order_id: None, product_id: None, quantity: 5, amount: None, unit_price: 90.0000000000  row: 0x109a4d3d0  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,165 - logic_logger - INF
..Item[None] {Formula amount} id: None, order_id: None, product_id: None, quantity: 5, amount: 450.0000000000, unit_price: 90.0000000000  row: 0x109a4d3d0  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,165 - logic_logger - INF
....Order[None] {server aggregate_defaults: amount_total } id: None, notes: Test order 1761523857162, customer_id: 50, CreatedOn: None, date_shipped: None, amount_total:  [None-->] 0  row: 0x109a33f50  session: 0x109863f00  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,165 - logic_logger - INF
..Item[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)} id: None, order_id: None, product_id: None, quantity: 5, amount: 450.0000000000, unit_price: 90.0000000000  row: 0x109a4d3d0  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,165 - logic_logger - INF
....Order[None] {Adjustment logic chaining deferred for this parent parent do_defer_adjustment: True, is_parent_submitted: True, is_parent_row_processed: False, order} id: None, notes: Test order 1761523857162, customer_id: 50, CreatedOn: None, date_shipped: None, amount_total:  [None-->] 450.0000000000  row: 0x109a33f50  session: 0x109863f00  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,165 - logic_logger - INF
..Order[None] {Insert - client} id: None, notes: Test order 1761523857162, customer_id: 50, CreatedOn: None, date_shipped: None, amount_total: 450.0000000000  row: 0x109a33f50  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,165 - logic_logger - INF
..Order[None] {early_row_event_all_classes - handle_all did stamping} id: None, notes: Test order 1761523857162, customer_id: 50, CreatedOn: 2025-10-26 17:10:57.165840, date_shipped: None, amount_total: 450.0000000000  row: 0x109a33f50  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,165 - logic_logger - INF
..Order[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)} id: None, notes: Test order 1761523857162, customer_id: 50, CreatedOn: 2025-10-26 17:10:57.165840, date_shipped: None, amount_total: 450.0000000000  row: 0x109a33f50  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,166 - logic_logger - INF
....Customer[50] {Update - Adjusting customer: balance} id: 50, name: Alice 1761523857156, balance:  [0E-10-->] 450.0000000000, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x109a4db50  session: 0x109863f00  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,166 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109863f00)   										 - 2025-10-26 17:10:57,166 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109863f00)   										 - 2025-10-26 17:10:57,167 - logic_logger - INF
..Order[47] {AfterFlush Event} id: 47, notes: Test order 1761523857162, customer_id: 50, CreatedOn: 2025-10-26 17:10:57.165840, date_shipped: None, amount_total: 450.0000000000  row: 0x109a33f50  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,167 - logic_logger - INF
..Order[47] {Sending Order to Shipping [Note: **Kafka not enabled** ]} id: 47, notes: Test order 1761523857162, customer_id: 50, CreatedOn: 2025-10-26 17:10:57.165840, date_shipped: None, amount_total: 450.0000000000  row: 0x109a33f50  session: 0x109863f00  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,167 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Carbon Neutral Discount Applied
&emsp;  Scenario: Carbon Neutral Discount Applied  
&emsp;&emsp;    Given Customer "Bob" with balance 0 and credit limit 2000  
&emsp;&emsp;    When B2B order placed for "Bob" with 10 carbon neutral Gadget  
&emsp;&emsp;    Then Customer balance should be 900  
    And Item amount reflects 10% discount  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Carbon Neutral Discount Applied
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Item  
    2. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
    3. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Carbon Neutral Discount Applied
```
Logic Phase:		ROW LOGIC		(session=0x109863570) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,186 - logic_logger - INF
..Product[1] {Update - client} id: 1, name: Gadget, unit_price: 100.0000000000, carbon_neutral: True  row: 0x1099600c0  session: 0x109863570  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,186 - logic_logger - INF
..Item[None] {Insert - client} id: None, order_id: None, product_id: None, quantity: 10, amount: None, unit_price: None  row: 0x10991f3d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,186 - logic_logger - INF
..Item[None] {copy_rules for role: product - unit_price} id: None, order_id: None, product_id: None, quantity: 10, amount: None, unit_price: 100.0000000000  row: 0x10991f3d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,187 - logic_logger - INF
..Item[None] {Formula amount} id: None, order_id: None, product_id: None, quantity: 10, amount: 900.0000000000000222044604925, unit_price: 100.0000000000  row: 0x10991f3d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,187 - logic_logger - INF
....Order[None] {server aggregate_defaults: amount_total } id: None, notes: Carbon neutral test 1761523857184, customer_id: 51, CreatedOn: None, date_shipped: None, amount_total:  [None-->] 0  row: 0x10984f9d0  session: 0x109863570  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,187 - logic_logger - INF
..Item[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)} id: None, order_id: None, product_id: None, quantity: 10, amount: 900.0000000000000222044604925, unit_price: 100.0000000000  row: 0x10991f3d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,187 - logic_logger - INF
....Order[None] {Adjustment logic chaining deferred for this parent parent do_defer_adjustment: True, is_parent_submitted: True, is_parent_row_processed: False, order} id: None, notes: Carbon neutral test 1761523857184, customer_id: 51, CreatedOn: None, date_shipped: None, amount_total:  [None-->] 900.0000000000000222044604925  row: 0x10984f9d0  session: 0x109863570  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,187 - logic_logger - INF
..Order[None] {Insert - client} id: None, notes: Carbon neutral test 1761523857184, customer_id: 51, CreatedOn: None, date_shipped: None, amount_total: 900.0000000000000222044604925  row: 0x10984f9d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,187 - logic_logger - INF
..Order[None] {early_row_event_all_classes - handle_all did stamping} id: None, notes: Carbon neutral test 1761523857184, customer_id: 51, CreatedOn: 2025-10-26 17:10:57.187415, date_shipped: None, amount_total: 900.0000000000000222044604925  row: 0x10984f9d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,187 - logic_logger - INF
..Order[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)} id: None, notes: Carbon neutral test 1761523857184, customer_id: 51, CreatedOn: 2025-10-26 17:10:57.187415, date_shipped: None, amount_total: 900.0000000000000222044604925  row: 0x10984f9d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,187 - logic_logger - INF
....Customer[51] {Update - Adjusting customer: balance} id: 51, name: Bob 1761523857179, balance:  [0E-10-->] 900.0000000000000222044604925, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10991eed0  session: 0x109863570  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,187 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109863570)   										 - 2025-10-26 17:10:57,187 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109863570)   										 - 2025-10-26 17:10:57,188 - logic_logger - INF
..Order[48] {AfterFlush Event} id: 48, notes: Carbon neutral test 1761523857184, customer_id: 51, CreatedOn: 2025-10-26 17:10:57.187415, date_shipped: None, amount_total: 900.0000000000000222044604925  row: 0x10984f9d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,188 - logic_logger - INF
..Order[48] {Sending Order to Shipping [Note: **Kafka not enabled** ]} id: 48, notes: Carbon neutral test 1761523857184, customer_id: 51, CreatedOn: 2025-10-26 17:10:57.187415, date_shipped: None, amount_total: 900.0000000000000222044604925  row: 0x10984f9d0  session: 0x109863570  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,188 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Multi-Item Order Totals Correctly
&emsp;  Scenario: Multi-Item Order Totals Correctly  
&emsp;&emsp;    Given Customer "Diana" with balance 0 and credit limit 3000  
&emsp;&emsp;    When B2B order placed for "Diana" with 3 Widget and 2 Gadget  
&emsp;&emsp;    Then Customer balance should be 470  
    And Order contains 2 items  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Multi-Item Order Totals Correctly
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Item  
    2. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
    3. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Multi-Item Order Totals Correctly
```
Logic Phase:		ROW LOGIC		(session=0x109863bd0) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,204 - logic_logger - INF
..Product[1] {Update - client} id: 1, name: Gadget, unit_price: 100.0000000000, carbon_neutral: True  row: 0x1098b25f0  session: 0x109863bd0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,204 - logic_logger - INF
..Item[None] {Insert - client} id: None, order_id: None, product_id: 2, quantity: 3, amount: None, unit_price: None  row: 0x10991f650  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,204 - logic_logger - INF
..Item[None] {copy_rules for role: product - unit_price} id: None, order_id: None, product_id: 2, quantity: 3, amount: None, unit_price: 90.0000000000  row: 0x10991f650  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,204 - logic_logger - INF
..Item[None] {Formula amount} id: None, order_id: None, product_id: 2, quantity: 3, amount: 270.0000000000, unit_price: 90.0000000000  row: 0x10991f650  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,204 - logic_logger - INF
....Order[None] {server aggregate_defaults: amount_total } id: None, notes: Multi-item test 1761523857201, customer_id: 52, CreatedOn: None, date_shipped: None, amount_total:  [None-->] 0  row: 0x1098b69d0  session: 0x109863bd0  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,204 - logic_logger - INF
..Item[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)} id: None, order_id: None, product_id: 2, quantity: 3, amount: 270.0000000000, unit_price: 90.0000000000  row: 0x10991f650  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,204 - logic_logger - INF
....Order[None] {Adjustment logic chaining deferred for this parent parent do_defer_adjustment: True, is_parent_submitted: True, is_parent_row_processed: False, order} id: None, notes: Multi-item test 1761523857201, customer_id: 52, CreatedOn: None, date_shipped: None, amount_total:  [None-->] 270.0000000000  row: 0x1098b69d0  session: 0x109863bd0  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,204 - logic_logger - INF
..Item[None] {Insert - client} id: None, order_id: None, product_id: None, quantity: 2, amount: None, unit_price: None  row: 0x10991fe50  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,204 - logic_logger - INF
..Item[None] {copy_rules for role: product - unit_price} id: None, order_id: None, product_id: None, quantity: 2, amount: None, unit_price: 100.0000000000  row: 0x10991fe50  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,205 - logic_logger - INF
..Item[None] {Formula amount} id: None, order_id: None, product_id: None, quantity: 2, amount: 200.0000000000, unit_price: 100.0000000000  row: 0x10991fe50  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,205 - logic_logger - INF
..Item[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)} id: None, order_id: None, product_id: None, quantity: 2, amount: 200.0000000000, unit_price: 100.0000000000  row: 0x10991fe50  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,205 - logic_logger - INF
....Order[None] {Adjustment logic chaining deferred for this parent parent do_defer_adjustment: True, is_parent_submitted: True, is_parent_row_processed: False, order} id: None, notes: Multi-item test 1761523857201, customer_id: 52, CreatedOn: None, date_shipped: None, amount_total:  [270.0000000000-->] 470.0000000000  row: 0x1098b69d0  session: 0x109863bd0  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,205 - logic_logger - INF
..Order[None] {Insert - client} id: None, notes: Multi-item test 1761523857201, customer_id: 52, CreatedOn: None, date_shipped: None, amount_total: 470.0000000000  row: 0x1098b69d0  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,205 - logic_logger - INF
..Order[None] {early_row_event_all_classes - handle_all did stamping} id: None, notes: Multi-item test 1761523857201, customer_id: 52, CreatedOn: 2025-10-26 17:10:57.205310, date_shipped: None, amount_total: 470.0000000000  row: 0x1098b69d0  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,205 - logic_logger - INF
..Order[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)} id: None, notes: Multi-item test 1761523857201, customer_id: 52, CreatedOn: 2025-10-26 17:10:57.205310, date_shipped: None, amount_total: 470.0000000000  row: 0x1098b69d0  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,205 - logic_logger - INF
....Customer[52] {Update - Adjusting customer: balance} id: 52, name: Diana 1761523857196, balance:  [0E-10-->] 470.0000000000, credit_limit: 3000.0000000000, email: None, email_opt_out: None  row: 0x10991e3d0  session: 0x109863bd0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,205 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109863bd0)   										 - 2025-10-26 17:10:57,205 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109863bd0)   										 - 2025-10-26 17:10:57,206 - logic_logger - INF
..Order[49] {AfterFlush Event} id: 49, notes: Multi-item test 1761523857201, customer_id: 52, CreatedOn: 2025-10-26 17:10:57.205310, date_shipped: None, amount_total: 470.0000000000  row: 0x1098b69d0  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,206 - logic_logger - INF
..Order[49] {Sending Order to Shipping [Note: **Kafka not enabled** ]} id: 49, notes: Multi-item test 1761523857201, customer_id: 52, CreatedOn: 2025-10-26 17:10:57.205310, date_shipped: None, amount_total: 470.0000000000  row: 0x1098b69d0  session: 0x109863bd0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,206 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Item Quantity Change Updates Totals
&emsp;  Scenario: Item Quantity Change Updates Totals  
&emsp;&emsp;    Given Customer "Alice" with balance 0 and credit limit 1000  
    And Order is created for "Alice" with 5 Widget  
&emsp;&emsp;    When Item quantity changed to 10  
&emsp;&emsp;    Then Item amount should be 900  
    And Order amount_total should be 900  
    And Customer balance should be 900  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Item Quantity Change Updates Totals
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
  Order  
    3. RowEvent Order.send_order_to_shipping()   
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
```
**Logic Log** in Scenario: Item Quantity Change Updates Totals
```
Logic Phase:		ROW LOGIC		(session=0x109861e10) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,246 - logic_logger - INF
..Item[60] {Update - client} id: 60, order_id: 50, product_id: 2, quantity:  [5-->] 10, amount: 450.0000000000, unit_price: 90.0000000000  row: 0x10991cad0  session: 0x109861e10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,246 - logic_logger - INF
..Item[60] {Formula amount} id: 60, order_id: 50, product_id: 2, quantity:  [5-->] 10, amount:  [450.0000000000-->] 900.0000000000, unit_price: 90.0000000000  row: 0x10991cad0  session: 0x109861e10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,246 - logic_logger - INF
....Order[50] {Update - Adjusting order: amount_total} id: 50, notes: Test order 1761523857230, customer_id: 53, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [450.0000000000-->] 900.0000000000  row: 0x10991f7d0  session: 0x109861e10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,247 - logic_logger - INF
......Customer[53] {Update - Adjusting customer: balance} id: 53, name: Alice 1761523857220, balance:  [450.0000000000-->] 900.0000000000, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x109a4c150  session: 0x109861e10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,247 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109861e10)   										 - 2025-10-26 17:10:57,247 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109861e10)   										 - 2025-10-26 17:10:57,248 - logic_logger - INF
....Order[50] {AfterFlush Event} id: 50, notes: Test order 1761523857230, customer_id: 53, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [450.0000000000-->] 900.0000000000  row: 0x10991f7d0  session: 0x109861e10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,248 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Changing Customer Adjusts Both Balances
&emsp;  Scenario: Changing Customer Adjusts Both Balances  
&emsp;&emsp;    Given Customer "Alice" with balance 0 and credit limit 1000  
    And Customer "Bob" with balance 0 and credit limit 2000  
    And Order is created for "Alice" with 3 Widget  
&emsp;&emsp;    When Order customer changed to "Bob"  
&emsp;&emsp;    Then Customer "Alice" balance should be 0  
    And Customer "Bob" balance should be 270  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Changing Customer Adjusts Both Balances
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Changing Customer Adjusts Both Balances
```
Logic Phase:		ROW LOGIC		(session=0x109862f10) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,278 - logic_logger - INF
..Order[51] {Update - client} id: 51, notes: Test order 1761523857266, customer_id:  [54-->] 55, CreatedOn: 2025-10-26, date_shipped: None, amount_total: 270.0000000000  row: 0x109a4c3d0  session: 0x109862f10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,278 - logic_logger - INF
....Customer[55] {Update - Adjusting customer: balance, balance} id: 55, name: Bob 1761523857259, balance:  [0E-10-->] 270.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x109a4c9d0  session: 0x109862f10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,279 - logic_logger - INF
....Customer[54] {Update - Adjusting Old customer} id: 54, name: Alice 1761523857255, balance:  [270.0000000000-->] 0E-10, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x109a4cad0  session: 0x109862f10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,279 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109862f10)   										 - 2025-10-26 17:10:57,279 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109862f10)   										 - 2025-10-26 17:10:57,280 - logic_logger - INF
..Order[51] {AfterFlush Event} id: 51, notes: Test order 1761523857266, customer_id:  [54-->] 55, CreatedOn: 2025-10-26, date_shipped: None, amount_total: 270.0000000000  row: 0x109a4c3d0  session: 0x109862f10  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,280 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Delete Item Reduces Order Total
&emsp;  Scenario: Delete Item Reduces Order Total  
&emsp;&emsp;    Given Customer "Charlie" with balance 0 and credit limit 2000  
    And Order is created for "Charlie" with 2 Widget and 3 Gadget  
&emsp;&emsp;    When First item is deleted  
&emsp;&emsp;    Then Order amount_total should be 300  
    And Customer balance should be 300  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Delete Item Reduces Order Total
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
    3. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
```
**Logic Log** in Scenario: Delete Item Reduces Order Total
```
Logic Phase:		ROW LOGIC		(session=0x109863570) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,310 - logic_logger - INF
..Item[62] {Delete - client} id: 62, order_id: 52, product_id: 2, quantity: 2, amount: 180.0000000000, unit_price: 90.0000000000  row: 0x10991fe50  session: 0x109863570  ins_upd_dlt: dlt, initial: dlt - 2025-10-26 17:10:57,310 - logic_logger - INF
....Order[52] {Update - Adjusting order: amount_total} id: 52, notes: Test order 1761523857290, customer_id: 56, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [480.0000000000-->] 300.0000000000  row: 0x10991f6d0  session: 0x109863570  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,310 - logic_logger - INF
......Customer[56] {Update - Adjusting customer: balance} id: 56, name: Charlie 1761523857285, balance:  [480.0000000000-->] 300.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x109a4cb50  session: 0x109863570  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,311 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109863570)   										 - 2025-10-26 17:10:57,311 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109863570)   										 - 2025-10-26 17:10:57,311 - logic_logger - INF
....Order[52] {AfterFlush Event} id: 52, notes: Test order 1761523857290, customer_id: 56, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [480.0000000000-->] 300.0000000000  row: 0x10991f6d0  session: 0x109863570  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,311 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Ship Order Excludes from Balance
&emsp;  Scenario: Ship Order Excludes from Balance  
&emsp;&emsp;    Given Customer "Diana" with balance 0 and credit limit 2000  
    And Order is created for "Diana" with 2 Widget  
&emsp;&emsp;    When Order is shipped  
&emsp;&emsp;    Then Customer balance should be 0  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Ship Order Excludes from Balance
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Ship Order Excludes from Balance
```
Logic Phase:		ROW LOGIC		(session=0x109863ce0) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,333 - logic_logger - INF
..Order[53] {Update - client} id: 53, notes: Test order 1761523857322, customer_id: 57, CreatedOn: 2025-10-26, date_shipped:  [None-->] 2025-10-26 00:00:00, amount_total: 180.0000000000  row: 0x109a4d250  session: 0x109863ce0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,333 - logic_logger - INF
....Customer[57] {Update - Adjusting customer: balance} id: 57, name: Diana 1761523857316, balance:  [180.0000000000-->] 0E-10, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x109a4e150  session: 0x109863ce0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,334 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109863ce0)   										 - 2025-10-26 17:10:57,334 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109863ce0)   										 - 2025-10-26 17:10:57,334 - logic_logger - INF
..Order[53] {AfterFlush Event} id: 53, notes: Test order 1761523857322, customer_id: 57, CreatedOn: 2025-10-26, date_shipped:  [None-->] 2025-10-26 00:00:00, amount_total: 180.0000000000  row: 0x109a4d250  session: 0x109863ce0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,334 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Unship Order Includes in Balance
&emsp;  Scenario: Unship Order Includes in Balance  
&emsp;&emsp;    Given Customer "Alice" with balance 0 and credit limit 2000  
    And Shipped order is created for "Alice" with 4 Widget  
&emsp;&emsp;    When Order is unshipped  
&emsp;&emsp;    Then Customer balance should be 360  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Unship Order Includes in Balance
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Unship Order Includes in Balance
```
Logic Phase:		ROW LOGIC		(session=0x109a648d0) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,355 - logic_logger - INF
..Order[54] {Update - client} id: 54, notes: Shipped order 1761523857344, customer_id: 58, CreatedOn: 2025-10-26, date_shipped:  [2025-10-26-->] None, amount_total: 360.0000000000  row: 0x109a4d5d0  session: 0x109a648d0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,355 - logic_logger - INF
....Customer[58] {Update - Adjusting customer: balance} id: 58, name: Alice 1761523857337, balance:  [0E-10-->] 360.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x109a4ead0  session: 0x109a648d0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,355 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109a648d0)   										 - 2025-10-26 17:10:57,355 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109a648d0)   										 - 2025-10-26 17:10:57,356 - logic_logger - INF
..Order[54] {AfterFlush Event} id: 54, notes: Shipped order 1761523857344, customer_id: 58, CreatedOn: 2025-10-26, date_shipped:  [2025-10-26-->] None, amount_total: 360.0000000000  row: 0x109a4d5d0  session: 0x109a648d0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,356 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Exceed Credit Limit Rejected
&emsp;  Scenario: Exceed Credit Limit Rejected  
&emsp;&emsp;    Given Customer "Bob" with balance 0 and credit limit 500  
&emsp;&emsp;    When B2B order placed for "Bob" with 10 Widget  
&emsp;&emsp;    Then Order creation should fail  
    And Error message mentions credit limit  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Exceed Credit Limit Rejected
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
    2. Constraint Function: None   
  Item  
    3. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
    4. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
  Order  
    5. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
Logic Phase:		ROW LOGIC		(session=0x1098638a0) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,369 - logic_logger - INFO  
..Customer[None] {Insert - client} id: None, name: Alice 1761523857368, balance: 0, credit_limit: 2000, email: None, email_opt_out: None  row: 0x10991f850  session: 0x1098638a0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,369 - logic_logger - INFO  
..Customer[None] {server aggregate_defaults: balance } id: None, name: Alice 1761523857368, balance: 0, credit_limit: 2000, email: None, email_opt_out: None  row: 0x10991f850  session: 0x1098638a0  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,370 - logic_logger - INFO  
Logic Phase:		COMMIT LOGIC		(session=0x1098638a0)   										 - 2025-10-26 17:10:57,370 - logic_logger - INFO  
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x1098638a0)   										 - 2025-10-26 17:10:57,370 - logic_logger - INFO  
These Rules Fired (see Logic Phases, above, for actual order):  
```
**Logic Log** in Scenario: Exceed Credit Limit Rejected
```
Logic Phase:		ROW LOGIC		(session=0x109a64160) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,365 - logic_logger - INF
..Product[2] {Update - client} id: 2, name: Widget, unit_price: 90.0000000000, carbon_neutral: None  row: 0x109a523c0  session: 0x109a64160  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,365 - logic_logger - INF
..Item[None] {Insert - client} id: None, order_id: None, product_id: None, quantity: 10, amount: None, unit_price: None  row: 0x109a4ddd0  session: 0x109a64160  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,365 - logic_logger - INF
..Item[None] {copy_rules for role: product - unit_price} id: None, order_id: None, product_id: None, quantity: 10, amount: None, unit_price: 90.0000000000  row: 0x109a4ddd0  session: 0x109a64160  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,365 - logic_logger - INF
..Item[None] {Formula amount} id: None, order_id: None, product_id: None, quantity: 10, amount: 900.0000000000, unit_price: 90.0000000000  row: 0x109a4ddd0  session: 0x109a64160  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,365 - logic_logger - INF
....Order[None] {server aggregate_defaults: amount_total } id: None, notes: Test order 1761523857363, customer_id: 59, CreatedOn: None, date_shipped: None, amount_total:  [None-->] 0  row: 0x109a33ed0  session: 0x109a64160  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,366 - logic_logger - INF
..Item[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)} id: None, order_id: None, product_id: None, quantity: 10, amount: 900.0000000000, unit_price: 90.0000000000  row: 0x109a4ddd0  session: 0x109a64160  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,366 - logic_logger - INF
....Order[None] {Adjustment logic chaining deferred for this parent parent do_defer_adjustment: True, is_parent_submitted: True, is_parent_row_processed: False, order} id: None, notes: Test order 1761523857363, customer_id: 59, CreatedOn: None, date_shipped: None, amount_total:  [None-->] 900.0000000000  row: 0x109a33ed0  session: 0x109a64160  ins_upd_dlt: *, initial: * - 2025-10-26 17:10:57,366 - logic_logger - INF
..Order[None] {Insert - client} id: None, notes: Test order 1761523857363, customer_id: 59, CreatedOn: None, date_shipped: None, amount_total: 900.0000000000  row: 0x109a33ed0  session: 0x109a64160  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,366 - logic_logger - INF
..Order[None] {early_row_event_all_classes - handle_all did stamping} id: None, notes: Test order 1761523857363, customer_id: 59, CreatedOn: 2025-10-26 17:10:57.366212, date_shipped: None, amount_total: 900.0000000000  row: 0x109a33ed0  session: 0x109a64160  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,366 - logic_logger - INF
..Order[None] {TODO DB adjust_from_inserted/adopted_child adjusts Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)} id: None, notes: Test order 1761523857363, customer_id: 59, CreatedOn: 2025-10-26 17:10:57.366212, date_shipped: None, amount_total: 900.0000000000  row: 0x109a33ed0  session: 0x109a64160  ins_upd_dlt: ins, initial: ins - 2025-10-26 17:10:57,366 - logic_logger - INF
....Customer[59] {Update - Adjusting customer: balance} id: 59, name: Bob 1761523857359, balance:  [0E-10-->] 900.0000000000, credit_limit: 500.0000000000, email: None, email_opt_out: None  row: 0x109a4e950  session: 0x109a64160  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,366 - logic_logger - INF
....Customer[59] {Constraint Failure: Customer balance (900.0000000000) exceeds credit limit (500.0000000000)} id: 59, name: Bob 1761523857359, balance:  [0E-10-->] 900.0000000000, credit_limit: 500.0000000000, email: None, email_opt_out: None  row: 0x109a4e950  session: 0x109a64160  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,366 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Change Product Updates Unit Price
&emsp;  Scenario: Change Product Updates Unit Price  
&emsp;&emsp;    Given Customer "Alice" with balance 0 and credit limit 2000  
    And Order is created for "Alice" with 5 Widget  
&emsp;&emsp;    When Item product changed to "Gadget"  
&emsp;&emsp;    Then Item unit_price should be 100  
    And Item amount should be 500  
    And Customer balance should be 500  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Change Product Updates Unit Price
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10883d260>)  
  Item  
    2. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
    3. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Change Product Updates Unit Price
```
Logic Phase:		ROW LOGIC		(session=0x109862cf0) (sqlalchemy before_flush)			 - 2025-10-26 17:10:57,389 - logic_logger - INF
..Item[66] {Update - client} id: 66, order_id: 55, product_id:  [2-->] 1, quantity: 5, amount: 450.0000000000, unit_price: 90.0000000000  row: 0x109a4e050  session: 0x109862cf0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,389 - logic_logger - INF
..Item[66] {copy_rules for role: product - unit_price} id: 66, order_id: 55, product_id:  [2-->] 1, quantity: 5, amount: 450.0000000000, unit_price:  [90.0000000000-->] 100.0000000000  row: 0x109a4e050  session: 0x109862cf0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,389 - logic_logger - INF
..Item[66] {Formula amount} id: 66, order_id: 55, product_id:  [2-->] 1, quantity: 5, amount:  [450.0000000000-->] 500.0000000000, unit_price:  [90.0000000000-->] 100.0000000000  row: 0x109a4e050  session: 0x109862cf0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,389 - logic_logger - INF
....Order[55] {Update - Adjusting order: amount_total} id: 55, notes: Test order 1761523857375, customer_id: 60, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [450.0000000000-->] 500.0000000000  row: 0x109a4ced0  session: 0x109862cf0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,390 - logic_logger - INF
......Customer[60] {Update - Adjusting customer: balance} id: 60, name: Alice 1761523857368, balance:  [450.0000000000-->] 500.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x109a4d0d0  session: 0x109862cf0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,390 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x109862cf0)   										 - 2025-10-26 17:10:57,390 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x109862cf0)   										 - 2025-10-26 17:10:57,391 - logic_logger - INF
....Order[55] {AfterFlush Event} id: 55, notes: Test order 1761523857375, customer_id: 60, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [450.0000000000-->] 500.0000000000  row: 0x109a4ced0  session: 0x109862cf0  ins_upd_dlt: upd, initial: upd - 2025-10-26 17:10:57,391 - logic_logger - INF

```
</details>
  
&nbsp;&nbsp;  
/Users/val/dev/ApiLogicServer/ApiLogicServer-dev/build_and_test/ApiLogicServer/basic_demo/test/api_logic_server_behave/behave_run.py completed at October 26, 2025 17:10:5  