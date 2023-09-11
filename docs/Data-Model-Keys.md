A critical part of enabling API Logic Server automation is providing for Primary and Foreign Keys.  

## Primary Keys

These are expected to defined in the database.  They are required for updates, and for the Admin App.

&nbsp;

### `--infer_unique_keys`

In some (discouraged) cases, your schema might not declare a primary key, but 

* designate a specific column as `unique`, or
* declare a unique constraint or index

The `--infer_unique_keys` option is provided to address such cases.  It will presume the unique column/constraint/index is a primary key, and class creation will proceed normally.

&nbsp;

### Table vs. Class

If your table has no primary key, and `infer_unique_keys` does not apply, the system will create a table instead of a class.  This significantly reduces functionality: no api, no rules, no admin app, etc.

Such situations are flagged on creation as follows for the `EmployeeSkills` table in a ChatGPT-created [Employee Skills database](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/tests/test_databases/mysql_test_databases/employee-skills.sql){:target="_blank" rel="noopener"}:

```bash
Welcome to API Logic Server, 09.02.24

                 .. .. .. ..Create EmployeeSkills as table, because no Unique Constraint   


Customizable project ../../../servers/employee_skills created from database mysql+pymysql://root:p@localhost:3306/employee_skills.  Next steps:


Run API Logic Server:
  cd ../../../servers/employee_skills;  python api_logic_server_run.py

Customize using your IDE:
  code ../../../servers/employee_skills  # e.g., open VSCode on created project
  Establish your Python environment - see https://apilogicserver.github.io/Docs/IDE-Execute/#execute-prebuilt-launch-configurations
```

## Foreign Keys

These are also expected to be defined in the database.  They are required for a large set of automation, including:

* Multi-table APIs

* Multi-table forms, including Automatic Joins

* Multi-Table logic (such as sums, counts, parent references, and copy)

If these are missing in the schema, you can provide them in the SQLAlchemy models, as illustrated in [the sample project](https://github.com/valhuber/ApiLogicServer/blob/main/api_logic_server_cli/project_prototype_nw/database/customize_models.py).