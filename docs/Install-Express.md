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
    python -m venv venv                  # may require python3 -m venv venv
    source venv/bin/activate             # windows: venv\Scripts\activate
    python -m pip install ApiLogicServer
    ```

    Notes:
    
    1. Windows users will need to run the terminal in Admin mode, with scripts enabled
    2. For `genai` functions, you will need an [OpenAI Key](Sample-Basic-Tour.md#get-an-openai-apikey){:target="_blank" rel="noopener"}
    2. If you are using SqlServer, you also need to [install `pyodbc`](Install-pyodbc.md)
    3. If you are using VSCode, we ***strongly recommend*** you create the [VSCode CLI](IDE-Customize.md#vscode-cli){:target="_blank" rel="noopener"}.

    &nbsp;

    __Start the genai-logic manager__

    ```bash title="Start Manager"
    genai-logic start
    ```

    This will install the samples and open in your IDE; open the readme and follow the directions to create projects.


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

    __Start Docker__
    ```bash title="Start (might install) API Logic Server Docker"
      > docker run -it --name api_logic_server --rm -p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost genai-logic/api_logic_server
      $ # you are now active in the API Logic Server docker container to create projects
    ```

    > **Mac ARM:** if you have an M1 or M2 Mac, change the last parameter to `apilogicserver/api_logic_server_arm`
  
    > **Windows:** use __Powershell__ (`PWD` is not supported in Command Line)

    &nbsp;

    __Create the Tutorial Project__

    You are now running a terminal window in the Docker machine.  Create the Tutorial project:
      ```bash title="Create Tutorial"
      $ cd /localhost/             # a directory on your local file system in which...
      $ genai-logic tutorial    # tutorial directory will be created
      $ exit                       # return to local host 
      ```

    &nbsp;

    __Or, Create a Typical Project__

    Typical project creation identifies the database and target project name:
      ```bash title="Create Typical project"
      $ cd /localhost/             # a directory on your local file system for project creation
      $ genai-logic create-and-run --project_name=ApiLogicProject --db_url=
      $ exit                       # return to local host 
      ```

    &nbsp;

    __Open the created Project in VSCode__
    
    Once the project is created, open it in VSCode on your local host:

    1. Open Folder `genai-logic/tutorial` in VSCode
        * Accept option to "Reopen in Container"

            > If you already skipped this option, no worries.  Use __View > Command Palette > Remote-Containers: Reopen in Container__


&nbsp;

---


## Next Steps - Tutorial

You're all set - the Sample is created, installed and ready to run.  Open the readme for a walk-through.
