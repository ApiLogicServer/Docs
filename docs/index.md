---
title: API Logic Server
Description: Instantly Create and Run Database Projects - Flask, APIs, SQLAlchemy, React Apps, Rules, Low-Code
---

[![Downloads](https://pepy.tech/badge/apilogicserver)](https://pepy.tech/project/apilogicserver)
[![Latest Version](https://img.shields.io/pypi/v/apilogicserver.svg)](https://pypi.python.org/pypi/apilogicserver/)
[![Supported Python versions](https://img.shields.io/pypi/pyversions/apilogicserver.svg)](https://pypi.python.org/pypi/apilogicserver/)

[![API Logic Server Intro](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/hero-banner.png?raw=true)](https://apilogicserver.github.io/Docs/ "Single command creates executable, customizable Flask projects")

&nbsp;

# Welcome to API Logic Server - Docs (V8)

API Logic Server creates __executable, customizable Flask database projects:__

* Creation is __Instant:__ create _executable_ projects from your database with a _single_ command.  Projects are __highly functional,__ providing:

    * __API:__ an endpoint for each table, with filtering, sorting, pagination and related data access

    * __Admin UI:__ multi-page / multi-table apps, with page navigations, automatic joins and declarative hide/show

* __Standard Flask / SQLAlchemy Projects__ -- _customize with your IDE_ for familiar edit/debug services

* __Business Logic Automation:__ using unique spreadsheet-like rules, extensible with Python :trophy:

&nbsp;


### Instant Evaluation - _no install_

Run in the cloud: VSCode via your Browser, courtesy Codespaces.  Use your existing GitHub account (no signup is required), and:

1. [__Click here__](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=593459232){:target="_blank" rel="noopener"} to open the *Create Codespace* page.

2. Configure as desired, and click __Create codespace__.

>  This process takes about a minute.  Wait until you see the port created.

We think you'll find Codespaces pretty amazing - check it out!

&nbsp;

# Why It Matters: 

### Faster, Simpler, Modern Architecture

API Logic Server can dramatically improve web app development:

* Automation makes it __faster:__ what used to require weeks or months is now immediate.  Unblock UI Dev, and engage business users - _early_ - instead of investing in a misunderstanding.

* Automation makes it __simpler:__ this reduces the risk of architectural errors, e.g., APIs without pagination.

* Automation guarantees a __modern software architecture:__ _container-ready_, _API-based_, with _shared logic_ between UIs and APIs (no more logic in UI controllers), in a predictable structure for maintenance.

&nbsp;

### Flexibility of a Framework, Faster than Low Code

We saw short-comings with current approaches for building database systems:   

* __Frameworks:__ Frameworks like Flask or Django enable you to build a single endpoint or _Hello World_ page, but
    * __Require weeks or more__ for a _multi-endpoint_ API and _multi-page_ application
* __Low Code Tools:__ are great for building custom UIs, but
    * __Slow Admin app creation,__ requiring _layout for each screen_
    * __Propietary IDEs__ don't _preserve value_ of traditional IDEs like VSCode, PyCharm, etc
    * __No automation for backend business logic__ (it's nearly half the effort)<br><br>

We wanted to provide:

* __Flexibility of a framework:__ use your IDE's code editor and debugger to customize the created project, with full access to underlying Flask and SQLAlchemy services

* __Faster than low code for admin apps:__ you get a full API and Admin app instantly, no screen painting required

&nbsp;

### What is API Logic Server

API Logic Server is an open source Python project, consisting of:

* a set of runtimes (SAFRS API, Flask, SQLAlchemy ORM, business logic engine) for project execution, plus 

* a CLI (Command Language Interface) to create executable projects, which can be customized in an IDE such as VSCode or PyCharm

It runs as a standard pip install, or under Docker. After installation, you use the CLI create a project like this:

```
ApiLogicServer create --project_name=ApiLogicProject db_url=
```
&nbsp;

!!! pied-piper ":bulb: Key Takeaway"

    API Logic Server reads your schema, and creates an executable, customizable project providing the features listed below.  Check it out [here](Install-Express){:target="_blank" rel="noopener"}.


&nbsp;

# Feature Summary

|   | Feature    | Providing   | Why it Matters   |
:-------|:-----------|:------------|:-----------------|
| __Instant__ | 1. [**Admin App**](Admin-Tour){:target="_blank" rel="noopener"} | Instant **multi-page, multi-table** app  [(running here on PythonAnywhere)](http://apilogicserver.pythonanywhere.com/admin-app/index.html#/Home){:target="_blank" rel="noopener"}              | Engage Business Users<br>Back-office Admin       |
| | 2. [JSON:**API** and Swagger](API){:target="_blank" rel="noopener"}                     | Endpoint for each table, with... <br>Filtering, pagination, related data                                                                        | Custom UI Dev<br>App Integration                           |
| | 3. Data Model Class Creation                                                     | Classes for Python-friendly ORM                                                                                                                             | Custom Data Access<br>Used by API                |
| __Customizable__ | 4. [**Customizable Project**](Project-Structure){:target="_blank" rel="noopener"}                   | Custom Endpoints, Logic <br>Use Python and your IDE  |Customize and run <br>Re-creation *not* required |                                                                                      
| __Unique Logic__ | 5. [Spreadsheet-like Business Rules](Logic-Rules-plus-Python){:target="_blank" rel="noopener"}  &nbsp; :trophy:      | **40X more concise** - compare [legacy code](https://github.com/valhuber/LogicBank/wiki/by-code){:target="_blank" rel="noopener"} | Unique backend automation <br> ... nearly half the system  |
|  | Extensible with Python      | Familiar Event Model | Eg., Send messages, email  |
| Testing | 6. [Behave **Test Framework**](Behave)         | Test Suite Automation<br/>Behave Logic Report<br/>Drive Automation with Agile                                                                                                                           | Optimize Automation to get it fast<br/>Agile Collaboration to get it right                |

&nbsp;

# Instant -- Single Command

Use the CLI to create the sample API and Admin App project, with a single command.

&nbsp;

### Create With Docker

Execute the following commands (Windows, use Windows Terminal or Powershell):

```bash title="Run API Logic Server in Docker"
# Start the API Logic Server docker container
docker run -it --name api_logic_server --rm -p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost apilogicserver/api_logic_server

ApiLogicServer create-and-run --project_name=/localhost/ApiLogicProject --db_url=
```
&nbsp;

### Or, Create With Local Install
Presuming Python 3.7+ [is installed](Install){:target="_blank" rel="noopener"}, it's typically:

```bash title="Run API Logic Server from a local pip install"
python -m venv venv        # may require python3 -m venv venv
source venv/bin/activate   # windows venv\Scripts\activate
venv\Scripts\activate      # mac/linux: source venv/bin/activate
python -m pip install ApiLogicServer

ApiLogicServer create --project_name=ApiLogicProject --db_url=  # or, create-and-run
python ApiLogicProject/api_logic_server_run.py                  # run the server
```
&nbsp;

## Execute

Your system is running - explore the data and api at [localhost:5656](http://localhost:5656).  Using the defaults provided above, you have started the [Tutorial](Tutorial/){:target="_blank" rel="noopener"}, the recommended quick start for API Logic Server.

&nbsp;

# Customize in IDE

VSCode and PyCharm users can customize and run/debug within their IDE with [these steps](IDE-Execute){:target="_blank" rel="noopener"}.  Created projects include Launch and Docker configurations.  

![Customize in your IDE](images/generated-project.png){ align=left }

[Rebuild services](https://valhuber.github.io/ApiLogicServer/Project-Rebuild/){:target="_blank" rel="noopener"} are provided to accommodate changes to database structure or ORM classes.

&nbsp;

# Overview Video

Project creation is based on database schema introspection as shown below: identify a database, and the ```ApiLogicServer create``` commands creates an executable, customomizable project.

Click for a video tutorial, showing complete project creation, execution, customization and debugging.

[![Using VS Code](https://github.com/valhuber/apilogicserver/wiki/images/creates-and-runs-video.jpg?raw=true?raw=true)](https://youtu.be/tOojjEAct4M "Using VS Code with the ApiLogicServer container"){:target="_blank" rel="noopener"}

&nbsp;

# Getting Started

### Local Install

API Logic Server is designed to make it easy to get started:

* **Install and run Tutorial** - 
[install](https://valhuber.github.io/ApiLogicServer/Install-Express/){:target="_blank" rel="noopener"}, and explore the [tutorial](https://valhuber.github.io/ApiLogicServer/Tutorial/){:target="_blank" rel="noopener"}.  You'll create a complete project using the pre-installed sample database, explore its features, and support for customization and debugging. 

* **Installed Sample Databases** -
Here are [some installed sample databases](Data-Model-Examples){:target="_blank" rel="noopener"}

* **Dockerized Test Databases** - 
Then, you might like to try out some of our [dockerized test databases](https://valhuber.github.io/ApiLogicServer/Database-Connectivity/){:target="_blank" rel="noopener"}.

* **Your Database** - 
Finally, try your own database.

&nbsp;

# Use Cases

There are a variety of ways for getting value from API Logic Server:

* __Create and Customize database web apps__ - the core target of the project

* __Admin App for your database__ - the Admin App is a create way to navigate through your database, particularly to explore data relationships

* __Data Repair__ - using the Admin App with logic to ensure integrity, repair data for which you may not have had time to create custom apps

* __Project Creation__ - even if you do not intend to use the API, Admin App or logic, you can use API Logic Server to create project you then edit by hand.  Created projects will include the SQLAlchemy Data Models, and project structure

* __Learning__ - explore the [Learning Center](https://github.com/ApiLogicServer/.github/blob/main/profile/README.md){:target="_blank" rel="noopener"} to learn about key concepts of Flask and SQLAlchemy



&nbsp;

# Project Information

### Making Contributions

This is an [open source project](https://github.com/valhuber/ApiLogicServer){:target="_blank" rel="noopener"}.  We are open to suggestions for enhancements.  Some of our ideas include:

| Component           | Provides         | Consider Adding                                                                |
|:---------------------------|:-----------------|:-------------------------------------------------------------------------------|
| 1. [JSON:**API** and Swagger](https://github.com/thomaxxl/safrs){:target="_blank" rel="noopener"} | API Execution    | **Security** authenticate, role-based access control [active development](Security-Overview)<br/>**Multi-DB** support multiple databases [active development](Data-Model-Multi)/ API<br/>**Serverless** / **Kubernetes** - extend [containerization](Working-With-Docker/#create-docker-hub-from-api-logic-project){:target="_blank" rel="noopener"} | 
| 2. [Transactional **Logic**](https://github.com/valhuber/logicbank#readme){:target="_blank" rel="noopener"}   | Rule Enforcement | New rule types |
| 3. [SAFRS React Admin](https://github.com/thomaxxl/safrs-react-admin){:target="_blank" rel="noopener"} | Admin UI Enhancements | Maps, trees, ... |
| 4. [This project](https://github.com/valhuber/ApiLogicServer){:target="_blank" rel="noopener"} | API Logic Project Creation | Support for features described above |


To get started, please see  the [Architecture.](Internals).

### Preview Version

You can try the pre-release at (you may need to use `python3`):

```bash
python -m pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple ApiLogicServer==8.0.1

Or use:

```bash
docker run -it --name api_logic_server --rm -p 5656:5656 -p 5002:5002 -v ~/dev/servers:/localhost apilogicserver/api_logic_server_x
```

Or, you can use [the beta version on codespaces](https://github.com/ApiLogicServer/beta){:target="_blank" rel="noopener"}.

Notes - the following are not working:

* Swagger
* Passwords validation

&nbsp;

### Status

We have tested several databases - see [status here.](Database-Connectivity)

We are tracking [issues in git](https://github.com/valhuber/ApiLogicServer/issues){:target="_blank" rel="noopener"}.

 &nbsp;

### Acknowledgements

Many thanks to:

- [Thomas Pollet](https://www.linkedin.com/in/pollet/), for SAFRS, SAFRS-react-admin, and invaluable design partnership
- Nitheish Munusamy, for contributions to Safrs React Admin
- [Marelab](https://marmelab.com/en/), for [react-admin](https://marmelab.com/react-admin/)
- Armin Ronacher, for Flask
- Mike Bayer, for SQLAlchemy
- Alex Grönholm, for Sqlacodegen
- [Meera Datey](https://www.linkedin.com/in/meeradatey/), for React Admin prototyping
- Denny McKinney, for Tutorial review
- Achim Götz, for design collaboration and testing
- Max Tardiveau, for testing and help with Docker
- Michael Holleran, for design collaboration and testing
- Nishanth Shyamsundar, for review and testing
- Thomas Peters, for review and testing
- Daniel Gaspar, for Flask AppBuilder
- Gloria Huber and Denny McKinney, for doc review

&nbsp;

### Articles

There are a few articles that provide some orientation to API Logic Server:

* [How Automation Activates Agile](https://modeling-languages.com/logic-model-automation/){:target="_blank" rel="noopener"}
* [How Automation Activates Agile](https://dzone.com/articles/automation-activates-agile){:target="_blank" rel="noopener"} - providing working software rapidly drives agile collaboration to define systems that meet actual needs, reducing requirements risk
* [How to create application systems in moments](https://dzone.com/articles/create-customizable-database-app-systems-with-1-command){:target="_blank" rel="noopener"}
* [Stop coding database backends…Declare them with one command.](https://medium.com/@valjhuber/stop-coding-database-backends-declare-them-with-one-command-938cbd877f6d){:target="_blank" rel="noopener"}
* [Instant Database Backends](https://dzone.com/articles/instant-api-backends){:target="_blank" rel="noopener"}
* [Extensible Rules](https://dzone.com/articles/logic-bank-now-extensible-drive-95-automation-even){:target="_blank" rel="noopener"} - defining new rule types, using Python
* [Declarative](https://dzone.com/articles/agile-design-automation-how-are-rules-different-fr){:target="_blank" rel="noopener"} - exploring _multi-statement_ declarative technology
* [Automate Business Logic With Logic Bank](https://dzone.com/articles/automate-business-logic-with-logic-bank){:target="_blank" rel="noopener"} - general introduction, discussions of extensibility, manageability and scalability
* [Agile Design Automation With Logic Bank](https://dzone.com/articles/logical-data-indendence){:target="_blank" rel="noopener"} - focuses on automation, design flexibility and agile iterations
* [Instant Web Apps](https://dzone.com/articles/instant-db-web-apps){:target="_blank" rel="noopener"} 



[^1]:
    See the [FAQ for Low Code](FAQ-Low-Code)