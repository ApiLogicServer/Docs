The sample application [(run it here)](http://apilogicserver.pythonanywhere.com/admin-app/index.html) is created from the database shown below [(tutorial here)](../Tutorial).  It is an extension to Northwind that includes additional relationships:

* multiple relationships between Department / Employee
* multi-field relationships between Order / Location
* self-relationships in Department

## Northwind with Logic

The integrity of this database is enforced with [this logic](../Logic-Why/#solution-rules-are-an-executable-design).

![Sample Database](images/model/sample-database.png)


## Northwind without logic

Specify your database as `nw-` to use the same database, but _without pre-installed customizations_ for the API and Logic.  See below for an example.

&nbsp;

### Activate Security

Activate security using the `ApiLogicServer add-auth` command.

So, to create the sample _without customizations_ and then add security:

```bash
ApiLogicServer create --project_name=nw --db_url=nw-
cd nw
ApiLogicServer add-auth --project_name=. --db_url=auth
```

Test it as described in [Authorization](../Security-Authorization/#sample).

Note the use of `--db_url=nw-` to create the sample, _without customization or security._

> If you are new to API Logic Server, this is a good way to observe basic project creation.

This command will:

1. Add the sqlite database and models, using `ApiLogicServer add-db --db_url=auth --bind_key=authentication`
    * This uses [Multi-Database Support](../Data-Model-Multi){:target="_blank" rel="noopener"} for the sqlite authentication data
2. Add `User.Login`` endpoint to the User model
3. Set `SECURITY_ENABLED` in `config.py`
4. Add Sample authorizations to `security/declare_security.py`

