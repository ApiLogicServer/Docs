!!! pied-piper ":bulb: TL;DR - It is a standard Python / Flask container: install, validate in about 15 minutes"

    A GenAI-Logic project is a plain Python (Flask, SQLAlchemy) service: one process, one port (5656), configured by environment variables, state in your database.  It runs in a standard public image, `apilogicserver/api_logic_server`; there is nothing to build to try it.

    This page is for DevOps teams: install, run, verify, and what to look at.  You need Docker or Podman, nothing else - no Python install.

&nbsp;

## What you are running

| Item | Detail |
|---|---|
| **Image** | `apilogicserver/api_logic_server` on Docker Hub, linux `amd64` and `arm64`. Built from [`docker/api_logic_server.Dockerfile`](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/docker/api_logic_server.Dockerfile): `python:3.12-slim`, plus `pip install -r requirements.txt` |
| **Process** | One Python process: `python3 /app/api_logic_server_run.py` (Flask).  `gunicorn` is in the image, for example `gunicorn api_logic_server_run:flask_app -w 2 -b 0.0.0.0:5656` |
| **User** | Non-root (`api_logic_server`) |
| **Port** | `5656` (HTTP) |
| **Your code** | The project folder, mounted at `/app` (or copied into your own image - see [Build Project Image](DevOps-Containers-Build.md)) |
| **Config** | Environment variables (`APILOGICPROJECT_*`), e.g. database URI, security on/off, port.  See `devops/docker-standard-image/env.list` and [Container Configuration](DevOps-Container-Configuration.md) |
| **State** | In your database. The default is SQLite (a file in the project's `database/` folder); set `APILOGICPROJECT_SQLALCHEMY_DATABASE_URI` for PostgreSQL, MySQL, Oracle or SQL Server (drivers are in the image) |
| **Logs** | stdout, and `logs/als.log` in the project folder |
| **Business logic** | Declarative rules in `logic/`, executed in-process by the [LogicBank](https://github.com/ApiLogicServer/LogicBank) library on SQLAlchemy commit.  No separate service |
| **API** | JSON:API (`/api/<Table>`), OpenAPI/Swagger at `/api`, Admin UI at `/admin-app/index.html` |

Extra Python packages are plain `pip`: put `RUN pip install <package>` in your project's `devops/docker-image/build_image.dockerfile`, which extends the standard image.

&nbsp;

## Validate in 15 minutes

Run these from the Manager directory (these commands are for macOS and Linux shells, zsh or bash; on Windows, use WSL2 or Git Bash).  The commands use `$CONTAINER_CLI`, set to `docker` or `podman` (see [Install-Express](Install-Express.md#containers-optional-set-up-and-test-after-install) for the one-line setup; Podman notes: [Podman](DevOps-Podman.md)).

&nbsp;

### 1. Pull the image

```bash
$CONTAINER_CLI pull apilogicserver/api_logic_server
# inventory of every Python package
$CONTAINER_CLI run --rm apilogicserver/api_logic_server pip list
```

Expect: pulls in a minute or so (about 1 GB); the `pip list` is the complete software inventory, for your scanning tools.

&nbsp;

> **Behind a corporate registry?**  If Docker Hub is blocked, mirror the image into yours, then use your name wherever these commands say `apilogicserver/api_logic_server` (and in `FROM` in `build_image.dockerfile`):
>
> ```bash
> $CONTAINER_CLI pull apilogicserver/api_logic_server
> $CONTAINER_CLI tag  apilogicserver/api_logic_server <your-registry>/api_logic_server
> $CONTAINER_CLI push <your-registry>/api_logic_server
> ```
>
> The image is public, built from the Dockerfile linked above, and the server makes no outbound calls at startup.  We ran a project in a container with **no network** (`--network none`): the API and Admin UI served normally.  Outbound calls happen only for features you configure: Keycloak, the MCP client, n8n, and LLM calls from AI rules.  One detail: the Admin UI page loads fonts from `fonts.googleapis.com` *in the browser*; if that is blocked, the browser falls back to its default fonts.

&nbsp;

### 2. Create a project locally (developers do this)

Developers create and test projects with a local install (see [Install-Express](Install-Express.md)); DevOps then runs the *same project folder* in the container.  From the Manager (venv active):

```bash
genai-logic create \
  --project_name=basic_demo \
  --db_url=sqlite:///samples/dbs/basic_demo.sqlite
cd basic_demo
# adds the sample rules customer credit check
genai-logic add-cust
cd ..
```

Expect: a `basic_demo` folder of ordinary Python files (models, API, rules, tests, `devops/`).  Nothing here needs a container.

> **No local Python?** The container can create the project too: `$CONTAINER_CLI run --rm -v ${PWD}:/localhost apilogicserver/api_logic_server genai-logic create --project_name=/localhost/basic_demo --db_url=basic_demo`, then the same with `-w /localhost/basic_demo ... genai-logic add-cust`.

&nbsp;

### 3. Run it

```bash
$CONTAINER_CLI run -d --name basic_demo \
  -p 5656:5656 \
  -v ${PWD}/basic_demo:/app \
  apilogicserver/api_logic_server \
  python3 /app/api_logic_server_run.py
$CONTAINER_CLI logs basic_demo
```

Expect: log ends with `Running on http://0.0.0.0:5656`.  Open the Admin UI at `http://localhost:5656/admin-app/index.html` (the full path; `http://localhost:5656` redirects there, but `/admin-app/` alone is a 404), and `http://localhost:5656/api` for the API (Swagger).

```bash
curl --retry 30 --retry-all-errors --retry-delay 2 "http://localhost:5656/api/Customer/?page%5Blimit%5D=1"
```

&nbsp;

### 4. Verify the business rules are enforced

The sample declares that a customer's balance cannot exceed the credit limit.  Violate it through the API:

```bash
curl -i -X PATCH http://localhost:5656/api/Customer/1/ -H 'Content-Type: application/vnd.api+json' -d '{"data":{"type":"Customer","id":"1","attributes":{"credit_limit":1}}}'
```

Expect: `HTTP 400` with the rule's message: `Customer balance (...) exceeds credit limit (1)`.  The change was rolled back; the rule runs for every caller of the database session, not just this endpoint.

&nbsp;

### 5. Create and run automated tests (optional)

Tests are [Behave](https://behave.readthedocs.io) (standard Python BDD), in `test/api_logic_server_behave/`.  A new project ships only a placeholder feature, so first create tests from the rules.  Test creation takes a few minutes, which is why it is optional.

**5a. Create the tests.**  Open the project (`basic_demo`) in VS Code with an AI coding assistant (Copilot, Claude Code...) and say:

```
create tests from rules
```

The project's instructions guide the assistant: it writes a test plan (`docs/requirements/<name>/test_plan.md`) and the feature files and steps.  Review them as you would any code.

**5b. Run them in the container** (the project must be running, as in step 3):

```bash
$CONTAINER_CLI exec \
  -w /app/test/api_logic_server_behave \
  basic_demo \
  python behave_run.py --outfile=logs/behave.log
```

Expect: `scenarios passed, 0 failed`, exit code 0 - suitable for a CI step.  Logs are in `test/api_logic_server_behave/logs/`.

&nbsp;

### 6. Explore your container

**Stop it and start it again.**  Your data survives, because it lives in your project folder (the mount), not in the container:

```bash
$CONTAINER_CLI stop basic_demo
# same container, same command, same data
$CONTAINER_CLI start basic_demo
# basic_demo is Up, port 5656
$CONTAINER_CLI ps
```

**Look inside.**  Open a shell in the running container:

```bash
$CONTAINER_CLI exec -it basic_demo bash
```

Then try these (you are user `api_logic_server`, not root):

```bash
# YOUR project: the folder you mounted
ls /app
# the product: api_logic_server_cli/, bin/
ls /home/api_logic_server
# the CLI is installed in /home/api_logic_server/bin
which genai-logic
# Python 3.12 /usr/local/bin/python
python --version
# the key libraries
pip list | grep -i -E "logicbank|safrs|flask|sqlalchemy"
# Debian 11 bullseye, python:3.12-slim
cat /etc/os-release | head -1
# leave the shell the server keeps running
exit
```

What you see: your app is at `/app`, the product and its CLI are installed in the image, and nothing else is needed.  It is a standard Python container.

> Running a `genai-logic` command *inside* this container prints a "port 5656 does not appear to be available" warning: the server in the same container is using it.  It is harmless.

&nbsp;

### 7. Optional: app + Postgres with compose

The usual multi-container shape: your app (standard image) and a database, on one network, configured by environment variables.  **Skip this if you did not set up the Postgres container** (see the Manager README, "Containers: Podman or Docker"): creating the project below needs it running.

First create a project over the Postgres sample database `northwind` (from the Manager, venv active):

```bash
genai-logic create \
  --project_name=nw_pg \
  --db_url=postgresql://postgres:p@localhost/northwind
```

Then save this as `compose-pg.yml` in the Manager directory:

```yaml
services:
  postgres:                      # database: the apilogicserver/postgres sample image
    image: docker.io/apilogicserver/postgres:latest
    environment:
      - POSTGRES_PASSWORD=p
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres -d northwind"]
      interval: 3s
      retries: 20

  app:                           # your project, in the standard image
    image: docker.io/apilogicserver/api_logic_server:latest
    command: python3 /app/api_logic_server_run.py
    volumes:
      - ./nw_pg:/app
    ports:
      - "5657:5656"            # host 5657, so it does not clash with basic_demo on 5656
    environment:
      # "postgres" is the service name above, not localhost
      - APILOGICPROJECT_SQLALCHEMY_DATABASE_URI=postgresql://postgres:p@postgres/northwind
    depends_on:
      postgres:
        condition: service_healthy
```

```bash
$CONTAINER_CLI compose -f compose-pg.yml up -d
curl --retry 30 --retry-all-errors --retry-delay 2 "http://localhost:5657/api/Customer/?page%5Blimit%5D=1"
$CONTAINER_CLI compose -f compose-pg.yml down
```

Expect (`curl` retries for a few seconds while the app starts): a customer (`Alfreds Futterkiste`, Berlin) read from Postgres, on port 5657.  (If you see `Alice` it came from `basic_demo`, not Postgres.  An error `proxy already running` means the host port is taken: change the left number in `ports`.)  The environment variable overrides the database URI the project was created with, so one project folder runs unchanged against different databases.  The compose file uses no published database port, so it does not clash with a Postgres container you already run.

> Podman needs a compose provider (`brew install docker-compose`); see [Podman](DevOps-Podman.md).

&nbsp;

### 8. Clean up, and try your own variations

```bash
# if still running
$CONTAINER_CLI rm -f basic_demo
```

Then, as you wish:

* **Your database** - add `-e APILOGICPROJECT_SQLALCHEMY_DATABASE_URI=postgresql://user:pw@host/db` to the `$CONTAINER_CLI run` in step 3.  To create a project over an existing database, use `--db_url=<that URI>` in step 2.
* **gunicorn** - replace the `python3 ...` command with `gunicorn api_logic_server_run:flask_app -w 2 -b 0.0.0.0:5656` (add `-w /app` to `$CONTAINER_CLI run`).
* **Your own image** - `sh devops/docker-image/build_image.sh .`, then `sh devops/docker-image/run_image.sh`.  The dockerfile is 3 lines: `FROM apilogicserver/api_logic_server`, `COPY`, `CMD`.  See [Build Project Image](DevOps-Containers-Build.md).  Projects created before release 17.05.36 carry older scripts that call `docker` and need a `dev-network`.  On Podman, build directly instead: `$CONTAINER_CLI build -f devops/docker-image/build_image.dockerfile -t myproject .` (run from the project folder), then run it as in step 3 with `myproject` as the image.
* **Compose** - `$CONTAINER_CLI compose -f devops/docker-standard-image/docker-compose-standard-image.yml up`
* **Security** - `genai-logic add-auth --provider-type=sql` (run as in step 2, with `-w /localhost`) uses a SQL user table - no other container.  Keycloak is also supported; see [Security](Security-Overview.md).

&nbsp;

## What to look at

For a DevOps review, these are the places to look:

* The [Dockerfile](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/docker/api_logic_server.Dockerfile) and [requirements.txt](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/requirements.txt) - the full dependency list (Flask, SQLAlchemy, SAFRS, LogicBank, DB drivers).
* The project's `api_logic_server_run.py` and `config/config.py` - how the app starts and how environment variables override settings.
* `logic/` - the business rules are readable Python; they are source code, in your repository, reviewed and versioned like any other.
* `devops/` - the container and deployment files the project carries: [Use Standard Image](DevOps-Containers-Use-Standard.md), [Build Project Image](DevOps-Containers-Build.md), [Run Container](DevOps-Containers-Run.md), cloud deployment ([Azure](DevOps-Containers-Azure-Setup.md)), and [Podman](DevOps-Podman.md).

&nbsp;

## Known limits

* The image runs the Flask server by default (it logs a "development server" warning); use gunicorn, as above, for production.
* The sample steps above use SQLite, which suits validation.  For production, use a server database via the environment variable.
* Container networking: a container reaches another container (database, Keycloak) by its network name, not `localhost`.  Create a network (`$CONTAINER_CLI network create dev-network`) and add `--net dev-network` to the `$CONTAINER_CLI run`.
