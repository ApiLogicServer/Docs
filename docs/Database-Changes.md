!!! pied-piper ":bulb: TL;DR - Executable Test Suite, Documentation"

      You can change your database schema and rebuild your project, preserving customizations to your api and admin app.  You can drive changes from either:

      * Your database, using your database tools

      * Your `database/models.py` file, using alembic to drive those changes into the database

      To reconcile your api and admin app, you then issue `als rebuild-from-model` or 'rebuild-from-database`


&nbsp;

## Rebuilding

Ignoring the boxes labeled "rebuild", the key elements of the creation process are illustrated below:

* the system reads the database schema to create `models.py`

* `models.py` drives the creation process

* you customize the created project, mainly by altering the files on the far right

As shown in the diagram, creation is always driven from `models.py.`  Models differ from physical schemas in important ways:

* the system ensures that class names are capitalized and singular

* there are good reasons to customize `models.py`:
   * to add foreign keys missing in the database - these are critical for multi-table apis and applications
   * to provide better naming

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/extended_builder/rebuild-from.png?raw=true"></figure>

You can rebuild your project, preserving customizations (including any additional files you have created).  You have 2 alternatives, depending on where you choose the _"source of truth"_ for your database:

| Source of Truth | Means | Use `rebuild` option |
| :--- |:---|:---|
| Database | The schema is the source of truth<br><br>It includes all the foreign keys | `rebuild-from-datatabase:` rebuilds the files shown in blue and purple. |
| Model | Model is the source of truth<br><br>Use SQLAlchemy services to drive changes into the database |`rebuild-from-model:` rebuilds the files shown in blue |

Note that `ui/admin/admin.yaml` is never overwritten (the dotted line 
means it is written on only on `create` commands).  After rebuilds, merge the new `ui/admin/admin-created.yaml` into your customized `admin.yaml.`

For more information, see [Alembic](Data-Model-Customization.md){:target="_blank" rel="noopener"}.

&nbsp;

### API and Admin App merge updates

As of release 5.02.03, ```rebuild``` services provide support for updating customized API and Admin:

| System Object | Support |
| :---  | :--- |
| API | `api/expose_api_models_created.py` created with new `database/models.py` classes |
| Admn App | `ui/admin/admin-merge.yaml` is the merge of `ui/admin/admin.yaml` and new `database/models.py` classes |

Review the altered files, edit (if required), and copy them over the original files.

&nbsp;

### Use Alembic to update database schema from model

As of release 5.02.03, created API Logic Projects integrate [Alembic](https://alembic.sqlalchemy.org/en/latest/index.html) to perform database migrations.

* Manual: create migration scripts by hand, or
* Autogenerate: alter your `database/models.py`, and have alembic create the migration scripts for you

Preconfiguration includes:

* initialized `database/alembic` directory
* configured `database/alembic/env.py` for autogenerations
* configured `database/alembic.ini` for directory structure

See the `readme` in your `database/alembic` for more information.
