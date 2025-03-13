!!! pied-piper ":bulb: Lab-Focused Training"

      Instead of hours of concepts, many propose that training be organzied around a series of Labs.  This page outlines such a course, presuming:

      * WebGenAI-focused
      * Java background - new to Python

### Initial Background
Review the [GenAI Architecture](Architecture-What-Is-GenAI.md){:target="_blank" rel="noopener"}, and take a quick scan of [Python for Java programmers](Tech-Python.md){:target="_blank" rel="noopener"}. 


### Installation and Configuration
While WebGenAI is available via your browser - you will want to have a local version of Python, ApiLogicServer, VSCode (and optionally Docker Desktop) running.  This has been documented here:

1. [Python 3.12 Installation](Tech-Install-Python.md){:target="_blank" rel="noopener"}
2. [Understand Virtual Environments](https://docs.python.org/3/library/venv.html){:target="_blank" rel="noopener"}, and [als notes](Project-Env.md){:target="_blank" rel="noopener"}
3. [ApiLogicServer Installation](Install-Express.md){:target="_blank" rel="noopener"}
4. [VSCode for Python](https://code.visualstudio.com/docs/python/python-tutorial){:target="_blank" rel="noopener"}
5. [Docker Desktop Install](https://docs.docker.com/desktop/){:target="_blank" rel="noopener"}
6. [Sample Docker Databases](Database-Docker.md){:target="_blank" rel="noopener"} are available for learning.

&nbsp;

## Core WebGenAI

In this series of labs, you will 

1. create and run projects
2. debug them, both in WebGanAI and the IDE
3. explore iterations

&nbsp;

### Using WebGenAI in the Browser

You can run WebGenAI locally on your desktop or your company may have a cloud version running. WebGenAI uses OpenAI ChatGPT and requires the configuration of both a license and an OpenAI API Key.  Watch the video [here](https://www.youtube.com/watch?v=7I33Fa9Ulos){:target="_blank" rel="noopener"}

In this lab:

1. Create the demo project from a prompt [Prompt Engineering Basics](https://apifabric.ai/admin-app/index.html#/Home?demo=genai_demo){:target="_blank" rel="noopener"}
2. Verify the logic by navigating to a Customer with an unshipped order, and altering one of the items to have a very large quantity
3. Explore [debugging logic](WebGenAI.md#debugging-logic){:target="_blank" rel="noopener"} using your Browser

&nbsp;

### Using your IDE

#### Download (aka Export)

The web-based interface is great for rapid creation, but you will enjoy much better debugging using your IDE.  We'll explore that in these next labs.

Please see [Export](WebGenAI-CLI.md#export){:target="_blank" rel="noopener"}.

Use the 'Project Download' link from the '2> develop' page or the project page (as a tar file). Unzip or un-tar the file and copy to the manager or developer workspace.

&nbsp;

#### Start the Manager

The Manager is a pre-configured VSCode with samples used to help new developers learn about ApiLogicServer.  See the [Manager](Manager.md){:target="_blank" rel="noopener"} documentation.

See the procedure below (`cd ApiLogicServer; code .`)

&nbsp;

#### Copy your Project to the Manager Directory

As explained in [Export](WebGenAI-CLI.md#export){:target="_blank" rel="noopener"}.

&nbsp;

#### Start your project

The Manager has a readme which explains how to run projects from inside the manager.  When you are getting started, it's easiest just to launch another instance of VSCode.  In the termimal window of VSCode:

```bash
cd <your project>
code .
```

&nbsp;

#### Explore Logic Debugging

Refer to the [docs on logic debugging](Logic-Debug.md){:target="_blank" rel="noopener"}.

1. Put a breakpoint on the constraint
2. Start the Server (F5)
3. Start the App in the Browser
4. Verify the logic by navigating to a Customer with an unshipped order, and altering one of the items to have a very large quantity
  * Observe the log, showing each rule firing with the row data

&nbsp;

### Explore Rule Concepts
ApiLogicServer provides a rule engine (LogicBank) to allow the developer to add derivations, constraints and events to any API endpoint.  These rules can be created by WebGenAI natural language or using the VSCode IDE manually entered.

1. [Rule Type Patterns](Logic.md){:target="_blank" rel="noopener"} 

&nbsp;

### WebGenAI Iterations

Explore WebGenAI iteration services:

2. Use the 'Iterate' button to modify the created project
3. Use the ['Logic'](WebGenAI.md#using-the-logic-editor){:target="_blank" rel="noopener"} 
   button and the 'Suggestion' to create natural language rules
4. Use the 'Update Model' button if the rules fail to activate

&nbsp;

### Dev Strategy: WebGenAI, IDE, or Both?

You will find WebGenAI remains useful, particularly for updating the data model (e.g., as required for logic).  The system provides [Import/Merge](IDE-Import-WebGenAI.md){:target="_blank" rel="noopener"} services to sync WebGenAI changes with IDE changes.

If you elect to focus on IDE development, analogous services are provided with [Rebuild from Model / Database, and Alembic support](Database-Changes.md){:target="_blank" rel="noopener"}.

&nbsp;

## Concepts and Facilities


### Command Line Basics
The command line (cli) is the key to use all of the features of ApiLogicServer.  Note that each command may have a set of additional arguments: use --help to see the additional features (e.g. als genai --help).

```
als --help
Welcome to API Logic Server {version}

Usage: als [OPTIONS] COMMAND [ARGS]...

      Creates [and runs] logic-enabled Python database API Logic Projects.

          Creation is from your database (--db-url identifies a SQLAlchemy database)

          Doc: https://apilogicserver.github.io/Docs
          And: https://apilogicserver.github.io/Docs/Database-Connectivity/
  
      Suggestions:

          ApiLogicServer start                                # create and manage projects
          ApiLogicServer create --db-url= --project-name=     # defaults to Northwind sample
      

Options:
  --help  Show this message and exit.

Commands:
  about                  Recent Changes, system information.
  add-auth               Adds authorization/authentication to curr project.
  add-cust               Adds customizations to northwind, genai,...
  add-db                 Adds db (model, binds, api, app) to curr project.
  app-build              Builds runnable app from: ui/<app>/app-model.yaml
  app-create             Creates Ontomize app model: ui/<app>/app-model.yaml
  create                 Creates new customizable project (overwrites).
  create-and-run         Creates new project and runs it (overwrites).
  create-ui              Creates models.yaml from models.py (internal).
  curl                   Execute cURL command, providing auth headers...
  curl-test              Test curl commands (nw only; must be r)
  examples               Example commands, including SQLAlchemy URIs.
  genai                  Creates new customizable project (overwrites).
  genai-create           Create new project from --using prompt text.
  genai-iterate          Iterate current project from --using prompt text.
  genai-logic            Adds (or suggests) logic to current project.
  genai-utils            Utilities for GenAI.
  login                  Login and save token for curl command.
  rebuild-from-database  Updates database, api, and ui from changed db.
  rebuild-from-model     Updates database, api, and ui from changed models.
  run                    Runs existing project.
  start                  Create and Manage API Logic Projects.
  tutorial               Creates (updates) Tutorial.
  welcome                Just print version and exit.
```

1. Explore [cli](Project-Structure.md){:target="_blank" rel="noopener"} create, add-auth, app-build, app-create, rebuild-from-database
2. GenAI [cli](WebGenAI-CLI.md){:target="_blank" rel="noopener"} 

&nbsp;

### Connect to SQL
If the project has an existing SQL DBMS (MySQL, PostgreSQL, SQL Server, Oracle) - ApiLogicServer can connect to SQL and build a detailed API. Review the documentation of Data-Model design, examples, keys, quoted identifiers, etc.
In this lab - we will connect to the northwind database.
```
als create --project-name=myproject --db-url=nw+
cd myproject
code .
```
Open database/models.py

1. [Data-Model-Design](Data-Model-Design.md){:target="_blank" rel="noopener"} 
2. Primary Keys on each table
3. Relationships (foreign keys) many-to-one (parent), one-to-many (children) (or many-to-many)
4. Accented characters (als create --db-url=... --quote) quoted identifiers
5. SQLAlchemy ORM model.py 
6. Run Server (F5) with or without security
7. Start React Application (http://localhost:5656)
8. Review OpenAI (Swagger) (http://localhost:5656/api) JSON API

&nbsp;

### Integration 
Some applications may require integration with other services (e.g. email, payment, workflow, etc) 
In this lab - explore how to use the existing services to integration with Kafka or Workflow.

1. Integration and Configuration [Kafka](Integration-Kafka.md){:target="_blank" rel="noopener"}
2. Send a message to Kafka (event driven) by topic 
3. Listen for incoming Kafka message by topic
4. Integration with Workflow (n8n) - Using WebHooks
5. Configuration of Kafka or n8n (config.py)

### Ontimize Angular Application
OntimizeWeb from Imatia is an Angular application that is automatically created from the command line.
In this lab - review the Ontimize process [here](App-Custom-Ontimize-Overview.md){:target="_blank" rel="noopener"}

Start ApiLogicServer first (note: must enable security: als add-auth --provider-type=sql)
```
als app-create --app=app
als app-build --help
 example:

      ApiLogicServer app-build —app=name=app1

      ApiLogicServer app-build —app=name=app1 —api-endpoint=Orders 
      # only build Orders          This creates app1/app-model.yml. 

Options:
  --project-name TEXT  Project containing App
  --app TEXT           App directory name
  --api-endpoint TEXT  API endpoint name
  --template-dir TEXT  Directory of user defined Ontimize templates
  --help               Show this message and exit.


als app-build --app=app
cd ui/app
npm install && npm start  # http://localhost:4299
```

1. Create an Ontimize application
2. Build (rebuild) Ontimize Application or Page
3. Yaml File Basics
4. Working with Templates 
5. Application Model Editor
6. Advanced Filters (enable)

Note: This version uses the Ontimize API Bridge - work is being done to use JSON API

&nbsp;

### Configure Security
The ability to secure your application is an important part of the creation of any API Microservice application.  In this lab - review and try:

1. Who Can Access - [Authentication](Security-Authentication.md){:target="_blank" rel="noopener"}
2. What can they Do - [Authorization (role-based access control)](Security-Authorization.md){:target="_blank" rel="noopener"}
3. Use [KeyCloak](Security-Keycloak.md){:target="_blank" rel="noopener"} local docker image
4. Use [SQL](Security-sql.md){:target="_blank" rel="noopener"} login



### Deployment (devops)
ApiLogicServer has a suite of tools for [devops](DevOps-Docker.md){:target="_blank" rel="noopener"} to build and deploy Docker containers. 

1. [Build a Docker Image](DevOps-Containers-Build.md){:target="_blank" rel="noopener"}

&nbsp;

### Adv Project

1. Adding attributes if they are not added automatically
2. SQLIte to PostgreSQL migration (sqlite3 db.sqlite .dump > postgres.sql)
3. Rebuild test data (?)

&nbsp;

### Be Aware Of

1. [Behave Testing](Behave.md){:target="_blank" rel="noopener"} (optional)
2. [Alembic](Database-Changes.md/#use-alembic-to-update-database-schema-from-model){:target="_blank" rel="noopener"} Schema Migration

&nbsp;

## Appendices


### Start the Manager

The Manager is a pre-configured VSCode with samples used to help new developers learn about ApiLogicServer.  See the [Manager](Manager.md){:target="_blank" rel="noopener"} documentation.

Recall you installed the manager when you installed API Logic Server.
In a terminal window or powershell:

```
mkdir ApiLogicServer
cd ApiLogicServer
python -m venv venv
source venv/bin/activate      # windows: venv\Scripts\activate
pip install ApiLogicServer
ApiLogicServer start
```
> Explore the NorthWind (nw) example to learn about ApiLogicServer.  Each folder represents a key concepts (e.g. config, api, database, logic, security, devops, test, ui)

Later, when you exit VSCode, you can restart the Manager:

```bash
cd ApiLogicServer
code .
```

&nbsp;


&nbsp;

#### Explore the folders

1. Config/config.py - runtime settings
2. [Database/models.py](Data-Model-Customization.md){:target="_blank" rel="noopener"} - SQLAlchemy ORM 
3. [Api/custom_api.py](API.md){:target="_blank" rel="noopener"} - Custom API endpoints
4. logic/declare_logic.py
5. [security](Security-Overview.md){:target="_blank" rel="noopener"} declare_security.py and security/system/authentication.py 
6. [devops containers](DevOps-Containers.md){:target="_blank" rel="noopener"} - various docker scripts 
7. [ui/admin admin.yaml](Admin-Tour.md){:target="_blank" rel="noopener"} - React back office
8. [test - behave testing](Behave.md){:target="_blank" rel="noopener"}

