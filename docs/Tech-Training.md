!!! pied-piper ":bulb: Lab-Focused Training"

      Instead of hours of concepts, many propose that training be organzied around a series of Labs.  This page outlines such a course, presuming:

      * WebGenAI-focused
      * Java background - new to Python

## Initial Background
Review the [GenAI Architecture](Architecture-What-Is-GenAI.md){:target="_blank" rel="noopener"}, and take a quick scan of [Python for Java programmers](Tech-Python.md){:target="_blank" rel="noopener"}.


## Installation and Configuration
While WebGenAI is available via your browser - you will want to have a local version of Python, ApiLogicServer, VSCode (and optionally Docker Desktop) running.  This has been documented here:

1. [Python 3.12 Installation](Tech-Install-Python.md){:target="_blank" rel="noopener"}
2. [Understand Virtual Environments](https://docs.python.org/3/library/venv.html){:target="_blank" rel="noopener"}
3. [ApiLogicServer Installation](Install-Express.md){:target="_blank" rel="noopener"}
4. [VSCode for Python](https://code.visualstudio.com/docs/python/python-tutorial){:target="_blank" rel="noopener"}
5. [Docker Desktop Install](https://docs.docker.com/desktop/){:target="_blank" rel="noopener"}
6. [Sample Docker Databases](Database-Docker.md){:target="_blank" rel="noopener"} are available for learning.

&nbsp;

## WebGenAI Core Lab
You can run WebGenAI locally on your desktop or your company may have a cloud version running. WebGenAI uses OpenI ChatGPT and requires the configuration of both a license and an OpenAI API Key.  Watch the video [here](https://www.youtube.com/watch?v=7I33Fa9Ulos){:target="_blank" rel="noopener"}

In this lab, we will learn the following:

1. Create a project from a prompt [Prompt Engineering Basics](WebGenAI.md){:target="_blank" rel="noopener"}
2. Use the 'Iterate' button to modify the created project
3. Use the ['Logic'](WebGenAI-logic-editor.md){:target="_blank" rel="noopener"} 
   button and the 'Suggestion' to create natural language rules
4. Use the 'Update Model' button if the rules fail to activate
5. Review the Rules and Log
6. Setup [CodeSpaces](Sample-Genai.md){:target="_blank" rel="noopener"} to see the project in GitHub

&nbsp;

## Explore Rule Concepts
ApiLogicServer provides a rule engine (LogicBank) to allow the developer to add derivations, constraints and events to any API endpoint.  These rules can be created by WebGenAI natural language or using the VSCode IDE manually entered.

1.  [Rule Type Patterns](Logic.md){:target="_blank" rel="noopener"} 

&nbsp;

## Download & Customizing
Use the 'Project Download' link from the '2> develop' page or the project page (as a tar file). Unzip or un-tar the file and copy to the manager or developer workspace.

&nbsp;

## Start the Manager
The Manager is a pre-configured VSCode with samples used to help new developers learn about ApiLogicServer.

See the [Manager](Manager.md){:target="_blank" rel="noopener"} documentation.
In a terminal window or powershell:
```
mkdir ApiLogicServer
cd ApiLogicServer
python -m venv venv
source venv/bin/activate 
pip install ApiLogicServer
ApiLogicServer start
```
Explore the NorthWind (nw) example to learn about ApiLogicServer.  Each folder represents a key concepts (e.g. config, api, database, logic, security, devops, test, ui)

### Explore the folders

1. Config/config.py - runtime settings
2. [Database/models.py](Data-Model-Customization.md){:target="_blank" rel="noopener"} - SQLAlchemy ORM 
3. [Api/custom_api.py](API-Customize.md){:target="_blank" rel="noopener"} - Custom API endpoints
4. logic/declare_logic.py
5. [security](Security-Overview.md){:target="_blank" rel="noopener"} declare_security.py and security/system/authentication.py 
6. [devops containers](DevOps-Containers.md){:target="_blank" rel="noopener"} - various docker scripts 
7. [ui/admin admin.yaml](Admin-Tour.md){:target="_blank" rel="noopener"} - React back office and Ontimize Angular (ui/app)
8. [test - behave testing](Behave.md){:target="_blank" rel="noopener"}

Manager - Explore examples
    * samples/nw_sample - [NW Tutorial](Tutorial.md){:target="_blank" rel="noopener"}, search for #als to see examples, B2B example
    * system/genai [GenAI Demo Tutorial](Sample-Genai.md){:target="_blank" rel="noopener"}

&nbsp;

## Command Line Basics
The command line (cli) is the most key to use the features of ApiLogicServer.

```
als --help
```

1. Explore [cli](Project-Structure.md){:target="_blank" rel="noopener"} create, add-auth, app-build, app-create, rebuild-from-database
2. GenAI [cli](WebGenAI-CLI.md){:target="_blank" rel="noopener"} genai

## Configure Security
The ability to secure your application is an important part of the creation of any API Microservice application.  In this lab - review and try:

1. Who Can Access - [Authentication](Security-Authentication.md){:target="_blank" rel="noopener"}
2. What can they Do - [Authorization (role-based access control)](Security-Authorization.md){:target="_blank" rel="noopener"}
3. Use [KeyCloak](Security-Keycloak.md){:target="_blank" rel="noopener"} local docker image
4. Use [SQL](Security-sql.md){:target="_blank" rel="noopener"} login


&nbsp;

## Integration 
Some applications may require integration with other services (e.g. email, payment, workflow, etc) 
In this lab - explore how to use the existing services to integration with Kafka or Workflow.

1. Integration and Configuration [Kafka](Integration-Kafka.md){:target="_blank" rel="noopener"}
2. Integration with Workflow (n8n)

## Ontimize
OntimizeWeb from Imatia is an Angular application that is automatically created from the command line.
In this lab - review the Ontimize process [here](App-Custom-Ontimize-Overview.md){:target="_blank" rel="noopener"}

```
als app-create --app=app
als app-build --help

als app-build --app=app
cd ui/app
npm install && npm start
```

1. Create an Ontimize application
2. Build (rebuild) Ontimize Application or Page
3. Yaml File Basics
4. Working with Templates 
5. Application Model Editor

&nbsp;

## Deployment (devops)
ApiLogicServer has a suite of tools for [devops](DevOps-Docker.md){:target="_blank" rel="noopener"} to build and deploy Docker containers. 

1. [Build a Docker Image](DevOps-Build.md){:target="_blank" rel="noopener"}

&nbsp;

## Adv Project

1. Adding attributes if they are not added automatically
2. SQLIte to PostgreSQL migration (sqlite3 db.sqlite .dump > postgres.sql)
3. Rebuild test data (?)

&nbsp;

## Be Aware Of

1. [Behave Testing](Behave.md){:target="_blank" rel="noopener"} (optional)
2. [Alembic](Database-Changes.md/#use-alembic-to-update-database-schema-from-model){:target="_blank" rel="noopener"} Schema Migration

