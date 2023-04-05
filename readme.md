# Welcome to API Logic Server

There are the official docs of [API Logic Server](https://apilogicserver.github.io/Docs/).  Docs are built with mkdocs, which requires special setup to operate locally.

* Mac: run `docs.sh`
* Windows: execute this in Powershell:

```
PS C:\Users\val\dev\Org-ApiLogicServer> cd .\Docs\
PS C:\Users\val\dev\Org-ApiLogicServer\Docs> venv\Scripts\activate
mkdocs serve
```

These start a process that monitors changes to the docs folder, whereupon the docs are rebuilt.

To see the doc build locally, [http://127.0.0.1:8000](http://127.0.0.1:8000).