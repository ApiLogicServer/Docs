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
 - 2025-10-22 17:44:37,422 - logic_logger - DEBU
Rule Bank[0x10b326cf0] (loaded 2025-10-22 17:40:11.529970
Mapped Class[Customer] rules
  Constraint Function: None
  Constraint Function: None
  Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>
Mapped Class[SysEmail] rules
  RowEvent SysEmail.send_mail()
Mapped Class[Order] rules
  Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None
  RowEvent Order.send_order_to_shipping()
Mapped Class[Item] rules
  Derive <class 'database.models.Item'>.amount as Formula (1): <function
  Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price
Logic Bank - 13 rules loaded - 2025-10-22 17:44:37,423 - logic_logger - INF
Logic Bank - 13 rules loaded - 2025-10-22 17:44:37,423 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4365d0) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,428 - logic_logger - INF
..Customer[None] {Insert - client} id: None, name: Alice 1761180277424, balance: 0, credit_limit: 1000, email: None, email_opt_out: None  row: 0x10c4cdfd0  session: 0x10c4365d0  ins_upd_dlt: ins, initial: ins - 2025-10-22 17:44:37,429 - logic_logger - INF
..Customer[None] {server aggregate_defaults: balance } id: None, name: Alice 1761180277424, balance: 0, credit_limit: 1000, email: None, email_opt_out: None  row: 0x10c4cdfd0  session: 0x10c4365d0  ins_upd_dlt: ins, initial: ins - 2025-10-22 17:44:37,429 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4365d0)   										 - 2025-10-22 17:44:37,429 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4365d0)   										 - 2025-10-22 17:44:37,432 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
## Feature: Order Processing Business Rules  
  
&nbsp;
&nbsp;
### Scenario: Good Order - Creates order successfully
&emsp;  Scenario: Good Order - Creates order successfully  
&emsp;&emsp;    Given Customer "Alice" with balance 0 and credit limit 1000  
&emsp;&emsp;    When B2B order placed for "Alice" with 5 Widget  
&emsp;&emsp;    Then Customer balance should be 450  
    And Order created successfully  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Good Order - Creates order successfully
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    3. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Good Order - Creates order successfully
```

Good Order - Creates order successfull
 - 2025-10-22 17:44:37,439 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4351d0) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,442 - logic_logger - INF
..Customer[6] {Update - client} id: 6, name: Alice 1761180277424, balance: 0E-10, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x10c4cfd50  session: 0x10c4351d0  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,443 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4351d0)   										 - 2025-10-22 17:44:37,443 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4351d0)   										 - 2025-10-22 17:44:37,444 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Multi-Item Order - Tests aggregate calculations
&emsp;  Scenario: Multi-Item Order - Tests aggregate calculations  
&emsp;&emsp;    Given Customer "Bob" with balance 0 and credit limit 2000  
&emsp;&emsp;    When B2B order placed for "Bob" with 3 Widget and 2 Gadget  
&emsp;&emsp;    Then Customer balance should be 570  
    And Order total should be 570  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Multi-Item Order - Tests aggregate calculations
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    3. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Multi-Item Order - Tests aggregate calculations
```

Multi-Item Order - Tests aggregate calculation
 - 2025-10-22 17:44:37,465 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4e0af0) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,467 - logic_logger - INF
..Customer[7] {Update - client} id: 7, name: Bob 1761180277459, balance: 0E-10, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c53d4d0  session: 0x10c4e0af0  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,467 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4e0af0)   										 - 2025-10-22 17:44:37,467 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4e0af0)   										 - 2025-10-22 17:44:37,467 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Carbon Neutral Discount - Tests custom logic
&emsp;  Scenario: Carbon Neutral Discount - Tests custom logic  
&emsp;&emsp;    Given Customer "Charlie" with balance 0 and credit limit 3000  
&emsp;&emsp;    When B2B order placed for "Charlie" with 10 carbon neutral Gadget  
&emsp;&emsp;    Then Customer balance should be 1350  
    And Item amount reflects 10% discount  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Carbon Neutral Discount - Tests custom logic
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    3. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
    5. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Carbon Neutral Discount - Tests custom logic
```

Carbon Neutral Discount - Tests custom logi
 - 2025-10-22 17:44:37,487 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4e2580) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,488 - logic_logger - INF
..Customer[8] {Update - client} id: 8, name: Charlie 1761180277481, balance: 0E-10, credit_limit: 3000.0000000000, email: None, email_opt_out: None  row: 0x10c53cf50  session: 0x10c4e2580  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,488 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4e2580)   										 - 2025-10-22 17:44:37,489 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4e2580)   										 - 2025-10-22 17:44:37,489 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Change Item Quantity - Tests formula recalculation
&emsp;  Scenario: Change Item Quantity - Tests formula recalculation  
&emsp;&emsp;    Given Customer "Diana" with balance 0 and credit limit 1000  
    And Order exists for "Diana" with 5 Widget  
&emsp;&emsp;    When Item quantity changed to 10  
&emsp;&emsp;    Then Item amount should be 900  
    And Order total should be 900  
    And Customer balance should be 900  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Change Item Quantity - Tests formula recalculation
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
  Item  
    2. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
  Order  
    3. RowEvent Order.send_order_to_shipping()   
    4. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
```
**Logic Log** in Scenario: Change Item Quantity - Tests formula recalculation
```

Change Item Quantity - Tests formula recalculatio
 - 2025-10-22 17:44:37,519 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4e2470) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,521 - logic_logger - INF
..Item[10] {Update - client} id: 10, order_id: 9, product_id: 2, quantity:  [5-->] 10, amount: 450.0000000000, unit_price: 90.0000000000  row: 0x10c53f7d0  session: 0x10c4e2470  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,522 - logic_logger - INF
..Item[10] {Formula amount} id: 10, order_id: 9, product_id: 2, quantity:  [5-->] 10, amount:  [450.0000000000-->] 900.0000000000, unit_price: 90.0000000000  row: 0x10c53f7d0  session: 0x10c4e2470  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,522 - logic_logger - INF
....Order[9] {Update - Adjusting order: amount_total} id: 9, notes: Single-item test order, customer_id: 9, CreatedOn: 2025-10-22, date_shipped: None, amount_total:  [450.0000000000-->] 900.0000000000  row: 0x10c53e5d0  session: 0x10c4e2470  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,523 - logic_logger - INF
......Customer[9] {Update - Adjusting customer: balance} id: 9, name: Diana 1761180277502, balance:  [450.0000000000-->] 900.0000000000, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x10c5bc450  session: 0x10c4e2470  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,523 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4e2470)   										 - 2025-10-22 17:44:37,523 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4e2470)   										 - 2025-10-22 17:44:37,524 - logic_logger - INF
....Order[9] {AfterFlush Event} id: 9, notes: Single-item test order, customer_id: 9, CreatedOn: 2025-10-22, date_shipped: None, amount_total:  [450.0000000000-->] 900.0000000000  row: 0x10c53e5d0  session: 0x10c4e2470  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,524 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Change Customer - Tests FK update adjusting both parents
&emsp;  Scenario: Change Customer - Tests FK update adjusting both parents  
&emsp;&emsp;    Given Customer "Alice" with balance 0 and credit limit 1000  
    And Customer "Bob" with balance 0 and credit limit 2000  
    And Order exists for "Alice" with 5 Widget  
&emsp;&emsp;    When Order customer changed to "Bob"  
&emsp;&emsp;    Then Customer "Alice" balance should be 0  
    And Customer "Bob" balance should be 450  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Change Customer - Tests FK update adjusting both parents
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Change Customer - Tests FK update adjusting both parents
```

Change Customer - Tests FK update adjusting both parent
 - 2025-10-22 17:44:37,553 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4e2580) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,555 - logic_logger - INF
..Order[10] {Update - client} id: 10, notes: Single-item test order, customer_id:  [10-->] 11, CreatedOn: 2025-10-22, date_shipped: None, amount_total: 450.0000000000  row: 0x10c53e5d0  session: 0x10c4e2580  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,555 - logic_logger - INF
....Customer[11] {Update - Adjusting customer: balance, balance} id: 11, name: Bob 1761180277536, balance:  [0E-10-->] 450.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c5bdd50  session: 0x10c4e2580  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,556 - logic_logger - INF
....Customer[10] {Update - Adjusting Old customer} id: 10, name: Alice 1761180277533, balance:  [450.0000000000-->] 0E-10, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x10c5be0d0  session: 0x10c4e2580  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,556 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4e2580)   										 - 2025-10-22 17:44:37,556 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4e2580)   										 - 2025-10-22 17:44:37,557 - logic_logger - INF
..Order[10] {AfterFlush Event} id: 10, notes: Single-item test order, customer_id:  [10-->] 11, CreatedOn: 2025-10-22, date_shipped: None, amount_total: 450.0000000000  row: 0x10c53e5d0  session: 0x10c4e2580  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,557 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Delete Item - Tests sum recalculation
&emsp;  Scenario: Delete Item - Tests sum recalculation  
&emsp;&emsp;    Given Customer "Charlie" with balance 0 and credit limit 2000  
    And Order exists for "Charlie" with 3 Widget and 2 Gadget  
&emsp;&emsp;    When First item is deleted  
&emsp;&emsp;    Then Customer balance should be 300  
    And Order total should be 300  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Delete Item - Tests sum recalculation
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
    3. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
```
**Logic Log** in Scenario: Delete Item - Tests sum recalculation
```

Delete Item - Tests sum recalculatio
 - 2025-10-22 17:44:37,579 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4e27a0) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,581 - logic_logger - INF
..Item[12] {Delete - client} id: 12, order_id: 11, product_id: 2, quantity: 3, amount: 270.0000000000, unit_price: 90.0000000000  row: 0x10c5be950  session: 0x10c4e27a0  ins_upd_dlt: dlt, initial: dlt - 2025-10-22 17:44:37,581 - logic_logger - INF
....Order[11] {Update - Adjusting order: amount_total} id: 11, notes: Multi-item test order, customer_id: 12, CreatedOn: 2025-10-22, date_shipped: None, amount_total:  [570.0000000000-->] 300.0000000000  row: 0x10c5bdfd0  session: 0x10c4e27a0  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,581 - logic_logger - INF
......Customer[12] {Update - Adjusting customer: balance} id: 12, name: Charlie 1761180277563, balance:  [570.0000000000-->] 300.0000000000, credit_limit: 2000.0000000000, email: None, email_opt_out: None  row: 0x10c5bf650  session: 0x10c4e27a0  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,582 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4e27a0)   										 - 2025-10-22 17:44:37,582 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4e27a0)   										 - 2025-10-22 17:44:37,583 - logic_logger - INF
....Order[11] {AfterFlush Event} id: 11, notes: Multi-item test order, customer_id: 12, CreatedOn: 2025-10-22, date_shipped: None, amount_total:  [570.0000000000-->] 300.0000000000  row: 0x10c5bdfd0  session: 0x10c4e27a0  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,583 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Ship Order - Tests WHERE clause exclusion
&emsp;  Scenario: Ship Order - Tests WHERE clause exclusion  
&emsp;&emsp;    Given Customer "Diana" with balance 0 and credit limit 1000  
    And Order exists for "Diana" with 5 Widget  
&emsp;&emsp;    When Order is shipped  
&emsp;&emsp;    Then Customer balance should be 0  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Ship Order - Tests WHERE clause exclusion
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Ship Order - Tests WHERE clause exclusion
```

Ship Order - Tests WHERE clause exclusio
 - 2025-10-22 17:44:37,602 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4e2f10) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,605 - logic_logger - INF
..Order[12] {Update - client} id: 12, notes: Single-item test order, customer_id: 13, CreatedOn: 2025-10-22, date_shipped:  [None-->] 2025-10-22 00:00:00, amount_total: 450.0000000000  row: 0x10c5be6d0  session: 0x10c4e2f10  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,605 - logic_logger - INF
....Customer[13] {Update - Adjusting customer: balance} id: 13, name: Diana 1761180277587, balance:  [450.0000000000-->] 0E-10, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x10c5be350  session: 0x10c4e2f10  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,606 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4e2f10)   										 - 2025-10-22 17:44:37,606 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4e2f10)   										 - 2025-10-22 17:44:37,606 - logic_logger - INF
..Order[12] {AfterFlush Event} id: 12, notes: Single-item test order, customer_id: 13, CreatedOn: 2025-10-22, date_shipped:  [None-->] 2025-10-22 00:00:00, amount_total: 450.0000000000  row: 0x10c5be6d0  session: 0x10c4e2f10  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,606 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Unship Order - Tests WHERE clause inclusion
&emsp;  Scenario: Unship Order - Tests WHERE clause inclusion  
&emsp;&emsp;    Given Customer "Alice" with balance 0 and credit limit 1000  
    And Shipped order exists for "Alice" with 5 Widget  
&emsp;&emsp;    When Order is unshipped  
&emsp;&emsp;    Then Customer balance should be 450  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Unship Order - Tests WHERE clause inclusion
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
  Order  
    2. RowEvent Order.send_order_to_shipping()   
```
**Logic Log** in Scenario: Unship Order - Tests WHERE clause inclusion
```

Unship Order - Tests WHERE clause inclusio
 - 2025-10-22 17:44:37,626 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4e2140) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,628 - logic_logger - INF
..Order[13] {Update - client} id: 13, notes: Pre-shipped test order, customer_id: 14, CreatedOn: 2025-10-22, date_shipped:  [2025-10-22-->] None, amount_total: 450.0000000000  row: 0x10c5bdb50  session: 0x10c4e2140  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,628 - logic_logger - INF
....Customer[14] {Update - Adjusting customer: balance} id: 14, name: Alice 1761180277610, balance:  [0E-10-->] 450.0000000000, credit_limit: 1000.0000000000, email: None, email_opt_out: None  row: 0x10c60c3d0  session: 0x10c4e2140  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,629 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4e2140)   										 - 2025-10-22 17:44:37,629 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4e2140)   										 - 2025-10-22 17:44:37,629 - logic_logger - INF
..Order[13] {AfterFlush Event} id: 13, notes: Pre-shipped test order, customer_id: 14, CreatedOn: 2025-10-22, date_shipped:  [2025-10-22-->] None, amount_total: 450.0000000000  row: 0x10c5bdb50  session: 0x10c4e2140  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,629 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Exceed Credit Limit - Tests constraint failure
&emsp;  Scenario: Exceed Credit Limit - Tests constraint failure  
&emsp;&emsp;    Given Customer "Bob" with balance 0 and credit limit 100  
&emsp;&emsp;    When B2B order placed for "Bob" with 5 Widget  
&emsp;&emsp;    Then Order creation should fail with credit limit error  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Rules Used** in Scenario: Exceed Credit Limit - Tests constraint failure
```
  Customer  
    1. Derive <class 'database.models.Customer'>.balance as Sum(Order.amount_total Where Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total, where=lambda row: row.date_shipped is None) - <function declare_logic.<locals>.<lambda> at 0x10b400cc0>)  
    2. Constraint Function: None   
  Item  
    3. Derive <class 'database.models.Item'>.amount as Formula (1): <function>  
    4. Derive <class 'database.models.Item'>.unit_price as Copy(product.unit_price)  
  Order  
    5. Derive <class 'database.models.Order'>.amount_total as Sum(Item.amount Where  - None)  
```
**Logic Log** in Scenario: Exceed Credit Limit - Tests constraint failure
```

Exceed Credit Limit - Tests constraint failur
 - 2025-10-22 17:44:37,637 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c4e3240) (sqlalchemy before_flush)			 - 2025-10-22 17:44:37,639 - logic_logger - INF
..Customer[15] {Update - client} id: 15, name: Bob 1761180277633, balance: 0E-10, credit_limit: 100.0000000000, email: None, email_opt_out: None  row: 0x10c5bfd50  session: 0x10c4e3240  ins_upd_dlt: upd, initial: upd - 2025-10-22 17:44:37,639 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c4e3240)   										 - 2025-10-22 17:44:37,639 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c4e3240)   										 - 2025-10-22 17:44:37,640 - logic_logger - INF

```
</details>
  
&nbsp;&nbsp;  
/Users/val/dev/ApiLogicServer/ApiLogicServer-dev/build_and_test/ApiLogicServer/basic_demo/test/api_logic_server_behave/behave_run.py completed at October 22, 2025 17:44:3  