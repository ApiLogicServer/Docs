This section applies only to `pip` installs.  Docker based installs eliminate such environment issues, and are therefore recommended.

Important: in addition to Python environment, there are other configuration settings to consider as described in the [Quick Start](../IDE-Execute).

## Per-project `venv`

You created a virtual environment when you installed ApiLogicServer.  This ```venv``` will work for all of your created ApiLogicServer projects, or you can use a per-project ```venv```, as follows.

The created project contains a ```requirements.txt``` used to create a [virtual environment](https://docs.python.org/3/library/venv.html).
You can create it in the usual manner:

```sh
cd ApiLogicProject
python3 -m venv venv       # may require python -m venv venv
source venv/bin/activate   # windows venv\Scripts\activate
python3 -m pip install -r requirements.txt
```
&nbsp;

## Shared `venv`

If you wish to share a `venv` over multiple projects, use __Settings > Python: Venv Path__, and specify a directory containing `venv` directories (e.g, where you installed API Logic Server).  This is a convenient way to get started.

Recall this does _not_ apply to docker or Codespace environments.  


<details markdown>

<summary> Show me how </summary>

&nbsp;

A typical way to install API Logic Server is to create a directory called `ApiLogicServer`, and create a `venv` inside it, like this:

```bash title="Install API Logic Server in a Virtual Environment"
python -m venv venv                  # may require python3 -m venv venv
venv\Scripts\activate                # mac/linux: source venv/bin/activate
python -m pip install ApiLogicServer
```

&nbsp;

The resultant directory structure:

![Installed venv](images/tutorial/setup/install-dirs.png)

This `venv` can be re-used by defining a global path in your `Python: venv` setting:

![Settings to define global venv](images/tutorial/setup/settings-python-venv.png)

Then, choose this `venv` with `select interpreter` (you sometimes have to open a Python file):

![Select global venv](images/tutorial/setup/select-interpreter.png)

</details>


## Default `venv` from install

You can also set up the default `venv` for VSCode.  For example, if you installed ApiLogicServer in `/dev/ApiLogicServer`:

```bash
export VIRTUAL_ENV=~/dev/ApiLogicServer/venv
```
Exercise caution - this might affect other projects.

&nbsp;

## `venv_setup` - shortcut setup procedures

Ss of release 5.02.10, projects are created with a `venv_setup` directory which may be helpful in establishing and verifying your Python environment.  For more information, see the [Trouble Shooting Guide](../Troubleshooting#ide-issues).

&nbsp;

## Notes

### Issues with `pip`

The install sometimes fails due on machines with an older version of `pip`.  If you see a message suggesting you upgrade  `pip` , do so.

### VSCode may fail to find your `venv`

If VSCode does not find your `venv`, you can [specify it manually](https://code.visualstudio.com/docs/python/environments#_manually-specify-an-interpreter) using `Python: Select Interpreter`

For more information, see [Work with Environments](https://code.visualstudio.com/docs/python/environments#_work-with-environments).