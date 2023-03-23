Under Construction

[Containers](../DevOps-Containers){:target="_blank" rel="noopener"} are a best practice for deployment, *and* offer several advantables for development.  This outlines a typical scenario for deploying API Logic Server projects to Azure.

![Container Overview](images/docker/container-dev-deploy.png)

## Deploying Containers

One of the main features of containers is that you can use them to deploy your system to the cloud.  S

Under construction.  Coming soon.

&nbsp;

## Create Azure Account

## Create Managed Database

Used: https://learn.microsoft.com/en-us/azure/azure-sql/database/free-sql-db-free-account-how-to-deploy?view=azuresql#create-a-database

what is managed



### database nwlogic 



### Load Data: Azure Data Tools

![Azure Data Tools](images/docker/azure/data-tools.png)

Extensions for MySQL, Postgres

### Use SqlServer Auth

Login failed for user '<token-identified principal>'. The server is not currently configured to accept this token.

## Portal

![Azure Data Tools](images/docker/azure/portal.png)


## Create Container

![Azure Data Tools](images/docker/azure/create-container.png)

```bash
az container create --resource-group myResourceGroup --name mycontainer --image apilogicserver/docker_api_logic_project:latest --dns-name-label val-demo --ports 5656 --environment-variables 'FLASK_HOST'='mssql+pyodbc://valhuber:PWD@mysqlserver-nwlogic.database.windows.net:1433/nwlogic?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=no' 'VERBOSE'='True'
```


## Run Admin App


## Trouble Shooting

```bash
az container logs --resource-group myResourceGroup --name mycontainer
```

### SqlServer Auth Type (AD vs SQLServer Auth)

### pyodbc version

### ssh to container

Unable to get this working





