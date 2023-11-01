!!! pied-piper ":bulb: TL;DR - Standards-based Customization: **Your IDE**, standard packages"

    The `ApiLogicServer create` command creates API Logic Projects: **customize in *your* IDE.**

    Use standard packages, such as **Flask and SQLAlchemy**.

    Standard file-based projects: use **GitHub** for source control, etc.


For more information on opening projects and establishing their Python Execution environment, see [Execute an API Logic Project](IDE-Execute.md){:target="_blank" rel="noopener"}.

&nbsp;

## Use your IDE for API Logic Projects

The `ApiLogicServer create` command creates an API Logic Project, which you can open in your IDE as shown below.  As illustrated in the [Tutorial](Tutorial.md){:target="_blank" rel="noopener"}, you can use the expected features of your IDE to customize, run and debug your project:

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/generated-project.png?raw=true"></figure>

&nbsp;

## Customize

[Customize](Tutorial.md#customize-and-debug.md) API Logic Projects using standard IDE Code Editors, including code completion (particularly useful for [declaring logic](Logic-Why.md#code-completion){:target="_blank" rel="noopener"}):

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/vscode/venv.png?raw=true"></figure>

&nbsp;

## Run

The `ApiLogicServer create` command also creates:

* Launch configurations to run your project, and run [tests](Behave.md){:target="_blank" rel="noopener"}.
* [Docker](DevOps-Docker.md){:target="_blank" rel="noopener"} files to open your project, and dockerize your project into a container for DockerHub

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/ui-admin/run-admin-app.png?raw=true"></figure>

&nbsp;

## Debug

Utilize IDE Debuggers, including for declarative rules, as described in the [Tutorial](Tutorial.md#customize-and-debug):

<figure><img src="https://github.com/valhuber/ApiLogicServer/raw/main/images/docker/VSCode/nw-readme/declare-logic.png"></figure>
