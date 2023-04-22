!!! pied-piper "TL;DR - Compute virtual attribute `checksum` in `loaded_as_persistent`, verify on save"

    SQLAlchemy provides the `loaded_as_persistent` event, enabling us to compute the `check_sum`, store it in the row, and check it on update.

    Storing it in the row is critical because we do not want to maintain server state between client calls.  For that, we can use `@jsonapi_attr`.

    Declaring this *virtual attribute* is TBD.


## Event `loaded_as_persistent`

Looks like this:

```python
    @event.listens_for(session, `loaded_as_persistent`)
    def receive_loaded_as_persistent(session, instance):
        "listen for the 'loaded_as_persistent' event"

        logger.debug(f'{__name__} - compute checksum')
```

We can listen for it at server start.

## safrs `@jsonapi_attr`

This provides a mechanism to define attributes as part of the row (so it sent to / returned from the client), and not saved to disk.  It looks like this, for Employee:

```python
    from safrs import jsonapi_attr
    # add derived attribute: https://github.com/thomaxxl/safrs/blob/master/examples/demo_pythonanywhere_com.py
    @jsonapi_attr
    def proper_salary(self):  # type: ignore [no-redef]
        import database.models as models
        if isinstance(self, models.Employee):
            import decimal
            rtn_value = self.Salary
            rtn_value = decimal.Decimal('1.25') * rtn_value
            self._proper_salary = int(rtn_value)
            return self._proper_salary
        else:
            print("class")
            return db.Decimal(10)

    @proper_salary.setter
    def proper_salary(self, value):  # type: ignore [no-redef]
        self._proper_salary = value
        print(f'_proper_salary={self._proper_salary}')
        pass
```

## Open Issue: declaring `@jsonapi_attr`

The current example for `proper_salary` fails, since the getter/setter must be of the model (here, Employee) class.  The code above works if hand-entered in `database.models.py`.

However, that is not ideal... if `models.py` is rebuilt-from-model, these changes are lost.  I looked into the following:

### Declare in subclass; fails in logic

It would not be difficult to generate current models with the suffix `_base`, then sublcass all these models in a customer-alterable file, initially empty.  

However, this failed, since LogicBank uses simple mechanisms to find attributes and relationships.  This might be an extensive change.

### Declare in mixin: fails to be invoked by safrs

Other approach is to generate models like this:

```python
class Employee(SAFRSBase, Base, models_mix.Employee_mix):
```

where `models_mix.Employee_mix` is a user-alterable file that defines virtual attributes.  However, this does not appear to work (be called) for `@jsonapi_attr`s.  Hand-altered prototype: https://github.com/valhuber/opt_locking_mix.



