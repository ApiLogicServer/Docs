There is a conventional approach to learning a framework such as Flask: start with a Tutorial, build something small, and gradually increase your knowledge.  There are dozens to hundreds of such Tutorials, and they are very helpful.

Here we offer a complementary approach.  It's based on a ***running project*** you can explore within a minute, to learn how it works -- and how to create it, *in seconds*.

&nbsp;

## App Fiddle: an *In Action* Flask Tutorial

Tools like JSFiddle are extremely useful.  Without installation, you can use your Browser to explore existing JavaScript / HTML code, alter it, and see the results.

Here, we apply this approach to an entire app: an ***App Fiddle*** (link at the end).

* Like a JSFiddle, it **opens in your Browser.  No install.**
* But it's a **complete Flask App:** a running project, with a database, accessed with SQLAlchemy.
* **Accessed via VSCode**, *running in your Browser*, courtesy Codespaces.
    * Codespaces is a remarkable new product from GitHub.  When you click the link above, it requisitions a server, installs your project (and all its dependencies, such as Python and Flask), and opens it in VSCode *in your Browser*.
    * You can also use this App Fiddle to explore Codespaces, how to set up a dev container, and use it on your own projects.

The link (at the end) actually opens 3 projects.  The first is a minimal Flask/SQLAlchemy app.  It has a readme - use it to explore the code, run it, alter / debug it, etc.

&nbsp;

## Deliver *While Learning*

But that's not all.

While the first project shows it's pretty simple to create a single endpoint, gather some data and return it, it's a *lot* more work to create an entire project (multiple endpoints, an Admin App, etc).

So, we've created API Logic Server.  It's an open source Python app, already loaded into our Codespace project.

It creates an entire Flask project with a single command, like this:

```bash
ApiLogicServer create --project_name=ApiLogicProject --db_url=nw-  # use Northwind, no customizations
```

This reads your database schema and creates a complete, executable project, *instantly:*

* **API:** an endpoint for each table, with filtering, sorting, pagination and related data access.  Swagger is automatic.


* **Admin UI:** multi-page / multi-table apps, with page navigations, automatic joins and declarative hide/show.  It executes a yaml file, so basic customizations do not require HTML or JavaScript background.

    * Custom UIs can be built using your tool of choice (React, Angular, etc), using the API.<br><br>


&nbsp;

## Fully Customizable - Standard Python, Flask, SQLAlchemy

The created project is a standard Flask/SQLAlchemy project.  Customize and extend it with all the fundamentals learned in Tutorials and App Fiddle.

&nbsp;

## Unique Spreadsheet-like Business Rules

As a experienced app developer, I think of projects as about half backend and half frontend.  Your mileage may vary, but the backend is certainly a lot of work:

* multi-table derivations and constraints applied on update
    * E.g. the customer's balance - the sum of the unpaid order totals - cannot exceed 
the credit limit


* authorization and authentication
    * E.g., users must enter a valid id and password to gain access
    * And, their roles determine what database rows they see (e.g., a multi-tenant application)

API Logic Server enables you to ***declare spreadsheet-like rules*** to implement these.  Rules are a very significant technology, but perhaps the most striking characteristic is that they are *40X more concise than code*.  You can read more about rules [here](Logic-Why).

The third project in the fiddle illustrates both the rules, and some "standard" Flask/SQLAlchemy customizations.  A tutorial is included to help you explore these, run them, see how to debug them, etc.

&nbsp;

## Intrigued?

[Click here to start it](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=594296622)  (takes about a minute to load).
