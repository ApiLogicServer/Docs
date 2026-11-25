
!!! pied-piper ":bulb: TL;DR - Configure Containers with env variables"

    Containers are most commonly configured by environment variables, either in docker files, docker compose files, env files, or command line arguments.  The most common configuration parameters govern database / port locations - [click here](#overridden-by-env-variables).

    For dev, pre-prod and prod, and for passwords and other secrets, see [Environments and Secrets](#environments-and-secrets-dev-pre-prod-prod): the standard industry practice, not something specific to GenAI-Logic.

&nbsp;

## Starting the Server

### Via the Container

Once the container [is created](DevOps-Containers-Build.md){:target="_blank" rel="noopener"}, you can start it [click here](https://github.com/ApiLogicServer/demo/blob/main/devops/docker-image/run_image.sh){:target="_blank" rel="noopener"}, which contains:

```bash
docker run --env-file devops/docker-image/env.list -it --name api_logic_project --rm --net dev-network -p 5656:5656 -p 5002:5002 apilogicserver/<your project>
```

Note that:

1. Execution begins automatically (the dockerfile runs `python api_logic_server_run.py`)

2. Configuration is via `env.list`; configure as required


&nbsp;

### Via the IDE

As described in the Quick Start, Run Configurations are provided to start the server in your IDE.

&nbsp;

### Command Line - Python

Recall that you execute your API Logic Project by __starting the server__, like this:

```
ApiLogicServer (venv)> cd my_new_project
my_new_project(venv)> python api_logic_server_run.py
```
Note this presumes you have activated your `venv`.  The system also provides shell scripts you can use:
```
sh run.sh  # windows - use run.ps1
```


Then, __to run the Admin App and Swagger:__

Run your browser at

```html
http://localhost:5656/
```

&nbsp;

### Command Line - Scripts

Alternatively, you can start the server using the run script, e.g.:

![server-run](images/server-run.png)

### Stopping the server

You can stop the server by cancelling it, or via an API:

```
http://localhost:5656/stop?msg=API stop - Stop API Logic Server
```

This can be useful in testing if you don't have access to the server console.  The `msg` parameter is optional.

&nbsp;

## Configuring the server

Configuration parameters enable you to specify hosts and ports, database locations, debug settings, etc., as described below.

&nbsp;

### Environments and Secrets: dev, pre-prod, prod

!!! note "Not specific to GenAI-Logic"

    This is the common best practice for configuring any service, in any language: "store config in the environment", from [The Twelve-Factor App](https://12factor.net/config){:target="_blank" rel="noopener"}. Your platform team most likely uses it already. GenAI-Logic projects follow it, so they deploy the way your other services do.

**The principles:**

1. **One build, many environments.** The same code (and the same container image) runs in dev, pre-prod and prod. Only configuration differs.
2. **Configuration comes from the environment.** Each environment sets environment variables; they override the defaults committed with the code.
3. **Secrets are never in git.** Database passwords, signing keys and client secrets come from a secrets store, injected as environment variables when the service starts.
4. **Commit the names, not the values.** The repository shows which variables exist (with safe dev defaults); each environment supplies its own values.

**Layers - the higher layer wins:**

```
  environment variables        set by the deployment, secrets injected here      (wins)
          ▲
  config/default.env           committed with the project: non-secret defaults
          ▲
  config/config.py             code defaults
```

**Where values come from, per environment:**

```
                              ┌─ dev:      config/default.env  +  personal overrides (not committed)
                              │
  same code / same image  ────┼─ pre-prod: deployment config    +  secrets store  ──►  env variables  ──►  server
                              │
                              └─ prod:     deployment config    +  secrets store  ──►  env variables  ──►  server
```

| | Dev | Pre-prod | Prod |
|:--|:--|:--|:--|
| **Non-secret settings** (hosts, ports, Kafka broker, Keycloak realm) | `config/default.env` | Deployment config: docker compose env, Kubernetes ConfigMap, or the cloud service's environment settings (below) | Same as pre-prod, prod values |
| **Secrets** (database password, `SECRET_KEY`, client secrets) | Local dev values; real ones only in a personal, uncommitted file or shell | Secrets store: Kubernetes Secrets, HashiCorp Vault, CI secrets, or the cloud's store (below) | Same as pre-prod, prod values |

The same pattern works on every major cloud; only the product names differ:

| Cloud | Environment settings (non-secret) | Secrets store |
|:--|:--|:--|
| **AWS** | ECS task definition, App Runner, EKS ConfigMap; Systems Manager Parameter Store | AWS Secrets Manager |
| **Azure** | App Service / Container Apps settings, AKS ConfigMap | Azure Key Vault |
| **GCP** | Cloud Run / GKE environment variables, ConfigMap | Google Secret Manager |
| **IBM Cloud** | Code Engine / IKS / OpenShift environment variables, ConfigMap | IBM Cloud Secrets Manager |

Each one delivers its secrets to the container as environment variables, so the project needs no cloud-specific code.

In each cloud, a small group (typically the platform or security team) manages secret values, and only the running service, not people, is granted read access; every read and change is audited. Developers need never see production passwords.
| **Who sets them** | Each developer | The deployment pipeline | The deployment pipeline |

**Check before going to production:**

- `SECRET_KEY`: the project ships with a placeholder in `config/default.env`. With the SQL security provider it signs login tokens (Keycloak signs its own), so set your own value from the secrets store: at least 32 random characters, for example `python -c "import secrets; print(secrets.token_urlsafe(48))"`.
- `APILOGICPROJECT_ENV`: `dev`, `preprod` or `prod`. `config/default.env` says `dev`; the deployment sets it, and the project's container image (`devops/docker-image`) defaults to `prod`. Outside `dev`, a server with SQL security refuses to start with the placeholder `SECRET_KEY`; in `dev` it starts and logs a reminder.
- Security provider: the sql provider, as shipped, stores passwords in plain text and is for development and testing. Use Keycloak or your identity provider in production, or harden the sql provider ([see here](Security-sql.md)).
- `APILOGICPROJECT_CONSUME_DEBUG=false`: the Kafka debug endpoints are for development only.
- Database URIs (`SQLALCHEMY_DATABASE_URI`, `SQLALCHEMY_DATABASE_URI_AUTHENTICATION`) carry passwords: set them from the secrets store, never in a committed file.

The sections below describe each layer, and the variable names.

&nbsp;

### Database Locations

SQLAlchemy database URIs are set in your `config/config.py` file, from your creation CLI arguments.  They apply to target database(s), and the authentication database.  For example:

```python
    SQLALCHEMY_DATABASE_URI : typing.Optional[str] = f"mysql+pymysql://root:p@localhost:3306/classicmodels"
```

Special handling is provided for sqlite databases, [as described here](Database-Connectivity.md#sqlite){:target="_blank" rel="noopener"}.

&nbsp;

### Docker Directories

Projects are created with a [`devops/docker-image/build-image/dockerfile`](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/base/devops/docker-image/build_image.dockerfile){:target="_blank" rel="noopener"}, resulting in the following directory structure:  

![docker-directories](images/docker/docker-directories.png)

&nbsp;

### Hosts and Ports

ApiLogicServer attempts to avoid port conflicts.  These can arise from:

* Common use of 8080

* Mac use of 5000

To avoid conflicts, ports are defaulted as follows:

| For |  Port |
|:--------------|:--------------|
| ApiLogicServer | `5656` |


Hosts are defaulted as follows:

| Installed as |  Host |
|:--------------|:--------------|
| Docker | `0.0.0.0` |
| Local Install | `localhost` |

These defaults are also stored in the `config/config.py` file.

&nbsp;

### Defaults: Create Time

You can specify default values for hosts, ports and databases when you create the application.  Specify ApiLogicServer CLI arguments, like this:

```bash
ApiLogicServer create --project_name=~/dev/servers/api_logic_server \
                      --host=myhost --port=myport --swagger_host=mycloud \
                      --db_url=mysql+pymysql://root:p@localhost:3306/classicmodels
```

&nbsp;

### Overridden by: Config.py

As noted above, the defaults are stored in the `config/config.py` file.  You can override these values as required.

&nbsp;

### Overridden by: config/default.env

`config/default.env` is committed with the project and loaded when the server starts. Most settings are read from it (security, locking, Kafka, debug endpoints), each with a comment explaining it. It is the right place for non-secret defaults shared by the team, and the wrong place for passwords: it is in git. An environment variable of the same name overrides it.

&nbsp;

### Overridden by: run args

When you run created applications, you can provide API Logic ***Project*** arguments to override the defaults.  Discover the arguments using `--help`:

```bash
(venv) val@Vals-MBP-16 ApiLogicProject % python api_logic_server_run.py -h

API Logic Project Starting: /Users/val/dev/servers/ApiLogicProject/api_logic_server_run.py
usage: api_logic_server_run.py [-h] [--port PORT] [--flask_host FLASK_HOST] [--swagger_host SWAGGER_HOST]
                               [--swagger_port SWAGGER_PORT] [--http_type HTTP_TYPE] [--verbose VERBOSE]
                               [--create_and_run CREATE_AND_RUN]
                               [flask_host_p] [port_p] [swagger_host_p]

positional arguments:
  flask_host_p
  port_p
  swagger_host_p

options:
  -h, --help                       show this help message and exit
  --port PORT                      port (Flask) (default: 5656)
  --flask_host FLASK_HOST          ip to which flask will be bound (default: localhost)
  --swagger_host SWAGGER_HOST      ip clients use to access API (default: localhost)
  --swagger_port SWAGGER_PORT      swagger port (eg, 443 for codespaces) (default: 5656)
  --http_type HTTP_TYPE            http or https (default: http)
  --verbose VERBOSE                for more logging (default: False)
  --create_and_run CREATE_AND_RUN  system use - log how to open project (default: False)
(venv) val@Vals-MBP-16 ApiLogicProject % 

```
These are used for [Codespaces support](https://valhuber.github.io/ApiLogicServer/Tech-CodeSpaces/){:target="_blank" rel="noopener"}

&nbsp;

__Notes:__

* `host` is the flask-host, which maps to the IP address of the interface to which flask will be bound (on the machine itself
* `swagger_host` maps to the ip address as seen by the clients

For example, 127.0.0.1 (localhost) or 0.0.0.0 (any interface) only have meaning on your own computer.

Also, it's possible to map hostname->IP DNS entries manually in /etc/hosts, but users on other computers are not aware of that mapping.

### Overridden by: env variables

A common approach for host, port and database configuration is to use env variables.  These can be set in your OS, or container options such as env files or docker compose.  

!!! note "Best Practice: env variables"
    
    We recommend the use of environmental variables when running Docker containers.

    You can see the env variables in the sample `env_list` file - [click here](https://github.com/ApiLogicServer/demo/blob/main/devops/docker-image/env.list){:target="_blank" rel="noopener"}.  

The names of the variables are those noted used in the `config/config.py` file, **preceded by** `APILOGICPROJECT_`[^1].  These values override both the `config/config.py` values and the Api Logic Project CLI arguments.

Here are the most commonly set environment variables:

```yaml
services:

    api-logic-server:
        image: apilogicserver/classicmodels
        environment:
          - APILOGICPROJECT_VERBOSE=true
          - SECURITY_ENABLED=true
          - APILOGICPROJECT_CLIENT_URI=//classicmodels.azurewebsites.net
          - PYTHONPATH=/app/ApiLogicProject 
          ## specify Database uri's:
          - APILOGICPROJECT_SQLALCHEMY_DATABASE_URI=mysql+pymysql://root:p@mysql-service:3306/classicmodels
          - APILOGICPROJECT_SQLALCHEMY_DATABASE_URI_AUTHENTICATION=mysql+pymysql://root:p@mysql-service:3306/authdb
```

For example, to override the database location on mac:

```bash
export APILOGICPROJECT_SQLALCHEMY_DATABASE_URI=mysql+pymysql://root:p@localhost:3306/
```

To see a list of typical env variables, [click here](https://github.com/ApiLogicServer/demo/blob/main/devops/docker-image/env.list){:target="_blank" rel="noopener"}.

&nbsp;

#### Docker project `env.list` file

The example below illustrates you can store such variables in a `classicmodels/devops/docker-image/env.list` file (be sure to edit these - the current values are commented out, intended to confirm settings during initial testing).  Some of the most common settings are noted below:

```python title="env.list env variables - initially commented out"

# ip to which flask will be bound (default: 0.0.0.0)
# APILOGICPROJECT_FLASK_HOST=flask-host-e

# port (Flask) (default: 5656)
# APILOGICPROJECT_PORT=port-e

# ip clients use to access API (default: localhost)
# APILOGICPROJECT_SWAGGER_HOST=swagger-host-e

# swagger port (eg, 443 for codespaces) (default: 5656)
# APILOGICPROJECT_SWAGGER_PORT=swagger-port-e

# http or https (default: http)
# APILOGICPROJECT_HTTP_SCHEME=http-scheme-e

# APILOGICPROJECT_HTTP_SCHEME=http

# for reverse proxy cases where the entire URI must be specified
# APILOGICPROJECT_CLIENT_URI=httpe://hoste:porte
```

<details markdown>

<summary> Env variables in the `env.list` file </summary>

APILOGICPROJECT_SWAGGER_PORT

![Running image locally](images/docker/container-run.png)

</details>

### Debugging

Use the `APILOGICPROJECT_VERBOSE` to log the values to the console log.

&nbsp;

## Production Deployment

As noted in the [gunicorn documentation](https://flask.palletsprojects.com/en/2.0.x/deploying/){:target="_blank" rel="noopener"}:

  > While lightweight and easy to use, Flask’s built-in server is not suitable for production as it doesn’t scale well. 

&nbsp;

#### gunicorn

You can run API Logic Server servers under [gunicorn](https://flask.palletsprojects.com/en/2.2.x/deploying/gunicorn/){:target="_blank" rel="noopener"}.  To use the default API Logic Server ports:

```
gunicorn api_logic_server_run:flask_app -w 4 -b localhost:5656
```

Or, to use the default gunicorn ports:

```
gunicorn api_logic_server_run:flask_app -w 4
```

You will also need to:

1. Update the default server/port settings in `api_logic_server_run.py`
2. Start your browser at [http://127.0.0.1:8000](http://127.0.0.1:8000)

&nbsp;

#### PythonAnywhere
Please see the [Install Instructions](Install.md){:target="_blank" rel="noopener"} for information on PythonAnywhere.

&nbsp;

#### Docker

You can use Docker compose files or env files to configure your project.  There is an example in the default project - [click here to see run-image.sh](https://github.com/ApiLogicServer/demo/tree/main/devops/docker-image){:target="_blank" rel="noopener"}.

[^1]:
    Several changes were made as of release 9.01.17.  It is available as preview; [click here](index.md#getting-started){:target="_blank" rel="noopener"}

