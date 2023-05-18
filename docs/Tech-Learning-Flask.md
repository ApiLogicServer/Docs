There is a conventional approach to learning a framework such as Flask.  **Learn** with a Tutorial, ***then* build,** starting small, gradually increasing functionality. There are dozens to hundreds of such Tutorials, and they are very helpful.

Here we offer a complementary approach, one that entirely reverses the script.  **Build** a *complete running project* - explore within a minute.  ***Then* learn:** alter it, debug it -- and then how to *create* it, *in seconds*.
<br><br>

We call it an **API Fiddle** - [try it here](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=641207071), described below.

---

&nbsp;

## API Fiddle: an *In Action* Flask Tutorial

Tools like JSFiddle are extremely useful.  Without installation, you can use your Browser to explore existing JavaScript / HTML code, alter it, and see the results.

Here, we apply this approach to an entire app: an [***API* Fiddle**](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=641207071).  What's that?

* Like a JSFiddle, it **opens in your Browser.  No install.**
* But it's a **complete Flask App:** a running project, with a database, accessed with SQLAlchemy.
* **Accessed via VSCode**, *running in your Browser*, courtesy Codespaces.
    * Codespaces is a remarkable new product from GitHub.  When you click the link above, it requisitions a server, installs your project (and all its dependencies, such as Python and Flask), and opens it in VSCode *in your Browser*.
    * You can also use this API Fiddle learn how to use Codespaces - how to set up a dev container, and use it on your own projects.

The link (at the end) actually opens 2 projects.  The first is a minimal Flask/SQLAlchemy app.  It has a readme - use it to explore the code, run it, alter / debug it, etc.  The other illustrates how API Logic Server *creates* executable, customizable Flask projects, with a single command.

&nbsp;

## Deliver *While Learning*

But that's not all.

Two additional projects are provided in the API Fiddle.  These show how you can create a Flask project with a single command, then customize it in your IDE with standard Flask and SQLAlchemy, with API Logic Server.

API Logic Server is an open source Python app, already loaded into our Codespace project.  It creates an entire Flask project, like this:

```bash title="Create a Flask project with this command"
ApiLogicServer create --project_name=ApiLogicProject --db_url=nw-  # use Northwind, no customizations
```

This reads your database schema and creates a complete, executable Flask project, *instantly:*

* **API:** an endpoint for each table, with filtering, sorting, pagination and related data access.  Swagger is automatic.

* **Admin UI:** multi-page / multi-table apps, with page navigations, automatic joins and declarative hide/show.

* **Customizable:** use your IDE, Flask and SQLAlchemy to customize your project, including unique delarative spreadsheet-like rules for logic and security.  Custom UIs can be built using your tool of choice (React, Angular, etc), using the API.

&nbsp;

## Intrigued?

[Click here to start it](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=641207071)  (takes about a minute to load).  We'd love feedback - provide it [here](https://github.com/valhuber/ApiLogicServer/issues).
