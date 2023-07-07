In most cases, Python and Python Projects are simple and fast to install, as described below.  If you encounter issues, open the [Detailed Install](../Install).

Follow these instructions to:

1. Install API Logic Server
2. Create the sample Tutorial API Logic Server Project
3. Open it in your IDE
4. Prepare the projects' Python environment


## Create an install directory

You can create this anywhere, such as your home folder or Desktop.

```bash title="Create an install directory"
mkdir ApiLogicServer      # a directory of projects on your local machine
```

## Use Local Install, or Docker

You can install API Logic Server locally using `pip`, or use Docker.  If you already have docker, it can eliminate many of the sometimes-tricky Python install issues.

Open the appropriate section below.

=== "Local Install"

    __Verify Pre-reqs: Python 3.8+__

    Ensure you have these pre-reqs:

    ```bash title="Verify 3.8 - 3.11"
    python --version  # on macs, you may need to use Python3
    ```

    If you need to install Python (it can be tricky), see [these notes](../Tech-Install-Python).
    &nbsp;

    __Install API Logic Server in a Virtual Environment__

    Then, install API Logic Server in the usual manner (typically you create/cd to a new directory, e.g., `ApiLogicServer`):

    ```bash title="Install API Logic Server in a Virtual Environment"
    python -m venv venv                  # may require python3 -m venv venv
    source venv/bin/activate             # windows: venv\Scripts\activate
    python -m pip install ApiLogicServer
    ```

    If you are using SqlServer, you also need to [install `pyodbc`](../Install-pyodbc).

    &nbsp;

    __Create the Tutorial Project__

    ```bash title="Create Tutorial"
    ApiLogicServer tutorial
    ```

    &nbsp;

    __Or, Create a Normal Project__

    ```bash title="Create Typical Project"
    ApiLogicServer create --project_name=ApiLogicProject --db_url=  # or, create-and-run
    ```

    &nbsp;

    __Open the Project in VSCode__

    You have 2 choices:

    * Use a shared `venv`; follow [this procedure](../Project-Env/#shared-venv), _or_
    * Create a `venv` local to the project
        1. Open Folder `ApiLogicServer/tutorial` in VSCode
            * Decline options for Containers
        2. Establish your Virtual Environment - open __Terminal > New Terminal__, and

    ```bash title="Install API Logic Server in a Virtual Environment"
    python -m venv venv                  # may require python3 -m venv venv
    venv\Scripts\activate                # mac/linux: source venv/bin/activate
    python -m pip install -r requirements.txt  # accept "new Virtual environment"
    ```

    &nbsp;

    __Or, run the project directly__

    ```bash title="Run the Project from the Command Line"
    cd ApiLogicProject
    python ApiLogicProject/api_logic_server_run.py                  # run the server
    ```


=== "Docker"

    __Start Docker__
    ```bash title="Start (might install) API Logic Server Docker"
      > docker run -it --name api_logic_server --rm -p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost apilogicserver/api_logic_server
      $ # you are now active in the API Logic Server docker container to create projects
    ```

    > **Mac ARM:** if you have an M1 or M2 Mac, change the last parameter to `apilogicserver/api_logic_server_arm`
  
    > **Windows:** use __Powershell__ (`PWD` is not supported in Command Line)

    &nbsp;

    __Create the Tutorial Project__

    You are now running a terminal window in the Docker machine.  Create the Tutorial project:
      ```bash title="Create Tutorial"
      $ cd /localhost/             # a directory on your local file system in which...
      $ ApiLogicServer tutorial    # tutorial directory will be created
      $ exit                       # return to local host 
      ```

    &nbsp;

    __Or, Create a Typical Project__

    Typical project creation identifies the database and target project name:
      ```bash title="Create Typical project"
      $ cd /localhost/             # a directory on your local file system for project creation
      $ ApiLogicServer create-and-run --project_name=ApiLogicProject --db_url=
      $ exit                       # return to local host 
      ```

    &nbsp;

    __Open the created Project in VSCode__
    
    Once the project is created, open it in VSCode on your local host:

    1. Open Folder `ApiLogicServer/tutorial` in VSCode
        * Accept option to "Reopen in Container"

            > If you already skipped this option, no worries.  Use __View > Command Palette > Remote-Containers: Reopen in Container__


&nbsp;

---


## Next Steps - Tutorial

You're all set - the Tutorial is created, installed and ready to run.  Proceed to [Explore the Tutorial](../Tutorial).
