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

!!! pied-piper ":bulb: Fastest, Easiest Way to Create Database Backends"

    For Developers and their organizations seeking to **increase business agility,**

    API Logic Server provides ***instant* creation of executable projects** from a database with one CLI command, **customizable with standards:** Python, Flask, SQLAlchemy, and tools such as GitHub and your IDE.

    Unlike Frameworks, API Logic Server provides **unique automation** to create executable projects from databases, and **unique spreadsheet-like rules** that decrease backend code by **40X**, and promote quality.

&nbsp;


---

# Usage: Create, Run, Customize

API Logic Server is an open source Python project, consisting of a CLI and set of runtimes (SAFRS API, Flask, SQLAlchemy ORM, business logic engine) for project execution.

It runs as a standard pip install, or under Docker. For more on API Logic Server Architecture, [see here](Architecture-What-Is.md){:target="_blank" rel="noopener"}.

**1. Create: Automate Project Creation With a Single CLI Command**

The [**`ApiLogicServer create`**](Project-Structure.md){:target="_blank" rel="noopener"} CLI command creates an executable project by reading the database schema in the `db_url` argument.  For example, this will create an executable, customizable project from the pre-installed sample database:

```bash
ApiLogicServer create --project_name=ApiLogicProject --db_url=nw
```

&nbsp;

**2. Run: Automated JSON:API, Admin App**

The **project is executable**, providing a [**JSON:API**](API.md){:target="_blank" rel="noopener"} and an [**Admin App**](Admin-Tour.md){:target="_blank" rel="noopener"}:

<details markdown>

<summary>See JSON:API and Admin App</summary>

&nbsp;

You can run directly (`python api_logic_server_run.py`), or open it in your IDE and use the pre-created run configurations:

![Admin App](images/ui-admin/Order-Page.png)

The Admin App provides a link to the Swagger:

![Swagger](images/api/swagger-get-data.png)

</details>

&nbsp;

**3. Customize: Rules and Python**

The **project is customizable in your IDE**.  Use Python and rules to customize it: logic and security, and custom APIs and messages.

> Rules are unique and significant - [40X more concise than code](Logic-Why.md){:target="_blank" rel="noopener"}.


<details markdown>

<summary>See Customizations</summary>

&nbsp;

Rules are 40X more concise than code, and are extensible with Python:

![Logic](images/logic/5-rules-cocktail.png)

Projects are designed for customization:

![Customize](images/nutshell/your-code-here.png)

</details>

&nbsp;


---


# Key Features

| Feature | Notes   |
:-------|:-----------|
| [Instant Project Creation](Project-Structure.md){:target="_blank" rel="noopener"} | Unblock Agile Collaboration, Custom App Dev |
| [AI-Driven Automation](Tutorial-Agile.md){:target="_blank" rel="noopener"} | Use ChatGPT to automate database creation |
| [Application Integration](Sample-Integration.md){:target="_blank" rel="noopener"} | Automation with APIs and Kafka Messages |
| [Rule-based Transaction Logic](Logic-Why.md){:target="_blank" rel="noopener"} | 40X More Concise than procedural code |
| [Rule-Base Row Level Security](Security-Overview.md){:target="_blank" rel="noopener"} | Authorization and Authentication |
| [Self-Serve JSON:API](API.md){:target="_blank" rel="noopener"} | UI Developers and Partners don't require API Dev |
| [Admin Web App](Admin-Tour.md){:target="_blank" rel="noopener"} | Agile Collaboration, Prototyping, Testing, Back Office Data Entry |
| [Multiple Databases](Data-Model-Multi.md){:target="_blank" rel="noopener"} | Application Integration |
| [Deployment Automation](Tutorial-Deployment.md){:target="_blank" rel="noopener"} | Automated Container Creation, Azure Deployment |

&nbsp;

---

# Scenarios

As illustrated below, API Logic Server supports transactions from User Interfaces, and Application Integration - both via custom APIs and Kafka messages.

![API Logic Server](images/nutshell/als-nutshell.png)

*JSON:API* are a standard for self-serve APIs -- where clients can select the columns and the related data they require.

> Self-serve APIs reduce the need for ongoing custom API development.  Analogous to GraphQL, they fulfill requirements for UI development and ad hoc integration.

You can use Python, Flask and SQLAlchemy to create Custom APIs, e.g. for B2B Partners.  In addition to the underlying logic, API Logic Server provides mapping services as described under **Application Integration.**

Appication Integration support also provides automation for producing and consuming Kafka messages.  To see these services in a running sample, [click here](Sample-Integration.md){:target="_blank" rel="noopener"}.

For various Use Cases, [click here](Product-Detail.md/#use-cases){:target="_blank" rel="noopener"}.

&nbsp;

---

# Video: Agile Collaboration

Click the image below for a video tutorial, showing complete project creation, execution, customization and debugging ([instructions here](Tech-Agile.md){:target="_blank" rel="noopener"}).  Or, see it using AI: [click here](Tutorial-AI.md).

[![Delivering the Agile Vision](images/agile/als-agile-video.png)](https://youtu.be/sD6RFp8S6Fg "Using VS Code with the ApiLogicServer container"){:target="_blank" rel="noopener"}

&nbsp;

# Getting Started - Install, Tutorial

API Logic Server is designed to make it easy to get started:

* **Install and run Tutorial** - 
[install](https://valhuber.github.io/ApiLogicServer/Install-Express.md){:target="_blank" rel="noopener"}, and explore the [tutorial](https://valhuber.github.io/ApiLogicServer/Tutorial/){:target="_blank" rel="noopener"}.  The tutorial creates 2 versions of the [sample database](https://valhuber.github.io/ApiLogicServer/Sample-Database.md){:target="_blank" rel="noopener"}

     * without customizations - so you to see exactly what is automated from the `ApiLogicServer create` command
     * with customizations - so you can see how to customize 

* **Installed Sample Databases** -
Here are [some installed sample databases](Data-Model-Examples.md){:target="_blank" rel="noopener"} you can use with simplified abbreviations for `db_url`.

* **Dockerized Test Databases** - 
Then, you might like to try out some of our [dockerized test databases](https://valhuber.github.io/ApiLogicServer/Database-Connectivity.md){:target="_blank" rel="noopener"}.

* **Your Database** - Finally, try your own database.

&nbsp;

In addition to this app dev oriented tutorial, you can also explore:

* **Messaging:** the [Application Integration Tutorial](Sample-Integration.md){:target="_blank" rel="noopener"} illustrates using messaging, self-serve APIs and customized APIs, choreographed with rules and Python.

* **Deployment:** the [Deployment Tutorial](Tutorial-Deployment.md){:target="_blank" rel="noopener"} illustrates various ways to containerize and deploy your applications

* **Using AI:** the [AI-Driven Automation Tutorial](Tech-AI.md){:target="_blank" rel="noopener"} shows how you can use ChatGPT to create new databases from english descriptions, to bootstrap a very rapid create / collaborate / iterate Agile cycle.

&nbsp;

## Release Notes

To see Release Notes, [click here](https://github.com/ApiLogicServer/ApiLogicServer-src/releases){:target="_blank" rel="noopener"}.

## Preview Version

<details markdown>

<summary> Show me how </summary>

&nbsp;

This pre-release includes:

* Running [Kafka publish](Sample-Integration.md); consume now working.

* Fix for MySQL CHAR/String import [Issue 26](https://github.com/ApiLogicServer/ApiLogicServer-src/issues/26){:target="_blank" rel="noopener"}


You can try it at (you may need to use `python3`):

```bash
python -m pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple ApiLogicServer==10.01.03
```

Or use (neither available currently):

```bash
docker run -it --name api_logic_server --rm -p 5656:5656 -p 5002:5002 -v ~/dev/servers:/localhost apilogicserver/api_logic_server_x
```

Or, you can use [the beta version on codespaces](https://github.com/ApiLogicServer/beta){:target="_blank" rel="noopener"}.

</details>

&nbsp;

# Contact Us

We'd love to hear from you:

1. Email: apilogicserver@gmail.com
2. Slack: [https://apilogicserver.slack.com](https://join.slack.com/t/apilogicserver/signup?x=x-p3388652117142-3395302306098-5241761647201)

&nbsp;

# Detailed Product Information

For more product information, [click here](Product-Detail.md){:target="_blank" rel="noopener"}.