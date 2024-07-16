To make experimenting easier, several sqlite databases are included in the install.  Use them as described below.

## `db_url` Abbreviations

SQLAlchemy URIs can be fiddly.  For example, the sample database is specified like this:

```
ApiLogicServer create --project_name=Allocation --db_url=sqlite:////Users/val/Desktop/database.sqlite
```

So, API Logic Server supports the following `db_url` shortcuts for these pre-installed sqlite sample databases:

* [nw](Tutorial.md){:target="_blank" rel="noopener"} - same as the sample (customers and orders; you can also use an empty `db_url`)

    * With no customizations, the default nw example illustrates the level of automation you should expect for your own projects

* nw- - same as nw
* nw+ - same as nw, but with customizations

    * This includes many examples of customization, so it's an excellent idea to create and explore it

* [basic_demo](Sample-Basic-Demo.md){:target="_blank" rel="noopener"} - a similar, simpler example 
* [allocation](Logic-Allocation.md){:target="_blank" rel="noopener"} - a rule to allocate a payment to a set of outstanding orders
* [BudgetApp](Tech-Budget-App.md){:target="_blank" rel="noopener"} - illustrates automatic creation of parent rows for rollups
* [auth](Security-Overview.md#auth-providers){:target="_blank" rel="noopener"} - sqlite authentication database

In addition to the pre-installed sqlite samples, there are also abbreviations for a few [docker databases](Database-Docker.md){:target="_blank" rel="noopener"}:

* chinook - albums and artists
* classicmodels - customers and orders
* todo - a simple 1 table database

&nbsp;

## Creating databases with ChatGPT

If you don't have a database, but have an *idea*, you can 

* create databases with ChatGPT, and then 
* turn these into projects with ApiLogicServer

You can [see an example here](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/tests/test_databases/ai-created){:target="_blank" rel="noopener"}.

![chatgpt](images/model/employees%20and%20skills.png)

> Note: such databases require *adult supervision*, for example, they often fail to include primary keys on junction tables.

&nbsp;

## Creating Sample Projects

You can use the abbreviations to create projects.  For example, create the sample project _without customizations_ to see how API Logic Server would support your own databases:

```
ApiLogicServer create --project_name=nw_no_customizations --db_url=nw-
```

__Notes:__

1. Docker users would typically precede the `project_name` with `localhost/`

2. Codespaces users should specify `project_name` as `./`

