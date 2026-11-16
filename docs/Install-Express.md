In most cases, Python and Python Projects are simple and fast to install, as described below.  If you encounter issues, open the [Detailed Install](Install.md).

Follow these instructions to:

1. Install API Logic Server
2. Create the sample Tutorial API Logic Server Project
3. Open it in your IDE
4. Prepare the projects' Python environment


## Create an install directory

You can create this anywhere, such as your home folder or Desktop.

```bash title="Create an install directory"
mkdir genai-logic      # a directory of projects on your local machine
```

## Use Local Install, or Docker

You can install API Logic Server locally using `pip`, or use Docker.  If you already have docker, it can eliminate many of the sometimes-tricky Python install issues.

Open the appropriate section below.

=== "Local Install"

    __Verify Pre-reqs: Python 3.10+__

    Ensure you have these pre-reqs:

    ```bash title="Verify 3.10 - 3.13"
    python --version  # on macs, you may need to use Python3
    ```

    > Note: Python 3.13 is supported as of release 15.0.52.  <br>On Windows, 3.13 appears to cause install failures due to Pandas - this is under investigation, please use 3.11.

    If you need to install Python (it can be tricky), see [these notes](Tech-Install-Python.md).

    > Install requires a c compiler.  E.g., MacOS users will require Command Line Tools: <br>`> xcode-select --install`

    > Releases before 15.0.60 may require: `brew install librdkafka`.

    > Windows VSCode users may require admin privileges for PowerShell: <br>`Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

    &nbsp;

    __Install API Logic Server in a Virtual Environment__

    Then, install API Logic Server in the usual manner (typically you create/cd to a new directory, e.g., `genai-logic`):

    ```bash title="Install API Logic Server in a Virtual Environment"
    cd genai-logic
    python -m venv venv                  # may require python3 -m venv venv
    source venv/bin/activate             # windows: venv\Scripts\activate
    python -m pip install ApiLogicServer
    ```

    Notes:
    
    1. Windows users will need to run the terminal in Admin mode, with scripts enabled
    2. For `genai` functions, you will need an [OpenAI Key](Sample-Basic-Tour.md#get-an-openai-apikey){:target="_blank" rel="noopener"}
    2. If you are using SqlServer, you also need to [install `pyodbc`](Install-pyodbc.md)
    3. If you are using VSCode, we ***strongly recommend*** you create the VSCode CLI - for more information, [click here](IDE-Customize.md#vscode-cli){:target="_blank" rel="noopener"}.  Do this before the next step

    &nbsp;

    __Start the genai-logic manager__

    ```bash title="Start Manager"
    genai-logic start
    ```

    This will install the samples and open in your IDE; open the readme and follow the directions to create projects.

    For GenAI-Logic updates, you can restart the Manager with `--clean`.  This does not affect existing projects.


    &nbsp;
    
    __Create the Basic Demo Project__

    This project provides a **`Readme`** to walk you through key aspects of API Logic Server.  For more information, [click here](Sample-Basic-Tour.md){:target="_blank" rel="noopener"}.

    The **`Readme`** recommends that you start by creating the *basic demo* app:

    ```bash title="Create Basic Demo"
    genai-logic create --project_name=basic_demo --db_url=basic_demo
    ```

    &nbsp;

    __Open the Project in VSCode__

    The project should open automatically in your IDE with a pre-installed virtual environment (for more information, [click here](/Project-Env.md){:target="_blank" rel="noopener"})

=== "Docker"

    __Start the container__

    This needs no Python install: the image contains Python, API Logic Server and its libraries.  Run it from the directory in which you want your projects (it is mounted at `/localhost`):

    ```bash title="Start API Logic Server container"
    docker run -it --name api_logic_server --rm -p 5656:5656 -v ${PWD}:/localhost apilogicserver/api_logic_server
    # you are now at a prompt inside the API Logic Server container
    ```

    > **Podman:** use `podman` instead of `docker`.  The image runs natively on Intel and Arm (M-series) machines.

    > **Windows:** use __PowerShell__ (`${PWD}` is not supported in Command Prompt).

    &nbsp;

    __Create the Basic Demo Project__

    You are now at a prompt in the container.  Create the project in the mounted directory, then return to your machine:

    ```bash title="Create Basic Demo"
    cd /localhost
    genai-logic create --project_name=basic_demo --db_url=basic_demo
    exit
    ```

    The project is now in your directory (`basic_demo`).  To run it without installing anything else, see [Use Standard Image](DevOps-Containers-Use-Standard.md).

    &nbsp;

    __Or, Create a Typical Project__

    Typical project creation identifies the database and target project name:

    ```bash title="Create Typical project"
    cd /localhost
    genai-logic create --project_name=ApiLogicProject --db_url=<your database URI>
    exit
    ```

    &nbsp;

    __Open the created Project in VSCode__

    Once the project is created, open it in VSCode on your local host:

    1. Open Folder `basic_demo` in VSCode
        * Accept option to "Reopen in Container"

            > If you already skipped this option, no worries.  Use __View > Command Palette > Dev Containers: Reopen in Container__


&nbsp;

---

## Containers (optional): set up and test after install

The basic demos need no containers.  Some samples use Postgres, Keycloak or Kafka containers, and DevOps teams will want to verify the container path.  After install, take a minute to set up and test your container runtime - **Docker or Podman** (Podman is fully supported; see [Podman](DevOps-Podman.md)).

1. Start the runtime: Docker Desktop, or for Podman `podman machine start`.

2. Tell the shell which one you use.  Add this line to your shell profile (`~/.zshrc` or `~/.bashrc`) so every terminal and every script has it (it picks Docker if running, else Podman):

    ```bash title="Set CONTAINER_CLI"
    export CONTAINER_CLI=$(docker info >/dev/null 2>&1 && echo docker || echo podman)
    ```

    Open a new terminal, and check it: `echo $CONTAINER_CLI`.  (Windows PowerShell: `$env:CONTAINER_CLI = "docker"`, or `"podman"`.)

3. Test it by running the standard image:

    ```bash title="Test container"
    $CONTAINER_CLI run --rm apilogicserver/api_logic_server python3 --version
    ```

    This pulls the image on first use (about 1 GB) and prints the Python version.  If it does, containers work.

The Manager's `README` has the full procedure (section **Containers: Podman or Docker**: Postgres, Keycloak, Kafka, with verification steps).  To run and validate a project in a container, see the [DevOps Quick Start](DevOps-Quick-Start.md).

&nbsp;

---


## Next Steps - Tutorial

You're all set - the Sample is created, installed and ready to run.  Open the readme for a walk-through.
