---
hide:
 - title
---
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

!!! pied-piper ":bulb: TL;DR - Create Project From Existing Database"

    The `genai-logic create` CLI command creates a customizable / executable API Logic Project **from an existing database,** providing:

    * **A [JSON:API](API.md){:target="_blank" rel="noopener"} -** Endpoint for each table, with filtering, sorting, pagination, optimistic locking, including __related data access__, based on relationships in the models file (typically derived from foreign keys)

    * **[An Admin App](Admin-Tour.md){:target="_blank" rel="noopener"} -** multi-page, multi-table, with automatic joins

    The `genai-logic genai` CLI command creates a customizable / executable API Logic Project **and a new database**, from an NL prompt.  For more information, see [WebGenAI CLI](WebGenAI-CLI){:target="_blank" rel="noopener"}.

    Customize the project in your IDE to add custom endpoints, rules and Python for logic and security.  Projects are fully configured for development (e.g. run configurations) and deployment (e.g., image creation, env variables).

&nbsp;

## `genai-logic create` (existing db)

The key `genai-logic create` options are:

* `--project_name` defines the directory created for your project

* `--db_url` identifies the database.  Specify a [SQLAlchemy url](Database-Connectivity.md){:target="_blank" rel="noopener"}, or one of the [preloaded sample database abbreviations](Data-Model-Examples.md){:target="_blank" rel="noopener"}

Discover other options with `genai-logic create --help`.

Discover other commands with `genai-logic --help`.

&nbsp;

### Create `--from-model`

In addition to creating projects from databases, you can also create them from SQLAlchemy models.  For example:

* Copilot can produce models
* Many Python programmers prefer to use SQLAlchemy as their database tool

```bash title="Create from Model"
als create --project-name=sample_ai --from-model=sample_ai.py --db-url=sqlite
```

&nbsp;

## `genai-logic genai` (new db)

The key `genai-logic genai` options are:

* `--using` identifies the prompt file name

* `--project_name` defines the directory created for your project (optional)

Discover other options with `genai-logic create --help`.

Discover other commands with `genai-logic --help`.

The key files that drive execution are described below.  Note they are models - instead of lengthy generated code (*what*), they are Python declarations of ***how***.

&nbsp;

## Using AI Assistant

&nbsp;

In addition to CLI commands, you might it simpler to use your AI Assistant (e.g., Copilot).

### CLI Shortcut (Manager)

Copilot in the Manager will create run the CLI for you with commands such as:

```bash title="Create from Copilot"
create a project from basic_demo in samoles.dbs
```

