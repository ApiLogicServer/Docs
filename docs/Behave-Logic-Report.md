
# Behave Logic Report

This is the sample project from API Logic Server, based on the Northwind database (sqlite database located in the `database` folder - no installation required):

![Sample Database](images/model/sample-database.png)

>  The sample Scenarios below were chosen to illustrate the basic patterns of using rules.  Open the disclosure box (_"Tests - and their logic..."_) to see the implementation and notes.

The following report was created during test suite execution.

&nbsp;

---

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
  Category  
    1. Constraint Function: <function declare_logic.<locals>.valid_category_description at 0x10af92840>   
  
```
**Logic Log** in Scenario: Transaction Processing
```

The following rules have been activate
 - 2024-02-29 14:54:31,925 - logic_logger - DEBU
Rule Bank[0x10acc1190] (loaded 2024-02-29 14:54:22.467544
Mapped Class[Customer] rules
  Constraint Function: None
  Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>
  RowEvent Customer.customer_defaults()
  Constraint Function: None
  Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>
  Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None
Mapped Class[Order] rules
  Derive Order.AmountTotal as Sum(OrderDetail.Amount Where None
  RowEvent Order.send_order_to_shipping()
  Constraint Function: <function declare_logic.<locals>.do_not_ship_empty_orders at 0x10af92a20>
  RowEvent Order.congratulate_sales_rep()
  RowEvent Order.order_defaults()
  Derive Order.OrderDetailCount as Count(<class 'database.models.OrderDetail'> Where None
  RowEvent Order.clone_order()
  Derive Order.OrderDate as Formula (1): as_expression=lambda row: datetime.datetime.now()
Mapped Class[OrderDetail] rules
  Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...
  Derive OrderDetail.UnitPrice as Copy(Product.UnitPrice
  RowEvent OrderDetail.order_detail_defaults()
  Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDat
Mapped Class[Employee] rules
  Constraint Function: None
  Constraint Function: <function declare_logic.<locals>.raise_over_20_percent at 0x10af93420>
  Copy to: EmployeeAudi
Mapped Class[Category] rules
  Constraint Function: <function declare_logic.<locals>.valid_category_description at 0x10af92840>
Mapped Class[Product] rules
  Derive Product.UnitsInStock as Formula (1): <function
  Derive Product.UnitsShipped as Sum(OrderDetail.Quantity Where <function declare_logic.<locals>.<lambda> at 0x10af93100>
Logic Bank - 31 rules loaded - 2024-02-29 14:54:31,930 - logic_logger - INF
Logic Bank - 31 rules loaded - 2024-02-29 14:54:31,930 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c5cc110) (sqlalchemy before_flush)			 - 2024-02-29 14:54:32,387 - logic_logger - INF
..Shipper[1] {Delete - client} Id: 1, CompanyName: Speedy Express, Phone: (503) 555-9831  row: 0x10c5c2490  session: 0x10c5cc110  ins_upd_dlt: dlt - 2024-02-29 14:54:32,387 - logic_logger - INF

Logic Phase:		ROW LOGIC		(session=0x10c660650) (sqlalchemy before_flush)			 - 2024-02-29 14:54:32,457 - logic_logger - INF
..Category[1] {Update - client} Id: 1, CategoryName: Beverages, Description:  [Soft drinks, coffees, teas, beers, and ales-->] x, Client_id: 1  row: 0x10c661bd0  session: 0x10c660650  ins_upd_dlt: upd - 2024-02-29 14:54:32,457 - logic_logger - INF
..Category[1] {Constraint Failure: Description cannot be 'x'} Id: 1, CategoryName: Beverages, Description:  [Soft drinks, coffees, teas, beers, and ales-->] x, Client_id: 1  row: 0x10c661bd0  session: 0x10c660650  ins_upd_dlt: upd - 2024-02-29 14:54:32,458 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
## Feature: Application Integration  
  
&nbsp;
&nbsp;
### Scenario: GET Customer
&emsp;  Scenario: GET Customer  
&emsp;&emsp;    Given Customer Account: VINET  
&emsp;&emsp;    When GET Orders API  
&emsp;&emsp;    Then VINET retrieved  
  
&nbsp;
&nbsp;
### Scenario: GET Department
&emsp;  Scenario: GET Department  
&emsp;&emsp;    Given Department 2  
&emsp;&emsp;    When GET Department with SubDepartments API  
&emsp;&emsp;    Then SubDepartments returned  
  
&nbsp;
&nbsp;
## Feature: Authorization  
  
&nbsp;
&nbsp;
### Scenario: Grant
&emsp;  Scenario: Grant  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When u1 GETs Categories  
&emsp;&emsp;    Then Only 1 is returned  
  
&nbsp;
&nbsp;
### Scenario: Multi-tenant
&emsp;  Scenario: Multi-tenant  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When sam GETs Customers  
&emsp;&emsp;    Then only 3 are returned  
  
&nbsp;
&nbsp;
### Scenario: Global Filters
&emsp;  Scenario: Global Filters  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When sam GETs Departments  
&emsp;&emsp;    Then only 8 are returned  
  
&nbsp;
&nbsp;
### Scenario: Global Filters With Grants
&emsp;  Scenario: Global Filters With Grants  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When s1 GETs Customers  
&emsp;&emsp;    Then only 1 customer is returned  
  
&nbsp;
&nbsp;
### Scenario: CRUD Permissions
&emsp;  Scenario: CRUD Permissions  
&emsp;&emsp;    Given NW Test Database  
&emsp;&emsp;    When r1 deletes a Shipper  
&emsp;&emsp;    Then Operation is Refused  
  
&nbsp;
&nbsp;
## Feature: Optimistic Locking  
  
&nbsp;
&nbsp;
### Scenario: Get Category
&emsp;  Scenario: Get Category  
&emsp;&emsp;    Given Category: 1  
&emsp;&emsp;    When Get Cat1  
&emsp;&emsp;    Then Expected Cat1 Checksum  
  
&nbsp;
&nbsp;
### Scenario: Valid Checksum
&emsp;  Scenario: Valid Checksum  
&emsp;&emsp;    Given Category: 1  
&emsp;&emsp;    When Patch Valid Checksum  
&emsp;&emsp;    Then Valid Checksum, Invalid Description  
  
&nbsp;
&nbsp;
### Scenario: Missing Checksum
&emsp;  Scenario: Missing Checksum  
&emsp;&emsp;    Given Category: 1  
&emsp;&emsp;    When Patch Missing Checksum  
&emsp;&emsp;    Then Valid Checksum, Invalid Description  
  
&nbsp;
&nbsp;
### Scenario: Invalid Checksum
&emsp;  Scenario: Invalid Checksum  
&emsp;&emsp;    Given Category: 1  
&emsp;&emsp;    When Patch Invalid Checksum  
&emsp;&emsp;    Then Invalid Checksum  
  
&nbsp;
&nbsp;
## Feature: Place Order  
  
&nbsp;
&nbsp;
### Scenario: Good Order Custom Service
&emsp;  Scenario: Good Order Custom Service  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Good Order Placed  
&emsp;&emsp;    Then Logic adjusts Balance (demo: chain up)  
&emsp;&emsp;    Then Logic adjusts Products Reordered  
&emsp;&emsp;    Then Logic sends email to salesrep  
&emsp;&emsp;    Then Logic sends kafka message  
&emsp;&emsp;    Then Logic adjusts aggregates down on delete order  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


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

![behave-logic](images/behave/declare-logic.png)

> **Key Takeaway:** sum/count aggregates (e.g., `Customer.Balance`) automate ***chain up*** multi-table transactions.

**Events - Extensible Logic**

Inspect the log for __Hi, Andrew - Congratulate Nancy on their new order__. 

The `congratulate_sales_rep` event illustrates logic 
[Extensibility](https://apilogicserver.github.io/Docs/Logic/#extensibility-python-events) 
- using Python to provide logic not covered by rules, 
like non-database operations such as sending email or messages.

![send-email](images/behave/send-email.png)

There are actually multiple kinds of events:

* *Before* row logic
* *After* row logic
* On *commit,* after all row logic has completed (as here), so that your code "sees" the full logic results

Events are passed the `row` and `old_row`, as well as `logic_row` which enables you to test the actual operation, chaining nest level, etc.

You can set breakpoints in events, and inspect these.

&nbsp;
&nbsp;


**Rules Used** in Scenario: Good Order Custom Service
```
  Customer  
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>)  
    2. RowEvent Customer.customer_defaults()   
    3. Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>)  
    4. Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None)  
  Order  
    5. RowEvent Order.order_defaults()   
    6. RowEvent Order.clone_order()   
    7. Derive Order.OrderDate as Formula (1): as_expression=lambda row: datetime.datetime.now())  
    8. RowEvent Order.send_order_to_shipping()   
    9. RowEvent Order.congratulate_sales_rep()   
    10. Derive Order.OrderDetailCount as Count(<class 'database.models.OrderDetail'> Where None)  
    11. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where None)  
  OrderDetail  
    12. Derive OrderDetail.UnitPrice as Copy(Product.UnitPrice)  
    13. RowEvent OrderDetail.order_detail_defaults()   
    14. Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDate  
    15. Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...]  
  Product  
    16. Derive Product.UnitsInStock as Formula (1): <function>  
    17. Derive Product.UnitsShipped as Sum(OrderDetail.Quantity Where <function declare_logic.<locals>.<lambda> at 0x10af93100>)  
  
```
**Logic Log** in Scenario: Good Order Custom Service
```

Logic Phase:		ROW LOGIC		(session=0x10c663210) (sqlalchemy before_flush)			 - 2024-02-29 14:54:32,623 - logic_logger - INF
..OrderDetail[None] {Insert - client} Id: None, OrderId: None, ProductId: 1, UnitPrice: None, Quantity: 1, Discount: 0, Amount: None, ShippedDate: None  row: 0x10c688590  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,623 - logic_logger - INF
..OrderDetail[None] {copy_rules for role: Product - UnitPrice} Id: None, OrderId: None, ProductId: 1, UnitPrice: 18.0000000000, Quantity: 1, Discount: 0, Amount: None, ShippedDate: None  row: 0x10c688590  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,625 - logic_logger - INF
..OrderDetail[None] {Formula Amount} Id: None, OrderId: None, ProductId: 1, UnitPrice: 18.0000000000, Quantity: 1, Discount: 0, Amount: 18.0000000000, ShippedDate: None  row: 0x10c688590  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,626 - logic_logger - INF
....Order[None] {Adjustment logic chaining deferred for this parent parent do_defer_adjustment: True, is_parent_submitted: True, is_parent_row_processed: False, Order} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [None-->] 18.0000000000, Country: None, City: None, Ready: None, OrderDetailCount:  [None-->] 1, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: * - 2024-02-29 14:54:32,627 - logic_logger - INF
....Product[1] {Update - Adjusting Product: UnitsShipped} Id: 1, ProductName: Chai, SupplierId: 1, CategoryId: 1, QuantityPerUnit: 10 boxes x 20 bags, UnitPrice: 18.0000000000, UnitsInStock: 39, UnitsOnOrder: 0, ReorderLevel: 10, Discontinued: 0, UnitsShipped:  [0-->] 1  row: 0x10c6685d0  session: 0x10c663210  ins_upd_dlt: upd - 2024-02-29 14:54:32,627 - logic_logger - INF
....Product[1] {Formula UnitsInStock} Id: 1, ProductName: Chai, SupplierId: 1, CategoryId: 1, QuantityPerUnit: 10 boxes x 20 bags, UnitPrice: 18.0000000000, UnitsInStock:  [39-->] 38, UnitsOnOrder: 0, ReorderLevel: 10, Discontinued: 0, UnitsShipped:  [0-->] 1  row: 0x10c6685d0  session: 0x10c663210  ins_upd_dlt: upd - 2024-02-29 14:54:32,627 - logic_logger - INF
..Order[None] {Insert - client} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 18.0000000000, Country: None, City: None, Ready: None, OrderDetailCount: 1, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,629 - logic_logger - INF
..Order[None] {server_defaults: Ready -- skipped: Ready[BOOLEAN (not handled)] } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 18.0000000000, Country: None, City: None, Ready: None, OrderDetailCount: 1, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,629 - logic_logger - INF
..Order[None] {Formula OrderDate} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:32.634854, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 18.0000000000, Country: None, City: None, Ready: None, OrderDetailCount: 1, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,635 - logic_logger - INF
....Customer[ALFKI] {Update - Adjusting Customer: Balance, UnpaidOrderCount, OrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2120.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10c683c10  session: 0x10c663210  ins_upd_dlt: upd - 2024-02-29 14:54:32,635 - logic_logger - INF
..OrderDetail[None] {Insert - client} Id: None, OrderId: None, ProductId: 2, UnitPrice: None, Quantity: 2, Discount: 0, Amount: None, ShippedDate: None  row: 0x10c689bd0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,637 - logic_logger - INF
..OrderDetail[None] {copy_rules for role: Product - UnitPrice} Id: None, OrderId: None, ProductId: 2, UnitPrice: 19.0000000000, Quantity: 2, Discount: 0, Amount: None, ShippedDate: None  row: 0x10c689bd0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,639 - logic_logger - INF
..OrderDetail[None] {Formula Amount} Id: None, OrderId: None, ProductId: 2, UnitPrice: 19.0000000000, Quantity: 2, Discount: 0, Amount: 38.0000000000, ShippedDate: None  row: 0x10c689bd0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,639 - logic_logger - INF
....Order[None] {Update - Adjusting Order: AmountTotal, OrderDetailCount} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:32.634854, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [18.0000000000-->] 56.0000000000, Country: None, City: None, Ready: None, OrderDetailCount:  [1-->] 2, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: upd - 2024-02-29 14:54:32,640 - logic_logger - INF
....Order[None] {Prune Formula: OrderDate [[]]} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:32.634854, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [18.0000000000-->] 56.0000000000, Country: None, City: None, Ready: None, OrderDetailCount:  [1-->] 2, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: upd - 2024-02-29 14:54:32,641 - logic_logger - INF
......Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2120.0000000000-->] 2158.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10c683c10  session: 0x10c663210  ins_upd_dlt: upd - 2024-02-29 14:54:32,641 - logic_logger - INF
....Product[2] {Update - Adjusting Product: UnitsShipped} Id: 2, ProductName: Chang, SupplierId: 1, CategoryId: 1, QuantityPerUnit: 24 - 12 oz bottles, UnitPrice: 19.0000000000, UnitsInStock: 17, UnitsOnOrder: 40, ReorderLevel: 25, Discontinued: 0, UnitsShipped:  [0-->] 2  row: 0x10c6921d0  session: 0x10c663210  ins_upd_dlt: upd - 2024-02-29 14:54:32,644 - logic_logger - INF
....Product[2] {Formula UnitsInStock} Id: 2, ProductName: Chang, SupplierId: 1, CategoryId: 1, QuantityPerUnit: 24 - 12 oz bottles, UnitPrice: 19.0000000000, UnitsInStock:  [17-->] 15, UnitsOnOrder: 40, ReorderLevel: 25, Discontinued: 0, UnitsShipped:  [0-->] 2  row: 0x10c6921d0  session: 0x10c663210  ins_upd_dlt: upd - 2024-02-29 14:54:32,644 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10c663210)   										 - 2024-02-29 14:54:32,645 - logic_logger - INF
..Order[None] {Commit Event} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:32.634854, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: None, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,645 - logic_logger - INF
..Order[None] {Hi, Andrew - Congratulate Nancy on their new order} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:32.634854, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: None, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,649 - logic_logger - INF
..Order[None] {Illustrate database access} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:32.634854, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: None, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,650 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10c663210)   										 - 2024-02-29 14:54:32,658 - logic_logger - INF
..Order[11078] {AfterFlush Event} Id: 11078, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:32.634854, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,659 - logic_logger - INF
..Order[11078] {Sending Order to Shipping << not activated >>} Id: 11078, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:32.634854, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: 56.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 2, CloneFromOrder: None  row: 0x10c6621d0  session: 0x10c663210  ins_upd_dlt: ins - 2024-02-29 14:54:32,660 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Bad Ship of Empty Order
&emsp;  Scenario: Bad Ship of Empty Order  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order Shipped with no Items  
&emsp;&emsp;    Then Rejected per Do Not Ship Empty Orders  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Bad Ship of Empty Order
   
Reuse the rules for Good Order...

Familiar logic patterns:

* Constrain a derived result
* Counts as existence checks

Logic Design ("Cocktail Napkin Design")

* Constraint: do_not_ship_empty_orders()
* Order.OrderDetailCount = count(OrderDetail)



&nbsp;
&nbsp;


**Rules Used** in Scenario: Bad Ship of Empty Order
```
  Customer  
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>)  
    2. RowEvent Customer.customer_defaults()   
    3. Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>)  
    4. Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None)  
  Order  
    5. RowEvent Order.order_defaults()   
    6. Constraint Function: <function declare_logic.<locals>.do_not_ship_empty_orders at 0x10af92a20>   
    7. Derive Order.OrderDate as Formula (1): as_expression=lambda row: datetime.datetime.now())  
```
**Logic Log** in Scenario: Bad Ship of Empty Order
```

Logic Phase:		ROW LOGIC		(session=0x10cbb71d0) (sqlalchemy before_flush)			 - 2024-02-29 14:54:33,017 - logic_logger - INF
..Order[None] {Insert - client} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: 2013-10-13, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: None, CloneFromOrder: None  row: 0x10cbb6250  session: 0x10cbb71d0  ins_upd_dlt: ins - 2024-02-29 14:54:33,018 - logic_logger - INF
..Order[None] {server_defaults: Ready OrderDetailCount -- skipped: Ready[BOOLEAN (not handled)] } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: 2013-10-13, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10cbb6250  session: 0x10cbb71d0  ins_upd_dlt: ins - 2024-02-29 14:54:33,018 - logic_logger - INF
..Order[None] {Formula OrderDate} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.021904, RequiredDate: None, ShippedDate: 2013-10-13, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10cbb6250  session: 0x10cbb71d0  ins_upd_dlt: ins - 2024-02-29 14:54:33,022 - logic_logger - INF
....Customer[ALFKI] {Update - Adjusting Customer: OrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance: 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount: 10, Client_id: 1  row: 0x10cbb7a50  session: 0x10cbb71d0  ins_upd_dlt: upd - 2024-02-29 14:54:33,022 - logic_logger - INF
..Order[None] {Constraint Failure: Cannot Ship Empty Orders} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.021904, RequiredDate: None, ShippedDate: 2013-10-13, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10cbb6250  session: 0x10cbb71d0  ins_upd_dlt: ins - 2024-02-29 14:54:33,024 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Bad Order Custom Service
&emsp;  Scenario: Bad Order Custom Service  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order Placed with excessive quantity  
&emsp;&emsp;    Then Rejected per Check Credit  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


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
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>)  
    2. RowEvent Customer.customer_defaults()   
    3. Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>)  
    4. Constraint Function: None   
    5. Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None)  
  Order  
    6. RowEvent Order.order_defaults()   
    7. RowEvent Order.clone_order()   
    8. Derive Order.OrderDate as Formula (1): as_expression=lambda row: datetime.datetime.now())  
    9. Derive Order.OrderDetailCount as Count(<class 'database.models.OrderDetail'> Where None)  
    10. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where None)  
  OrderDetail  
    11. Derive OrderDetail.UnitPrice as Copy(Product.UnitPrice)  
    12. Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...]  
    13. RowEvent OrderDetail.order_detail_defaults()   
    14. Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDate  
```
**Logic Log** in Scenario: Bad Order Custom Service
```

Logic Phase:		ROW LOGIC		(session=0x10cb75850) (sqlalchemy before_flush)			 - 2024-02-29 14:54:33,111 - logic_logger - INF
..Order[None] {Insert - client} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: None, CloneFromOrder: None  row: 0x10cb76010  session: 0x10cb75850  ins_upd_dlt: ins - 2024-02-29 14:54:33,111 - logic_logger - INF
..Order[None] {server_defaults: Ready OrderDetailCount -- skipped: Ready[BOOLEAN (not handled)] } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10cb76010  session: 0x10cb75850  ins_upd_dlt: ins - 2024-02-29 14:54:33,112 - logic_logger - INF
..Order[None] {Formula OrderDate} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.115474, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: 0, CloneFromOrder: None  row: 0x10cb76010  session: 0x10cb75850  ins_upd_dlt: ins - 2024-02-29 14:54:33,115 - logic_logger - INF
....Customer[ALFKI] {Update - Adjusting Customer: UnpaidOrderCount, OrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance: 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10cb67850  session: 0x10cb75850  ins_upd_dlt: upd - 2024-02-29 14:54:33,116 - logic_logger - INF
..OrderDetail[None] {Insert - client} Id: None, OrderId: None, ProductId: 1, UnitPrice: None, Quantity: 1111, Discount: 0, Amount: None, ShippedDate: None  row: 0x10cb74690  session: 0x10cb75850  ins_upd_dlt: ins - 2024-02-29 14:54:33,119 - logic_logger - INF
..OrderDetail[None] {copy_rules for role: Product - UnitPrice} Id: None, OrderId: None, ProductId: 1, UnitPrice: 18.0000000000, Quantity: 1111, Discount: 0, Amount: None, ShippedDate: None  row: 0x10cb74690  session: 0x10cb75850  ins_upd_dlt: ins - 2024-02-29 14:54:33,120 - logic_logger - INF
..OrderDetail[None] {Formula Amount} Id: None, OrderId: None, ProductId: 1, UnitPrice: 18.0000000000, Quantity: 1111, Discount: 0, Amount: 19998.0000000000, ShippedDate: None  row: 0x10cb74690  session: 0x10cb75850  ins_upd_dlt: ins - 2024-02-29 14:54:33,121 - logic_logger - INF
....Order[None] {Update - Adjusting Order: AmountTotal, OrderDetailCount} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.115474, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [None-->] 19998.0000000000, Country: None, City: None, Ready: None, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10cb76010  session: 0x10cb75850  ins_upd_dlt: upd - 2024-02-29 14:54:33,122 - logic_logger - INF
....Order[None] {Prune Formula: OrderDate [[]]} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.115474, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 10, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [None-->] 19998.0000000000, Country: None, City: None, Ready: None, OrderDetailCount:  [0-->] 1, CloneFromOrder: None  row: 0x10cb76010  session: 0x10cb75850  ins_upd_dlt: upd - 2024-02-29 14:54:33,123 - logic_logger - INF
......Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 22100.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cb67850  session: 0x10cb75850  ins_upd_dlt: upd - 2024-02-29 14:54:33,123 - logic_logger - INF
......Customer[ALFKI] {Constraint Failure: balance (22100.00) exceeds credit (2300.00)} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 22100.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cb67850  session: 0x10cb75850  ins_upd_dlt: upd - 2024-02-29 14:54:33,124 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Alter Item Qty to exceed credit
&emsp;  Scenario: Alter Item Qty to exceed credit  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order Detail Quantity altered very high  
&emsp;&emsp;    Then Rejected per Check Credit  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


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
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>)  
    2. RowEvent Customer.customer_defaults()   
    3. Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>)  
    4. Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None)  
    5. Constraint Function: None   
  Order  
    6. RowEvent Order.order_defaults()   
    7. Derive Order.OrderDetailCount as Count(<class 'database.models.OrderDetail'> Where None)  
    8. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where None)  
  OrderDetail  
    9. RowEvent OrderDetail.order_detail_defaults()   
    10. Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...]  
```
**Logic Log** in Scenario: Alter Item Qty to exceed credit
```

Logic Phase:		ROW LOGIC		(session=0x10cb1d810) (sqlalchemy before_flush)			 - 2024-02-29 14:54:33,223 - logic_logger - INF
..OrderDetail[1040] {Update - client} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity:  [15-->] 1110, Discount: 0.25, Amount: 684.0000000000, ShippedDate: None  row: 0x10cb1e550  session: 0x10cb1d810  ins_upd_dlt: upd - 2024-02-29 14:54:33,224 - logic_logger - INF
..OrderDetail[1040] {Formula Amount} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity:  [15-->] 1110, Discount: 0.25, Amount:  [684.0000000000-->] 50616.0000000000, ShippedDate: None  row: 0x10cb1e550  session: 0x10cb1d810  ins_upd_dlt: upd - 2024-02-29 14:54:33,224 - logic_logger - INF
..OrderDetail[1040] {Prune Formula: ShippedDate [['Order.ShippedDate']]} Id: 1040, OrderId: 10643, ProductId: 28, UnitPrice: 45.6000000000, Quantity:  [15-->] 1110, Discount: 0.25, Amount:  [684.0000000000-->] 50616.0000000000, ShippedDate: None  row: 0x10cb1e550  session: 0x10cb1d810  ins_upd_dlt: upd - 2024-02-29 14:54:33,225 - logic_logger - INF
....Order[10643] {Update - Adjusting Order: AmountTotal} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-09-22, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal:  [1086.00-->] 51018.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cbc8050  session: 0x10cb1d810  ins_upd_dlt: upd - 2024-02-29 14:54:33,227 - logic_logger - INF
....Order[10643] {Prune Formula: OrderDate [[]]} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-09-22, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal:  [1086.00-->] 51018.0000000000, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cbc8050  session: 0x10cb1d810  ins_upd_dlt: upd - 2024-02-29 14:54:33,228 - logic_logger - INF
......Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 52034.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10cb74950  session: 0x10cb1d810  ins_upd_dlt: upd - 2024-02-29 14:54:33,229 - logic_logger - INF
......Customer[ALFKI] {Constraint Failure: balance (52034.00) exceeds credit (2300.00)} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 52034.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount: 10, Client_id: 1  row: 0x10cb74950  session: 0x10cb1d810  ins_upd_dlt: upd - 2024-02-29 14:54:33,230 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Alter Required Date - adjust logic pruned
&emsp;  Scenario: Alter Required Date - adjust logic pruned  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order RequiredDate altered (2013-10-13)  
&emsp;&emsp;    Then Balance not adjusted  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


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
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>)  
    2. Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>)  
    3. Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None)  
  Order  
    4. RowEvent Order.order_defaults()   
    5. RowEvent Order.clone_order()   
    6. RowEvent Order.send_order_to_shipping()   
    7. RowEvent Order.congratulate_sales_rep()   
  
```
**Logic Log** in Scenario: Alter Required Date - adjust logic pruned
```

Logic Phase:		ROW LOGIC		(session=0x10cbd3590) (sqlalchemy before_flush)			 - 2024-02-29 14:54:33,336 - logic_logger - INF
..Order[10643] {Update - client} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-09-22-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cbd1190  session: 0x10cbd3590  ins_upd_dlt: upd - 2024-02-29 14:54:33,337 - logic_logger - INF
..Order[10643] {Prune Formula: OrderDate [[]]} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-09-22-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cbd1190  session: 0x10cbd3590  ins_upd_dlt: upd - 2024-02-29 14:54:33,338 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10cbd3590)   										 - 2024-02-29 14:54:33,339 - logic_logger - INF
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-09-22-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cbd1190  session: 0x10cbd3590  ins_upd_dlt: upd - 2024-02-29 14:54:33,340 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10cbd3590)   										 - 2024-02-29 14:54:33,341 - logic_logger - INF
..Order[10643] {AfterFlush Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate:  [2013-09-22-->] 2013-10-13 00:00:00, ShippedDate: None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cbd1190  session: 0x10cbd3590  ins_upd_dlt: upd - 2024-02-29 14:54:33,341 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Set Shipped - adjust logic reuse
&emsp;  Scenario: Set Shipped - adjust logic reuse  
&emsp;&emsp;    Given Customer Account: ALFKI  
&emsp;&emsp;    When Order ShippedDate altered (2013-10-13)  
&emsp;&emsp;    Then Balance reduced 1086  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


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

![order-shipped-date](images/behave/order-shipped-date.png)


> **Key Takeaway:** parent references (e.g., `OrderDetail.ShippedDate`) automate ***chain-down*** multi-table transactions.

> **Key Takeaway:** Automatic Reuse (_design one, solve many_)



&nbsp;
&nbsp;


**Rules Used** in Scenario: Set Shipped - adjust logic reuse
```
  Customer  
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>)  
    2. RowEvent Customer.customer_defaults()   
    3. Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>)  
    4. Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None)  
  Order  
    5. RowEvent Order.order_defaults()   
    6. RowEvent Order.clone_order()   
    7. RowEvent Order.send_order_to_shipping()   
    8. RowEvent Order.congratulate_sales_rep()   
  
```
**Logic Log** in Scenario: Set Shipped - adjust logic reuse
```

Logic Phase:		ROW LOGIC		(session=0x10cc06c10) (sqlalchemy before_flush)			 - 2024-02-29 14:54:33,540 - logic_logger - INF
..Order[10643] {Update - client} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cc07a90  session: 0x10cc06c10  ins_upd_dlt: upd - 2024-02-29 14:54:33,541 - logic_logger - INF
..Order[10643] {Prune Formula: OrderDate [[]]} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cc07a90  session: 0x10cc06c10  ins_upd_dlt: upd - 2024-02-29 14:54:33,542 - logic_logger - INF
....Customer[ALFKI] {Update - Adjusting Customer: Balance, UnpaidOrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 1016.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [10-->] 9, Client_id: 1  row: 0x10cc15090  session: 0x10cc06c10  ins_upd_dlt: upd - 2024-02-29 14:54:33,543 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10cc06c10)   										 - 2024-02-29 14:54:33,547 - logic_logger - INF
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cc07a90  session: 0x10cc06c10  ins_upd_dlt: upd - 2024-02-29 14:54:33,547 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10cc06c10)   										 - 2024-02-29 14:54:33,549 - logic_logger - INF
..Order[10643] {AfterFlush Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [None-->] 2013-10-13, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10cc07a90  session: 0x10cc06c10  ins_upd_dlt: upd - 2024-02-29 14:54:33,550 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Reset Shipped - adjust logic reuse
&emsp;  Scenario: Reset Shipped - adjust logic reuse  
&emsp;&emsp;    Given Shipped Order  
&emsp;&emsp;    When Order ShippedDate set to None  
&emsp;&emsp;    Then Logic adjusts Balance by -1086  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


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
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>)  
    2. RowEvent Customer.customer_defaults()   
    3. Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>)  
    4. Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None)  
  Order  
    5. RowEvent Order.order_defaults()   
    6. RowEvent Order.clone_order()   
    7. RowEvent Order.send_order_to_shipping()   
    8. RowEvent Order.congratulate_sales_rep()   
  
```
**Logic Log** in Scenario: Reset Shipped - adjust logic reuse
```

Logic Phase:		ROW LOGIC		(session=0x10cbfd710) (sqlalchemy before_flush)			 - 2024-02-29 14:54:33,757 - logic_logger - INF
..Order[10643] {Update - client} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10c5c8d10  session: 0x10cbfd710  ins_upd_dlt: upd - 2024-02-29 14:54:33,758 - logic_logger - INF
..Order[10643] {Prune Formula: OrderDate [[]]} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10c5c8d10  session: 0x10cbfd710  ins_upd_dlt: upd - 2024-02-29 14:54:33,759 - logic_logger - INF
....Customer[ALFKI] {Update - Adjusting Customer: Balance, UnpaidOrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [1016.0000000000-->] 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount: 15, UnpaidOrderCount:  [9-->] 10, Client_id: 1  row: 0x10cbcb390  session: 0x10cbfd710  ins_upd_dlt: upd - 2024-02-29 14:54:33,761 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10cbfd710)   										 - 2024-02-29 14:54:33,764 - logic_logger - INF
..Order[10643] {Commit Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10c5c8d10  session: 0x10cbfd710  ins_upd_dlt: upd - 2024-02-29 14:54:33,765 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10cbfd710)   										 - 2024-02-29 14:54:33,766 - logic_logger - INF
..Order[10643] {AfterFlush Event} Id: 10643, CustomerId: ALFKI, EmployeeId: 6, OrderDate: 2013-08-25, RequiredDate: 2013-10-13, ShippedDate:  [2013-10-13-->] None, ShipVia: 1, Freight: 29.4600000000, ShipName: Alfreds Futterkiste, ShipAddress: Obere Str. 57, ShipCity: Berlin, ShipRegion: Western Europe, ShipZip: 12209, ShipCountry: Germany, AmountTotal: 1086.00, Country: None, City: None, Ready: True, OrderDetailCount: 3, CloneFromOrder: None  row: 0x10c5c8d10  session: 0x10cbfd710  ins_upd_dlt: upd - 2024-02-29 14:54:33,767 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Clone Existing Order
&emsp;  Scenario: Clone Existing Order  
&emsp;&emsp;    Given Shipped Order  
&emsp;&emsp;    When Cloning Existing Order  
&emsp;&emsp;    Then Logic Copies ClonedFrom OrderDetails  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Clone Existing Order
   
We create an order, setting CloneFromOrder.

This copies the CloneFromOrder OrderDetails to our new Order.

The copy operation is automated using `logic_row.copy_children()`:

1. `place_order.feature` defines the test

2. `place_order.py` implements the test.  It uses the API to Post an Order, setting `CloneFromOrder` to trigger the copy logic

3. `declare_logic.py` implements the logic, by invoking `logic_row.copy_children()`.  `which` defines which children to copy, here just `OrderDetailList`

![clone-order](images/behave/clone-order.png)

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
    1. Derive Customer.Balance as Sum(Order.AmountTotal Where <function declare_logic.<locals>.<lambda> at 0x10ae893a0>)  
    2. RowEvent Customer.customer_defaults()   
    3. Derive Customer.UnpaidOrderCount as Count(<class 'database.models.Order'> Where <function declare_logic.<locals>.<lambda> at 0x10af93240>)  
    4. Constraint Function: None   
    5. Derive Customer.OrderCount as Count(<class 'database.models.Order'> Where None)  
  Order  
    6. RowEvent Order.order_defaults()   
    7. RowEvent Order.clone_order()   
    8. Derive Order.OrderDate as Formula (1): as_expression=lambda row: datetime.datetime.now())  
    9. Derive Order.OrderDetailCount as Count(<class 'database.models.OrderDetail'> Where None)  
    10. Derive Order.AmountTotal as Sum(OrderDetail.Amount Where None)  
  OrderDetail  
    11. Derive OrderDetail.UnitPrice as Copy(Product.UnitPrice)  
    12. Derive OrderDetail.Amount as Formula (1): as_expression=lambda row: row.UnitPrice * row.Qua [...]  
    13. RowEvent OrderDetail.order_detail_defaults()   
    14. Derive OrderDetail.ShippedDate as Formula (2): row.Order.ShippedDate  
```
**Logic Log** in Scenario: Clone Existing Order
```

Logic Phase:		ROW LOGIC		(session=0x10cb75010) (sqlalchemy before_flush)			 - 2024-02-29 14:54:33,960 - logic_logger - INF
..Order[None] {Insert - client} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: None, CloneFromOrder: 10643  row: 0x10cb77ad0  session: 0x10cb75010  ins_upd_dlt: ins - 2024-02-29 14:54:33,961 - logic_logger - INF
..Order[None] {server_defaults: Ready OrderDetailCount -- skipped: Ready[BOOLEAN (not handled)] } Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: None, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: 0, CloneFromOrder: 10643  row: 0x10cb77ad0  session: 0x10cb75010  ins_upd_dlt: ins - 2024-02-29 14:54:33,961 - logic_logger - INF
..Order[None] {Formula OrderDate} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.966182, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: 0, CloneFromOrder: 10643  row: 0x10cb77ad0  session: 0x10cb75010  ins_upd_dlt: ins - 2024-02-29 14:54:33,966 - logic_logger - INF
....Customer[ALFKI] {Update - Adjusting Customer: UnpaidOrderCount, OrderCount} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance: 2102.0000000000, CreditLimit: 2300.0000000000, OrderCount:  [15-->] 16, UnpaidOrderCount:  [10-->] 11, Client_id: 1  row: 0x10cc2e150  session: 0x10cb75010  ins_upd_dlt: upd - 2024-02-29 14:54:33,966 - logic_logger - INF
..Order[None] {Begin copy_children} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.966182, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal: None, Country: None, City: None, Ready: None, OrderDetailCount: 0, CloneFromOrder: 10643  row: 0x10cb77ad0  session: 0x10cb75010  ins_upd_dlt: ins - 2024-02-29 14:54:33,969 - logic_logger - INF
....OrderDetail[None] {Insert - Copy Children OrderDetailList} Id: None, OrderId: None, ProductId:  [None-->] 28, UnitPrice: None, Quantity:  [None-->] 15, Discount:  [None-->] 0.25, Amount: None, ShippedDate: None  row: 0x10cbca710  session: 0x10cb75010  ins_upd_dlt: ins - 2024-02-29 14:54:33,970 - logic_logger - INF
....OrderDetail[None] {copy_rules for role: Product - UnitPrice} Id: None, OrderId: None, ProductId:  [None-->] 28, UnitPrice:  [None-->] 45.6000000000, Quantity:  [None-->] 15, Discount:  [None-->] 0.25, Amount: None, ShippedDate: None  row: 0x10cbca710  session: 0x10cb75010  ins_upd_dlt: ins - 2024-02-29 14:54:33,972 - logic_logger - INF
....OrderDetail[None] {Formula Amount} Id: None, OrderId: None, ProductId:  [None-->] 28, UnitPrice:  [None-->] 45.6000000000, Quantity:  [None-->] 15, Discount:  [None-->] 0.25, Amount:  [None-->] 684.0000000000, ShippedDate: None  row: 0x10cbca710  session: 0x10cb75010  ins_upd_dlt: ins - 2024-02-29 14:54:33,972 - logic_logger - INF
......Order[None] {Update - Adjusting Order: AmountTotal, OrderDetailCount} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.966182, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [None-->] 684.0000000000, Country: None, City: None, Ready: None, OrderDetailCount:  [0-->] 1, CloneFromOrder: 10643  row: 0x10cb77ad0  session: 0x10cb75010  ins_upd_dlt: upd - 2024-02-29 14:54:33,973 - logic_logger - INF
......Order[None] {Prune Formula: OrderDate [[]]} Id: None, CustomerId: ALFKI, EmployeeId: 1, OrderDate: 2024-02-29 14:54:33.966182, RequiredDate: None, ShippedDate: None, ShipVia: None, Freight: 11, ShipName: None, ShipAddress: None, ShipCity: None, ShipRegion: None, ShipZip: None, ShipCountry: None, AmountTotal:  [None-->] 684.0000000000, Country: None, City: None, Ready: None, OrderDetailCount:  [0-->] 1, CloneFromOrder: 10643  row: 0x10cb77ad0  session: 0x10cb75010  ins_upd_dlt: upd - 2024-02-29 14:54:33,973 - logic_logger - INF
........Customer[ALFKI] {Update - Adjusting Customer: Balance} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2786.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cc2e150  session: 0x10cb75010  ins_upd_dlt: upd - 2024-02-29 14:54:33,974 - logic_logger - INF
........Customer[ALFKI] {Constraint Failure: balance (2786.00) exceeds credit (2300.00)} Id: ALFKI, CompanyName: Alfreds Futterkiste, ContactName: Maria Anders, ContactTitle: Sales Representative, Address: Obere Str. 57A, City: Berlin, Region: Western Europe, PostalCode: 12209, Country: Germany, Phone: 030-0074321, Fax: 030-0076545, Balance:  [2102.0000000000-->] 2786.0000000000, CreditLimit: 2300.0000000000, OrderCount: 16, UnpaidOrderCount: 11, Client_id: 1  row: 0x10cc2e150  session: 0x10cb75010  ins_upd_dlt: upd - 2024-02-29 14:54:33,975 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
## Feature: Salary Change  
  
&nbsp;
&nbsp;
### Scenario: Audit Salary Change
&emsp;  Scenario: Audit Salary Change  
&emsp;&emsp;    Given Employee 5 (Buchanan) - Salary 95k  
&emsp;&emsp;    When Patch Salary to 200k  
&emsp;&emsp;    Then Salary_audit row created  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


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

![sal-change](images/behave/salary_change.png)

> **Key Takeaway:** use **extensible own rule types** to automate pattern you identify; events can result in tedious amounts of code.



&nbsp;
&nbsp;


**Rules Used** in Scenario: Audit Salary Change
```
  
```
**Logic Log** in Scenario: Audit Salary Change
```

Logic Phase:		ROW LOGIC		(session=0x10cc2f810) (sqlalchemy before_flush)			 - 2024-02-29 14:54:34,018 - logic_logger - INF
..Employee[5] {Update - client} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 200000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None  row: 0x10cbaea10  session: 0x10cc2f810  ins_upd_dlt: upd - 2024-02-29 14:54:34,019 - logic_logger - INF
..Employee[5] {BEGIN Copy to: EmployeeAudit} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 200000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None  row: 0x10cbaea10  session: 0x10cc2f810  ins_upd_dlt: upd - 2024-02-29 14:54:34,021 - logic_logger - INF
....EmployeeAudit[None] {Insert - Copy EmployeeAudit} Id: None, Title: Sales Manager, Salary: 200000, LastName: Buchanan, FirstName: Steven, EmployeeId: None, CreatedOn: None  row: 0x10cc17890  session: 0x10cc2f810  ins_upd_dlt: ins - 2024-02-29 14:54:34,022 - logic_logger - INF
....EmployeeAudit[None] {early_row_event_all_classes - handle_all sets 'Created_on} Id: None, Title: Sales Manager, Salary: 200000, LastName: Buchanan, FirstName: Steven, EmployeeId: None, CreatedOn: 2024-02-29 14:54:34.023040  row: 0x10cc17890  session: 0x10cc2f810  ins_upd_dlt: ins - 2024-02-29 14:54:34,023 - logic_logger - INF
Logic Phase:		COMMIT LOGIC		(session=0x10cc2f810)   										 - 2024-02-29 14:54:34,023 - logic_logger - INF
Logic Phase:		AFTER_FLUSH LOGIC	(session=0x10cc2f810)   										 - 2024-02-29 14:54:34,026 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
### Scenario: Manage ProperSalary
&emsp;  Scenario: Manage ProperSalary  
&emsp;&emsp;    Given Employee 5 (Buchanan) - Salary 95k  
&emsp;&emsp;    When Retrieve Employee Row  
&emsp;&emsp;    Then Verify Contains ProperSalary  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


&nbsp;
&nbsp;


**Logic Doc** for scenario: Manage ProperSalary
   
Observe the use of `old_row
`
> **Key Takeaway:** State Transition Logic enabled per `old_row`



&nbsp;
&nbsp;


**Rules Used** in Scenario: Manage ProperSalary
```
```
**Logic Log** in Scenario: Manage ProperSalary
```
```
</details>
  
&nbsp;
&nbsp;
### Scenario: Raise Must be Meaningful
&emsp;  Scenario: Raise Must be Meaningful  
&emsp;&emsp;    Given Employee 5 (Buchanan) - Salary 95k  
&emsp;&emsp;    When Patch Salary to 96k  
&emsp;&emsp;    Then Reject - Raise too small  
<details markdown>
<summary>Tests - and their logic - are transparent.. click to see Logic</summary>


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
    1. Constraint Function: <function declare_logic.<locals>.raise_over_20_percent at 0x10af93420>   
```
**Logic Log** in Scenario: Raise Must be Meaningful
```

Logic Phase:		ROW LOGIC		(session=0x10cbd36d0) (sqlalchemy before_flush)			 - 2024-02-29 14:54:34,275 - logic_logger - INF
..Employee[5] {Update - client} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 96000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None  row: 0x10cbc9590  session: 0x10cbd36d0  ins_upd_dlt: upd - 2024-02-29 14:54:34,276 - logic_logger - INF
..Employee[5] {Constraint Failure: Buchanan needs a more meaningful raise} Id: 5, LastName: Buchanan, FirstName: Steven, Title: Sales Manager, TitleOfCourtesy: Mr., BirthDate: 1987-03-04, HireDate: 2025-10-17, Address: 14 Garrett Hill, City: London, Region: British Isles, PostalCode: SW1 8JR, Country: UK, HomePhone: (71) 555-4848, Extension: 3453, Notes: Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French., ReportsTo: 2, PhotoPath: Employee/buchanan.jpg, EmployeeType: Commissioned, Salary:  [95000.0000000000-->] 96000, WorksForDepartmentId: 3, OnLoanDepartmentId: None, UnionId: None, Dues: None  row: 0x10cbc9590  session: 0x10cbd36d0  ins_upd_dlt: upd - 2024-02-29 14:54:34,277 - logic_logger - INF

```
</details>
  
&nbsp;
&nbsp;
## Feature: Tests Successful  
  
&nbsp;
&nbsp;
### Scenario: Run Tests
&emsp;  Scenario: Run Tests  
&emsp;&emsp;    Given Database and Set of Tests  
&emsp;&emsp;    When Run Configuration: Behave Tests  
&emsp;&emsp;    Then No Errors  
  
&nbsp;&nbsp;  
February 29, 2024 14:54:3  