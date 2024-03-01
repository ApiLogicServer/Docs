---
title: API Logic Server
Description: Instantly Create and Run Database Projects - Flask, APIs, SQLAlchemy, React Apps, Rules, Low-Code
---
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>
[![Downloads](https://static.pepy.tech/badge/apilogicserver)](https://pepy.tech/project/apilogicserver)
[![Latest Version](https://img.shields.io/pypi/v/apilogicserver.svg)](https://pypi.python.org/pypi/apilogicserver/)
[![Supported Python versions](https://img.shields.io/pypi/pyversions/apilogicserver.svg)](https://pypi.python.org/pypi/apilogicserver/)

[![API Logic Server Intro](images/hero-banner.png)](#instant-evaluation-no-install "Click for instant cloud-based, no-install eval")


&nbsp;

!!! pied-piper ":bulb: Instant Microservices, for Integration and App Backends"

    For Developers and their organizations seeking to **increase business agility,**

    API Logic Server provides ***Microservice Automation:*** create executable projects with *1 command*:
    
    1. ***API Automation:*** crud for each table, with pagination, optimistic locking, filtering and sorting, and
    2.  ***App Automation:*** a multi-page, multi-table Admin App.  <br>

    **Customize in your IDE:** use standard tools (Python, Flask, SQLAlchemy, GitHub and Docker), plus<br>

    3. ***Logic Automation:*** unique **rules - 40X** more concise multi-table derivations and constraints.

    Unlike frameworks, weeks-to-months of complex development is no longer necessary.  <br>
    API Logic Server provides unique automation **for instant integrations and app backends**.


---

&nbsp;

# Overview - Videos, Tour

API Logic Server is an open source Python project.  It is a **CLI** for project creation, and set of **runtimes** (SAFRS API, Flask, SQLAlchemy ORM, business logic engine) for project execution.

It runs as a standard pip install, or under Docker. For more on API Logic Server Architecture, [see here](Architecture-What-Is.md){:target="_blank" rel="noopener"}.

Explore it below.

<details markdown>

<summary>See Microservice Automation (40 sec) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Click Here</summary>

See how **Microservice Automation** creates and runs a microservice - a multi-page app, and an API. 

* Here is a microservice -- api and admin app - **created / running in 5 seconds**

    * It would be similar for your databases

* Then, customize in your IDE with Python and **Logic Automation:** spreadsheet-like rules

![quick tour](images/nutshell/gif.gif)

</details>

<details markdown>

<summary>Video Tutorial (6 min)</summary>

&nbsp;

Click the image below for a video tutorial, showing complete project creation, execution, customization and debugging ([instructions here](Tech-Agile.md){:target="_blank" rel="noopener"}).  Or, see it using AI: [click here](Tutorial-AI.md).

[![Microservice Automation](images/sample-ai/ai-driven-automation-video.png)](https://youtu.be/-7aZPWz849I "Microservice Automation"){:target="_blank" rel="noopener"}

</details>



<details markdown>

<summary>Quick Screenshot Tour of using API Logic Server: Create, Run, Customize</summary>

&nbsp;

**1. Create: *Microservice Automation***

Create executable, [customizable projects](Project-Structure.md){:target="_blank" rel="noopener"} instantly:

* ***Microservice Automation*** means create projects with a single CLI command

```bash
ApiLogicServer create --project_name=ApiLogicProject --db_url=nw
```

&nbsp;

**2. Run: *API Automation and App Automation***

Microservice Automation creates a project that is *executable,* with:

* ***API Automation*** means you have a running [**JSON:API**](API.md){:target="_blank" rel="noopener"}
* ***App Automation*** means you have a running [**Admin App**](Admin-Tour.md){:target="_blank" rel="noopener"}

> The API **unblocks UI Developers** from waiting on lengthy API development cycles.
<br>The Admin App can be used for **instant business user collaboration**.
<details markdown>

<summary>See JSON:API and Admin App</summary>

&nbsp;

You can run directly (`python api_logic_server_run.py`), or open it in your IDE and use the pre-created run configurations:

![Admin App](images/ui-admin/Order-Page.png)

Unlike frameworks which require significant time and expertise, the create command builds a complete API for your database, with endpoints for each table, including swagger.  The Admin App provides a link to the Swagger:

![Swagger](images/api/swagger-get-data.png)

</details>

&nbsp;

**3. Customize: Logic Automation, Python Flexibility**

Customize created projects in your IDE, with Python and standard libaries.  Significantly, Microservice Automation also includes:.

* ***Logic Automation*** means you customize logic using **Rules and Python** in your IDE

> Rules are unique and confer **significant business agility** - [40X more concise than code](Logic-Why.md){:target="_blank" rel="noopener"}, <br>for security and multi-table derivation and constraints.


<details markdown>

<summary>See Logic With Rules and Python</summary>

&nbsp;

Rules are 40X more concise than code, and are extensible with Python:

![Logic](images/logic/5-rules-cocktail.png)

For more on customization, [click here](IDE-Customize.md#customize){:target="_blank" rel="noopener"}.

</details>

&nbsp;

> Customization also provides **no-code ad hoc integrations**,<br>and enables **Instant Business Relationships.**

<details markdown>

<summary>See Integration: APIs and Messages</summary>

&nbsp;

The automatically created JSON:API provides **no-code ad hoc integrations**, enabling organizations to move beyond ETL.  For example, other applications might require a customer record, and their addresses.  The automatically created self-serve JSON:API requires no code, and reduces future custom API development:

1. Create the JSON:API
2. Declare [security](Security-Overview.md){:target="_blank" rel="noopener"}, to control access and row level authorization

Integrate with B2B Partners by creating **custom endpoints** using Python and Flask, with under 10 lines of code.  *Instant business relationships.*  Observe that:

1. Update logic is partitioned out of each service - or UI - into shared [Logic](Logic.md){:target="_blank" rel="noopener"}
2. Mapping between SQLAlchemy rows and requests is automated with the [RowDictMapper](Integration-Map.md){:target="_blank" rel="noopener"}

![APIs](images/integration/dict-to-row.jpg)

<br>

Integrate internal systems with **Kafka**, using business logic events:

![Messages](images/integration/order-to-shipping.jpg)

For more on integration, explore running code in the [Application Integration Sample Tutorial](Sample-Integration.md){:target="_blank" rel="noopener"}.

</details>

</details>

---

&nbsp;

# Scenarios

<details markdown>

<summary>Application Integration</summary>

As illustrated below, API Logic Server supports transactions from User Interfaces, and 3 alternatives for Application Integration:

1. **Ad Hoc Integration:** the automatically created JSON:API provides **no-code ad hoc integrations**, enabling organizations to move beyond ETL.  For example, other applications might require a customer record, and their addresses from an existing database.

    * *JSON:API* are a standard for self-serve APIs -- where clients can select the columns and the related data they require.

    * Analogous to GraphQL, self-serve APIs reduce the need for ongoing custom API development.

2. **B2B Partners:** you can use Python, Flask and SQLAlchemy to create Custom APIs, e.g. for B2B Partners.  These are simplified by automatic reuse of [Logic](Logic-Why.md){:target="_blank" rel="noopener"}, and [Integration Mapping](Integration-Map.md){:target="_blank" rel="noopener"}.

3. **Messages:** Application Integration support also provides automation for producing and consuming Kafka messages.  Here's an article: [click here](https://dzone.com/articles/instant-integrations-with-api-automation){:target="_blank" rel="noopener"}.  To see these services in a tutorial, [click here](Sample-Integration.md){:target="_blank" rel="noopener"}.

![API Logic Server](images/nutshell/als-nutshell.png)

</details>


<details markdown>

<summary>Unblock Client App Dev</summary>

Framework-based API development is time-consuming and complex.  Since client App Dev depends on APIs, front-end dev is often blocked.  This serialized dev process reduces business agility, and increases pressure on the team.

API Logic server can change that.  

1. **API Automation** means client App Dev can start as soon as you have a database

2. **Logic Automation** means that

    1. Such logic - a substantial element of the system - is **automatically partitioned** out of each client into server-based logic.  This reduces client coding, and enables the logic to be shared between user interfaces and services.
    2. Logic development can proceed **in parallel** with client App Dev

Here's an [article, here](https://dzone.com/articles/instant-app-backends-with-api-and-logic-automation){:target="_blank" rel="noopener"}.  Or, the the [Tutorial, here](Tutorial.md){:target="_blank" rel="noopener"}.

</details>


<details markdown>

<summary>Instant Microservices with AI-Driven Schema Automation</summary>

API and Logic Automation begins with a database.  But what if it's a new project, and there is no database.

You can certainly use your SQL tools.  But we all know that SQL can be... tiresome.

AI provides a solution: ***Schema Automation***.  You can use ChatGPT to create the SQL DDL like this:

!!! pied-piper "Create database definitions from ChatGPT"

    Create a sqlite database for customers, orders, items and product
    
    Hints: use autonum keys, allow nulls, Decimal types, foreign keys, no check constraints.

    Include a notes field for orders.

    Create a few rows of only customer and product data.

    Enforce the Check Credit requirement:

    1. Customer.Balance <= CreditLimit
    2. Customer.Balance = Sum(Order.AmountTotal where date shipped is null)
    3. Order.AmountTotal = Sum(Items.Amount)
    4. Items.Amount = Quantity * UnitPrice
    5. Store the Items.UnitPrice as a copy from Product.UnitPrice

Then, employ API Logic Server API and Logic Automation, and use Python and standard frameworks to finish the job.

Here's a tutorial you can to explore this: [click here](Sample-AI.md){:target="_blank" rel="noopener"},or see [this article](https://dzone.com/articles/ai-and-rules-for-agile-microserves){:target="_blank" rel="noopener"}.

</details>

&nbsp;
For additional Use Cases, [click here](Product-Detail.md/#use-cases){:target="_blank" rel="noopener"}.

---

&nbsp;

# Start: Install, Samples, Training

<details markdown>

<summary>Install</summary>

If you have the Python (version 3.8-3.11), install is standard ([more detailed instructions are here](Install-Express.md){:target="_blank" rel="noopener"}), typically:

```bash title="Install API Logic Server in a Virtual Environment"
python -m venv venv                  # may require python3 -m venv venv
source venv/bin/activate             # windows: venv\Scripts\activate
python -m pip install ApiLogicServer
```

Then explore the *demos, samples and tutorials*, below.

</details>

<details markdown>

Type:

* Demo: Small Databases, Introduces Key Features
* Tutorial: Detailed Walk-throughs
* Samples: other databases (brief description)

> Recommendation: **start with the first 2 items**

<summary>Demos, Tutorials, Samples</summary>

| Project | Notes   |  Type  |
:-------|:-----------|:-------|
| [**AI Sample**](Sample-AI.md){:target="_blank" rel="noopener"} | 1. Use ChatGPT to create new databases from natural language<br>2. Illustrate a very rapid create / customize / iterate cycle<br>3. Introduce Integration | Demo |
| [**Tutorial**](Tutorial.md){:target="_blank" rel="noopener"}  | 1. How to Use the Key Features<br>2. Key code samples for adapting into your project | Tutorial |
| | | |
| [App Integration](Sample-Integration.md){:target="_blank" rel="noopener"} | Illustrates *running* Kafka messaging, self-serve and customized APIs, choreographed with rules and Python | Tutorial |
| [Deployment](Tutorial-Deployment.md){:target="_blank" rel="noopener"} | Containerize and deploy your applications | Tutorial |
| [Agile](Tech-Agile.md){:target="_blank" rel="noopener"} | Behavior Driven Design and testing, using Behave | Tutorial |
| [AI Drives Agile Vision](Tech-AI.md){:target="_blank" rel="noopener"} | Use ChatGPT to create new databases from natural language, to bootstrap an agile create / deploy and collaborate / iterate cycle | Demo |
| [Basic Demo](Sample-Basic-Demo.md){:target="_blank" rel="noopener"} | Focused use of API, Admin App and Rules on small customer/orders database | Demo |
| [Allocation](Logic-Allocation.md){:target="_blank" rel="noopener"} | *Power Rule* to allocate a payment to a set of outstanding orders | Sample |
| [MySQL Docker](Database-Connectivity.md){:target="_blank" rel="noopener"} | Create projects from sample databases: *chinook* (albums and artists), and *classicmodels* (customers and orders) | Sample |
| Sqlite databases | Create projects from pre-installed databases via [abbreviations](Data-Model-Examples.md){:target="_blank" rel="noopener"}:<br>- chinook, classicmodels, todo | Sample |
| [BudgetApp](Tech-Budget-App.md){:target="_blank" rel="noopener"} | illustrates automatic creation of parent rows for rollups | Sample |


Finally, try your own database.

</details>


<details markdown>

<summary> Training </summary>

After installing, you can optionally run the first demo, above.  The key training activities are:

1. Perform the [**Tutorial**](Tutorial.md){:target="_blank" rel="noopener"}
    * `ApiLogicServer create --project_name= --db_url=`
    * Keep this project installed; you can find code samples by searching `#als`
2. Perform [**Logic Training**](Logic.md){:target="_blank" rel="noopener"}
    * Spreadsheet-like rules and Python for integration, and multi-table derivations / constraints
3. **API Customization:** explore the code in `api/customize_api.py`
    * Note this is largely standard Flask, enhanced with logic

</details>

<details markdown>

<summary> Resources </summary>

You might find the following helpful in exploring the project:

* **Installed Sample Databases** -
Here are [some installed sample databases](Data-Model-Examples.md){:target="_blank" rel="noopener"} you can use with simplified abbreviations for `db_url`.

* **Dockerized Test Databases** - 
Then, you might like to try out some of our [dockerized test databases](https://valhuber.github.io/ApiLogicServer/Database-Connectivity.md){:target="_blank" rel="noopener"}.

* [auth](Security-Authentication-Provider.md#sqlite-auth-provider){:target="_blank" rel="noopener"} - sqlite authentication database (you can also use other DBMSs)

</details>

<details markdown>

<summary> Release Notes </summary>

02/24/2024 - 10.03.04: Issue 45 (RowDictMapper joins), Issue 44 (defaulting), Issue 43 (rebuild no yaml), Tests

02/13/2024 - 10.02.04: kafka_producer.send_kafka_message, sample md fixes, docker ENV, pg authdb

02/07/2024 - 10.02.00: BugFix[38]: foreign-key/getter collision

01/31/2024 - 10.01.28: LogicBank fix, sample-ai, better rules example

01/15/2024 - 10.01.18: Cleanup, logic reminder, nw tutorial fixes

01/08/2024 - 10.01.07: Default Interpreter for VS Code, Allocation fix, F5 note fix, #als signposts

01/03/2024 - 10.01.00: Quoted col names, Default Interpreter for VS Code

12/21/2023 - 10.00.01: Fix < Python 3.11

12/19/2023 - 10.00.00: Kafka pub/sub, Data Type Fixes

12/06/2023 - 09.06.00: Oracle Thick Client, Safrs 3.1.1, Integration Sample, No rule sql logging, curl Post

11/19/2023 - 09.05.14: ApiLogicServer curl, optional project_name arg on add-auth, add-db, rebuild

11/12/2023 - 09.05.08: multi-db bug fix (24)

11/07/2023 - 09.05.07: Basic-demo: simplify customization process

11/05/2023 - 09.05.06: Basic-demo enhancements, bug fixes (22, 23)

10/31/2023 - 09.05.00: Enhanced Security (global filter, permissions), Logic (Insert Parent)

09/29/2023 - 09.04.00: Enhanced devops automation (sqlite, MySql, Postgres)

09/08/2023 - 09.03.04: AI Driven Automation (preview)

09/08/2023 - 09.03.00: Oracle support

09/08/2023 - 09.02.23: Fix Issue 16 - Incorrect admin.yml when table name <> class name

08/22/2023 - 09.02.18: Devops container/compose, Multi-arch dockers, add-auth with db_url, auth docker dbs

07/04/2023 - 09.01.00: SQLAlchemy 2 typed-relns/attrs, Docker: Python 3.11.4 & odbc18

06/22/2023 - 09.00.00: Optimistic Locking, safrs 310 / SQLAlchemy 2.0.15

05/07/2023 - 08.04.00: safrs 3.0.4, tutorial demo notes, rm cli/docs, move pythonanywhere

05/01/2023 - 08.03.06: allocation sample

04/29/2023 - 08.03.03: restore missing debug info for open database failures

04/26/2023 - 08.03.00: virt attrs (Issue 56), safrs 3.0.2, LogicBank 1.8.4, project readme updates

04/13/2023 - 08.02.00: integratedConsole, logic logging (66), table relns fix (65)

03/23/2023 - 08.01.15: table filters, cloud debug additions, issue 59, 62-4

02/15/2023 - 08.00.01: Declarative Authorization and Authentication

01/05/2023 - 07.00.00: Multi-db, sqlite test dbs, tests run, security prototype, env config

11/22/2022 - 06.03.06: Image, Chkbox, Dialects, run.sh, SQL/Server url change, stop endpoint, Chinook Sqlite

10/02/2022 - 06.02.00: Option infer_primary_key, Oct1 SRA (issue 49), cleanup db/api setup, restore postgres dvr

09/15/2022 - 06.01.00: Multi-app Projects

08/28/2022 - 06.00.01: Admin App show_when, cascade add. Simplify Codespaces swagger url & use default config

06/12/2022 - 05.02.22: No pyodbc by default, model customizations simplified, better logging

05/04/2022 - 05.02.03: alembic for database migrations, admin-merge.yaml

04/27/2022 - 05.01.02: copy_children, with support for nesting (children and grandchildren, etc.)

03/27/2022 - 05.00.06: Introducing [Behave test framework](https://apilogicserver.github.io/Docs/Logic-Tutorial/), LogicBank bugfix

12/26/2021 - 04.00.05: Introducing the Admin app, with Readme Tutorial

</details>

<details markdown>

<summary> Preview Version </summary>

&nbsp;

This pre-release includes:

* Support for parent fields in RowDictMapper (see issues - breaking change)

You can try it at (you may need to use `python3`):

```bash
python -m pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple ApiLogicServer==10.03.10
```

Or use (neither available currently):

```bash
docker run -it --name api_logic_server --rm -p 5656:5656 -p 5002:5002 -v ~/dev/servers:/localhost apilogicserver/api_logic_server_x
```

Or, you can use [the beta version on codespaces](https://github.com/ApiLogicServer/beta){:target="_blank" rel="noopener"}.

</details>

---

&nbsp;

# Key Features

<details markdown>

<summary>API Features</summary>

| Feature | Notes   |
:-------|:-----------|
| API Automation | Unlike Frameworks, API created automatically |
| Logic | Update requests automatically enforce relevant logic |
| Security | Role-based result filtering |
| [Self-Serve JSON:API](API.md){:target="_blank" rel="noopener"} | UI Developers and Partners don't require API Dev |
| Standards-based | JSON:API |
| Optimistic Locking | Ensure User-1 does not overwrite changes from User-2 |
| Multi-table | Retrieve related data (e.g. customers, *with orders*) |
| Pagination | Performance - deliver large result sets a page at a time |
| Filtering | Injection-safe filtering |

</details>

<details markdown>

<summary>Logic Features</summary>

| Feature | Notes   |
:-------|:-----------|
| Conciseness | Rules reduce the backend half your system by 40X |
| Automatic Ordering | Simplifies Maintenance |
| Automatic Optimization | Reduce SQLs by pruning and adjustment-based aggregates |
| Automatic Invocation | Rules called automatically to help ensure quality |
| Multi-Field | Formulas and contraints can access parent data, with optional cascade |
| Multi-table | Sum / Count Rules can aggregate child data, with optional qualification |
| Extensible | Formulas, Constraints and Events can invoke Python |
| Debugging | Use IDE Debugger, and logic log to see which rules fire |

</details>

<details markdown>

<summary>Security Features</summary>

| Feature | Notes   |
:-------|:-----------|
| Authentication | Control login access |
| Authorization | Row level access based on roles, or user properties |
| Authorization | Global filters (e.g, multi-tenant) |
| Extensible | Use sql for authentication, or your own provider |

</details>

<details markdown>

<summary>Admin App Features</summary>

| Feature | Notes   |
:-------|:-----------|
| App Automation | Unlike frameworks, Multi-Page App is created automatically |
| Multi-Table - Parents | Automatic Joins (e.g., Items show Product Name, not Product Id) |
| Multi-Table - Children | Parent pages provide tab sheets for related child data (e,g, Customer / Order List) |
| Lookups | E.g., Item Page provides pick-lists for Product |
| Cascade Add | E.g., Add Order defaults the Customer Id |
| Declarative Hiding | Hide fields based on expression, or insert/update/delete state |
| Intelligent Layout | Names and join fields at the start, Ids at the end
| Simple Customization | Simple yaml file (not complex html, framework, JavaScript) |
| Images | Show image for fields containing URLs |
| Data Types | Define customfields for your data types |

</details>

<details markdown>

<summary>Other Features</summary>

| Feature | Notes   |
:-------|:-----------|
| Microservice Automation | One-command API / App Projects |
| [Application Integration](Sample-Integration.md){:target="_blank" rel="noopener"} | Automation with APIs and Kafka Messages |
| [AI-Driven Automation](Sample-AI.md){:target="_blank" rel="noopener"} | Use ChatGPT to automate database creation |
| [Multiple Databases](Data-Model-Multi.md){:target="_blank" rel="noopener"} | Application Integration |
| [Deployment Automation](Tutorial-Deployment.md){:target="_blank" rel="noopener"} | Automated Container Creation, Azure Deployment |

</details>

---

&nbsp;

# Works With

<details markdown>

<summary>API Logic Server works with key elements of your existing infrastructure</summary>

| Works With | Notes   |
:-------|:-----------|
| [AI](Tutorial-AI.md){:target="_blank" rel="noopener"} | Use ChatGPT to create databases, and use API Logic Server to turn these into projects |
| [Other Systems](Sample-Integration.md){:target="_blank" rel="noopener"} | APIs and Messages - with logic |
| [Databases](Database-Connectivity.md){:target="_blank" rel="noopener"} | Tested with MySQL, Sql/Server, Postgres, SQLite and Oracle |
| Client Frameworks | Creates instant APIs that factors out business logic, where it is automatically shared for User Interfaces, APIs, and Messages |
| [Your IDE](IDE-Customize.md){:target="_blank" rel="noopener"} | Creates standard projects you can customize in your IDE, such as VSCode and PyCharm |
| [Messaging](Sample-Integration.md){:target="_blank" rel="noopener"} | Produce and Consume Kafka Messages
| [Deployment](Tutorial-Deployment.md){:target="_blank" rel="noopener"} | Scripts to create container images, and deploy them to the cloud |
| [Agile and Test Methodologies](Logic-Tutorial.md){:target="_blank" rel="noopener"} | Use Behave to capture requirements, rapidly implement them with API Logic Server, collaborate with Business Users, and test with the Behave framework |

</details>

---

&nbsp;

# Contact Us

We'd love to hear from you:

1. Email: apilogicserver@gmail.com
2. Issues: [github](https://github.com/ApiLogicServer/ApiLogicServer-src/issues){:target="_blank" rel="noopener"}
3. Slack: [https://apilogicserver.slack.com](https://join.slack.com/t/apilogicserver/signup?x=x-p3388652117142-3395302306098-5241761647201)

---

&nbsp;

# More Information

<details markdown>

<summary>Acknowledgements</summary>

Many thanks to

- [Thomas Pollet](https://www.linkedin.com/in/pollet/), for SAFRS, SAFRS-react-admin, and invaluable design partnership
- Tyler Band, for leadership on security
- [Marelab](https://marmelab.com/en/), for [react-admin](https://marmelab.com/react-admin/)
- Armin Ronacher, for Flask
- Mike Bayer, for SQLAlchemy
- Alex Grönholm, for Sqlacodegen
- Thomas Peters, for review and testing
- [Meera Datey](https://www.linkedin.com/in/meeradatey/), for React Admin prototyping
- Denny McKinney, for Tutorial review
- Achim Götz, for design collaboration and testing
- Max Tardiveau, for testing and help with Docker
- Michael Holleran, for design collaboration and testing
- Nishanth Shyamsundar, for review and testing
- Gloria Huber and Denny McKinney, for doc review

</details>

<details markdown>

<summary>Articles</summary>

There are several articles that provide some orientation to API Logic Server:

* [Instant App Backends With API and Logic Automation](https://dzone.com/articles/instant-app-backends-with-api-and-logic-automation)
* [Instant Integrations With API and Logic Automation](https://dzone.com/articles/instant-integrations-with-api-automation)
* [AI and Rules for Agile Microservices in Minutes](https://dzone.com/articles/ai-and-rules-for-agile-microserves)

Also:

* [How Automation Activates Agile](https://modeling-languages.com/logic-model-automation/)
* [How Automation Activates Agile](https://dzone.com/articles/automation-activates-agile) - providing working software rapidly drives agile collaboration to define systems that meet actual needs, reducing requirements risk
* [How to create application systems in moments](https://dzone.com/articles/create-customizable-database-app-systems-with-1-command)
* [Stop coding database backends…Declare them with one command.](https://medium.com/@valjhuber/stop-coding-database-backends-declare-them-with-one-command-938cbd877f6d)
* [Instant Database Backends](https://dzone.com/articles/instant-api-backends)
* [Extensible Rules](https://dzone.com/articles/logic-bank-now-extensible-drive-95-automation-even) - defining new rule types, using Python
* [Declarative](https://dzone.com/articles/agile-design-automation-how-are-rules-different-fr) - exploring _multi-statement_ declarative technology
* [Automate Business Logic With Logic Bank](https://dzone.com/articles/automate-business-logic-with-logic-bank) - general introduction, discussions of extensibility, manageability and scalability
* [Agile Design Automation With Logic Bank](https://dzone.com/articles/logical-data-indendence) - focuses on automation, design flexibility and agile iterations
* [Instant Web Apps](https://dzone.com/articles/instant-db-web-apps)
</details>