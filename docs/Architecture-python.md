!!! pied-piper ":bulb: TL;DR: 2 venvs: Run-venv, Dev-venv (no CLI)"

    Upgrading to major versions of [Python](https://www.python.org/downloads/){:target="_blank" rel="noopener"} (e.g., 3.12) is [non-trivial](https://pythonspeed.com/articles/upgrade-python-3.12/){:target="_blank" rel="noopener"}.  Key risk areas revolve around [dependencies](https://pyreadiness.org/3.12/){:target="_blank" rel="noopener"}:

    1. [pyodbc](https://pypi.org/project/pyodbc/){:target="_blank" rel="noopener"}

    2. [psycopg](https://stackoverflow.com/questions/77241353/psycopg2-importerror-python3-12-on-windows/77269958#77269958){:target="_blank" rel="noopener"}

    These affect:

    1. requirements.txt
    2. setup.py
    3. build and test (per pyodbc install)

&nbsp;

**Under Construction**

Verify psycoopg - create a venv and test pip install

Install unixobdbc, you might get:

```bash
==> Running `brew cleanup unixodbc`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
Removing: /opt/homebrew/Cellar/unixodbc/2.3.11... (48 files, 2.3MB)
Warning: The following dependents of upgraded formulae are outdated but will not
be upgraded because they are not bottled:
  msodbcsql18
(venv) val@Vals-MPB-14 Desktop % 
```

but seemed to work

bizarre show BLT when running app

DocNotes no longer support \B (geesh) - used extensively to format help

setup has psycopg[binary], yields:<br>
psycopg-binary==3.1.18

## Setup is gone

You can no longer do this:

```bash
python3 setup.py sdist bdist_wheel

python3 -m twine upload  --repository-url https://test.pypi.org/legacy/ --skip-existing dist/* 
```


install setuptools:

* Totally gone.  Rewrite your entire build and test.
* [Guide](https://packaging.python.org/en/latest/guides/modernize-setup-py-project/)
* [Migration?](https://stackoverflow.com/questions/72832052/is-there-a-simple-way-to-convert-setup-py-to-pyproject-toml)
  * [PDM](https://pdm-project.org/latest/) - another venv?
  * [Hatch](https://hatch.pypa.io/latest/intro/#existing-project)


