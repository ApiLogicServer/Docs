The sample application [(run it here)](http://apilogicserver.pythonanywhere.com/admin-app/index.html) is created from the database shown below [(tutorial here)](../Tutorial).  It is an extension to Northwind that includes additional relationships:

* multiple relationships between Department / Employee
* multi-field relationships between Order / Location
* self-relationships in Department

## Northwind with Logic

The integrity of this database is enforced with [this logic](../Logic-Why/#solution-rules-are-an-executable-design).

![Sample Database](images/model/sample-database.png)


## Standard Northwind
Specify your database as `nw-` to use the same database, but _without pre-installed customizations_ for the API and Logic.
