!!! pied-piper ":bulb: TL;DR: 2 venvs: Run-venv, Dev-venv (no CLI)"

    Upgrading to major versions of Python (e.g., 3.12) is [non-trivial](https://pythonspeed.com/articles/upgrade-python-3.12/){:target="_blank" rel="noopener"}.  Key risk areas revolve around [dependencies](https://pyreadiness.org/3.12/){:target="_blank" rel="noopener"}:

    1. [pyodbc](https://pypi.org/project/pyodbc/){:target="_blank" rel="noopener"}

    2. [psycopg](https://stackoverflow.com/questions/77241353/psycopg2-importerror-python3-12-on-windows/77269958#77269958){:target="_blank" rel="noopener"}

    These affect:

    1. requirements.txt
    2. setup.py
    3. build and test (per pyodbc install)

&nbsp;

**Under Construction**

