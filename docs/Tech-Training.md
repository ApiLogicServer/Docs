!!! pied-piper ":bulb: Lab-Focused Training"

      Instead of hours of concepts, many propose that training be organzied around a series of Labs.  This page outlines such a course, presuming:

      * WebGenAI-focused
      * Java background - new to Python

## Initial Background
Review the [GenAI Architecture](Architecture-What-Is-GenAI.md){:target="_blank" rel="noopener"}, and take a quick scan of [Python for Java programmers](Tech-Python.md){:target="_blank" rel="noopener"}.


## Installation and Configuration
While WebGenAI is available via your browser - you will want to have a local version of Python, ApiLogicServer, VSCode (and optionally Docker Desktop) running.  This has been documented here:

1. [Python 3.12 Installation](Tech-Install-Python.md){:target="_blank" rel="noopener"}
2. [Understand Virtual Environments](Project-Env.md){:target="_blank" rel="noopener"}; for general background, [see python docs)(https://docs.python.org/3/library/venv.html){:target="_blank" rel="noopener"}
3. [ApiLogicServer Installation](Install-Express.md){:target="_blank" rel="noopener"}
4. [VSCode for Python](https://code.visualstudio.com/docs/python/python-tutorial){:target="_blank" rel="noopener"}
5. [Docker Desktop Install](https://docs.docker.com/desktop/){:target="_blank" rel="noopener"}
6. [Sample Docker Databases](Database-Docker.md){:target="_blank" rel="noopener"} are available for learning.

&nbsp;

## WebGenAI Core Lab
You can run WebGenAI locally on your desktop or your company may have a cloud version running. WebGenAI uses OpenAI ChatGPT and requires the configuration of both a license and an OpenAI API Key.  Watch the video [here](https://www.youtube.com/watch?v=7I33Fa9Ulos){:target="_blank" rel="noopener"}

In this lab, we will learn the following:

1. Create a project from a prompt [Prompt Engineering Basics](WebGenAI.md){:target="_blank" rel="noopener"}
2. Use the 'Iterate' button to modify the created project
3. Use the ['Logic'](WebGenAI.md#using-the-logic-editor){:target="_blank" rel="noopener"} 
   button and the 'Suggestion' to create natural language rules
4. Use the 'Update Model' button if the rules fail to activate
5. Review the Rules and Log
6. Setup [CodeSpaces](Sample-Genai.md){:target="_blank" rel="noopener"} to see the project in GitHub

&nbsp;

## Download & Customizing
Use the 'Project Download' link from the '2> develop' page or the project page (as a tar file). Unzip or un-tar the file and copy to the manager or developer workspace.

&nbsp;

## Start the Manager
The Manager is a pre-configured VSCode with samples used to help new developers learn about ApiLogicServer.
See the [Manager](Manager.md){:target="_blank" rel="noopener"} documentation.
```
mkdir ApiLogicServer
cd ApiLogicServer
python -m venv venv
source venv/bin/activate 
ApiLogicServer start
```

1. Creating custom endpoint
    * [NW Tutorial](Tutorial.md), #als examples heads up, B2B example
    * [GenAI Demo Tutorial](Sample-Genai.md)
2. Custom logic
3. Data Model Classes (attr/reln accessors) - Python ‘beans'

&nbsp;

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

1. Create an Ontimize application
2. Build (rebuild) Ontimize Pages
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

