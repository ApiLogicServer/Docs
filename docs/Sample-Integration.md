# Purpose

Coming Soon -- see preview.

## System Requirements

This app illustrates using IntegrationServices for B2B integrations with APIs, and internal integration with messages.

We have the following **Use Cases:**

I. **Ad Hoc Requests** for information (Sales, Accounting) that cannot be antipated in advance.

II. 2 **Two Transaction Sources:**

1. Order Entry UI for internal users
2. B2B partners post `OrderB2B` APIs in an agreed-upon format


![overview](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/overview.jpg?raw=true)

The **Northwind API Logic Server** provides APIs and the underlying logic for both transaction sources:

1. **Self-serve APIs**, to support

    1. UI developers to build the Order Entry UI
    2. Ad hoc Rquests

2. **Order Logic:** shared over both transaction sources, this logic

    1. Enforces database integrity (checks credit, reorders products)
    2. Provides application integration services to format an order to alert shipping with a Kafka message.  Unlike APIs, messages are lost if the receiving server (Shipping) is down

3. A **Custom API**, to match an agreed-upon format for B2B partners

The **Shipping API Logic Server** listens on kafka, and stores the message which updates <whatever> using logic.

&nbsp;

## Architecture Requirements

| Requirememnt | Worst Practice | Good Practice | Best Practice |
| :--- |:---|:---|:---|
| **Ad hoc requests** | Custom Server Dev  | Self-Serve APIs | Automated Self-Service APIs |
| **Logic** | Logic in UI | Reusable Logic | Declarative Business Rules, extensible with Python}
| **Integration** | ETL | APIs | Automated Self-Serve APIs |

&nbsp;

### Custom APIs

Custom APIs are required to meet API contracts that define API request formats.  This system includes 2: one to integrate with external B2B partners, and 1 to integrate with internal organizations.

### Self-Serve APIs

However, it would be undesirable to require custom API development for the inevitable series of requirements that do not stipulate an API contract.  So, our system should support **self-serve** APIs in addition to custom APIs.

Unlike Custom APIs which require server development, Self-Serve APIs can be used directly by consumers.  Consumers use Swagger to retrieve the data they want, then copying the URI to their code.  API consumers include:

* UI Developers - progress no longer blocked on custom server development

* Application Integration - remote customers and organizations (Accounting, Sales) can similarly meet their own needs

&nbsp;

#### Avoid ETL

Tradtional internal integration often involves ETL - Extract, Transfer and Load.  That is, each requesting system runs nightly programs to Extract the needed data, Transfer it to their location, and Load it for local access the next day.  This requires app dev for the extract, considerable bandwidth - all to see stale data.

In many cases, this might be simply to lookup a client's address.  For such requests, self-serve APIs can avoid ETL overhead, and provide current data.

&nbsp;

### Reusable Integration Services




### Shared Logic

A proper architecture must consider where to place business logic (check credit, reorder products).  Such multi-table logic often consitutes nearly half the development effort.

A worst practice is to place such logic on UI controller buttons.  It can be difficult or impossile to share this with the OrderB2B service, leading to duplication of efforts and inconsistency.

*Shared* logic is thus a requirement, to avoid duplication and ensure consistent results.  Ideally, such logic is declarative: much more concise, and automatically enforced, ordered and optimized.

&nbsp;

# Setup: Create Project

This is the sample app

```
ApiLogicServer create --project_name= --db_url=
```

&nbsp;

# Test `CustomAPI/Customer`

1. Establish the `venv`, as usual
2. F5 to run, as usual

&nbsp;

## Existing `add_order`

Here, the attribute names must exactly match the database / model names:

```bash
        curl -X 'POST' \
            'http://localhost:5656/api/ServicesEndPoint/add_order' \
            -H 'accept: application/vnd.api+json' \
            -H 'Content-Type: application/json' \
            -d '{
            "meta": {
                "method": "add_order",
                "args": {
                "CustomerId": "ALFKI",
                "EmployeeId": 1,
                "Freight": 10,
                "OrderDetailList": [
                    {
                    "ProductId": 1,
                    "Quantity": 1,
                    "Discount": 0
                    },
                    {
                    "ProductId": 2,
                    "Quantity": 2,
                    "Discount": 0
                    }
                ]
                }
            }
            }'
```

&nbsp;

## Verify create json from business object

1. Swagger: `ServicesEndPoint`` > `add_order`
2. Verify logic log contains **Send to Shipping:** (at end)

&nbsp;

## B2B Order

Discouraged, since requires client to provide Id.  Best practice is to use lookups - next example.,

1. Swagger: `ServicesEndPoint` > `add_order_by_id`

&nbsp;

Or... 

```bash
ApiLogicServer curl "'POST' 'http://localhost:5656/api/ServicesEndPoint/add_order_by_id'" --data '
{"order": {
            "AccountId": "ALFKI",
            "SalesRepId": 1,
            "Items": [
                {
                "ProductId": 1,
                "QuantityOrdered": 1
                },
                {
                "ProductId": 2,
                "QuantityOrdered": 2
                }
                ]
            }
}'
```

&nbsp;

## B2B Order With Lookup

```bash
ApiLogicServer curl "'POST' 'http://localhost:5656/api/ServicesEndPoint/OrderB2B'" --data '
{"order": {
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
}'
```

&nbsp;

# Status

12/02/2003 - runs, messaging is a TODO.

&nbsp;
