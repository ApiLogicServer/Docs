!!! pied-piper ":bulb: TL;DR - Dev Deploy: Multi-Container Systems"

    This page shows the simplest way to deploy a **dev system** to the cloud, to enable collaboration with Business User and fellow developers: 

    * create a resource group

    * create a database container (database server and data - for simplified management)

    * deploy an API Logic Project image from DockerHub


***Under Construction***

[Containers](../DevOps-Containers){:target="_blank" rel="noopener"} are a best practice for deployment, *and* offer several advantages for development.  This outlines a typical scenario for deploying API Logic Server projects to Azure.

This tutorial presumes you've already `push`ed an image, here called `apilogicserver/docker_api_logic_project:latest`.

![Container Overview](images/docker/container-dev-deploy.png)

&nbsp;

## Create Azure Account

I created a free account, electing the $200 free option.  In the entire exercise, I used less than $2 of my allotment.

&nbsp;

## Deploy Database Image

The API Logic Server project provides several [docker databases](../Database-Docker){:target="_blank" rel="noopener"}.  A simple approach is to build on one of these, to add your own data, and to create your own database container for your team.  This provides a valuable "common starting place" for test database structure and test data.

&nbsp;

### Container Group

The database creation wizard requires that you create a [container group](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-container-groups){:target="_blank" rel="noopener"}.

&nbsp;

### database `apilogicserver/mysql8.0:latest` 

This image contains the `classicmodels` database, and `authdb`.  You can run it locally for testing, as described in [docker databases](../Database-Docker){:target="_blank" rel="noopener"}.

This database as created using the scripts [shown here](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/tests/test_databases){:target="_blank" rel="noopener"}.   These directories include the sql to create the database and data, and the `docker_databases/Dockerfile-MySQL-container-data` to create and publish the image.

You can use the same procedures to use the existing image, add you own database, and publish to your own DockerHub repository.

In this example, that's not required - we'll just use the pre-created `classicmodels`.

&nbsp;

## Portal

![Azure Data Tools](images/docker/azure/portal.png)

&nbsp;

*** The information below is under construction, not tested***

&nbsp;

## Create Api Logic Project Container

![Azure Data Tools](images/docker/azure/create-container.png)

```bash
az container create --resource-group myResourceGroup --name mycontainer --image apilogicserver/docker_api_logic_project:latest --dns-name-label val-demo --ports 5656 --environment-variables 'FLASK_HOST'='mssql+pyodbc://valhuber:PWD@mysqlserver-nwlogic.database.windows.net:1433/nwlogic?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=no' 'VERBOSE'='True'
```

Most of the arguments are straight-forward, identifying the Docker Hub repository (`apilogicserver/docker_api_logic_project:latest`), the container group.  

> Note the `--environment-variables` are used to communicate the database and server location: `--environment-variables 'FLASK_HOST'='mssql+pyodbc://valhuber:PWD@mysqlserver-nwlogic.database.windows.net:1433/nwlogic?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=no' 'VERBOSE'='True'`

&nbsp;

### Recreate the container

If you need to recreate the container, you can use the portal, or this command:

```bash
az container delete --resource-group myResourceGroup --name mycontainer
```

&nbsp;

## Trouble Shooting

Use this command to view Azure logs:

```bash
az container logs --resource-group myResourceGroup --name mycontainer
```

For specific error conditions, see [Troubleshooting Azure](../Troubleshooting/#azure-cloud-deployment){:target="_blank" rel="noopener"}.

&nbsp;

&nbsp;

---

&nbsp;

# DevOps Readme - Rapid Cloud Preview

This project illustrates using API Logic Server with Docker and docker-compose.  The objective is to provide a simple way to explore using docker with API Logic Server on your local machine.  These are *not* production procedures - they are designed for simple local machine operation.

This doc explains:

* **I. Creating the project** - create the project from a docker database and run under the IDE

* **II. Running the project as an *image*** - create and run an image

* **III. Running the project as a *docker-compose*** - build, deploy and run

* **IV. Status, Open Issues (eg, not working on windows)** 

This presumes you have Python, and docker.

&nbsp;

&nbsp;

# General Setup

Stop the docker-compose container, if it is running.

&nbsp;

## 1. Install API Logic Server

Install the current (or [preview](https://apilogicserver.github.io/Docs/#preview-version)) release.  Use the `ApiLogicServer` command to verify the version > 9.1.33.

&nbsp;

## 2. Install this project from git

Follow this procedure to obtain the *empty* project from git:

```
# git clone https://github.com/ApiLogicServer/docker-compose-mysql-classicmodels.git
# cd docker-compose-mysql-classicmodels
```

Follow the directions in the readme.

&nbsp;

&nbsp;

# I. Create the Project

Follow the steps below:

&nbsp;

## 1. Start the MySQL database container:

```bash
docker run --name mysql-container --net dev-network -p 3306:3306 -d -e MYSQL_ROOT_PASSWORD=p apilogicserver/mysql8.0:latest
```

Verify it looks like this:

![Authdb](images/devops/multi-tier/authdb.png)

&nbsp;

## 2. Create the Project:

Create the project with API Logic Server:

```bash
ApiLogicServer create --project_name=. --db_url=mysql+pymysql://root:p@localhost:3306/classicmodels
```

&nbsp;

## 3. Verify proper operation

The project should be ready to run without customization:

1. Open the project in VSCode

![Project Structure](images/devops/multi-tier/docker-compose.png)

2. Establish your (possibly preview) virtual environment

3. Press F5 to run the server

4. Run the [Admin App](http://localhost:5656), and Swagger.  Verify that `customers` returns data.

&nbsp;

## 4. Add Security - using the terminal window inside VSCode:

**Stop the server.**

Open a ***new* terminal window** in VSCode:

> The *current* terminal window has an old copy of the project root.  If you try to run, you will see *No such file or directory".  Just open another terminal window and repeat the command.

```bash
ApiLogicServer add-auth --project_name=. --db_url=mysql+pymysql://root:p@localhost:3306/authdb
```

The system introspects your `--db_url` database, creates models for it, and configures your project to enable security.

The command above uses the pre-supplied [docker database](https://apilogicserver.github.io/Docs/Database-Connectivity/#docker-databases), here MySQL.

Security databases must include certain tables and columns.  Your authdb can optionally provide a superset of these.  Such extensions are useful in declaring role-based authorization.

To help you get started, the `auth-db` folder provides starter kits for creating these databases.  Alter these files for your project, prepare database containers for your team, and use them in the `add-auth` command above.

Re-run the project (F5), observe you need to login (***admin, p***).

&nbsp;

&nbsp;

# II. Running the git project as image

These scripts simplify creating and running docker containers for your project.  Their use is illustrated in the links above.

Important Notes:

1. The docker compose steps use the created image, so you must perform this step first

2. The image must contain the security models created in the step above

&nbsp;

## 1. Stop the Server 

Stop the API Logic Project, using your IDE.

&nbsp;

## 2. Build the Image

> For preview versions, verify `devops/docker-image/build_image.dockerfile` is using `apilogicserver/api_logic_server_x` (note the *_x*).

&nbsp;

```bash
sh devops/docker-image/build_image.sh .
```

&nbsp;

## 3. Observe the pre-configured server

When run from a container, the database uri using `localhost` (from above) does not work.  Confirm the following in `devops/docker-image/env.list`:

```
APILOGICPROJECT_SQLALCHEMY_DATABASE_URI=mysql+pymysql://root:p@mysql-container:3306/classicmodels
APILOGICPROJECT_SQLALCHEMY_DATABASE_URI_AUTHENTICATION=mysql+pymysql://root:p@mysql-container:3306/authdb
```

&nbsp;

## 4. Start the Server

Use the pre-created command line script:

```bash
sh devops/docker-image/run_image.sh
```

&nbsp;

## 5. Run the App

Run the [Admin App](http://localhost:5656), and Swagger.

You can also run the [Authentication Administration App](http://localhost:5656/admin/authentication_admin/) to define users and roles (though not required).

&nbsp;

&nbsp;

# III. Running the git project as docker-compose

Use docker compose to choreograph multiple services (e.g, your application and a database) for a multi-tiered system.


&nbsp;

## 1. Stop the server and docker database

Press ctl-C to stop the API Logic Project container.

The procedure below will spin up *another* database container.  If the current database container is running, you will see port conflicts.

**Stop** the database container (e.g., using Docker Desktop).

&nbsp;

## 2. Observe the pre-configured database service

Open `devops/docker-image/docker-compose.yml`, and observe:

```yaml
    mysql-service:
        image: apilogicserver/mysql8.0:latest
        restart: always
        environment:
            # MYSQL_DATABASE: 'db'
            # So you don't have to use root, but you can if you like
            - MYSQL_USER=root
            # You can use whatever password you like
            - MYSQL_PASSWORD=p
            # Password for root access
            - MYSQL_ROOT_PASSWORD=p
        ports:
            # <Port exposed> : <MySQL Port running inside container>
            - '3306:3306'
        expose:
            # Opens port 3306 on the container
            - '3306'
```

&nbsp;

## 3. Build, Deploy and Run

The following will build, deploy and start the container stack locally:

```
# sh devops/docker-compose/docker-compose.sh
```

Then, in your browser, open [`localhost`](http://localhost).

&nbsp;

### Manual Port configuration (not required)

The shell script above simply obtains your IP address, and stores in in an env file for server.

Alternatively, you can enter your port into `devops/docker-image/env-docker-compose.env`.

Then, use the following to build, deploy and start the default container stack locally:

```
# docker-compose -f ./devops/docker-compose/docker-compose.yml --env-file ./devops/docker-compose/env-docker-compose.env up
```

Then, in your browser, open [`localhost`](http://localhost).

&nbsp;

## 4. Observe Pre-configured Security

The database contains `authdb`.  To activate security, observe `devops/docker-compose/docker-compose.yml`:

1. Set `- SECURITY_ENABLED=true`

2. Under api-logic-server-environment, observe:

`          - APILOGICPROJECT_SQLALCHEMY_DATABASE_URI_AUTHENTICATION=mysql+pymysql://root:p@mysql-service:3306/authdb
`

&nbsp;

## IV. Deploy to cloud

***Under construction***

Steps to create:

az login

you will be redirected to a browser login page

and then you will see your account information in the CLI

&nbsp;

### Create the database in azure:

```bash
az container create --resource-group <resource group name> --name postgresql-container --image apilogicserver/postgres:latest --dns-name-label postgresql-container --ports 5432 --environment-variables PGDATA=/pgdata POSTGRES_PASSWORD=p
```


```bash
az container show --resource-group <resource group name> --name postgresql-container --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table
```

&nbsp;

### Deploy the App Container

```bash
az container create --resource-group <resource group name> --name <container name> --image <docker hub registry name>/<repository name>:<version> --dns-name-label <container name> --ports 5656 5002 --environment-variables SECURITY_ENABLED=True PYTHONPATH=/app/ApiLogicProject APILOGICPROJECT_SQLALCHEMY_DATABASE_URI=postgresql://postgres:p@postgresql-container.centralus.azurecontainer.io:5432/postgres APILOGICPROJECT_SQLALCHEMY_DATABASE_URI_AUTHENTICATION=postgresql://postgres:p@postgresql-container.centralus.azurecontainer.io:5432/authdb APILOGICPROJECT_SECURITY_ENABLED=True
```

Verify:

```bash
az container show --resource-group <resource group name> --name <container name> --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table
```

&nbsp;


# Status

Works with API Logic Server > 9.1.33.








