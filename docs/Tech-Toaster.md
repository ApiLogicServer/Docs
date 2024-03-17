!!! pied-piper ":bulb: TL;DR - An API Appliance"

    ![Toaster](images/sample-ai/toaster.jpg){: style="height:201px;width:300px"; align=right }
    
    Just as you can plug in a toaster, and 
    <br>add bread,

    You can plug this appliance into your database, and 
    <br>add Rules and Python.

    Automation can provide:

    * Remarkable agility and simplicity
    * With all the flexibility of a framework

&nbsp;

## 1. Plug It Into Your Database

Here's how you plug the docker appliance into your database:

```bash
$ ApiLogicServer create-and-run --project-name=sample_ai --db-url=sqlite:///sample_ai.sqlite
```

&nbsp;

### It Runs: Admin App and API

You have a running system as shown on the split-screen below: 

* a multi-page ***Admin App*** (shown on the left), supported by...
* a multi-table ***JSON:API with Swagger*** (shown on the right)

![Runs](images/sample-ai/Microservice-Automation.png)

So, right out of the box, you can support

* Custom client app dev, and 
* Ad hoc application integration
* Agile Collaboration, based on Working Software

It's worth reflecting on what you *didn't do* to get working software.  Using UI and server frameworks would require several weeks of work, and substantial expertise.

&nbsp;

### Containerize

API Logic Server can run as a container, or a standard pip install.  In either case, you can containerize your project for deployment, e.g. to the cloud.


&nbsp;

## 2. Add Rules for Logic

Instant working software is great, but without logic enforcement it's little more than a cool demo. 

Behind the running application is a project you can open with your IDE, and add logic:

![Logic](images/sample-ai/rules.jpg)

Instead of conventional procedural logic, the code above is *declarative.*  Like a spreadsheet, you declare ***rules*** for multi-table derivations and constraints.  The rules handlle all the database access, the dependencies, and logic ordering.

> The result is quite remarkable: the 5 spreadsheet-like rules above perform the same logic as 200 lines of Python.  The backend half of your system is ***40X more concise.***

Similar rules are provided for granting row-level access, based on user roles.

&nbsp;

## 3. Add Python for Flexibility

Automation and Rules provide remarkable agility, but you need flexibility to deliver a complete result.  Use Python and popular packages to complete the job.  

Here we customize for pricing discounts, and sending Kafka messages:

![Rules Plus Python](images/sample-ai/rules-plus-python.png)

&nbsp;

# Extensible Declarative Automation

The screenshots above illustrate remarkable agility.  This system might have taken weeks or mnnths using conventional frameworks.

But it's more than agility.  The *level of abstraction* here is very high, brings a level of simplicity that enables you to create microservices -- even if you are new to Python, or Frameworks such as Flask or SQLAlchemy.

There are 3 pillars that deliver this speed and simoplicity:

1. Automation - instead of slow and complex framework coding, just plug in your database for a running API and Admin App

2. Declarative - instead of tedious code that describe ***how*** logic operates, rules express ***what*** you want to accomplish

3. Extensible - finish the remaining elements with your IDE, Python and standard packages such as Flask and SQLAlchemy.



