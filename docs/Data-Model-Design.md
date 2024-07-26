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

Recall that the logic engine uses [adjustments](FAQ-RETE.md#adjustments-sum-counts-adjusted-in-1-row-up){:target="_blank" rel="noopener"} to maintain aggregates, instead of expensive (possibly nested) aggregate queries.  This can result in order-of-magnitude performance advantage.

It does, however, rely currently stored values being accurate.  Logic will ensure *remains* true, but you must ensure it's *initially* true.  Introducing stored aggregates in an existing database with existing rows requires you initialize new sums and counts.

For example, let's assume you introduced the `Customer.Balance` as a new column in the northwind [sample database](Sample-Database.md).  You'd need to initialize the Balance like this:

```sql
update Customer set Balance = (select AmountTotal from "Order" where Customer.Id = CustomerId and ShippedDate is null);

# Then, verify with:
select CompanyName, Balance from Customer where Id="ALFKI";
```

&nbsp;

## Relationship names

For each 1:N relationship, the system creates 2 SQLAlchemy relationship accessors.  For example, given a parent `Customer` and child `Order`, the system creates the following in `database/models.py`:

* parent accessor: from a child row object, retrieve its parent.  This is named with the parent class, so you can code:

```python title='parent accessor'
the_customer = the_order.customer()
```

* child accessor: 

&nbsp;

### Multi-reln

In the [sample database](Sample-Database.md){:target="_blank" rel="noopener"}, there are 2 relationships between `Department` and `Employee`.  The default names described above would clearly create name collisions.  These are avoided with 2 strategies:

* basic: the first relationship is named as above; subsequent accessor names are appended with a number (1, 2)

* advanced: if the foreign key is single-field, and ends with `id` or `_id`, the foreign key names is used:

```python title='advanced relationship names`

    # parent relationships (access parent) -- example: self-referential
    # .. https://docs.sqlalchemy.org/en/20/orm/self_referential.html
    Department : Mapped["Department"] = relationship(remote_side=[Id], back_populates=("DepartmentList"))

    # child relationships (access children)
    DepartmentList : Mapped[List["Department"]] = relationship(back_populates="Department")
    EmployeeList : Mapped[List["Employee"]] = relationship(foreign_keys='[Employee.OnLoanDepartmentId]', back_populates="OnLoanDepartment")
    WorksForEmployeeList : Mapped[List["Employee"]] = relationship(foreign_keys='[Employee.WorksForDepartmentId]', back_populates="WorksForDepartment")
```
