!!! pied-piper ":bulb: TL;DR: Run-venv = dev-venv + CLI"

    For internal API Logic Server Developers, there are 2 distinct `venv` environents:

    1. Run-venv: key libs (Flask, SQLAlchemy, SAFRS), + CLI

        * This is used for created projects

    2. Dev-venv: key libs only

        * This is used to develop API Logic Server (the internals)

&nbsp;
    
## Run `venv`

This is used by created projects.  It supports:

* Execution
* CLI operations such as adding authentication, rebuild etc.

As such, this `venv` includes the entire API Logic Server package - [source here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/base/requirements.txt){:target="_blank" rel="noopener"}:

```bash
# this includes the key libraries (Flask, SQLAlchemy, SAFRS), and the API Logic Server CLI

ApiLogicServer
```

&nbsp;

### Key Libs

As you'd expect, this `venv` includes the key runtime libs, such as Flask, SQLAlchemy, Safrs, LogicBank, etc.

&nbsp;

### Admin App Runtime

In addition, this `venv` contains the Admin App Runtime.  Note it's not in the GitHub project; it's placed in your source tree by the dev install procedure as a `gitignore` directory.

For more information, [see Admin App Reuse](Architecture-admin-app-reuse.md){:target="_blank" rel="noopener"}.

If the dev inst

&nbsp;

## Dev `venv`

The [dev `dev venv`](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/requirements.txt){:target="_blank" rel="noopener"} includes all the key libs, ***plus** the CLI.  

Note it's also defined in the `setup.py`.

Note this **does *not*** include the CLI.  That is because the dev environment is focused on *changing* the CLI, so it's important not to confuse you/Python about whether you are running code from the `venv` or the source tree.  We want the latter, so we omit this from the `venv`.
