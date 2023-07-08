This page does _not_ address created projects, rather, it is about the API Logic Server system used to create projects.  It is for those who want to extend the product or understand how it works, not for those simply using the product.

# How to Install it

Follow these steps to:

* Obtain the software from GitHub
* Open it in your IDE
* Perform basic testing
* Build and release (including automated testing)
* Change and integrate Safrs React Admin (Admin app)


## Obtain the projects from GitHub

To create the projects:

1. Create an empty folder (e.g., `~/dev/ApiLogicServer`)
2. Optionally, install the product there (creating a venv)
      * You can use this venv as a shared venv for testing
3. Download and run [the install-ApiLogicServer-dev procedure](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/install-ApiLogicServer-dev.sh) (note: Windows users use `install-ApiLogicServer-dev.ps1`), e.g.:

```bash title="Install API Logic Server Development environment"
cd ~/dev/ApiLogicServer/  # project directories created here
sh install-ApiLogicServer-dev.sh vscode
```

This will use `git clone` to create folders in `~/dev/ApiLogicServer/ApiLogicServer-dev/org/:`

![dev structure](images/internals/dev-structure.png)
  
It's basically straightforward, _though note_ the `cp` command which copies the `safrs-react-admin` runtime to API Logic Server for subsequent creation of API Logic Projects:

```bash
    echo "\ncopying build (sra - safrs-react-admin) --> ApiLogicServer"
    cp -r ../build api_logic_server_cli/create_from_model/safrs-react-admin-npm-build
```

> Note: `curl` must be installed for this procedure.

&nbsp;

## Open the dev workspace in your IDE

`install-ApiLogicServer...` will create a project (`~/dev/ApiLogicServer/ApiLogicServer-dev/org/ApiLogicServer-src/.vscode/ApiLogicServerDev.code-workspace`), and open it VS Code or PyCharm.

Python requires a virtual environment; the procedure differs for `vscode` vs. `charm`:

* `vscode` projects are created with a `venv` and are ready to run the Launch Configurations to create the sample
* `charm` projects require that you create the `venv` with the PyCharm

It should look something like this:

![dev structure](images/internals/dev-project.png)

&nbsp;

## Create the Sample (`~/dev/servers/ApiLogicProject`)

Once in your IDE, you can run the pre-defined launch configuration `0 - Create and Run ApiLogicProject` to create and run the sample.  This creates `~/dev/servers/ApiLogicProject`.

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/vscode/dev-run.png?raw=true"></figure>

&nbsp;

## Introduce enhancements, test

Note the Run Configurations below:

![dev structure](images/internals/run-configs.png)

Consider using **Run Config #1** to create a project, alter it as desired.  Note:

* You can use the debugger (inside the **IDE dev instance**) to debug the altered project

* The created/altered project is **git-ignored**, so is *not* part of any branch

You can then use **Run Config #2** to test it in a new project / ide instance.

1. Run the **behave tests** to ensure existing functionality is not broken

&nbsp;

## Update CLI creation

Update `api_logic_server_cli/project_prototype` (and probably `api_logic_server_cli/project_prototype_nw`) for enchanced creation

&nbsp;


## Build and Test

As of version 6.02.20, test automation ([located here](https://github.com/valhuber/ApiLogicServer/tree/main/tests/build_and_test)) replaces a series of manually executed scripts ([located here](https://github.com/valhuber/ApiLogicServer/tree/main/tests/creation_tests)).  These have been verified on Mac, Linux (Ubuntu) and Windows.

The automated test (use the launch configuration `BUILD AND TEST`) performs a number of steps.  You can configure the test to run some or all of these by editing the ``env_xxx.py` files shown here:

![Test env files](images/internals/test-env-files.png)

&nbsp;

#### `do_install_api_logic_server`

This:

1. Runs the standard Python build: `python3 setup.py sdist bdist_wheel`
2. Installs it into a Python environment `dev/servers/install/ApiLogicServer/venv`
3. Installs `pyodbc`.  Note this requires you have installed `odbc`, but install failures are intentionally ignored (instead, skip the Sql/Server database with`do_docker_sqlserver = False` )

!!! pied-piper ":bulb: venv can be used for projects"

    You will probably find it helpful to use this as a [shared venv](../Project-Env/#shared-venv).

#### `do_create_api_logic_project`...

This creates the sample project, runs the server, and tests the logic using the behave tests.  It produces quite a lot of output which you can ignore.  The test is designed to terminate if the tests fail.

These are extensive tests which verify project creation, server startup, logic and some minimal API testing (the Behave tests issue APIs to read/write data).

#### `do_allocation_test`

This is a complex rule example.

#### `do_docker_<database>`

These create projects from docker databases ([see here](../Database-Connectivity/#docker-databases)) which are expected to be running.  They perform minimal validation to ensure the server starts by executing the _hello world_ API.  

    This in fact verifies that the `models.py` file is created and runs.

&nbsp;

## Get Docs working

The install procedure also installs `Org-ApiLogicServer/Docs`.  Follow it's readme.

&bnsp;

## Testing Packages

In some cases, you may wish to test using experimental version of underlying packages, such as `safrs` or `logicbank`.  You can [add multiple paths to Python Path](https://stackoverflow.com/questions/41471578/visual-studio-code-how-to-add-multiple-paths-to-python-path){:target="_blank" rel="noopener"} like this:

*1.* Edit `ApiLogicServer/.vscode/settings.json` to identify the desired packages, e.g.:

```
    "terminal.integrated.env.osx": 
        { "PYTHONPATH": "/Users/val/dev/safrs" }
```

If yu have more than one, separate them with *colon*s.

*2.* With the ApiLogicServer venv active, `pip uninstall` the packages you want to test

*3.* Exit the ApiLogicServer workspace, and restart VSCode on the `ApiLogicServer` folder (not workspace)

*4.* Use the Run Configs to create/test the app, e.g., `2 - Debug ApiLogicProject`

> **Note:** you will need to perform a similar process if you want an *installed* local version of ApiLogicServer using the `tests/build_and_test` procedure.

This procedure sometimes fails.  You can also try adding your package to the `env' in the Run Config:

```json
        {
            "name": "No Security ApiLogicServer (e.g., simpler swagger)",
            "type": "python",
            "request": "launch",
            "program": "api_logic_server_run.py",
            "redirectOutput": true,
            "env": {"PYTHONPATH": "/Users/val/dev/safrs", "SECURITY_ENABLED": "False", "PYTHONHASHSEED": "0", "OPT_LOCKING": "optional", "verbose": "True"},
            "justMyCode": false,
            "args": ["--flask_host=localhost", "--port=5656", "--swagger_host=localhost", "--verbose=False"],
            "console": "internalConsole",
            "internalConsoleOptions": "openOnSessionStart"
        },
```
&nbsp;

### Simpler for LogicBank: local install

It's easy to create a local install for LogicBank.  First, you need to install the source:

```bash
cd ~/dev
git clone https://github.com/valhuber/LogicBank.git
```

Then, build it and add to the ApiLogicServer venv:

*1.* Create Logic Bank installer on your hard drive

```bash
python3 setup.py sdist bdist_wheel
```

*2.* With the ApiLogicServer venv active, `pip uninstall LogicBank`

*3.* With the ApiLogicServer venv active, `python3 -m pip install ~/dev/LogicBank`

&nbsp;

## Develop / Debug admin app

Once you have created the API Logic Project, you can restart the server like this (it is _not_ necessary to recreate the sample each time you run):

```bash title="Start API Logic Project"
cd ~/dev/servers/ApiLogicProject
python3 api_logic_server_run.py
```

You can obtain an editable version of the admin app like this:

```bash title="Get Data Provider"
cd ~/dev/safrs-react-admin
git clone https://github.com/thomaxxl/rav3-jsonapi-client # modified data provider used, installed in the project root
```

Then, to debug (with server running):

```bash title="Execute debug version of admin app"
npm install --global yarn # required only once
yarn install
yarn run build

yarn start
```

To make this the runtime used to create API Logic Projects:

```bash title="Update ApiLogicServer to use your admin app"
cp -a /build/. ../ApiLogicServer/api_logic_server_cli/create_from_model/admin/
```

&nbsp;

# Docker Startup

You can review the dockerfile on `github`.  Note that the normal operation is to start a terminal session as the last step:

```bash
CMD ["bash"]
```

When bash sessions are started, Linux runs `.bashrc`.  This checks for environment variables which can be used to load an existing project from git, and run it.  (Note: this defeats the normal terminal startup).  For example, start Docker using `-e` arguments, like this:


```bash
docker run -it --name api_logic_server --rm --net dev-network \
-p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost \
-e APILOGICSERVER_GIT='https://github.com/valhuber/Tutorial-ApiLogicProject.git' \
-e APILOGICSERVER_FIXUP='/localhost/Project-Fixup.sh' \
apilogicserver/api_logic_server
```


Alternatively, you can start Docker specifying an initial command, like this:
```bash
docker run -it --name api_logic_server --rm --net dev-network \
-p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost \
apilogicserver/api_logic_server \
sh /home/api_logic_server/bin/run-project.sh https://github.com/valhuber/Tutorial-ApiLogicProject.git /localhost/Project-Fixup.sh
```

In both cases, the git load is performed by `bin/run-project.sh`, which you can explore on github.

&nbsp;

## SQL Server testing with VSC

### Background

While Sql/Server itself runs nicely under docker, there is considerable complexity in installing OCBC.  As further described below, this led to a number of issues (ignoring time spent):

* `pyodbc` not pip-installed by default (installs fail unless odbc is installed, which is complex and might not be needed)

* multiple docker images (arm, amd)

* arm image unable to load odbc *and* run in VSCode .devcontainer

I am eager for suggestions to simplify / unify sql/server and odbc usage.  I'd hoped that `mcr.microsoft.com/devcontainers/python:3.11-bullseye` might include odbc, but it did not appear to be the case.  Since this image is considerably larger (1.77G) than python:3.9.4-slim-bullseye (895M), I went with the python versions.

&nbsp;

#### Complex ODBC Setup

As noted above, `pip` installs of pyodbc fail unless the odbc is installed.  Since not all users need odbc, the `pip` install does not include pyodbc.

##### For users

For users requiring pyodbc (SqlServer), there are 2 installs:

* ODBC Driver: [using `brew` as described here](../install-pyodbc){:target="_blank" rel="noopener"}

* `pip install pyodbc==4.0.34`

&nbsp;

##### For ApiLogicServer-dev

ApiLogicServer-dev `requirements.txt` does **not** install odbc.  If you wish to test Sql/Server in ApiLogicServer-dev, follow the user setup instructions above.

&nbsp;

#### Docker

Docker creation provides the opportunity to pre-install odbc and simplify life for Sql/Server users.  After considerable effort, we were able to create dockers with a *consistent* verisons of odbc (v18).  The procedure differs for amd/intel vs. arm, as described below.

&nbsp;

##### Docker amd works

The above instructions depend on `brew`, which is not convenient within a dockerfile.  So, it's installed as follows: [click to see dockerfile](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/docker/api_logic_server.Dockerfile){:target="_blank" rel="noopener"}.  This works well with Sql/Server, running as a devcontainer under VSCode.

* Note: this took days to discover.  Special thanks to Max Tardideau at [Gallium Data](https://www.galliumdata.com){:target="_blank" rel="noopener"}.


&nbsp;

##### Docker arm fails

The arm version is installed like this: [click to see dockerfile](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/docker/api_logic_server_arm.Dockerfile){:target="_blank" rel="noopener"}.  This...

* Works well with VSCode devcontainers, for *non-odbc* databases

* But, **does not include odbc.**

    * Attempting to introduce odbc fails with *ERROR: failed to solve: process "/bin/sh -c ACCEPT_EULA=Y apt-get install -y msodbcsql18" did not complete successfully: exit code: 100*.

odbc inclusion was solved with [this finding](https://stackoverflow.com/questions/71414579/how-to-install-msodbcsql-in-debian-based-dockerfile-with-an-apple-silicon-host){:target="_blank" rel="noopener"}, using `FROM --platform=linux/amd64` (special thanks to Joshua Schlichting and Dale K).

So, we created [this dockerfile **with odbc**](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/docker/api_logic_server_arm_x.Dockerfile){:target="_blank" rel="noopener"}.  Use it with a .devcontainer specifying `FROM apilogicserver/api_logic_server_arm_x`, or use [this test project](https://github.com/ApiLogicServer/beta){:target="_blank" rel="noopener"}.

* That does indeed enable odbc access from docker...

* But it ***fails with VSCode*** -- the Python extension is either disabled, or hangs on install (screen shots below).

![Unable to load Python](images/vscode/python-disabled.png)

![Python install hangs](images/vscode/python-install-hangs.png)

* Issue: on start, message: *WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested*

&nbsp;

#### VSC Bug - Run Configs

VSCode has a bug where it cannot parse Run Configs for SqlSvr:

```bash
zsh: no matches found: --db_url=mssql+pyodbc://sa:Posey3861@localhost:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no
```

&nbsp;

### Testing

There are several important testing configurations.

&nbsp;

#### 1. ApiLogicServer-dev

To get around the *VSC bug*, hacks were made to the Run Configs, and the CLI, as described below.

The run config has entries like this:

```
        {
            "name": "SQL Server nw (bypass vsc bug)",
            "type": "python",
            "request": "launch",
            "cwd": "${workspaceFolder}/api_logic_server_cli",
            "program": "cli.py",
            "redirectOutput": true,
            "argsExpansion": "none",
            "args": ["create",
                "--project_name=../../../servers/sqlsvr_nw",
                "--db_url=sqlsvr-nw"
            ],
            "console": "integratedTerminal"
        },
```

The CLI detects db_url's like `sqlsvr-nw`, and converts them to strings like this for [Database Connectivity > Docker Databases](../Database-Connectivity/#docker-databases){:target="_blank" rel="noopener"}:
```
    elif project.db_url == 'sqlsvr-nw':  # work-around - VSCode run config arg parsing
        rtn_abs_db_url = 'mssql+pyodbc://sa:Posey3861@localhost:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no'
    elif project.db_url == 'sqlsvr-nw-docker':  # work-around - VSCode run config arg parsing
        rtn_abs_db_url = 'mssql+pyodbc://sa:Posey3861@HOST_IP:1433/NORTHWND?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=no'
        host_ip = "10.0.0.234"  # ApiLogicServer create  --project_name=/localhost/sqlsvr-nw-docker --db_url=sqlsvr-nw-docker
        if os.getenv('HOST_IP'):
            host_ip = os.getenv('HOST_IP')  # type: ignore # type: str
        rtn_abs_db_url = rtn_abs_db_url.replace("HOST_IP", host_ip)
    elif project.db_url == 'sqlsvr-nw-docker-arm':  # work-around - VSCode run config arg parsing
        rtn_abs_db_url = 'mssql+pyodbc://sa:Posey3861@10.0.0.77:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no'
        host_ip = "10.0.0.77"  # ApiLogicServer create  --project_name=/localhost/sqlsvr-nw-docker --db_url=sqlsvr-nw-docker-arm
        if os.getenv('HOST_IP'):
            host_ip = os.getenv('HOST_IP')  # type: ignore # type: str
        rtn_abs_db_url = rtn_abs_db_url.replace("HOST_IP", host_ip)
```

So, on ApiLogicServer-dev:

1. Verify your machine has odbc **18** (using `brew which`)
2. Use **Run Config:** `SQL Server nw (bypass vsc bug)`

&nbsp;


#### 2. Local `pip` install

Note: since the docker image is odbc17, the following commands fail in docker, but run in pip install when you've installed odbc18:

```
ApiLogicServer create --project_name=sqlsvr-nw --db_url=sqlsvr-nw
```

#### 3. Docker (ARM pending)

You can run a ***Docker with ODBC*** (pending for arm with VSC):

```
# arm docker uses odbc18 (note the quotes around the db_url):
ApiLogicServer create  --project_name=/localhost/sqlserver --db_url='mssql+pyodbc://sa:Posey3861@10.0.0.77:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no'

# or, using the abbrevation
ApiLogicServer create  --project_name=/localhost/sqlsvr-nw-docker --db_url=sqlsvr-nw-docker-arm

# amd docker requires IP addresses:
ApiLogicServer create --project_name=/localhost/sqlserver --db_url='mssql+pyodbc://sa:Posey3861@10.0.0.234:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no'

# or, using the abbreviation (amd):
ApiLogicServer create  --project_name=/localhost/sqlsvr-nw-docker --db_url=sqlsvr-nw-docker
```

&nbsp;

# Useful links

As a contributor, you will likely work with:

* [Docker Databases](../Database-Connectivity)
* [Shared virtual environments](../Project-Env)
