# Welcome to API Logic Server

There are the official docs of [API Logic Server](https://apilogicserver.github.io/Docs/).  Docs are built with mkdocs, which requires special setup to operate locally.

* Mac: run `sh docs.sh`
    * I find it helpful to copy this to my `/usr/local/bin` folder.
* Windows: execute this in Powershell:

```
PS C:\Users\val\dev\Org-ApiLogicServer> cd .\Docs\
PS C:\Users\val\dev\Org-ApiLogicServer\Docs> venv\Scripts\activate
mkdocs serve
```

These start a process that monitors changes to the docs folder, whereupon the docs are rebuilt.

To see the doc build locally, [http://127.0.0.1:8000](http://127.0.0.1:8000).

The public docs are automatically rebuilt whenever you push changes to GitHub.

To push, you will need to:

```bash
git config --global http.postBuffer 1048576000
```
