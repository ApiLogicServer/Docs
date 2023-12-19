---
title: Declarative Application Integration
notes: gold docsite, 2100 words (goal: 1500)
version: 0.01 from docsite
---

# Purpose

Coming Soon -- see preview.

## System Requirements

This app illustrates using IntegrationServices for B2B push-style integrations with APIs, and internal integration with messages.  We have the following **Use Cases:**

1. **Ad Hoc Requests** for information (Sales, Accounting) that cannot be anticipated in advance.

2. **Two Transaction Sources:** A) internal Order Entry UI, and B) B2B partner `OrderB2B` API

The **Northwind API Logic Server** provides APIs *and logic* for both transaction sources:

1. **Self-Serve APIs**, to support ad hoc integration and UI dev, providing security (e.g, customers see only their account)

2. **Order Logic:** enforcing database integrity and application Integration (alert shipping)

3. A **Custom API**, to match an agreed-upon format for B2B partners

The **Shipping API Logic Server** listens on kafka, and processes the message.<br><br>

![overview](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/overview.jpg?raw=true)
&nbsp;

## Self-serve APIs, Shared Logic

This sample illustrates some key architectural considerations:

| Requirement | Poor Practice | Good Practice | Best Practice | Ideal
| :--- |:---|:---|:---|:---|
| **Ad Hoc Integration** | ETL | APIs | **Self-Serve APIs** |  **Automated** Self-Serve APIs |
| **Logic** | Logic in UI | | **Reusable Logic** | **Declarative Rules**<br>.. Extensible with Python |

We'll further expand of these topics as we build the system, but we note some Best Practices:

* **APIs should be self-serve:** not requiring continuing server development

    * APIs avoid the overhead of nightly Extract, Transfer and Load (ETL)

* **Logic should be re-used** over the UI and API transaction sources

    * Logic in UI controls is undesirable, since it cannot be shared with APIs and messages


&nbsp;

# Development Overview

&nbsp;

## 1. Create: Instant Project

The command below creates an `ApiLogicProject` by reading your schema.  The database is Northwind (Customer, Orders, Items and Product), as shown in the Appendix.  Note: the `db_url` value is [an abbreviation](https://apilogicserver.github.io/Docs/Data-Model-Examples/); you would normally supply a SQLAlchemy URL.  

```bash
$ ApiLogicServer create --project_name= --db_url=nw-    # create ApiLogicProject
```

You can then open the project in your IDE, and run it.


<details markdown>

<summary> Show me how </summary>

&nbsp;

To run the ApiLogicProject app:

1. **Create Virtual Environment:** as shown in the Appendix.

2. **Start the Server:** F5 (also described in the Appendix).

3. **Start the Admin App:** either use the links provided in the IDE console, or click [http://localhost:5656/](http://localhost:5656/).  The screen shown below should appear in your Browser.

</details>

One command has created meaningful elements of our system:
<br><br>

!!! pied-piper ":bulb: Instant Self-Serve API - ad hoc integration - and Admin App"

    ### API: Ad hoc Integration

    The system creates an API with end points for each table, with filtering, sorting, pagination, optimistic locking and related data access.
    
    The API is [**self-serve**](https://apilogicserver.github.io/Docs/API-Self-Serve/): consumers can select their own attributes and related data, eliminating reliance on custom API development.  In this sample, our self-serve API meets our needs for Ad Hoc Integration, and Custom UI Dev.

    <img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/api-swagger.jpeg?raw=true">

    ### Admin App: Order Entry UI

    The `create` command also creates an Admin App: multi-page, multi-table with automatic joins -- ready for **[business user agile collaboration](https://apilogicserver.github.io/Docs/Tech-AI/),** and back office data maintenance.  This complements custom UIs you can create with the API.

    You can click the first Customer, and see their Orders, and Items.

    <img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/admin-app-initial.jpeg?raw=true">

&nbsp;

## 2. Customize: in your IDE

While API/UI automation is a great start, we now require Custom APIs, Logic and Security.

You normally apply such customizations using your IDE, leveraging code completion, etc.  To accelerate this sample, you can apply the customizations with `ApiLogicServer add-cust`.   We'll review the customizations below.

<details markdown>

<summary> Show me how -- apply customizations </summary>

&nbsp;

The following `add-cust` process simulates:

* Adding security to your project using a CLI command, and
* Using your IDE to:

    * declare logic in `logic/declare_logic.sh`
    * declare security in `security/declare_security.py`
    * implement custom APIs in `api/customize_api.py`, using <br>`OrderShipping` declared in `integration/row_dict_maps`

> These customizations are shown in the screenshots below.

To apply customizations, in a terminal window for your project:

**1. Stop the Server** (Red Stop button, or Shift-F5 -- see Appendix)

**2. Apply Customizations:**

```bash
ApiLogicServer add-cust
```

**3. Enable and Start Kafka**

&nbsp;

<details markdown>

<summary>Show me how</summary>

To enable Kafka:

1. In `config.py`, find and comment out: `KAFKA_PRODUCER = None  # comment out to enable Kafka`

2. Update your `etc/conf` to include the lines shown below (e.g., `sudo nano /etc/hosts`).

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##

# for kafka
127.0.0.1       broker1
::1             localhost
255.255.255.255 broadcasthost
::1             localhost

127.0.0.1       localhost
# Added by Docker Desktop
# To allow the same kube context to work on the host and the container:
127.0.0.1 kubernetes.docker.internal
# End of section
```
3. Start Kafks: in a terminal window: `docker compose -f integration/kafka/dockercompose_start_kafka.yml up`

</details>


**4. Restart the server, login as `admin`**

</details>

### Declare UI Customizations

The admin app is not built with complex html and javascript.  Instead, it is configured with the ui/admin/admin.yml`, automatically created from your data model by `ApiLogicServer create`.

You can customize this file in your IDE to control which fields are shown (including joins), hide/show conditions, help text etc.  The `add-cust` process above has simulated such customizations.

To see customized Admin app in action, with the restarted server:

**1. Start the Admin App:** [http://localhost:5656/](http://localhost:5656/)

**2. Login** as `s1`, password `p`

**3. Click Customers**

&nbsp;

This makes it convenient to use the Admin App to enter an Order and OrderDetails:

<img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/order-entry-ui.jpg?raw=true">


Note the automation for **automatic joins** (Product Name, not ProductId) and **lookups** (select from a list of Products to obtain the foreign key).  If we attempt to order too much Chai, the transaction properly fails due to the Check Credit logic, described below.

&nbsp;

### Declare Check Credit Logic

Such logic (multi-table derivations and constraints) is a significant portion of a system, typically nearly half.  API Logic server provides **spreadsheet-like rules** that dramatically simplify and accelerate logic development.

&nbsp;

!!! pied-piper ":bulb: Logic: Multi-table Derivation and Constraint Rules, 40X More Concise"


    #### IDE: Declare and Debug

    The 5 check credit rules are shown below.  
    
    > Rules are 40X more concise than legacy code, as [shown here](https://github.com/valhuber/LogicBank/wiki/by-code){:target="_blank" rel="noopener"}.
    
    Rules are declared in Python, simplified with IDE code completion.  The `add-cust` process above has simulated the process of using your IDE to declare logic.
    
    Observe rules can be debugged using standard logging and the debugger:

    <img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/logic-chaining.jpeg?raw=true">

    Rules operate by handling SQLAlchemy events, so apply to all ORM access, whether by the api engine, or your custom code.

    &nbsp;

    #### Agility, Quality

    Rules are a unique and signifcant innovation, providing meaningful improvements over procedural logic:

    | CHARACTERISTIC | PROCEDURAL | DECLARATIVE | WHY IT MATTERS |
    | :--- |:---|:---|:---|
    | **Reuse** | Not Automatic | Automatic - all Use Cases | **40X Code Reduction** |
    | **Invocation** | Passive - only if called  | Active - call not required | Quality |
    | **Ordering** | Manual | Automatic | Agile Maintenance |
    | **Optimizations** |Manual | Automatic | Agile Design |

    > For more on rules, [click here](https://apilogicserver.github.io/Docs/Logic-Why/){:target="_blank" rel="noopener"}.

&nbsp;

### Declare Security

The `add-cust` process above has simulated the `ApiLogicServer add-auth` command, and using your IDE to declare security in `logic/declare_security.sh`.

To see security in action:

**1. Logout (upper right), and Login** as `AFLKI`, password `p`

**2. Click Customer**

&nbsp;

!!! pied-piper ":bulb: Security: Customers Filtered"

    #### Login, Row Filtering

    Observe you now see only customer ALFKI, per the secuity declared below.  Note the console log at the bottom shows how the filter worked.

    <img src="https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/security-filters.jpg?raw=true">

&nbsp;

## 3. Integrate: B2B and Shipping

We now have a running system - an API, logic, security, and a UI.  To integrate with B2B partners and Shipping, we have 2 tasks, described below.

&nbsp;

### B2B Custom Resource

The self-serve API, however, does not conform to the format required for a B2B partnership.  We need to create a custom resource.

You can create custom resources by editing `customize_api.py`, using standard Python, Flask and SQLAlchemy.  A custom `OrderB2B` resource is shown below.

The main task here is to ***map*** a B2B payload onto our logic-enabled SQLAlchemy rows.  API Logic Server provides a declarative `ApplicationIntegration` service you can use as follows:

1. Declare the mapping -- see the `OrderB2B` class in the right pane

    * Note the support for **lookup**, so partners can send ProductNames, not ProductIds

2. Create the custom API endpoint -- see the left pane:

    * Add `def OrderB2B` to `customize_api/py` to create a new endpoint
    * Use the `OrderB2B` class to transform a api request data to SQLAlchemy rows (`dict_to_row`)
    * The automatic commit initiates the same shared logic described above to check credit and reorder products

![post order](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/post-orderb2b.jpg?raw=true)

So, our custom endpoint required about 7 lines of code, along with the API specification on the right.

&nbsp;

### Send `OrderShipping` Message

Successful orders need to be sent to Shipping, again in a predesignated format.

Just as you can customize apis, you can complement rule-based logic using Python events:

1. Declare the mapping -- see the `OrderShipping` class in the right pane.

2. Define a Python `after_flush` event, which invokes `send_order_to_shipping`.  This is called by the logic engine, which passes the SQLAlchemy `models.Order`` row.

3. `send_order_to_shipping` uses the `OrderShipping` class, which maps our SQLAlchemy order row to a dict (`row_to_dict`).

![send order to shipping](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/order-to-shipping.jpg?raw=true)

&nbsp;

## 4. Consuming Messages

### Create/Start Shipping

To explore Shipping:

**1. Create the Shipping Project:**

```bash
ApiLogicServer create --project_name=shipping --db_url=shipping
```

**2. Start the Shipping Server: F5** (it's configured to use a different port)

&nbsp;

### Consuming Logic

Note the logic in `integration/kafka/kafka_consumer.py`.

![process in shipping](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/kafka-consumer.jpg?raw=true)

&nbsp;

### Test it

Use your IDE terminal window to simulate a business partner posting a B2BOrder.  You can set breakpoints in the code described above to explore system operation.

```bash
ApiLogicServer curl "'POST' 'http://localhost:5656/api/ServicesEndPoint/OrderB2B'" --data '
{"meta": {"args": {"order": {
    "AccountId": "ALFKI",
    "Surname": "Buchanan",
    "Given": "Steven",
    "Items": [
        {
        "ProductName": "Chai",
        "QuantityOrdered": 1
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

Internal Note: rebuild, deployment

Instant Business Relationship: by the clock...

Customize with Python, Flask, SQLAlchemy, libraries (Kafka...)

* Instantly: Ad hoc integration, Admin App (zero code)

* Under an hour: declare logic and security (5 rules, 1 security definition)

* An afternoon or so: application integration: this required the most code

    * Custom B2B API: 10 lines

    * Send Order to Shipping: 20 lines

    * Process Order in Shipping: 30 lines

    * Mapping configurations to transform rows and dicts:  120 




| Requirement | Poor Practice | Good Practice | Best Practice | Ideal
| :--- |:---|:---|:---|:---|
| **Ad Hoc Integration** | ETL | APIs | Self-Serve APIs |  **Automated** Self-Serve APIs |
| **UI Dev** | Custom API Dev  | Self-Serve APIs | **Automated** Self-Serve APIs<br>**Automated 
| **Logic** | Logic in UI | | Reusable Logic | **Declarative Rules**<br>.. Extensible with Python |
| **Custom Integration** | | Custom APIs |  | Reusable integration services |

&nbsp;

**Ad Hoc Integration (vs. ETL)**

Many systems need to support ad hoc integration: the inevitable series of requests that do not stipulate an API contract.  It's important to **avoid custom app dev for each new request**.

So, our system should support **self-serve** APIs (in addition to custom APIs).  Unlike Custom APIs which require server development, **Self-Serve APIs can be used directly by consumers to retrieve the attributes and related data they require.**  These can be used by:

* UI Developers - progress no longer blocked on custom server development

* Ad Hoc Integration - remote customers and organizations (Accounting, Sales) can similarly meet their own needs<br>

> **Avoid ETL:** Tradtional internal integration often involves ETL - Extract, Transfer and Load.  That is, each requesting system runs nightly programs to Extract the needed data, Transfer it to their location, and Load it for local access the next day.  This requires app dev for the extract, considerable bandwidth - all to see stale data.<br><br>In many cases, this might be simply to lookup a client's address.  For such requests, **self-serve APIs can avoid ETL overhead, and provide current data**.

&nbsp;

**UI Dev on self-serve APIs**

UI apps depend, of course, on APIs.  As described above, *self-serve APIs* reduce the load on the server team, and unblock the UI team.

For many internal requirements where UI needs are minimal, basic *"Admin"* UI apps can be automated.

&nbsp;

**Logic: Shared, Declarative**

A proper architecture must consider where to place business logic (check credit, reorder products).  Such multi-table logic often consitutes nearly half the development effort.

> A poor practice is to place such logic on UI controller buttons.  It can be difficult or impossible to share this with the OrderB2B service, leading to duplication of effort and inconsistency.

*Shared* logic is thus a requirement, to avoid duplication and ensure consistent results.  Ideally, such logic is declarative: significantly more concise.

&nbsp;

**Reusable Integration Services**

Custom integrations require attribute map / alias services to transform data from remote formats to match our system objects.  In the sample here, this is required to transform incoming B2B APIs, and outgoing message publishing.

Ideally, our architecture can extract Integration Services for reuse, including attribute map / alias services, Lookups, and Cascade Add.  Details below.

&nbsp;

**Messaging**

Note the integration to Shipping is via message, not APIs.  While both APIs and messages may can send data, there is an important difference:

* APIs are **synchronous**: if the remote server is down, the message fails.

* Messages are **async**: systems such as Kafka ensure that messages are delivered *eventually*, when the remote server is brought back online.

&nbsp;

# Status

12/17/2003 - runs.

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