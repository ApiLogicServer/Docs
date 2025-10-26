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

The following rules have been activate
 - 2025-10-26 15:17:37,243 - logic_logger - DEBU
Rule Bank[0x10b14acf0] (loaded 2025-10-26 14:34:55.567888
Mapped Class[Customer] rules
  Constraint Function: None
  Constraint Function: None
  Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>
Mapped Class[SysEmail] rules
  RowEvent SysEmail.send_mail()
Mapped Class[Order] rules
  Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None
  RowEvent Order.send_order_to_shipping()
Mapped Class[Item] rules
  Derive <class 'database.models.Item'>.amount as Formula (1): <function
  Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price
Logic Bank - 13 rules loaded - 2025-10-26 15:17:37,243 - logic_logger - INF
Logic Bank - 13 rules loaded - 2025-10-26 15:17:37,243 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c12b150) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,245 - logic_logger - INF
..Customer[None] {Insert - client} id: None, name: Alice 1761517057244, balance: 0, credit_limit: 1000, email: None, email_opt_out: None  row: 0x10c2aae50  session: 0x10c12b150  ins_upd_dlt: ins, initial: ins - 2025-10-26 15:17:37,245 - logic_logger - INF
..Customer[None] {server aggregate_defaults: balance } id: None, name: Alice 1761517057244, balance: 0, credit_limit: 1000, email: None, email_opt_out: None  row: 0x10c2aae50  session: 0x10c12b150  ins_upd_dlt: ins, initial: ins - 2025-10-26 15:17:37,246 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c12b150)   										 - 2025-10-26 15:17:37,246 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c12b150)   										 - 2025-10-26 15:17:37,246 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    3. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Good Order Created via B2B API
```

Good Order Created via B2B API - Single-item B2B orde
 - 2025-10-26 15:17:37,250 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c288950) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,252 - logic_logger - INF
..Customer[28] {Update - client} id: 28, name: Alice 1761517057244, balance: 0E-10, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x10c3672d0  session: 0x10c288950  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,252 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c288950)   										 - 2025-10-26 15:17:37,252 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c288950)   										 - 2025-10-26 15:17:37,252 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    3. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Carbon Neutral Discount Applied
```

Carbon Neutral Discount Applied - Carbon neutral orde
 - 2025-10-26 15:17:37,271 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c28a850) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,272 - logic_logger - INF
..Customer[29] {Update - client} id: 29, name: Bob 1761517057266, balance: 0E-10, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c3c4d50  session: 0x10c28a850  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,272 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c28a850)   										 - 2025-10-26 15:17:37,273 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c28a850)   										 - 2025-10-26 15:17:37,273 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    3. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Multi-Item Order Totals Correctly
```

Multi-Item Order Totals Correctly - Multi-item B2B orde
 - 2025-10-26 15:17:37,287 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c28aa50) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,289 - logic_logger - INF
..Customer[30] {Update - client} id: 30, name: Diana 1761517057283, balance: 0E-10, credit_limit: 3000.0000000000, email: None, email_opt_out: None  row: 0x10c4747d0  session: 0x10c28aa50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,289 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c28aa50)   										 - 2025-10-26 15:17:37,289 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c28aa50)   										 - 2025-10-26 15:17:37,289 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
  Order  
    3. RowEvent Order.send_order_to_shipping()   
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
```
**Logic Log** in Scenario: Item Quantity Change Updates Totals
```

Item Quantity Change Updates Totals - Changing quantit
 - 2025-10-26 15:17:37,318 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c28af50) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,319 - logic_logger - INF
..Item[38] {Update - client} id: 38, order_id: 32, product_id: 2, quantity:  [5-->] 10, amount: 450.0000000000, unit_price: 90.0000000000  row: 0x10c3676d0  session: 0x10c28af50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,319 - logic_logger - INF
..Item[38] {Formula amount} id: 38, order_id: 32, product_id: 2, quantity:  [5-->] 10, amount:  [450.0000000000-->] 900.0000000000, unit_price: 90.0000000000  row: 0x10c3676d0  session: 0x10c28af50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,319 - logic_logger - INF
....Order[32] {Update - Adjusting order: amount_total} id: 32, notes: Test order 1761517057308, customer_id: 31, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [450.0000000000-->] 900.0000000000  row: 0x10c365ed0  session: 0x10c28af50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,320 - logic_logger - INF
......Customer[31] {Update - Adjusting customer: balance} id: 31, name: Alice 1761517057301, balance:  [450.0000000000-->] 900.0000000000, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x10c475bd0  session: 0x10c28af50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,320 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c28af50)   										 - 2025-10-26 15:17:37,320 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c28af50)   										 - 2025-10-26 15:17:37,321 - logic_logger - INF
....Order[32] {AfterFlush Event} id: 32, notes: Test order 1761517057308, customer_id: 31, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [450.0000000000-->] 900.0000000000  row: 0x10c365ed0  session: 0x10c28af50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,321 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Changing Customer Adjusts Both Balances
```

Changing Customer Adjusts Both Balances - Changing custome
 - 2025-10-26 15:17:37,350 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c288850) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,352 - logic_logger - INF
..Order[33] {Update - client} id: 33, notes: Test order 1761517057338, customer_id:  [32-->] 33, CreatedOn: 2025-10-26, date_shipped: None, amount_total: 270.0000000000  row: 0x10c476ad0  session: 0x10c288850  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,352 - logic_logger - INF
....Customer[33] {Update - Adjusting customer: balance, balance} id: 33, name: Bob 1761517057330, balance:  [0E-10-->] 270.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c475e50  session: 0x10c288850  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,353 - logic_logger - INF
....Customer[32] {Update - Adjusting Old customer} id: 32, name: Alice 1761517057327, balance:  [270.0000000000-->] 0E-10, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x10c475d50  session: 0x10c288850  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,353 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c288850)   										 - 2025-10-26 15:17:37,353 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c288850)   										 - 2025-10-26 15:17:37,353 - logic_logger - INF
..Order[33] {AfterFlush Event} id: 33, notes: Test order 1761517057338, customer_id:  [32-->] 33, CreatedOn: 2025-10-26, date_shipped: None, amount_total: 270.0000000000  row: 0x10c476ad0  session: 0x10c288850  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,353 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
    3. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
```
**Logic Log** in Scenario: Delete Item Reduces Order Total
```

Delete Item Reduces Order Total - Deleting ite
 - 2025-10-26 15:17:37,381 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c289550) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,383 - logic_logger - INF
..Item[40] {Delete - client} id: 40, order_id: 34, product_id: 2, quantity: 2, amount: 180.0000000000, unit_price: 90.0000000000  row: 0x10c3c55d0  session: 0x10c289550  ins_upd_dlt: dlt, initial: dlt - 2025-10-26 15:17:37,383 - logic_logger - INF
....Order[34] {Update - Adjusting order: amount_total} id: 34, notes: Test order 1761517057363, customer_id: 34, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [480.0000000000-->] 300.0000000000  row: 0x10c2c38d0  session: 0x10c289550  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,383 - logic_logger - INF
......Customer[34] {Update - Adjusting customer: balance} id: 34, name: Charlie 1761517057359, balance:  [480.0000000000-->] 300.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c4751d0  session: 0x10c289550  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,383 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c289550)   										 - 2025-10-26 15:17:37,383 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c289550)   										 - 2025-10-26 15:17:37,384 - logic_logger - INF
....Order[34] {AfterFlush Event} id: 34, notes: Test order 1761517057363, customer_id: 34, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [480.0000000000-->] 300.0000000000  row: 0x10c2c38d0  session: 0x10c289550  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,384 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Ship Order Excludes from Balance
```

Ship Order Excludes from Balance - Shipping orde
 - 2025-10-26 15:17:37,404 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c288850) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,405 - logic_logger - INF
..Order[35] {Update - client} id: 35, notes: Test order 1761517057394, customer_id: 35, CreatedOn: 2025-10-26, date_shipped:  [None-->] 2025-10-26 00:00:00, amount_total: 180.0000000000  row: 0x10c475550  session: 0x10c288850  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,405 - logic_logger - INF
....Customer[35] {Update - Adjusting customer: balance} id: 35, name: Diana 1761517057388, balance:  [180.0000000000-->] 0E-10, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c476450  session: 0x10c288850  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,406 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c288850)   										 - 2025-10-26 15:17:37,406 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c288850)   										 - 2025-10-26 15:17:37,406 - logic_logger - INF
..Order[35] {AfterFlush Event} id: 35, notes: Test order 1761517057394, customer_id: 35, CreatedOn: 2025-10-26, date_shipped:  [None-->] 2025-10-26 00:00:00, amount_total: 180.0000000000  row: 0x10c475550  session: 0x10c288850  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,406 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Unship Order Includes in Balance
```

Unship Order Includes in Balance - Unshipping orde
 - 2025-10-26 15:17:37,426 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c12aa50) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,428 - logic_logger - INF
..Order[36] {Update - client} id: 36, notes: Shipped order 1761517057416, customer_id: 36, CreatedOn: 2025-10-26, date_shipped:  [2025-10-26-->] None, amount_total: 360.0000000000  row: 0x10c3c43d0  session: 0x10c12aa50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,428 - logic_logger - INF
....Customer[36] {Update - Adjusting customer: balance} id: 36, name: Alice 1761517057409, balance:  [0E-10-->] 360.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c3668d0  session: 0x10c12aa50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,428 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c12aa50)   										 - 2025-10-26 15:17:37,428 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c12aa50)   										 - 2025-10-26 15:17:37,429 - logic_logger - INF
..Order[36] {AfterFlush Event} id: 36, notes: Shipped order 1761517057416, customer_id: 36, CreatedOn: 2025-10-26, date_shipped:  [2025-10-26-->] None, amount_total: 360.0000000000  row: 0x10c3c43d0  session: 0x10c12aa50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,429 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
    2. Constraint Function: None   
  Item  
    3. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    4. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    5. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
Logic Phase:		ROW LOGIC		(session=0x10c288850) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,443 - logic_logger - INFO  
..Customer[None] {Insert - client} id: None, name: Alice 1761517057441, balance: 0, credit_limit: 2000, email: None, email_opt_out: None  row: 0x10c476650  session: 0x10c288850  ins_upd_dlt: ins, initial: ins - 2025-10-26 15:17:37,443 - logic_logger - INFO  
..Customer[None] {server aggregate_defaults: balance } id: None, name: Alice 1761517057441, balance: 0, credit_limit: 2000, email: None, email_opt_out: None  row: 0x10c476650  session: 0x10c288850  ins_upd_dlt: ins, initial: ins - 2025-10-26 15:17:37,443 - logic_logger - INFO  
Logic Phase:		COMMIT LOGIC		(session=0x10c288850)   										 - 2025-10-26 15:17:37,443 - logic_logger - INFO  
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c288850)   										 - 2025-10-26 15:17:37,443 - logic_logger - INFO  
These Rules Fired (see Logic Phases, above, for actual order):  
```
**Logic Log** in Scenario: Exceed Credit Limit Rejected
```

Exceed Credit Limit Rejected - Single-item B2B orde
 - 2025-10-26 15:17:37,436 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c288950) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,438 - logic_logger - INF
..Customer[37] {Update - client} id: 37, name: Bob 1761517057432, balance: 0E-10, credit_limit: 500.0000000000, email: None, email_opt_out: None  row: 0x10c35b150  session: 0x10c288950  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,438 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c288950)   										 - 2025-10-26 15:17:37,438 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c288950)   										 - 2025-10-26 15:17:37,438 - logic_logger - INF

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
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b224cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    3. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Change Product Updates Unit Price
```

Change Product Updates Unit Price - Changing produc
 - 2025-10-26 15:17:37,457 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c288e50) (sqlalchemy before_flush)			 - 2025-10-26 15:17:37,460 - logic_logger - INF
..Item[44] {Update - client} id: 44, order_id: 37, product_id:  [2-->] 1, quantity: 5, amount: 450.0000000000, unit_price: 90.0000000000  row: 0x10c474dd0  session: 0x10c288e50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,460 - logic_logger - INF
..Item[44] {copy_rules for role: product - unit_price} id: 44, order_id: 37, product_id:  [2-->] 1, quantity: 5, amount: 450.0000000000, unit_price:  [90.0000000000-->] 100.0000000000  row: 0x10c474dd0  session: 0x10c288e50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,460 - logic_logger - INF
..Item[44] {Formula amount} id: 44, order_id: 37, product_id:  [2-->] 1, quantity: 5, amount:  [450.0000000000-->] 500.0000000000, unit_price:  [90.0000000000-->] 100.0000000000  row: 0x10c474dd0  session: 0x10c288e50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,460 - logic_logger - INF
....Order[37] {Update - Adjusting order: amount_total} id: 37, notes: Test order 1761517057448, customer_id: 38, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [450.0000000000-->] 500.0000000000  row: 0x10c476350  session: 0x10c288e50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,461 - logic_logger - INF
......Customer[38] {Update - Adjusting customer: balance} id: 38, name: Alice 1761517057441, balance:  [450.0000000000-->] 500.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c476e50  session: 0x10c288e50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,461 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c288e50)   										 - 2025-10-26 15:17:37,461 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c288e50)   										 - 2025-10-26 15:17:37,462 - logic_logger - INF
....Order[37] {AfterFlush Event} id: 37, notes: Test order 1761517057448, customer_id: 38, CreatedOn: 2025-10-26, date_shipped: None, amount_total:  [450.0000000000-->] 500.0000000000  row: 0x10c476350  session: 0x10c288e50  ins_upd_dlt: upd, initial: upd - 2025-10-26 15:17:37,462 - logic_logger - INF

```
</details>
  
&nbsp;&nbsp;  
/Users/val/dev/ApiLogicServer/ApiLogicServer-dev/build_and_test/ApiLogicServer/basic_demo/test/api_logic_server_behave/behave_run.py completed at October 26, 2025 15:17:3  