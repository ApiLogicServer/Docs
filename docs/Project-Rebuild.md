The system is designed to accomodate database schema changes over the course of your project.  Such
changes preserve customizations you have made to your api, logic and app.

After changing your database, you can issue:

```bash
ApiLogicServer rebuild-from-database --db_url=sqlite:///basic_demo/database/db.sqlite
```

Or, after changing your database model, you can issue:


```bash
ApiLogicServer rebuild-from-model
```

These alternatives depend on whether you drive changes from your model, or from your database using database tools.  For more information, see [Database Changes](Database-Changes.md){:target="_blank" rel="noopener"}.
