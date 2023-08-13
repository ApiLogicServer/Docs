

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
