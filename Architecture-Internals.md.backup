## Technology Lineage: 40+ Years of Production Success

**TL;DR:** API Logic Server represents the modern evolution of business rules technology proven across **6,000+ enterprise deployments** spanning four decades, from Wang Labs PACE through Versata to today's cloud-native architecture.

### Historical Evolution

**1. Wang Labs PACE (1980s-1990s)**
- Original commercial business rules platform
- **6,000+ corporate customers** running mission-critical systems
- Pioneered declarative multi-table derivations and constraints
- Proved "5 rules replace 200 lines of code" at enterprise scale
- Established automatic dependency ordering and chaining

**2. Versata (1990s-2010s)**
- $3.4 billion startup backed by founders of Microsoft, Sybase, Ingres, Informix
- Fortune 500 enterprise deployments
- Advanced the rules engine with optimization (pruning, delta-based adjustments)
- Demonstrated correctness and performance at massive scale
- Validated the declarative paradigm across thousands of production systems

**3. API Logic Server / GenAI-Logic (2020s-present)**
- Modern evolution: same proven patterns, contemporary stack
- Python/SQLAlchemy (vs. Java/JDBC)
- Cloud-native (Docker/Kubernetes)
- Open source and extensible
- GenAI integration (natural language → declarative rules)
- Modern integration patterns (REST/JSON:API, Kafka, webhooks)

**Key Insight:** This technology is **not experimental**. The core architectural patterns (declarative rules, automatic dependency discovery, multi-table chaining, foreign key change handling) have been validated across 40+ years and thousands of production deployments.

&nbsp;

## Why Declarative Architecture Matters: The NL → DSL → Engines Pattern

**Read:** [Declarative GenAI: The Architecture Behind Enterprise Vibe Automation](https://medium.com/@valjhuber/declarative-genai-the-architecture-behind-enterprise-vibe-automation-1b8a4fe4fbd7)

This Medium article explains the fundamental architectural distinction that makes GenAI-Logic different:

**The Problem: "FrankenCode"**

Traditional GenAI vibe tools generate 200+ lines of buggy procedural code that:
- Misses corner cases (e.g., changing customer on order, changing product on item)
- Violates SOA principles (logic dumped on client)
- Creates instant technical debt (unmaintainable, opaque)
- Requires explicit handlers for every possible change path

**The Solution: Declarative GenAI**

Natural Language → Domain-Specific Language → Runtime Engines

Instead of generating procedural code, GenAI generates **declarative specifications** executed by proven runtime engines:

1. **Database Layer:** SQLAlchemy ORM with intelligent defaulting
2. **API Layer:** JSON:API engine with full rule enforcement, Swagger docs, MCP support
3. **UI Layer:** YAML-driven React Admin (working app, not scaffolding)
4. **Logic Layer:** Rules engine providing:
   - Automatic pruned invocation (attribute-level granularity)
   - Dependency ordering (auto-discovered from rule definitions)
   - Optimized chaining (delta-based, avoids expensive SQL aggregates)
   - Automatic completeness (handles ALL change paths, not just obvious ones)

**Critical: Rules as Correctness Guarantee**

Declarative rules aren't optional or a "coding style" - they're a **fundamental architectural requirement** for correctness in multi-table logic:

- **Dependency chains:** `Product.unit_price` change transitively affects `Item.unit_price` → `Item.amount` → `Order.amount_total` → `Customer.balance`
- **Foreign key changes:** When `Order.customer_id` changes, engine automatically adjusts **both** old and new customer balances
- **Automatic completeness:** Engine handles ALL possible change paths; procedural code inherently misses corner cases

**Why procedural fails:** Even AI-generated code misses critical cases because it requires explicit handlers for every change path. The rules engine eliminates this entire class of bugs through automatic dependency analysis and chaining.

**The Paradox Resolution:** Declarative DSL in Python, executed by runtime engine handling 95% of typical business logic (remaining 5% uses standard Python event handlers).

&nbsp;

## CRITICAL: Understanding the Nested Manager Architecture

The development environment has **two distinct Manager workspaces**:

**1. Seminal Manager** - `~/dev/ApiLogicServer/ApiLogicServer-dev/`
- Original Manager installation from `als start`
- Stable, persistent workspace
- Contains `build_and_test/` directory
- Used to run the BLT process
- Houses `org_git/` with source repositories

**2. BLT Manager (Nested)** - `~/dev/ApiLogicServer/ApiLogicServer-dev/build_and_test/ApiLogicServer/`
- Created and refreshed by the BLT (Build, Load and Test) process
- Contains rebuilt/tested version of API Logic Server
- Contains sample projects (`basic_demo`, `nw_sample`, etc.) for testing
- Has its own venv shared by test projects
- Gets regenerated with each BLT run
- Contains `system/ApiLogicServer-Internal-Dev/copilot-dev-context.md` for AI context restoration

**Complete Directory Structure:**
```
~/dev/ApiLogicServer/ApiLogicServer-dev/          # Seminal Manager
├── build_and_test/
│   └── ApiLogicServer/                           # BLT Manager (nested workspace)
│       ├── samples/                              # Sample/test projects
│       │   ├── basic_demo_sample/
│       │   ├── nw_sample/
│       │   └── ...
│       ├── venv/                                 # Shared venv for test projects
│       ├── system/
│       │   └── ApiLogicServer-Internal-Dev/      # Internal dev tooling
│       │       ├── copilot-dev-context.md        # AI context restoration
│       │       └── install-ApiLogicServer-dev.sh # Dev environment setup
│       └── docs/                                 # Training materials
└── org_git/
    ├── ApiLogicServer-src/                       # Framework source (edit here)
    │   └── api_logic_server_cli/
    │       └── prototypes/
    │           ├── base/                         # Templates for created projects
    │           └── manager/                      # Manager workspace templates
    |       └── tests/
    |           └── build_and_test/               # system rebuild and test -> build_and_test 
    └── Docs/                                     # Documentation project
        └── docs/
            └── Architecture-Internals.md         # This page
```

**Development Workflow:**
1. Edit framework code in `org_git/ApiLogicServer-src/`
2. Run BLT from Seminal Manager (rebuilds, tests, regenerates BLT Manager)
3. Test with sample projects in BLT Manager workspace
4. BLT Manager gets fresh context from `system/ApiLogicServer-Internal-Dev/copilot-dev-context.md` after each rebuild

**Why This Architecture:**
- **Isolation:** Changes being tested don't affect stable Seminal Manager
- **Clean slate:** Each BLT run creates fresh testing environment
- **Shared venv:** Test projects reuse BLT Manager's venv (speeds testing)
- **Context preservation:** `system/ApiLogicServer-Internal-Dev/copilot-dev-context.md` re-establishes understanding after rebuild

&nbsp;

## Cross-References for Full Context

**For Strategic Architecture Understanding:**
- `system/ApiLogicServer-Internal-Dev/copilot-dev-context.md` - Technology lineage, declarative architecture, NL→DSL→Engines pattern
- [Medium Article](https://medium.com/@valjhuber/declarative-genai-the-architecture-behind-enterprise-vibe-automation-1b8a4fe4fbd7) - Complete architectural rationale

**For Created Project Development:**
- Manager-level `.copilot-instructions.md` - How to CREATE projects
- Project-level `.copilot-instructions.md` - How to EXTEND/CUSTOMIZE projects
- `docs/training/logic_bank_api.prompt` - LogicBank API reference (in each project)
- `docs/training/testing.md` - Behave testing guide (1755 lines, in each project)

**For End Users:**
- [API Logic Server Documentation](https://apilogicserver.github.io/Docs/Doc-Home/) - Complete user guide
- [Installation](https://apilogicserver.github.io/Docs/Install/) - Setup procedures
- [Tutorial](https://apilogicserver.github.io/Docs/Tutorial/) - Step-by-step learning

&nbsp;

---

&nbsp;

This page does _not_ address created projects, rather, it is about the API Logic Server system used to create projects.  It is for those who want to extend the product or understand how it works, not for those simply using the product.

# How to Install it

The subsections below described the steps to:

1. Obtain the software from GitHub
2. Open the dev workspace in your IDE
3. Create the "initial 'venv'"
4. Perform the critical "Smoke Test" to ensure system operation


## Manager Internal Development Setup

![dev env](images/architecture/internals/dev-dirs.png)

To create the dev enviroment (result shown above): 

1. Install the user version of the API Logic Server

    * let's assume it's `~/dev/ApiLogicServer-dev`

2. Start the Manager: `als start`
3. Be sure you have installed the VSCode CLI - see [the VSCode CLI procedure](IDE-Customize.md/#vscode-cli){:target="_blank" rel="noopener"}
4. In your CLI terminal window:
    * Note: Windows users use `install-ApiLogicServer-dev.ps1`)

```bash title="Install API Logic Server Development environment"
sh system/ApiLogicServer-Internal-Dev/install-ApiLogicServer-dev.sh
```
5. In your newly created dev source, create `ApiLogicServer/ApiLogicServer-dev/org_git/ApiLogicServer-src/api_logic_server_cli/api_logic_server_info.yaml`, with:
```
last_created_date: May 28, 2025 12:08:45
last_created_project_name: /Users/val/dev/ApiLogicServer/ApiLogicServer-dev/servers/basic_demo
last_created_version: 14.05.16
```

The install procedure will use `git clone` to create folders in `~/dev/ApiLogicServer/ApiLogicServer-dev/org/:`

![dev structure](images/internals/install-ApiLogicServer-dev.png)

&nbsp;

### Admin App Source

This section is only if you did not load from the script.  You need to obtain the build of safrs react admin.

It's basically straightforward, _though note_ the `cp` command which copies the `safrs-react-admin` runtime to API Logic Server for subsequent creation of API Logic Projects:

```bash
echo "\ncopying build (sra - safrs-react-admin) --> ApiLogicServer"
cp -r ../build api_logic_server_cli/create_from_model/safrs-react-admin-npm-build
```

For more information, [see Admin App Reuse](Architecture-admin-app-reuse.md/#4-sra-runtime-extraced-from-project){:target="_blank" rel="noopener"}.

> Note: `curl` must be installed for this procedure.

&nbsp;

### Determine your IDE

API Logic Server has been developed with both VSCode and PyCharm.  While in many cases we prefer PyCharm, we have gravitated to VSCode since it supports an "initial `venv`".  

This means that for the many test projects, there is no need to create a per-project `venv`.  This speeds unit testing considerably.

> Importantly, this relies on the Build and Test procedure to create the "initial `venv`".

You will find that the VSCode install has a large number of Run Configs for these test projects.  In general, the created project can be run immediately in another window of VSCode, using the "initial `venv`".

&nbsp;

## Open the dev workspace

`install-ApiLogicServer...` will create a project workspace (`~/dev/ApiLogicServer/ApiLogicServer-dev/org_git/ApiLogicServer-src/.vscode/ApiLogicServerDev.code-workspace`), and open it VS Code or PyCharm.

```bash title='open the dev project'
cd ~/dev/ApiLogicServer/ApiLogicServer-dev/org_git/ApiLogicServer-src/.vscode
code ApiLogicServerDev.code-workspace
```


Python requires a virtual environment; the procedure differs for `vscode` vs. `charm`:

* `vscode` projects are created with a `venv` and are ready to run the Launch Configurations to create the sample
* `charm` projects require that you create the `venv` with the PyCharm

It should look something like this:

![dev structure](images/internals/dev-project.png)

&nbsp;

## Run the BLT

It is tiresome to create a `venv` for each project.  So, the system creates projects with a VSCode property identifying the `venv`.

* In actual practice, this is the [manager's `venv`](Manager.md){:target="_blank" rel="noopener"}.  

* For the dev environment, it is calculated to the `venv` of the [BLT](#build-and-test): 

    * Note: the dev env BLT is not valid here, since it does not contain the CLI (which is needed for projects)

![default-interpreter-path](images/architecture/default-interpreter-path.png)

1. So, your first task is to [***run the BLT***](#build-and-test).  It is simplest to run it without testing, just to create the `venv` (and verify your installation).  

    * Execute the **2nd Run Config (*BLT - Hold the Tomato*)** to create the `venv` used for created projects, such as the Sample (see next section):

![BLT Hold Tomato](images/architecture/blt-no-tomato.png)

2. Verify you have a `venv` at as shown above at:<br>`ApiLogicServer/ApiLogicServer-dev/build_and_test/ApiLogicServer`

&nbsp;

### Setup Required

If this fails, a common error is that sra is not installed at `api_logic_server_cli/create_from_model/safrs-react-admin-npm-build`.  This can happen if the install procedure was not followed, or failed.

Obtain the sra build folder, and copy it to the location above.

&nbsp;

## Critical "Smoke Test"

> This is the "smoke test" of API Logic Server.  In general, this should be successful prior to pushing changes.


&nbsp;

### Create the Sample

Once in your IDE, you can run the pre-defined launch configuration `2 - Create servers/ApiLogicProject (new IDE)` to create and run the sample.  This creates `~/dev/servers/ApiLogicProject`.

![dev-run](images/vscode/dev-run.png)

&nbsp;

### Run the Sample

Open it in another window of VSCode and ensure it runs. 

1. Run the admin app, and
2. Use the documented procedures to [add customizations](Tutorial.md#3-customize-and-debug-in-your-ide){:target="_blank" rel="noopener"} for APIs, Logic and Security.

&nbsp;

### Run Behave Tests

A critical test is the ***Behave Test***.  It tests a dozen or so transactions, exercising the API and Logic.  

1. Use the Run Config in the created project: `Behave Run`.

---

# Ongoing dev

Follow these procesures to introduce changes, test them, and perform releases.

&nbsp;

## Introduce enhancements, test

Note the Run Configurations below:

![dev structure](images/internals/run-configs.png)

Consider using **Run Config #1** to create project *inside* your current IDE instance.  Note:

* You can use the debugger (inside the **IDE dev instance**) to debug the altered project

* The created/altered project is **git-ignored**, so is *not* part of any branch

* Note you can create 2 projects, eg, to test base vs. dev

You can then use **Run Config #2** to test it in a new project / ide instance.

1. Run the **behave tests** to ensure existing functionality is not broken

&nbsp;

## Update CLI creation

Update `api_logic_server_cli/project_prototype` (and probably `api_logic_server_cli/project_prototype_nw`) for enchanced creation

&nbsp;


## Build and Test

This is a VSCode Run Configuration used for final pre-release testing.  It builds the project, installs, it, and runs several dozen tests.

1. Update the version number first in `api_logic_server_cli/api_logic_server.py`


!!! pied-piper ":bulb: venv can be used for projects"

    You will be using this as a [shared venv](Project-Env.md#shared-venv).

For more information, [see here](Architecture-Internals-BLT.md){:target="_blank" rel="noopener"}.

&nbsp;

## Releasing

Build and Test should run on Macs, Linux (Ubuntu) and Windows 11.  Once these are successful, release as follows:

1. At the root of `ApiLogicServer-src`, with **no `venv`**
2. Run
```bash
python3 setup.py sdist bdist_wheel

python3 -m twine upload  --skip-existing dist/* 
```

This will upload to Pypi.  You of course need credentials.

3. Delete the build folders: `ApiLogicServer.egg-info`, `build`, `dist`
4. Open `docker/api_logic_server.Dockerfile`
5. Update the build number (line 4: `--tag apilogicserver/api_logic_server:10.03.16`)
6. Copy/paste/run the instructions at the top:
```bash

# GA release -- DELETE BUILD DIRS FIRST

# docker buildx build --push -f docker/api_logic_server.Dockerfile --tag apilogicserver/api_logic_server:10.03.16 -o type=image --platform=linux/arm64,linux/amd64 .
# docker buildx build --push -f docker/api_logic_server.Dockerfile --tag apilogicserver/api_logic_server:latest -o type=image --platform=linux/arm64,linux/amd64 .
```

&nbsp;

## Get Docs working

The install procedure also installs `Org-ApiLogicServer/Docs`.  Follow it's readme.

&nbsp;

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

# Docker Setup

&nbsp;

## Docker Startup

You can review the [dockerfile on `github`](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/docker){:target="_blank" rel="noopener"}.  Note that the normal operation is to start a terminal session as the last step:

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

## SQL Server testing with VSCode

While Sql/Server itself runs nicely under docker, there is considerable complexity in installing OCBC, regarding pyodbc:

> `pyodbc` is not pip-installed by default, since installs fail unless odbc is installed, which is complex and might not be needed


### For users

For users requiring pyodbc (SqlServer), there are 2 installs:

* ODBC Driver: [using `brew` as described here](Install-pyodbc.md){:target="_blank" rel="noopener"}

* `pip install pyodbc==5.2.00`

&nbsp;

### For ApiLogicServer-dev

ApiLogicServer-dev `requirements.txt` does **not** install odbc.  If you wish to test Sql/Server in ApiLogicServer-dev, follow the user setup instructions above.

&nbsp;

## Multi-arch Docker images

Docker creation provides the opportunity to pre-install odbc and simplify life for Sql/Server users.  [This procedure](DevOps-Containers-Run.md#multi-architecture-images){:target="_blank" rel="noopener"} was used to create `apilogicserver/api_logic_server`, providing an image that supports odbc, *and* supports devcontainers for both arm and amd.  

```bash
# GA release
# docker buildx build --push -f docker/api_logic_server_all.Dockerfile --tag apilogicserver/api_logic_server_all:9.01.17 -o type=image --platform=linux/arm64,linux/amd64 .

# Beta - test codespaces with tutorial, API_Fiddle (change .devcontainer.json -> apilogicserver/api_logic_server_all_x)
# docker buildx build --push -f docker/api_logic_server_all.Dockerfile --tag apilogicserver/api_logic_server_all_x:9.01.17 -o type=image --platform=linux/arm64,linux/amd64 .

# Internal - verify what is done with build_and_test
# docker build -f docker/api_logic_server_all.Dockerfile -t apilogicserver/api_logic_server_local --rm .
```

&nbsp;

### Pre-push testing

In our (internal) case, we needed to build multi-arch images, but note the `buildx` command *combines build and push* in single procedure.  This prevents local testing prior to push.  That is why we use the "Internal" docker build, as shown above.

&nbsp;

## VSC Bug - Run Configs

VSCode has a bug where it cannot parse Run Configs for SqlSvr:

```bash
zsh: no matches found: --db_url=mssql+pyodbc://sa:Posey3861@localhost:1433/NORTHWND?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=no&Encrypt=no
```

&nbsp;

# Behave Reports

The doc file `Behave-Logic-Report.md` is derived from using the behave tests from nw+ (run the test, then create the report).

The report is copied into:

1. `api_logic_server_cli/prototypes/base/test/api_logic_server_behave/reports/Behave Logic Report Sample.md'
2. `Behave-Logic-Report.md` --
    a. Edit the report and remove the path information at the end
    b. Paste the report into `Behave-Logic-Report.md` ***over the old contents***.

&nbsp;

# Testing

There are several important testing configurations.

&nbsp;

## 1. ApiLogicServer-dev

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

The CLI detects db_url's like `sqlsvr-nw`, and converts them to strings like this for [Database Connectivity > Docker Databases](Database-Connectivity.md#docker-databases){:target="_blank" rel="noopener"}:
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


## 2. Local `pip` install

Note: since the docker image is odbc17, the following commands fail in docker, but run in pip install when you've installed odbc18:

```
ApiLogicServer create --project_name=sqlsvr-nw --db_url=sqlsvr-nw
```

&nbsp;

# Useful links

As a contributor, you will likely work with:

* [Docker Databases](Database-Connectivity.md){:target="_blank" rel="noopener"}
* [Shared virtual environments](Project-Env.md){:target="_blank" rel="noopener"}
