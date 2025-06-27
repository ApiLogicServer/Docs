!!! pied-piper ":bulb: TL;DR: 2 venvs: Run-venv, Dev-venv (no CLI)"

    For internal API Logic Server Developers, there are 2 distinct `venv` environents:

    1. Run-venv: contains key libs (Flask, SQLAlchemy, SAFRS), and the CLI

        * This is used for created projects

    2. Dev-venv: key libs only (no CLI)

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

The sections below describe the general components, and why CLI elements are included in the Run `venv`

&nbsp;

### Key Libs

As you'd expect, this `venv` includes the key runtime libs, such as Flask, SQLAlchemy, Safrs, LogicBank, etc.

&nbsp;

### CLI Services

The CLI provides commands such as `add-auth` and `rebuild`.  These are required for existing projects.

&nbsp;

### Admin App Runtime

In addition, this `venv` contains the Admin App Runtime.  Note it's not in the GitHub project; it's placed in your source tree by the dev install procedure as a `gitignore` directory.

For more information, [see Admin App Reuse](Architecture-admin-app-reuse.md){:target="_blank" rel="noopener"}.

If the dev inst fails to include this (e.g., improper dev-install, or dev-install failures), the Admin App will fail to run.

&nbsp;

## Dev `venv`

The [dev `dev venv`](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/requirements.txt){:target="_blank" rel="noopener"} includes all the key libs, ***but not** the CLI.  

Note it's also defined in the `setup.py`.

Note this **does *not*** include the CLI.  That is because the dev environment is focused on *changing* the CLI, so it's important not to confuse you/Python about whether you are running code from the `venv`, or from the source tree.  We want the latter, so we omit this from the `venv`.

There are 2 reasonable strategies for testing CLI changes:

1. Use the Manager: use a launch-config to run the cli, and alter the api_logic_server code in the `vwnv`
2. Use the dev env, and

    * create `.vscpde/launch.json` entries that set `cwd` to the target project (see: *Basic Demo - add-app*), and
    * ensure that manager files can be found (openAI learning) with `"env": {"APILOGICSERVER_DEBUG": "True", "APILOGICSERVER_HOME": "${workspaceFolder}"}`
