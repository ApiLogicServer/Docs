!!! pied-piper ":bulb: TL;DR - use Swagger to configure API"

    Multi-Table APIs can be configured using the `include` argument in the API call, and tested in Swagger.

&nbsp;

## Best Practices

### Swagger

Provider-defined APIs are configured by the API caller - the client application.  It's usually best to test these before testing your client app by using the created **Swagger**.  Note it provides the ability to copy the URL to paste into your app.

You may find it helpful to copy the json response to a json formatter, such as [jsonformatter](https://jsonformatter.curiousconcept.com){:target="_blank" rel="noopener"} or [jsongrid](https://jsongrid.com/json-grid){:target="_blank" rel="noopener"}.

### Disable Security

It also makes things simpler if you temporarily disable security (unless that's what you are testing!).  Created projects include Run Configurations for this.

&nbsp;

## Use `include` for related data

The `include` argument enables you to specify what related data is returned.  For example, in the [sample northwind database](Sample-Database.md), you can obtain a Customer, their Orders, the OrderDetails, and the Product Data like this:

```bash
curl -X GET "http://localhost:5656/api/Customer/ALFKI/?\
include=OrderList%2COrderList.OrderDetailList%2COrderList.OrderDetailList.Product&\
fields%5BCustomer%5D=Id%2CCompanyName%2CContactName%2CContactTitle%2CAddress%2CCity%2CRegion%2CPostalCode%2CCountry%2CPhone%2CFax%2CBalance%2CCreditLimit%2COrderCount%2CUnpaidOrderCount%2CClient_id" \
  -H 'accept: application/vnd.api+json' \
  -H 'Content-Type: application/vnd.api+json'
```

Note the `include` argument, repeated here with commas:

```
include=OrderList,OrderList.OrderDetailList,OrderList.OrderDetailList.Product
```

These terms are the Parent / Child Relationship names, from your data model.  Note they support multi-level navigations, such as `OrderList.OrderDetailList`.  For more on [relationship names, click here](Data-Model-Classes.md#relationship-names).

To explore the resultant json, [click here](https://github.com/ApiLogicServer/tutorial/tree/main/3.%20Logic/api/multi-table-example){:target="_blank" rel="noopener"}.





