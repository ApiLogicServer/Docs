Use the `add-auth` command to activate security.  Specify:

1. `--provider-type`: sql, keycloak, or your custom auth provider
2. `--db-url`: the persistent store to identify valid users and their roles.  These can be stores such as LDAP or Microsoft AD, or a security sql database.

&nbsp;

## Examples

Use your IDE's terminal window positioned at your project root:

```bash title='Configure Security - Examples'
als add-auth --provider-type=sql --db-url=
als add-auth --provider-type=sql --db_url=postgresql://postgres:p@localhost/authdb

als add-auth --provider-type=keycloak --db-url=localhost
als add-auth --provider-type=keycloak --db-url=hardened
```

&nbsp;

## `add-auth` Internal Processing

### Updates `config.py`

Internally, this updates `conf/config.py`:

![config](images/security/add-auth.png)

### Creates auth models


&nbsp;

## Appendix: Internals

The Security Manager and sqlite Authentication-Provider are built into created projects from the [system's prototype project](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/api_logic_server_cli/prototypes/nw){:target="_blank" rel="noopener"}.

