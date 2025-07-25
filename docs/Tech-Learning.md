There is a conventional approach to learning a framework such as Flask.  **Learn** with a Tutorial, ***then* build,** starting small, gradually increasing functionality. There are dozens to hundreds of such Tutorials, and they are very helpful.

Here we offer a complementary approach, one that entirely reverses the script.  **Build** a *complete running project* - explore within a minute.  ***Then* learn:** alter it, debug it -- and then how to *create* it, *in seconds*.
<br><br>

We call it an **App Fiddle** - [try it here](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=593459232).

---

&nbsp;

## App Fiddle: an *In Action* Flask Tutorial

Tools like JSFiddle are extremely useful.  Without installation, you can use your Browser to explore existing JavaScript / HTML code, alter it, and see the results.

![Flask Fiddle](images/vscode/app-fiddle/flask-fiddle.jpg){: style="height:150px;width:150px"; align=right }

Here, we apply this approach to an entire app: an [***App* Fiddle**](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=593459232).  What's that?

* Like a JSFiddle, it **opens in your Browser.  No install.**
* But it's a **complete Flask App:** a running project, with a database, accessed with SQLAlchemy.
* **Accessed via VSCode**, *running in your Browser*, courtesy Codespaces.
    * Codespaces is a remarkable new product from GitHub.  When you click the link above, it requisitions a server, installs your project (and all its dependencies, such as Python and Flask), and opens it in VSCode *in your Browser*.
    * You can also use this App Fiddle to explore Codespaces, how to set up a dev container, and use it on your own projects.

Click this link](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=593459232) to open a codespace containing 3 projects.  The first is a minimal Flask/SQLAlchemy app.  The other 2 illustrate how API Logic Server *creates* executable, customizable Flask projects, with a single command.

&nbsp;

## Deliver *While Learning*

But that's not all.

![Flask Fiddle](images/vscode/app-fiddle/horse-feathers.jpg){: style="height:150px;width:150px"; align=right }
While the first project shows it's pretty simple to create a single endpoint, gather some data and return it, it's a *lot* more work to create an entire project (multiple endpoints, an Admin App, etc).  That's a horse of an entirely different feather!

So, we've created API Logic Server.  It's an open source Python app, already loaded into our Codespace project.

It creates an entire Flask project with a single command, like this:

```bash title="Create a Flask project with this command"
ApiLogicServer create --project_name=ApiLogicProject --db_url=nw-  # use Northwind, no customizations
```

This reads your database schema and creates a complete, executable project, *instantly:*

* **API:** an endpoint for each table, with filtering, sorting, pagination and related data access.  Swagger is automatic.


* **Admin UI:** multi-page / multi-table apps, with page navigations, automatic joins and declarative hide/show.  It executes a yaml file, so basic customizations do not require HTML or JavaScript background.

    * Custom UIs can be built using your tool of choice (React, Angular, etc), using the API.<br><br>


&nbsp;

## Fully Customizable - Standard Python, Flask, SQLAlchemy

Creating the executable project requires no background in Flask, SQLAlchemy, or even Python.  In fact, you can use the created project to learn these technologies, by "fiddling" with a running system that's already delivering value (e.g, enabling custom UI dev, integration).

That's because the created project is a standard Flask/SQLAlchemy project. Customize and extend it with all the fundamentals you learned in conventional Tutorials, and in the App Fiddle, with your favorite IDE.

&nbsp;

## Unique Spreadsheet-like Business Rules

As a experienced app developer, I think of projects as about half backend and half frontend.  Your mileage may vary, but the backend is certainly a lot of work:

* multi-table derivations and constraints applied on update
    * E.g. the customer's balance - the sum of the unpaid order totals - cannot exceed 
the credit limit


* authorization and authentication
    * E.g., users must enter a valid id and password to gain access
    * And, their roles determine what database rows they see (e.g., a multi-tenant application)

API Logic Server enables you to ***declare spreadsheet-like rules*** to implement these.  [Rules](Logic-Why.md) are a very significant technology, but perhaps the most striking characteristic is that they are *40X more concise than code*.  These 5 rules represent the same logic as [200 lines of Python](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md):

```python title="5 Rules ~- 200 lines of code. Declare in IDE using code completion, debug in debugger."
Rule.constraint(validate=models.Customer,       # logic design translates directly into rules
    as_condition=lambda row: row.Balance <= row.CreditLimit,
    error_msg="balance ({row.Balance}) exceeds credit ({row.CreditLimit})")

Rule.sum(derive=models.Customer.Balance,        # adjust iff AmountTotal or ShippedDate or CustomerID changes
    as_sum_of=models.Order.AmountTotal,
    where=lambda row: row.ShippedDate is None)  # adjusts - *not* a sql select sum...

Rule.sum(derive=models.Order.AmountTotal,       # adjust iff Amount or OrderID changes
    as_sum_of=models.OrderDetail.Amount)

Rule.formula(derive=models.OrderDetail.Amount,  # compute price * qty
    as_expression=lambda row: row.UnitPrice * row.Quantity)

Rule.copy(derive=models.OrderDetail.UnitPrice,  # get Product Price (e,g., on insert, or ProductId change)
    from_parent=models.Product.UnitPrice)
```

The third project in the fiddle illustrates both the rules, and some "standard" Flask/SQLAlchemy customizations.  A tutorial is included to help you explore these, run them, see how to debug them, etc.

&nbsp;

## Intrigued?

[Click here to start it](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=593459232)  (takes about a minute to load).
