### SqlServer - install `pyodbc`

This is included in Docker, but not for local installs.  To install `pyodbc` (either global to your machine, or within a `venv`):

* Linux

```bash
apt install unixodbc-dev   # Linux only
pip install pyodbc
```

* Mac - using [brew](https://brew.sh/):

Install the [Microsoft ODBC driver](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver16), then:

```bash
# may be required - brew install unixodbc      # Mac only
pip install pyodbc==5.2.0
```
## Unix SQL Server downgrade to 17 in Docker
Running a SQL Server docker image connecting to a client database may require downgrading to version 17 of the unixodbc driver.  You can test the installed versions by basing into docker and running this command.
```
docker exec -it {container_id} bash
odbcinst -d -q
```

### Install build and ODBC unix driver dependencies version 17
```
# add this to you docker file after the copy command
# devops/docker-image/build_image.dockerfile
RUN apt-get update && \
    apt-get install -y curl gnupg apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev gcc g++ python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN pip install --upgrade pip && \
    pip install pyodbc==5.2.0
```
* Windows - not resolved - [this approach](https://github.com/mkleehammer/pyodbc/issues/1010) is not tested

Please see the examples on the [testing](Database-Connectivity.md) for important considerations in specifying SQLAlchemy URIs.

&nbsp;

### Limitations - SqlServer Sort fields

Note Sql/Server may not sort on certain fields such as images or long text.  This shows up, for example, in the Docker SqlServer sample database for `Category`.  So, when testing these in Swagger, modify your Sort fields accordingly.

&nbsp;