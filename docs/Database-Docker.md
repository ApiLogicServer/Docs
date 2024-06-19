Docker is a wonderful way to get known databases for your project, and eliminate often-messy database installs.  The docker databases below were created for use with API Logic Server, but you may find them generally useful. 

General notes:

* **Images include data:** the databases below contain data, so they are easier to install for dev.  In production, you would almost certainly separate storage from the database server.

* **Authdb:** in addition to the database noted below, the MySQL and Postgres versions contain `authdb`, so you can begin exploring / testing security.  You may wish to alter these to introduce additional data you can use in Grant declarations.

&nbsp;

## Quick Start

You probably don't need _all_ these, but here's how you start the docker databases (schema details below):

```
docker network create dev-network  # only required once

docker run --name mysql-container --net dev-network -p 3306:3306 -d -e MYSQL_ROOT_PASSWORD=p apilogicserver/mysql8.0:latest

docker run -d --name postgresql-container --net dev-network -p 5432:5432 -e PGDATA=/pgdata -e POSTGRES_PASSWORD=p apilogicserver/postgres:latest

docker run --name sqlsvr-container --net dev-network -p 1433:1433 -d apilogicserver/sqlsvr:latest

docker run --name sqlsvr-container --net dev-network -p 1433:1433 -d apilogicserver/sqlsvr-m1:latest  # Mac M1
```

![Docker databases](images/docker/databases/docker-db-versions.png)

&nbsp;

## Managing Docker DBs

For some internal notes on using Docker command line tools with Docker databases, [click here.](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/tests/test_databases/docker_databases){:target="_blank" rel="noopener"}

&nbsp;

## Connecting to Docker DBs

The examples below illustrate connecting _to_ dockerized databases.  You can connect _from_ `pip` installs, or from API Logic Server containers, as described below.

&nbsp;

### Locally, From `pip` Install

If you are using `pip install` version of API Logic Server.  Differences to note:

* the `/localhost` path is typically not required
* the server host address is `localhost`
* Note related in install procedure, the SqlServer example illustrates you can single-quote the url, instead of using the `\` escapes

```
ApiLogicServer create --project_name=sqlserver --db_url='mssql+pyodbc://sa:Posey3861@localhost:1433/SampleDB?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no'

ApiLogicServer create --project_name=classicmodels --db_url='mysql+pymysql://root:p@localhost:3306/classicmodels'

ApiLogicServer create --project_name=postgres --db_url=postgresql://postgres:p@localhost/postgres
```

&nbsp;

### From Container

To connect from docker containers, you must to enable connectivity from your API Logic Server container to your database container.  See the instructions below.

&nbsp;

#### Create Docker network

Start the docker machine like this (Windows users - use Powershell) to enable connectivity from your API Logic Server container to your database container:

```
cd ~/dev/servers  # project directories will be created here
docker network create dev-network  # only required once
docker run -it --name api_logic_server --rm -p 5656:5656 -p 5002:5002 --net dev-network -v ${PWD}:/ApiLogicServer apilogicserver/api_logic_server
```

And then, you can refer to the container names (`sqlsvr-container` instead of an IP name) for your database uri, e.g.:

```
mssql+pyodbc://sa:Posey3861@sqlsvr-container:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no"
```

&nbsp;

#### VSCode - enable network

If you are running API Logic Server in a container, and accessing dockerized databases, you will need to enable connectivity by uncommenting the indicated line in the diagram below:

![docker-db-access](images/docker/databases/docker-db-access.png)]

The diagram above, and the examples below, presume you have created a docker network called `dev-network`, as shown at the top of this page.

&nbsp;

### SqlServer SQLAlchemy URIs

Important considerations for SQLAlchemy URIs:

* The example above runs on a mac

* It depends on the version of ODBC Driver; for example, a more recent version is:

```
  mssql+pyodbc://sa:Posey3861@localhost:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no
```

* Observe the additional parameter for encryption ([see here](https://stackoverflow.com/questions/71587239/operationalerror-when-trying-to-connect-to-sql-server-database-using-pyodbc){:target="_blank" rel="noopener"})

* On Linux (and inside docker), the URI is:

```bash
--db_url='mssql+pyodbc://sa:Posey3861@sqlsvr-container:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no'
```

* In VSCode launch configurations, the `db_url` fails, a situation I have resolved and would welcome help on...

&nbsp;


## Sample DBs: `apilogicserver`

&nbsp;

### MySQL

#### classicmodels

Docker below built from [MySQL Tutorials](https://www.mysqltutorial.org/mysql-sample-database.aspx/){:target="_blank" rel="noopener"} - Customers, Orders...

```
docker run --name mysql-container --net dev-network -p 3306:3306 -d -e MYSQL_ROOT_PASSWORD=p apilogicserver/mysql8.0:version1.0.7
```

Then access using Docker:
```
ApiLogicServer create --project_name=/localhost/classicmodels --db_url=mysql+pymysql://root:p@mysql-container:3306/classicmodels
```

&nbsp;

#### MySQL Native user

If you are using VSCode, you may wish to [use tools](#vscode-database-tools) to manage and query your database.  A useful resource is [this video](https://www.youtube.com/watch?v=wzdCpJY6Y4c&ab_channel=BoostMyTool){:target="_blank" rel="noopener"}, which illustrates using *SQLTools*, a VSCode extension.  Connecting to Docker databases has proven difficult for many, but this video shows that the solution is to create a *native* user:
```
Create new MySQL user with old authentication method:
CREATE USER 'sqluser'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'sqluser'@'%';
FLUSH PRIVILEGES;
```

&nbsp;

#### Sakila

Obtained from [Sakila](https://github.com/LintangWisesa/Sakila_MySQL_Example){:target="_blank" rel="noopener"} - Actors and Films.

Installed in Docker per [these instructions](https://medium.com/@crmcmullen/how-to-run-mysql-in-a-docker-container-on-macos-with-persistent-local-data-58b89aec496a){:target="_blank" rel="noopener"}.

```
ApiLogicServer create --project_name=/localhost/sakila --db_url=mysql+pymysql://root:p@mysql-container/sakila
```

&nbsp;

#### Chinook

Obtained from [Chinook](https://github.com/lerocha/chinook-database){:target="_blank" rel="noopener"}s.

```
ApiLogicServer create --project_name=/localhost/chinook --db_url=mysql+pymysql://root:p@mysql-container/Chinook
```

&nbsp;


### Postgres

#### Northwind


Obtained from [pthom at git](https://github.com/pthom/northwind_psql){:target="_blank" rel="noopener"} - many thanks!

Installed in Docker per [these instructions](https://dev.to/shree_j/how-to-install-and-run-psql-using-docker-41j2){:target="_blank" rel="noopener"}.

```
docker run -d --name postgresql-container --net dev-network -p 5432:5432 -e PGDATA=/pgdata -e POSTGRES_PASSWORD=p apilogicserver/postgres:latest
```

Run under API Logic Server docker:
```
ApiLogicServer create --project_name=/localhost/postgres --db_url=postgresql://postgres:p@postgresql-container/postgres
```

> It may be necessary to replace the docker container name with your IP address, e.g., --db_url=postgresql://postgres:p@10.0.0.236/postgres

Docker pgadmin:
```
docker run --name pgadmin -p 5050:5050 thajeztah/pgadmin4
```

JDBC (for tools): `postgresql://postgres:p@10.0.0.234/postgres`

##### Version Update: 2.0.0

In prior versions, note the datatype ```bpchar``` (blank-padded char) results in several evidently benign messages like:
```
packages/sqlalchemy/dialects/postgresql/base.py:3185: SAWarning: Did not recognize type 'bpchar' of column 'customer_id'
```

The current version uses `character varying(5)`, and should not exhibit issues such as [Element does not exist](https://github.com/valhuber/ApiLogicServer/issues/48){:target="_blank" rel="noopener"}.


##### bpchar

This [was researched](https://github.com/sqlalchemy/sqlalchemy/discussions/8592){:target="_blank" rel="noopener"}.  

This database used `bpchar`` (an *old* datatype), with *no length* (a logical error - blank pad to unspecified length??).  So, the maintainers corrected the bogus example to eliminate the use of bpchar. 

Here is the [revised standard](https://github.com/pthom/northwind_psql/blob/master/northwind.sql), which we are using as our [test example](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/tests/postgres_databases/northwind.sql){:target="_blank" rel="noopener"}.

&nbsp;

### SqlServer

#### Northwind

Start SQL Server:

```
docker run --name sqlsvr-container --net dev-network -p 1433:1433 -d apilogicserver/sqlsvr:version2.0.1
```

Then, under API Logic Server, Docker installed:
```
ApiLogicServer create --project_name=/localhost/sqlserver --db_url=mssql+pyodbc://sa:Posey3861@sqlsvr-container:1433/NORTHWND?driver=ODBC+Driver+17+for+SQL+Server\&trusted_connection=no
```

You will probably also want to get [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15){:target="_blank" rel="noopener"}, and configure a connection like this (password: posey3861):

![Azure Data Tools](images/docker/databases/sqlsvr-conn.png)

It also supports connecting to Azure-based databases:

![Azure Data Tools](images/docker/azure/data-tools.png)

### Oracle

This procedure explores accessing oracle 19c via SQLAlchemy, using oracledb.  Many thanks to the following:

* [This article](https://medium.com/oracledevs/using-the-development-branch-of-sqlalchemy-2-0-with-python-oracledb-d6e89090899c){:target="_blank" rel="noopener"}.

* The [following sample code](https://github.com/cjbj/python-oracledb-demos-2022/blob/main/6_sqlalchemy_example.py){:target="_blank" rel="noopener"}.

* [This docker image](https://registry.hub.docker.com/r/doctorkirk/oracle-19c)

[This Project](https://github.com/valhuber/python-oracledb-SQLAlchemy){:target="_blank" rel="noopener"} contains short programs you can use to explore Oracle and SQLAlchemy.

&nbsp;

#### Obtain the Docker Image

**Set up Oracle Volume**

```bash
cd ~/dev/ApiLogicServer/oracle
mkdir oracle-19c
chmod -R 755 oracle-19c
```

**Start the Oracle Database**

For amd architectures, this will install Oracle 19 and SqlPlus (command line SQL):

```bash
docker run --name oracle-19c -p 1521:1521 -e ORACLE_SID=ORCL -e ORACLE_PWD=tiger -v ~/dev/ApiLogicServer/oracle/oracle-19c/oradata/:/opt/oracle/oradata doctorkirk/oracle-19c 
```

> Note: Start takes several minutes (initially) once docker is downloaded/started.  It's large: over 5GB (smaller images are available).

> Note: This fails under M-series Macs.  There are several web articles that discuss how to make this work, but we have not tried them.

**Verify SqlPlus Works**

Use Docker desktop > terminal to login to `sqlplus` with system/tiger.  Some commands you might want:

```sql
-- list schemas

select * from all_users;

select USERNAME from all_users;

alter session set current_schema = HR;

SELECT table_name FROM all_tables WHERE owner = 'HR';

-- determine service name

select value from v$parameter where name like '%service_name%';
```

&nbsp;

#### HR

To explore Oracle using the Oracle HR database...

##### Deploy the HR Example

Use [this documentation](https://docs.oracle.com/en/database/oracle/oracle-database/19/comsc/installing-sample-schemas.html#GUID-CB945E4C-D08A-4B26-A12D-3D6D688467EA){:target="_blank" rel="noopener"}.

The installer will ask several questions; we used the following responses:

> args: 1 = tiger, 2 = users, 3 = temp, 4 = tiger, 5 = $ORACLE_HOME/demo/schema/log/

Here, for example, is the [create sql](https://github.com/oracle-samples/db-sample-schemas/blob/main/human_resources/hr_create.sql){:target="_blank" rel="noopener"}.

&nbsp;

##### Create API Logic Project

```bash
ApiLogicServer create --project_name=oracle_hr --db_url='oracle+oracledb://hr:tiger@localhost:1521/?service_name=ORCL'
```

Notes:

1. `oracle+oracledb` designates the database type.  ApiLogicServer includes this driver, so you don't need to pip-install it.

2. Observe the login is `hr` (not `system`).  The previous step defines the `hr` user as having the default schema as `hr`.  This is one approach for filtering the tables for a specific schema.  

3. Note the `service_name=ORCL` corresponds to `ORACLE_SID=ORCL` on the docker start command above.

&nbsp;

#### New user/database

Some basic SqlPlus commands for creating a user / schema:

```sql
create user STRESS identified by tiger;

GRANT CONNECT, RESOURCE, DBA TO STRESS;

connect STRESS;

SELECT table_name FROM all_tables WHERE owner = 'STRESS';

```

You can create tables now (note user prefix not required per `connect`).

## Create Your Own DB Image

The API Logic Server project provides several docker databasesas described above.  A simple approach is to build on one of these, to add your own data, and to create your own database container for your team.  This provides a valuable "common starting place" for test database structure and test data.

&nbsp;

### 1. Add Databases, Test Data

You can access the database cli via Docker Desktop, to add databases, data etc as shown below.

Created projects contain "cheat-sheet" instructions for logging into your database; [click here](https://github.com/ApiLogicServer/demo/tree/main/devops/auth-db).

> [See here](Tech-Docker.md#preparing-a-database-image-for-self-contained-databases.md){:target="_blank" rel="noopener"} for another example on how to update / save a docker image.


![Authdb](images/devops/multi-tier/authdb.png)

&nbsp;

### 2. Push Docker Image

The same created directory contains `authdb_mysql.Dockerfile`, with instructions to convert a running (database) container to an image, and push it to your own DockerHub account.
