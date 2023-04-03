For databases with many tables, it may be desirable to filter these when creating your model. 

As of release 8.1.11, `ApiLogicServer create` provides a `--include_tables` option.  You can include or exclude tables based on regex expressions.

You designate a yaml file of regex expressions, such as:

```yaml
---
include:
  - I.*
  - J
  - X.*
exclude:
  - X1.*
```

For example, you can exclude the Region:

```bash
ApiLogicServer create --project_name=nw_filtered --db_url=nw --include_tables=nw_filter.yml
```

where nw_filter contains:
```yaml
---
include:
  - .*
exclude:
  - Region
```

!!! pied-piper "Heads up - exact match syntax ^Region$"

    Regex infers implicit leading/trailing wildcards.  For exact match, use ^Region$ in the example above


> As of release 8.1.12, you can omit the include/extend tag, and/or the values under them.  Prior releases require these tags to be present, and populated (e.g., use 'a^' to exclude nothing)
