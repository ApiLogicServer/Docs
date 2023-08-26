Consider the database design guidelines below.

&nbsp;

## Use Foreign Keys

These are required for multi-table rules (sum, count, copy etc), and for multi-table pages.

If these are not in your database, you can add them in to the created data model class.  For example, find [`Employee.Manager` in `customize_models`, here](https://github.com/ApiLogicServer/demo/tree/main/database){:target="_blank" rel="noopener"}.

&nbsp;

## Foreign Key Indices

In general, add indices for your Foreign Keys.  Note performance may be fine in dev, but degrade when product data volumes are encountered (e.g., pre-production testing).

&nbsp;


## Initialize Stored Derivations

Recall that the logic engine uses [adjustments](../FAQ-RETE/#adjustments-sum-counts-adjusted-in-1-row-up){:target="_blank" rel="noopener"} to maintain aggregates, instead of expensive (possibly nested) aggregate queries.  This can result in order-of-magnitude performance advantage.

It does, however, rely currently stored values being accurate.  Logic will ensure *remains* true, but you must ensure it's *initially* true.  Introducing stored aggregates in an existing database with existing rows requires you initialize new sums and counts.

For example, let's assume you introduced the `Customer.Balance` as a new column in the northwind [sample database](../Sample-Database).  You'd need to initialize the Balance like this:

```sql
update Customer set Balance = (select AmountTotal from "Order" where Customer.Id = CustomerId and ShippedDate is null);

# Then, verify with:
select CompanyName, Balance from Customer where Id="ALFKI";
```
