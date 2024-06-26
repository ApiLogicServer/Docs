## Customize the Model: add relationships, derived attributes
Model files describe your database tables.  You can extend these, e.g. to __add relationships__, and __add derived attributes__.

> Note: relationships are a particularly critical aspect of the model.  While they normally come from your schema and are discovered during `ApiLogicServer create`, they are often missing from the database.  You can add them as shown below.
  
&nbsp;

### Edit ```models.py```: referential integrity (e.g., sqlite)

[Rebuild support](Project-Rebuild.md) enables you to rebuild your project, preserving customizations you have made to the api, logic and app.  You can rebuild from the database, or from the model.

This enables you to edit the model to specify aspects not captured in creating the model from your schema.  For example, sqlite often is not configured to enforce referential integrity.  SQLAlchemy provides  support to fill such gaps.

For example, try to delete the last order for the first customer.  You will encounter an error since the default is to nullify foreign keys, which in this case is not allowed.

You can fix this by altering your ```models.py:```

```
    OrderDetailList = relationship('OrderDetail', cascade='all, delete', cascade_backrefs=True, backref='Order')
```

Your api, logic and ui are not (directly) dependent on this setting, so there is no need to rebuild; just restart the server, and the system will properly cascade the `Order` delete to the `OrderDetail` rows.  Note further that logic will automatically adjust any data dependent on these deletions (e.g. adjust sums and counts).

&nbsp;

### Edit `customize_models.py`: add relationships, derived attributes
In addition, you may wish to edit `customize_models.py`, for example:

* to define [relationships](https://github.com/valhuber/LogicBank/wiki/Managing-Rules#database-design), critical for multi-table logic, APIs, and web apps

     * See [this example](https://github.com/ApiLogicServer/demo/blob/main/database/customize_models.py).

* to describe derived attributes, so that your API, logic and apps are not limited to the physical data model
