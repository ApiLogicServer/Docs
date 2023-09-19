!!! pied-piper ":bulb: TL;DR - Dev Preview"

      Agile correctly advises getting Working Software as fast as possible, to faciliate Business User Collaboration and Iteration:

      1. **Instant Creation:** create working software from a database.

      2. **Publish to GitHub:** for dev team collaboration

      2. ***Dev Deploy* to the Cloud:** use the working software to collaborate with Business Users

      Use API Logic Server to create Dev Previews.

![ai-driven-automation](images/ai-driven-automation/ai-driven-automation.png)

## Dev Previews

API Logic Server can create projects with APIs and UIs with a single command.  But to enable collaboration, these need to be available to your colleagues.

Such **Dev Preview** deployments focus on simple and fast, as distinct from *Production Deployments* that focus on scalability, availability, etc.  As such:

* You might use Flask as a Web Server, instead of a production web server such as nginx

* You might use database containers, with both DBMS software *and data*, which make it easy to test both locally and in the cloud.

&nbsp;

## Test Databases

The procedures here offer 2 alternatives for test databases:

1. **Managed Databases:** use Azure to create databases and add data, and access from an App Server container

2. **Container Databases:** use docker container databases, and deploy as a docker compose, combining your App Server container and your docker database

   * You can create these as [shown here](../Database-docker#create-your-own-db-image)

The examples below use pre-supplied MySQL and Postgres databases; for more information, [click here](../Database-docker).
