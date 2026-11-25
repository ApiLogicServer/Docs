!!! pied-piper ":bulb: TL;DR - One image, two environments, secrets injected: dev to prod in about 20 minutes"

    The [DevOps Quick Start](DevOps-Quick-Start.md) runs a project in a container.  This page takes the next step: the **same image** runs as *dev* (SQLite, placeholder secrets) and as *prod* (Postgres, real secrets), and differs only in its environment variables.  You also create the prod database, move the schema with Alembic, and apply a later schema change to prod without losing data.

    None of this is specific to GenAI-Logic: it is the standard practice for any service (see [Environments and Secrets](DevOps-Container-Configuration.md#environments-and-secrets-dev-pre-prod-prod)).  Here you run a **prod-shaped environment on your own machine**: our Postgres container stands in for a managed database, and a file you keep out of git stands in for the cloud's secrets store.  The last section maps each step to a real cloud.

&nbsp;

## Before you start

You need:

- The [DevOps Quick Start](DevOps-Quick-Start.md), steps 1-3 done: the Manager has a `basic_demo` project (with `add-cust`), and you can run containers (`$CONTAINER_CLI` is `docker` or `podman`).  Stop its container if it is still running: `$CONTAINER_CLI rm -f basic_demo`.
- The Postgres container, running on port 5432 (Manager README, "Containers: Podman or Docker").
- Release 17.05.45 or later.  Earlier projects lack `devops/docker-compose-prod/` and the secret check.

Run the commands from the project folder, with the Manager's venv active:

```bash
cd basic_demo
source ../venv/bin/activate
```

On an Apple-silicon Mac, the project image is built for `linux/amd64`, so the container runtime prints a platform warning and runs it under emulation.  The warning is expected.

&nbsp;

## 1. Dev: security on, placeholder secret

```bash
genai-logic add-auth --provider-type=sql
python api_logic_server_run.py
```

Expect the server to start, with this line in its output:

```
SECRET_KEY is the shipped placeholder - fine for dev; set your own before pre-prod / prod
```

`SECRET_KEY` signs login tokens.  Dev uses the placeholder in `config/default.env`; that is fine on your machine and wrong anywhere else.  Stop the server (Ctrl+C).

> The sql security provider is for development and testing (passwords are stored in plain text); production normally uses Keycloak or your identity provider.  It is used here because it needs no extra container.  See [Security - sql](Security-sql.md).

&nbsp;

## 2. Create the prod database (once)

```bash
$CONTAINER_CLI exec postgresql-container psql -U postgres \
  -c "DROP DATABASE IF EXISTS basicdemo_prod" -c "CREATE DATABASE basicdemo_prod"
```

This drops and creates the database so you can repeat this page.  **You do this once, to start an environment.  You never drop prod again:** later changes are migrations (step 7).

&nbsp;

## 3. Create the prod schema with Alembic

Alembic builds the schema from the project's models, so the same mechanism handles the first deploy and every later change.  It reads the target database from `SQLALCHEMY_DATABASE_URI`, like the server.

```bash
cd database
export APILOGICPROJECT_NO_FLASK=True
PROD_DB=postgresql://postgres:p@localhost/basicdemo_prod

# record the schema as the first migration, then apply it to prod
SQLALCHEMY_DATABASE_URI=$PROD_DB alembic revision --autogenerate -m "baseline"
SQLALCHEMY_DATABASE_URI=$PROD_DB alembic upgrade head

# dev already has these tables: mark it as up to date, without changing it
alembic stamp head
cd ..
```

Expect `Detected added table` for each table, then `Running upgrade -> ..., baseline`.  Check prod:

```bash
$CONTAINER_CLI exec postgresql-container psql -U postgres -d basicdemo_prod -c "\dt"
```

The tables are there, empty.  Prod gets its schema from the migrations, not a copy of the dev database; its data comes from its own users (step 6), not from dev.

&nbsp;

## 4. Build the image (one image, every environment)

```bash
sh devops/docker-image/build_image.sh .
```

This builds `apilogicserver/basicdemo:latest`: your project on top of the standard image.  Nothing in it says which environment it is for.  It defaults to `APILOGICPROJECT_ENV=prod`, so a container that nobody configured fails safe (next step).

&nbsp;

## 5. Prod: secrets from outside the image

Open `devops/docker-compose-prod/`.  Two files:

- `docker-compose-prod.yml` sets the **non-secret** settings (`APILOGICPROJECT_ENV=prod`, security on, debug endpoints off) and reads the **secrets** from `secrets.env`.
- `secrets.env.example` is the committed template, with placeholders and comments.  Your copy, `secrets.env`, holds the real values and is in `.gitignore`.

Make your copy, and start prod **without** setting the key:

```bash
cd devops/docker-compose-prod
cp secrets.env.example secrets.env
$CONTAINER_CLI compose -f docker-compose-prod.yml up
```

Expect it to stop:

```
SECRET_KEY is the shipped placeholder, and APILOGICPROJECT_ENV is 'prod'. Anyone could sign login tokens. ... Server not started.
```

That is the point: in prod, the server refuses to run with a placeholder secret.  Generate a key, put it in `secrets.env`, and start again:

```bash
python -c "import secrets; print(secrets.token_urlsafe(48))"
# paste the output after SECRET_KEY= in secrets.env, then:
$CONTAINER_CLI compose -f docker-compose-prod.yml up -d
```

Expect it to start: `$CONTAINER_CLI compose -f docker-compose-prod.yml logs | grep "rules activated"`.  The database URI is in `secrets.env` too, because it carries the password.  It uses `host.docker.internal`: your machine, as seen from inside the container (Podman: `host.containers.internal` if that name does not resolve).

&nbsp;

## 6. Use prod: the rules run on Postgres

Log in, and keep the token:

```bash
TOKEN=$(curl -s -X POST localhost:5656/api/auth/login -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"p"}' | python -c "import sys,json; print(json.load(sys.stdin)['access_token'])")
H=(-H "Authorization: Bearer $TOKEN" -H "Content-Type: application/vnd.api+json")
```

Add a customer with a 1000 credit limit, a product at 100, and an order:

```bash
curl -s "${H[@]}" -X POST localhost:5656/api/Customer/ -d '{"data":{"type":"Customer","attributes":{"name":"Prod Co","credit_limit":1000}}}'
curl -s "${H[@]}" -X POST localhost:5656/api/Product/  -d '{"data":{"type":"Product","attributes":{"name":"Widget","unit_price":100}}}'
curl -s "${H[@]}" -X POST localhost:5656/api/Order/    -d '{"data":{"type":"Order","attributes":{"customer_id":1,"notes":"first prod order"}}}'
```

Then two items: 5 widgets (500, within the limit) and 10 more (would make the balance 1500):

```bash
curl -s "${H[@]}" -X POST localhost:5656/api/Item/ -d '{"data":{"type":"Item","attributes":{"order_id":1,"product_id":1,"quantity":5}}}'
curl -s "${H[@]}" -X POST localhost:5656/api/Item/ -d '{"data":{"type":"Item","attributes":{"order_id":1,"product_id":1,"quantity":10}}}'
```

Expect the first item's `amount` to be `500`, and the second to be rejected: `Customer balance (1500) exceeds credit limit (1000)`.  Check prod:

```bash
$CONTAINER_CLI exec postgresql-container psql -U postgres -d basicdemo_prod -c "select name, balance, credit_limit from customer"
```

The balance is 500: the rules derived it in Postgres, and the rejected item left nothing behind.  The same image is still a dev image too: `$CONTAINER_CLI run --rm -p 5657:5656 -e APILOGICPROJECT_ENV=dev apilogicserver/basicdemo` starts on its built-in SQLite with the placeholder reminder (stop it with Ctrl+C).

&nbsp;

## 7. Change the schema: migrate, never drop

Add a column in dev, then apply the same change to prod.  Back in the project folder:

```bash
cd ../..
```

Add this line to `class Customer` in `database/models.py`, after `email_opt_out`:

```python
    phone = Column(String)
```

Then generate the migration.  Autogenerate compares `models.py` with the database you point it at, so point it at one that is exactly at the last migration: here, prod.  (Not dev: `basic_demo`'s dev database carries tables that `models.py` does not, and the migration would drop them.)

```bash
cd database
export APILOGICPROJECT_NO_FLASK=True
PROD_DB=postgresql://postgres:p@localhost/basicdemo_prod
SQLALCHEMY_DATABASE_URI=$PROD_DB alembic revision --autogenerate -m "customer phone"
```

Expect `Detected added column 'customer.phone'`.  **Review the migration before you apply it anywhere:** open the new file in `database/alembic/versions/`; its `upgrade()` should contain one line, `op.add_column('customer', ...)`.  Anything else (a `drop_table`, a `drop_column`) means the database you compared against was not at the last migration: delete the file and find out why.  Then apply it to prod and to dev:

```bash
SQLALCHEMY_DATABASE_URI=$PROD_DB alembic upgrade head     # prod: same migration, no drop
alembic upgrade head                                      # dev
cd ..
```

Check prod:

```bash
$CONTAINER_CLI exec postgresql-container psql -U postgres -d basicdemo_prod -c "select name, balance, phone from customer"
```

The column is there, and the customer and its balance are unchanged.  To serve the new column, rebuild the image (step 4) and restart prod (`$CONTAINER_CLI compose -f docker-compose-prod.yml up -d`, in `devops/docker-compose-prod`): code and schema move together.  Then `phone` can be set through the API like any other attribute.

In a team, migrations are generated against a CI or staging database built from the migrations, reviewed like code, and applied by the deployment pipeline.

&nbsp;

## 8. On a real cloud

The steps are the same; only who does them changes:

| On your machine | On a real cloud |
|:--|:--|
| Postgres container, database `basicdemo_prod` | Managed database: Cloud SQL, RDS, Azure Database for PostgreSQL |
| `secrets.env` (gitignored) | Secrets store: GCP Secret Manager, AWS Secrets Manager, Azure Key Vault, a Kubernetes Secret.  The platform sets them as environment variables, as compose does here |
| `docker-compose-prod.yml` `environment:` | The service's settings: Cloud Run / App Service / ECS task definition, or a Kubernetes ConfigMap |
| You run `alembic upgrade head` against prod | The deployment pipeline runs it, with the database secret, before the new image starts |
| `build_image.sh` | CI builds the image once and pushes it to a registry; every environment pulls that image |
| Pre-prod: the same folder, its own `secrets.env`, and `APILOGICPROJECT_ENV=preprod docker compose -f docker-compose-prod.yml up` | A pre-prod environment with the same deployment definition and its own settings and secrets.  There is deliberately no separate test configuration: environments differ only in values |

In each cloud, a small group manages the secret values, and only the running service is granted read access.  The project needs no cloud-specific code.  Details: [Environments and Secrets](DevOps-Container-Configuration.md#environments-and-secrets-dev-pre-prod-prod).

&nbsp;

## 9. Clean up

```bash
cd devops/docker-compose-prod && $CONTAINER_CLI compose -f docker-compose-prod.yml down && cd ../..
$CONTAINER_CLI exec postgresql-container psql -U postgres -c "DROP DATABASE IF EXISTS basicdemo_prod"
```
