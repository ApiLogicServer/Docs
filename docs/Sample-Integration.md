---
title: Declarative Application Integration
notes: gold docsite, 2100 words (goal: 1500)
version: 0.01 from docsite
---

# Purpose

Coming Soon -- see preview.

## System Requirements

This app illustrates using IntegrationServices for B2B integrations with APIs, and internal integration with messages.

We have the following **Use Cases:**

I. **Ad Hoc Requests** for information (Sales, Accounting) that cannot be anticipated in advance.

II. 2 **Two Transaction Sources:**

1. Order Entry UI for internal users
2. B2B partners post `OrderB2B` APIs in an agreed-upon format

The **Northwind API Logic Server** provides APIs *and logic* for both transaction sources:

1. **Self-Serve APIs**, to support

    1. Ad hoc Integration Requests
    2. UI developers to build the Order Entry UI
    3. Security (e.g, only managers see discontinued products)

2. **Order Logic:** shared over both transaction sources, this logic

    1. Enforces database integrity (checks credit, reorders products)
    2. Provides Application Integration (alert shipping with a formatted Kafka message)

3. A **Custom API**, to match an agreed-upon format for B2B partners

The **Shipping API Logic Server** listens on kafka, and processes the message.

![overview](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/overview.jpg?raw=true)
&nbsp;

## Architecture Requirements

| Requirement | Poor Practice | Good Practice | Best Practice |
| :--- |:---|:---|:---|
| **Ad Hoc Integration** | ETL | APIs | **Automated** Self-Serve APIs |
| **UI App Dev** | Custom API Dev  | Self-Serve APIs | **Automated** Self-Serve APIs<br>**Automated Admin App** <br>.. (where applicable) |
| **Logic** | Logic in UI | Reusable Logic | **Declarative Business Rules**<br>.. extensible with Python |
| **Custom Integration** | | Custom APIs | Reusable integration services |

&nbsp;

### Ad Hoc Integration (vs. ETL)

It would be undesirable to require custom API development for ad integration: the inevitable series of requirements that do not stipulate an API contract.  So, our system should support **self-serve** APIs in addition to custom APIs.

Unlike Custom APIs which require server development, **Self-Serve APIs can be used directly by consumers to retrieve the attributes and related data they require.**  API consumers include:

* UI Developers - progress no longer blocked on custom server development

* Ad Hoc Integration - remote customers and organizations (Accounting, Sales) can similarly meet their own needs

&nbsp;

> **Avoid ETL:** Tradtional internal integration often involves ETL - Extract, Transfer and Load.  That is, each requesting system runs nightly programs to Extract the needed data, Transfer it to their location, and Load it for local access the next day.  This requires app dev for the extract, considerable bandwidth - all to see stale data.<br><br>In many cases, this might be simply to lookup a client's address.  For such requests, self-serve APIs can avoid ETL overhead, and provide current data.

&nbsp;

### UI Dev on self-serve APIs

UI apps depend, of course, on APIs.  While these can be custom, the sheer number of such requests places a burden on the server team.  As for ad hoc integrations, a better approach is self-serve APIs.

In many systems, basic *"Admin"* UI apps can be automated, to address requirements when the UI needs are minimal.

&nbsp;

### Logic: Shared, Declarative

A proper architecture must consider where to place business logic (check credit, reorder products).  Such multi-table logic often consitutes nearly half the development effort.

> A poor practice is to place such logic on UI controller buttons.  It can be difficult or impossible to share this with the OrderB2B service, leading to duplication of efforts and inconsistency.

*Shared* logic is thus a requirement, to avoid duplication and ensure consistent results.  Ideally, such logic is declarative: much more concise, and automatically enforced, ordered and optimized.

&nbsp;

### Reusable Integration Services

Custom integrations require attribute map / alias services to transform data from remote formats to match our system objects.  In the sample here, this is required to transform incoming B2B APIs, and outgoing message publishing.

Ideally, our architecture can extract Integration Services for reuse, including attribute map / alias services, Lookups, and Cascade Add.  Details below.

&nbsp;

### Messaging

Note the integration to Shipping is via message, not APIs.  While both APIs and messages may can send data, there is an important difference:

* APIs are **synchronous**: if the remote server is down, the message fails.

* Messages are **async**: systems such as Kafka ensure that messages are delivered *eventually*, when the remote server is brought back online.

&nbsp;

# Development Overview

&nbsp;

## 1. Create: Instant Project

Project creation is automated with a command like:

```bash
$ ApiLogicServer create --project_name= db_url=nw-
```

> Note: the `db_url` value is [an abbreviation](https://apilogicserver.github.io/Docs/Data-Model-Examples/).  You would normally supply a SQLAlchemy URI.

This creates a project by reading your schema.  The database is Northwind (Customer, Orders, Items and Product), as shown in the Appendix.  

You can then open the project in your IDE, and run it.


<details markdown>

<summary> Show me how </summary>

&nbsp;

To run the ApiLogicProject app:

1. **Create Virtual Environment:** as shown in the Appendix.

2. **Start the Server:** F5 (also described in the Appendix).

3. **Start the Admin App:** either use the links provided in the IDE console, or click [http://localhost:5656/](http://localhost:5656/).  The screen shown below should appear in your Browser.

</details>

The sections below explore the system that has been created.
<br><br>

!!! pied-piper ":bulb: Automation: Instant API, Admin App (enable UI dev, agile collaboration)"

    ### Self-Serve API

    The system creates an API with end points for each table, with filtering, sorting, pagination, optimistic locking and related data access.
    
    The API is [**self-serve**](https://apilogicserver.github.io/Docs/API-Self-Serve/), consumers can select their own attributes and related data, wihout requiring custom API development.

    <img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/api-swagger.jpeg?raw=true">

    ### Ad hoc Integration

    Our self-serve API meets our needs for Ad Hoc Integration, and Custom UI Dev.

    ### Admin App

    The `create` command also creates an Admin App: multi-page, multi-table -- ready for **[business user agile collaboration](https://apilogicserver.github.io/Docs/Tech-AI/),** and back office data maintenance.  This complements custom UIs created with the API.

    You can click Customer 2, and see their Orders, and Items.  FIXME

    <img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/admin-app-initial.jpeg?raw=true">

&nbsp;

## 2. Customize in your IDE

While API/UI automation is a great start, we now require Custom APIs, Logic and Security.  You normally apply such customizations using your IDE, leveraging code completion, etc.  To accelerate this sample, you can apply the customizations with `ApiLogicServer add-cust`.   We'll review the customizations below.

<details markdown>

<summary> Show me how -- apply customizations </summary>

&nbsp;

The following `apply_customizations` process simulates:

* Adding security to your project using a CLI command, and
* Using your IDE to:

    * declare logic in `logic/declare_logic.sh`
    * declare security in `security/declare_security.py`
    * implement custom APIs in `api/customize_api.py`, using <br>IntegrationServices declared in `integration/integration_services`

> These are shown in the screenshots below.<br>It's quite short - 5 rules, 7 security settings, and 120 lines for application integration.

To apply customizations, in a terminal window for your project:

**1. Stop the Server** (Red Stop button, or Shift-F5 -- see Appendix)

**2. Apply Customizations:**

```bash
ApiLogicServer add-cust
```

</details>


&nbsp;

### Declare Row-Level Security

The `apply_customizations` process above has simulated the `ApiLogicServer add-auth` command, and using your IDE to declare security in `logic/declare_security.sh`.

To see security in action:

**1. Start the Server**  F5

**2. Start the Admin App:** [http://localhost:5656/](http://localhost:5656/)

**3. Login** as `s1`, password `p`

**4. Click Products**

&nbsp;

!!! pied-piper ":bulb: Security: Discontinued Products Filtered"

    #### Login, Row Filtering

    Observe you now see fewer Products, per the `GlobalFilter` declared below.

    <img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/security-filters.jpeg?raw=true">


&nbsp;

### Declare Check Credit Logic

Such logic (multi-table derivations and constraints) is a significant portion of a system, typically nearly half.  API Logic server provides **spreadsheet-like rules** that dramatically simplify and accelerate logic development.

Rules are declared in Python, simplified with IDE code completion.  The screen below shows the 5 rules for our **Check Credit Logic** noted in the initial diagram.

The `apply_customizations` process above has simulated the process of using your IDE to declare logic in `logic/declare_logic.sh`.

To see logic in action:

**1. In the admin app, Logout (upper right), and login as admin, p**

**2. Use the Admin App to add an Order and Item for `Customer 1`** (see Appendix), where the rollup of Item Amount to the Order exceed the credit limit.

Observe the rules firing in the console log, as shown in the next screenshot.  FIX ME

&nbsp;

!!! pied-piper ":bulb: Logic: Multi-table Derivation and Constraint Rules, 40X More Concise"

    #### 40X More Concise

    Logic provides significant improvements over procedural logic, as described below.


    | CHARACTERISTIC | PROCEDURAL | DECLARATIVE | WHY IT MATTERS |
    | :--- |:---|:---|:---|
    | **Reuse** | Not Automatic | Automatic - all Use Cases | **40X Code Reduction** |
    | **Invocation** | Passive - only if called  | Active - call not required | Quality |
    | **Ordering** | Manual | Automatic | Agile Maintenance |
    | **Optimizations** |Manual | Automatic | Agile Design |

    <img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/logic-chaining.jpeg?raw=true">
    

&nbsp;

## 3. Integrate B2B and Shipping

TODO: pre-supplied integration services

![post order](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/post-orderb2b.jpg?raw=true)

![send order to shipping](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/order-to-shipping.jpg?raw=true)

```bash
ApiLogicServer curl "'POST' 'http://localhost:5656/api/ServicesEndPoint/OrderB2B'" --data '
{"meta": {"args": {"order": {
    "AccountId": "ALFKI",
    "Surname": "Buchanan",
    "Given": "Steven",
    "Items": [
        {
        "ProductName": "Chai",
        "QuantityOrdered": 1000
        },
        {
        "ProductName": "Chang",
        "QuantityOrdered": 2
        }
        ]
    }
}}}'
```


&nbsp;

# Summary

Note: rebuild, deployment

&nbsp;

# Status

12/02/2003 - runs, messaging is a TODO.

&nbsp;

# Appendix

## Apendix: Customizations

View them [here](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/api_logic_server_cli/prototypes/nw).

&nbsp;

## Appendix: Procedures

Specific procedures for running the demo are here, so they do not interrupt the conceptual discussion above.

You can use either VSCode or Pycharm.

&nbsp;

**1. Establish your Virtual Environment**

Python employs a virtual environment for project-specific dependencies.  Create one as shown below, depending on your IDE.

For VSCode:

Establish your `venv`, and run it via the first pre-built Run Configuration.  To establish your venv:

```bash
python -m venv venv; venv\Scripts\activate     # win
python3 -m venv venv; . venv/bin/activate      # mac/linux

pip install -r requirements.txt
```

For PyCharm, you will get a dialog requesting to create the `venv`; say yes.

See [here](https://apilogicserver.github.io/Docs/Install-Express/) for more information.

&nbsp;

**2. Start and Stop the Server**

Both IDEs provide Run Configurations to start programs.  These are pre-built by `ApiLogicServer create`.

For VSCode, start the Server with F5, Stop with Shift-F5 or the red stop button.

For PyCharm, start the server with CTL-D, Stop with red stop button.

&nbsp;

**3. Entering a new Order**

To enter a new Order:

1. Click `Customer 1``

2. Click `+ ADD NEW ORDER`

3. Set `Notes` to "hurry", and press `SAVE AND SHOW`

4. Click `+ ADD NEW ITEM`

5. Enter Quantity 1, lookup "Product 1", and click `SAVE AND ADD ANOTHER`

6. Enter Quantity 2000, lookup "Product 2", and click `SAVE`

7. Observe the constraint error, triggered by rollups from the `Item` to the `Order` and `Customer`

8. Correct the quantity to 2, and click `Save`


**4. Update the Order**

To explore our new logic for green products:

1. Access the previous order, and `ADD NEW ITEM`

2. Enter quantity 11, lookup product `Green`, and click `Save`.