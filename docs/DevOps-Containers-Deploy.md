[Containers](../DevOps-Containers){:target="_blank" rel="noopener"} are a best practice for deployment, *and* offer several advantages for development.  This outlines a typical scenario for deploying API Logic Server projects to Azure.

This tutorial presumes you've already `push`ed an image, here called `apilogicserver/docker_api_logic_project:latest`.

![Container Overview](images/docker/container-dev-deploy.png)

&nbsp;

## Create Azure Account

I created a free account, electing the $200 free option.  In the entire exercise, I used less than $2 of my allotment.

&nbsp;

## Create Managed Database

Creating the database was straightforward using Microsoft documentation.  To see it, [click here](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-sql-db-free-account-how-to-deploy?view=azuresql#create-a-database){:target="_blank" rel="noopener"}.

> Note: we used the database name `nwlogic`.

Note this is a *managed database*, which means that Azure will apply DBMS updates, take backups, etc.  Contrast this to running a database in a bare container, where you'd need to arrange such services yourself.

&nbsp;

### Container Group

The database creation wizard requires that you create a [container group](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-container-groups){:target="_blank" rel="noopener"}.

&nbsp;

### database `nwlogic` 

For this tutorial we created the database `nwlogic`.  It is an exact replica of the sample (nw) [sample database](Sample-Database{:target="_blank" rel="noopener"}), using SqlServer.

&nbsp;

### Load Data: Azure Data Tools

After creating the database, load the data using tools like [PyCharm Data Tools](Database-Connectivity/#pycharm-database-tools){:target="_blank" rel="noopener"}, or [DbVis](Database-Connectivity/#dbvis){:target="_blank" rel="noopener"}. 

To find the sql scripts, [click here](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/tests/sql_server){:target="_blank" rel="noopener"}.

&nbsp;

## Portal

![Azure Data Tools](images/docker/azure/portal.png)

&nbsp;

## Create Container

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

## Run Admin App

The `create` command above starts the server.  After that, you can run the admin app: http://val-demo.eastus.azurecontainer.io:5656/.

&nbsp;

## Trouble Shooting

Use this command to view Azure logs:

```bash
az container logs --resource-group myResourceGroup --name mycontainer
```

For specific error conditions, see [Troubleshooting Azure](../Troubleshooting/#azure-cloud-deployment){:target="_blank" rel="noopener"}.





