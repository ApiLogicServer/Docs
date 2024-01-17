!!! pied-piper ":bulb: TL;DR - Standards-based Customization: **Your IDE**, standard packages"

    The `ApiLogicServer create` command creates *API Logic Projects:* **customize in *your* IDE.**

    Use standard packages, such as **Flask and SQLAlchemy**.

    Standard file-based projects: use **GitHub** for source control, etc.


For more information on opening projects and establishing their Python Execution environment, see [Execute an API Logic Project](IDE-Execute.md){:target="_blank" rel="noopener"}.

&nbsp;

## Use your IDE

The `ApiLogicServer create` command creates an API Logic Project, which you can open in your IDE as shown below.  As illustrated in the [Tutorial](Tutorial.md){:target="_blank" rel="noopener"}, you can use the expected features of your IDE to customize, run and debug your project:

![generated project](images/generated-project.png)

&nbsp;

## Run

The `ApiLogicServer create` command also creates:

* Launch configurations to run your project, and run [tests](Behave.md){:target="_blank" rel="noopener"}.
* [Docker](DevOps-Docker.md){:target="_blank" rel="noopener"} files to open your project, and dockerize your project into a container for DockerHub

![customize](images/ui-admin/run-admin-app.png)

&nbsp;

## Customize

[Customize](Tutorial.md#3-customize-and-debug-in-your-ide){:target="_blank" rel="noopener"} API Logic Projects using standard IDE Code Editors, including code completion (particularly useful for [declaring logic](Logic-Why.md#code-completion){:target="_blank" rel="noopener"}).

1. You can find **customization points** by searching your project for `Your Code Goes Here`.

2. You can find **customization examples** by creating the [Tutorial](Tutorial.md){:target="_blank" rel="noopener"}, and searching for `#als`.

![customize](images/vscode/venv.png)

&nbsp;

## Debug

Utilize IDE Debuggers, including for declarative rules, as described in the [Tutorial](Tutorial.md#3-customize-and-debug-in-your-ide):

![customize](images/docker/VSCode/nw-readme/declare-logic.png)

&nbsp;

## Rebuild

If you change your database / data model, you can rebuild the project, preserving customizations.  For more information, [click here.](Project-Rebuild.md){:target="_blank" rel="noopener"}
