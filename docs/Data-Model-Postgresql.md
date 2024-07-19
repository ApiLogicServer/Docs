This page outlines considerations using postgresql.

## Creating

Our tests create the database [like this](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/tests/test_databases/postgres_databases/northwind.sql){:target="_blank" rel="noopener"}:

```sql
--
-- Revised for als from  https://github.com/pthom/northwind_psql/blob/master/northwind.sql
--
DROP DATABASE IF EXISTS northwind;
CREATE DATABASE northwind;
\c northwind;

-- in docker container/terminal
-- psql--username=postgres


CREATE TABLE employees (
    employee_id SERIAL,
    last_name character varying(20) NOT NULL,
    first_name character varying(10) NOT NULL...

ALTER TABLE ONLY employees
    ADD CONSTRAINT pk_employees PRIMARY KEY (employee_id);

SELECT setval('employees_employee_id_seq', (SELECT MAX(employee_id) FROM employees));
```

&nbsp;

## Connecting

We refer to it like this:

```bash
        {
            "name": "5 - Create Postgres (servers)",
            "type": "debugpy",
            "request": "launch",
            "cwd": "${workspaceFolder}/api_logic_server_cli",
            "justMyCode": false,
            "program": "cli.py",
            "redirectOutput": true,
            "args": ["create","--project_name=../../../servers/postgres-nw",
                "--db_url=postgresql://postgres:p@localhost/northwind"],
            "console": "integratedTerminal"
        },
```

&nbsp;

## Auto-generated keys

As you can see above, using `SERIAL` works, creating models that look like this:

```python

class Employee(SAFRSBase, Base):
    __tablename__ = 'employees'
    _s_collection_name = 'Employee'  # type: ignore
    __bind_key__ = 'None'

    employee_id = Column(Integer, server_default=text("nextval('employees_employee_id_seq'::regclass)"), primary_key=True)
    last_name = Column(String(20), nullable=False)
    first_name = Column(String(10), nullable=False)
```

&nbsp;

## Loading Test Data

The example above illustrates how we create test databases, and load data.  To make subequent inserts work, note you need to initialize sequences, e.g.:

```sql
SELECT setval('employees_employee_id_seq', (SELECT MAX(employee_id) FROM employees));
```