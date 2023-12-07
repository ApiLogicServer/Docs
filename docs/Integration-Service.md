!!! pied-piper ":bulb: TL;DR - IntegrationService: Map, Alias, Lookups"

    `IntegrationService` is a system-supplied class that provides methods to convert between SQLAlchemy `rows` and `Dict`.

    Services include selecting columns / related data, providing aliases, and Lookups

## Overview

`OrderB2B` is an `IntegrationService` Class that defines a `dict` structure, with the 2 conversion methods shown.

![overview](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/integration-service.jpg?raw=true)

&nbsp;

## Declaring an Integration Service

This is the definition of an `IntegrationService` called `OrderB2B`.  It defines the *shape* of orders received from business partners.  Notes:

1. `fields` designates a subset of the attributes
2. Several attributes are **aliased**, such as `Quantity` as `QuantityOrdered` (around line 27).
3. It also chooses `related` data, such as the `Items`, with a nested `IntegrationService`
4. It defines the subset of attributes used for **Lookups**
    * Our data model defines the foreign key as `ProductId`
    * But our partners do not know these; they refer to them as `ProductName`
    * So, a lookup enables them to provide a `ProductName`; the `IntegrationService` converts these into a  `ProductId`

![declaring int svc](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/OrderB2B.jpg?raw=true)

&nbsp;

## `dict_to_row`

This custom resource uses `dict_to_row` to convert the request data into SQLAlchemy objects, and saves them.  This runs the transaction logic (e.g., check credit, reorder Products).

![dict to row](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/dict-to-row.jpg?raw=true)

&nbsp;

## `row_to_dict`

Part of the business logic needs to convert orders into messages, formatted per Shipping specifications.  The `after_flush` event uses `row_to_dict` to automate this conversion.

![row-to-dict](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/row-to-dict.jpg?raw=true)