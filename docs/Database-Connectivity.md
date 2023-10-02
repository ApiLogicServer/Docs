This page lists some of the databases we have tested, including various (Mac-oriented) configuration notes.

Recall the `db_url` parameter is a SQLAlchemy URI.  To see some examples, see below, and use

```bash
ApiLogicServer examples
```

This produces a console log like:
```bash
Creates and optionally runs a customizable Api Logic Project

Examples:
  ApiLogicServer create-and-run
  ApiLogicServer create-and-run --db_url=sqlite:///nw.sqlite
  ApiLogicServer create-and-run --db_url=mysql+pymysql://root:p@mysql-container:3306/classicmodels --project_name=/localhost/docker_db_project
  ApiLogicServer create-and-run --db_url=mssql+pyodbc://sa:Posey3861@localhost:1433/NORTHWND?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=no
  ApiLogicServer create-and-run --db_url=postgresql://postgres:p@10.0.0.234/postgres
  ApiLogicServer create --project_name=my_schema --db_url=postgresql://postgres:p@localhost/my_schema
  ApiLogicServer create --project_name=oracle_hr --db_url='oracle+oracledb://hr:tiger@localhost:1521/?service_name=ORCL'
  ApiLogicServer create --db_url=postgresql+psycopg2://postgres:password@localhost:5432/postgres?options=-csearch_path%3Dmy_db_schema
  ApiLogicServer create --project_name=Chinook \
    --host=ApiLogicServer.pythonanywhere.com --port= \
    --db_url=mysql+pymysql://ApiLogicServer:***@ApiLogicServer.mysql.pythonanywhere-services.com/ApiLogicServer\$Chinook

Where --db_url is one of...
   <default>                     Sample DB                    - https://valhuber.github.io/ApiLogicServer/Sample-Database/
   nw-                           Sample DB, no customizations - add later with perform_customizations.py
   <SQLAlchemy Database URI>     Your own database            - https://docs.sqlalchemy.org/en/14/core/engines.html
                                      Other URI examples:     - https://apilogicserver.github.io/Docs/Database-Connectivity/
 
Docs: https://valhuber.github.io/ApiLogicServer/
```

Important notes:

* tables without primary keys are not imported as classes, and do not appear in your API or Admin application

&nbsp;

# Verify Database Connectivity

Database connectivity can be... trying.  Before attempting the SQLAlchemy connectivity discussed here, it's a best practice to make sure your computer can connec to the database server.  One possible approach is a command line utility called `telnet`.

First, ensure your machine has telnet installed.  Consult the documentation for your OS type.  Note that Windows 11 requires this command (use Powershell, and **run as adminstrator**):

```
Enable-WindowsOptionalFeature -Online -FeatureName TelnetClient
```

Then, you can issue a command such as:

```
telnet 10.0.0.77 3306  # where you subsitute IP address)
```
If you are prompted for your database password, you have established connectivity.

&nbsp;

# Sqlite

You can use an existing sqlite database like this:
```
ApiLogicServer create --project_name=Allocation --db_url=sqlite:////Users/val/Desktop/database.sqlite
```

Other important notes:

* As shown above, use the __full path__
* So that such databases are included in your project, they are copied to the `database` folder, and renamed to `db.sqlite'
* Sqlite databases are copied to your project, [as described here](../Database-Connectivity/#sqlite){:target="_blank" rel="noopener"}.  
* The project URL is made *relative* to this location (`sqlite:///../database/db.sqlite`).  This keeps your projects portable, e.g., colleagues can pull your project from `GitHub` and run.

&nbsp;

## Installation

The sqlite runtime is installed with API Logic Server.  You might, however, wish to install the command line tools.

These are typically already installed on Mac computers.

For windows, download and unzip this file:

![sqlite download](images/database/get-sqlite3.png)

And copy the 3 exe files to a place where they can be run, such as `~/AppData/Local/Microsoft/WindowsApps`:

![sqlite installation](images/database/install-sqlite3.png)

&nbsp;

## Northwind - sqlite (default sample)

See [Sample Database](../Sample-Database).

This is a sqlite database, packaged with API Logic Server, so you can explore without any installs.  It is obtained from [Northwind](https://github.com/jpwhite3/northwind-SQLite3), and altered to include several columns to demonstrate rules.

Run under API Logic Server docker:
```
ApiLogicServer run --project_name=/localhost/docker_project
```

## Chinook - Albums and Artists

Designate this as follows: `--db_url={install}/Chinook_Sqlite.sqlite`, e.g.:

```
~/ApiLogicServer/api_logic_server_cli/database/Chinook_Sqlite.sqlite
```

&nbsp;

## SQLite Database Abbreviations

To make experimenting easier, you can specify a [`db_url` shortcut](../Data-Model-Examples).

&nbsp;

# Docker Databases

See [Docker Test Databases](../Database-Docker).

&nbsp;

# Managing Database in your IDE

Various IDEs provide tools for managing databases.

&nbsp;

## dbvis

A very popular tool, with support for exporting tables and data.

For local connections, consider resetting `trustServerCertificate`:

![DBVis](images/model/trusted-connection.png)

&nbsp;

## adminer

You can [find it here](https://hub.docker.com/_/adminer).

Try:
```
docker run --name adminer --link some_database:db -p 8080:8080 --net dev-network adminer
```

Then you can hit http://localhost:8080 or http://host-ip:8080 in your browser:

![Customize in your IDE](images/docker/databases/aadminer.png){ align=left }

> You will need to install plug-ins for sqlite3, to address logging in without a password

&nbsp;

## PyCharm Database Tools

Pycharm provides excellent [database tools](https://www.jetbrains.com/help/pycharm/2021.3/database-tool-window.html), as shown below:

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/PyCharm/database-tools.png"></figure>

&nbsp;

## VSCode Database Tools

I also use [SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools).  To use it, you must first install drivers:

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/docker/VSCode/SQLTools/SQLTools-drivers.png"></figure>

You may want to install extensions for MySQL and Postgres.

Then, you can explore the sample:

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/docker/VSCode/SQLTools/SQLTools-sample.png"></figure>

&nbsp;

## Docker pgadmin

See [discussion above](#northwind-postgres-docker).

&nbsp;

## Azure Data Studio

See [discussion above](#northwind-sqlserver-docker).

&nbsp;

# PythonAnywhere

PythonAnyWhere provides the ability to create and connect to databases.  For example, create a project like this from within PythonAnyWhere:

```bash title="Create database for mysql/Chinook"
  ApiLogicServer create --project_name=Chinook \
      --host=ApiLogicServer.pythonanywhere.com --port= \
      --db_url=mysql+pymysql://ApiLogicServer:Your-DB-Password@ApiLogicServer.mysql.pythonanywhere-services.com/ApiLogicServer\$Chinook
```

Notes:

* Be aware of [connectivity and firewall issues](https://help.pythonanywhere.com/pages/AccessingMySQLFromOutsidePythonAnywhere/).

&nbsp;

