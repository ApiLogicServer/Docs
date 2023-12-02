# Purpose

Coming Soon -- see preview.

This app illustrates using IntegrationServices for B2B integrations with APIs, and internal integration with messages.

There are 2 **transaction sources:**

1. B2B partners
2. Internal UI

The **Northwind API Logic Server** provides APIs and the underlying logic for both transaction sources:
1. API - a self-serve API, here used by UI developers to build the Order Entry UI
2. Order Logic: shared over both transaction sources, this logic

    1. Enforces database integrity (checks credit, reorders products)
    2. Provides application integration services to format an order to alert shipping with a Kafka message.  Unlike APIs, messages are lost if the receiving server (Shipping) is down

The **Shipping API Logic Server** listens on kafka, and stores the message which updates <whatever> using logic

![overview](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/overview.jpg?raw=true)

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
ApiLogicServer curl "'POST' 'http://localhost:5656/api/ServicesEndPoint/add_b2b_order'" --data '
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

12/02/2003 - runs

&nbsp;
