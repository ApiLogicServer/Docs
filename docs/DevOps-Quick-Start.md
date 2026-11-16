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
| **API** | JSON:API (`/api/<Table>`), OpenAPI/Swagger at `/api`, Admin UI at `/admin-app` |

Extra Python packages are plain `pip`: put `RUN pip install <package>` in your project's `devops/docker-image/build_image.dockerfile`, which extends the standard image.

&nbsp;

## Validate in 15 minutes

Run these from an empty working directory (the commands work in macOS/Linux shells and PowerShell; in Windows `cmd`, use `%cd%` for `${PWD}`).  With Podman, type `podman` where these say `docker`, and `export CONTAINER_CLI=podman` so the project's `devops` scripts do the same (see [Podman](DevOps-Podman.md)).

&nbsp;

### 1. Pull the image

```bash
docker pull apilogicserver/api_logic_server
docker run --rm apilogicserver/api_logic_server pip list     # inventory of every Python package
```

Expect: pulls in a minute or so (about 1 GB); the `pip list` is the complete software inventory, for your scanning tools.

&nbsp;

### 2. Create a project (from a sample database, with sample rules)

```bash
docker run --rm -v ${PWD}:/localhost apilogicserver/api_logic_server genai-logic create --project_name=/localhost/basic_demo --db_url=basic_demo
cd basic_demo
docker run --rm -v ${PWD}:/localhost -w /localhost apilogicserver/api_logic_server genai-logic add-cust
```

Expect: a `basic_demo` folder of ordinary Python files appears in your directory (models, API, rules, tests, `devops/`).  `add-cust` adds the sample rules (customer credit check) to it.  The container wrote files into your folder; nothing is installed on your machine.

&nbsp;

### 3. Run it

```bash
docker run -d --name basic_demo -p 5656:5656 -v ${PWD}:/app apilogicserver/api_logic_server python3 /app/api_logic_server_run.py
docker logs basic_demo
```

Expect: log ends with `Running on http://0.0.0.0:5656`.  Open `http://localhost:5656` for the Admin UI, and `http://localhost:5656/api` for the API (Swagger).

```bash
curl "http://localhost:5656/api/Customer/?page%5Blimit%5D=1"
```

&nbsp;

### 4. Verify the business rules are enforced

The sample declares that a customer's balance cannot exceed the credit limit.  Violate it through the API:

```bash
curl -i -X PATCH http://localhost:5656/api/Customer/1/ -H 'Content-Type: application/vnd.api+json' -d '{"data":{"type":"Customer","id":"1","attributes":{"credit_limit":1}}}'
```

Expect: `HTTP 400` with the rule's message: `Customer balance (...) exceeds credit limit (1)`.  The change was rolled back; the rule runs for every caller of the database session, not just this endpoint.

&nbsp;

### 5. Run the automated tests

```bash
docker exec -w /app/test/api_logic_server_behave basic_demo python behave_run.py --outfile=logs/behave.log
```

Expect: `scenarios passed, 0 failed`, exit code 0.  Tests are [Behave](https://behave.readthedocs.io) (standard Python BDD); the output suits a CI step.

&nbsp;

### 6. Stop, and try your own variations

```bash
docker rm -f basic_demo
```

Then, as you wish:

* **Your database** - add `-e APILOGICPROJECT_SQLALCHEMY_DATABASE_URI=postgresql://user:pw@host/db` to the `docker run` in step 3.  To create a project over an existing database, use `--db_url=<that URI>` in step 2.
* **gunicorn** - replace the `python3 ...` command with `gunicorn api_logic_server_run:flask_app -w 2 -b 0.0.0.0:5656` (add `-w /app` to `docker run`).
* **Your own image** - `sh devops/docker-image/build_image.sh .`, then `sh devops/docker-image/run_image.sh`.  The dockerfile is 3 lines: `FROM apilogicserver/api_logic_server`, `COPY`, `CMD`.  See [Build Project Image](DevOps-Containers-Build.md).
* **Compose** - `docker compose -f devops/docker-standard-image/docker-compose-standard-image.yml up`
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
* Container networking: a container reaches another container (database, Keycloak) by its network name, not `localhost`.  Create a network (`docker network create dev-network`) and add `--net dev-network` to the `docker run`.
