## Declaring Logic

Analogous to logic declarations, Developers declare filters for users' roles (role-based access control).  A user can have multiple roles; a users' filters are **OR**ed together.

Roles are typically defined elsewhere (LDAP, AD, external SQL database), and accessed at runtime via the Authentication-Provider.  Roles simplify administration, since there are typically many fewer roles that users, and they are less subject to change.  You may elect to define the roles in your code for code completion, as shown below.

![Declare Security](images/security/declare-security.png){ align=left }

&nbsp;

## Sample

This is illustrated in the sample application `security/declare_security.py`:

```python
from security.system.authorization import Grant, Security
from database import models
import database
import safrs
import logging

"""
Illustrates declarative security - role-based authorization to database rows.

* See [documentation](https://apilogicserver.github.io/Docs/Security-Overview/)

* Security is activate in `config.py`
"""

app_logger = logging.getLogger(__name__)

db = safrs.DB
session = db.session


class Roles():
    """ Define Roles here, so can use code completion (Roles.tenant) """
    tenant = "tenant"
    renter = "renter"
    manager = "manager"

Grant(  on_entity = models.Category,    # illustrate multi-tenant - u1 shows only row 1
        to_role = Roles.tenant,
        filter = lambda : models.Category.Client_id == Security.current_user().client_id)  # User table attributes

Grant(  on_entity = models.Category,    # u2 has both roles - should return client_id 2 (2, 3, 4), and 5
        to_role = Roles.manager,
        filter = lambda : models.Category.Id == 5)

app_logger.debug("Declare Security complete - security/declare_security.py"
    + f' -- {len(database.authentication_models.metadata.tables)} tables loaded')
```

You can test it via the Admin App, or via Swagger.

&nbsp;

### Admin App

Click `Category` in the Admin App:

![Role-based authorization](images/security/security-admin.png){ align=left }


&nbsp;

### Swagger

The same result is visible in Swagger:

![Role-based authorization](images/security/swagger-categories.png){ align=left }