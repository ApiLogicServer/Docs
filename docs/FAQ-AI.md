## TL;DR - AI... with business-oriented models

![Failure to Communicate](images/sample-ai/copilot/failure-to-communicate.png){: style="height:200px;width:250px"; align=right }
AI has proven to be a powerful tool for automating function-level coding.  However, creating complete sub-systems is less successful, requiring language input for low-level implementation details.  These require substantial skill (e.g., detailed knowledge of a framework), and result in systems that are difficult to maintain.  In short, a **failure to communicate**.  

By introducing high-level ***business-oriented language***, it becomes possible to create complete systems.  API Logic Server uses AI to create complete systems from high-level business logic, without requiring detailed language input.  

These systems are then maintained at a high level of abstraction through created executable models.  The resultant systems are easy to maintain, and extend where necessary using standard languages and tools.  This approach is unique in the industry, and has been proven in a wide range of applications.



<details markdown>

<summary>Does GenAI require Microservice Automation?</summary>

GenAI brings well-known value to app development.  It's great for generating code snippets, including code snippets for *driving other sub-systems,* such as sql (e.g., "*create a database...*").  API Logic Server leverages both of these strengths.

While GenAI is great for *driving sub-systems* (like sql), it's not appropriate for *creating sub-systems.*  For example, you would not want to generate a DBMS using GenAI.

But what about microservices - APIs, and their logic?  It is like code snippets, or more like a sub-system?  We investigated GenAI API and logic creation, and here's what we found...

&nbsp;

**1. GenAI for APIs**

It is possible to create rudimentary APIs using GenAI.   However:

1. **Not enterprise-class:** the APIs are incomplete or incorrect for required features such as security, fitering, pagination, optimistic locking, etc.  For example, this filtering code only works for the primary key, and pagination is stubbed out:

```python
# Endpoint to get customers with filtering and pagination
@app.route('/customers', methods=['GET'])
def get_customers():
    page = int(request.args.get('page', 1))
    per_page = int(request.args.get('per_page', 10))
    query = session.query(Customer)
    customers = paginate(query, page, per_page).all()
    return jsonify([{'id': c.id, 'name': c.name, 'email': c.email, 'phone': c.phone} for c in customers])
```

2. **Complex:** it requires a great deal of prompt engineering to "program" the target framework to get a better result.  That requires detailed knowledge of the target -  *failure to communicate* - defeats the simplicity objective of using GenAI.

&nbsp;

---

**2. GenAI for Logic**

In most cases, GenAI responses simply ignores the logic requirement.  *Attempts* to address it fall in 3 categories: triggers, Logic Bank code with no context,  and Logic Bank code *with* context.

&nbsp;

**2a. Logic: Triggers**

The trigger solution GenAI response typically looks something like this:

```sql
-- Note: The enforcement of the Check Credit requirement is complex and might be better handled in application logic.
-- However, you can create a stored procedure or use triggers to enforce these rules, keeping in mind the performance implications.

-- Example of a trigger to enforce Customer.balance <= credit_limit (simplified version)
DELIMITER //
CREATE TRIGGER CheckCreditBeforeCustomerUpdate
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF NEW.Balance > NEW.Credit_Limit THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer balance exceeds credit limit.';
    END IF;
END;
//
DELIMITER ;
```

This is simply not a solution: it does not address the triggering event - some change to the order.  By contrast, our logic automates about a dozen Use Cases, including:

* The customer balance is adjusted (and credit is checked) when an order is inserted, deleted, shipped, or re-assigned to a different customer.  Importantly, the logic (and its overhead) is pruned on other changes, such as changing the shipping address.

* This dependency management chains: the *order* is adjusted when items are inserted, deleted, or updated with new quantities or different products.

Addressing this level of logic is why rules are 40X more concise than code.

&nbsp;

**2b. Logic: Logic Bank, without context**

If we engineer our prompt to suggest using Logic Bank (a component of API Logic Server), we get a response like this if there is no project context:

```python
def declare_logic():
    LogicBank.activate(session=session, activator=logic_bank_util.register_rules)

    @LogicBank.rule("order", "before_flush")
    def order_amount_total(row: LogicRow):
        row.amount_total = sum([item.quantity * item.unit_price for item in row.items])

    @LogicBank.rule("customer", "before_flush")
    def customer_balance(row: LogicRow):
        row.balance = sum([order.amount_total for order in row.orders if order.date_shipped is None])

    @LogicBank.rule("item", "before_flush")
    def item_amount(row: LogicRow):
        row.amount = row.quantity * row.unit_price

    @LogicBank.rule("item", "before_flush")
    def copy_unit_price_from_product(row: LogicRow):
        row.unit_price = row.product.unit_price

    @LogicBank.rule("customer", "before_flush")
    def check_credit_limit(row: LogicRow):
        if row.balance > row.credit_limit:
            raise Exception(f"Customer {row.name}'s balance exceeds their credit limit.")
```

There are no existing Logic Bank APIs remotely like those above.  This code does not even compile, much less run.  It is, as they say, an hallucination.

&nbsp;

**2c. Logic: Logic Bank, *With Context***

Excellent results are obtained when the prompt has available context.  Copilot turns our Natural Language requirements into Logic Bank code, requiring only minor adjustments.

And this is ***far* preferable** to generating logic code -- it's much better to understand and maintain the 5 rules than the 200 lines of generated code.

&nbsp;

**2d. Conclusion: Abstraction Level is Critical**

As perhaps expected, large scale sub-system creation from GenAI is not practical.  However, it is a great driver for engines, and for creating code snippets.  API Logic Server leverages these strengths, and provides the missing microservice logic automation.

Of course, the Logic Bank and SAFRS engines are required for actual execution, just as sql queries require a DBMS.  Watch it in the video below.
</details>
