!!! pied-piper ":bulb: TL;DR - Instant API, Related Data, Filtering, Sorting, Pagination, Swagger"

    The `ApiLogicServer create` command creates an API Logic Project that implements your API.  No additional code is required.  **Custom App Dev is unblocked.**

    * __Endpoint for each table__, with __CRUD support__ - create, read, update and delete.

    * Filtering, sorting, pagination, including __related data access__, based on relationships in the models file (typically derived from foreign keys)

    * Automatic **Swagger**

    * Enforces **logic and security** - automatic partitioning of logic from (each) client app

    * **Add new endpoints using standard Flask and SQLAlchemy** - customize `api/customize_api.py` - 

&nbsp;

## Declare / Customize API

APIs are:

1. Declared in `api/expose_api_models.py` -- *generated* code which is typically not modified

2. Customized in `api/customize_api.py` -- see below, and next page

![API Declaration](images/api/Declare-Customize-API.png)

&nbsp;

## Automatic Swagger Generation

API creation includes automatic swagger generation.  

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/ui-admin/swagger.png?raw=true"></figure>

Start the server, and open your Browser at `localhost:5656`.  Or, explore the sample app [running at PythonAnyWhere](http://apilogicserver.pythonanywhere.com/api){:target="_blank" rel="noopener"}.

&nbsp;

## Provider-Defined vs. Consumer-Defined

!!! pied-piper ":bulb: TL;DR - Consumer-Defined APIs: __reduce network traffic__, __minimize organizational dependencies.__"

      *Provider-defined* APIs are suitable for in-house use.
      
      For external use, *Consumer-defined* APIs can __reduce network traffic__ and __minimize organizational dependencies.__

Consider 2 classes of APIs:

* ***Provider-Defined APIs*** are predefined by server developers

    *  These can be **simpler for internal users**, whose needs can be determined in advance.

> But for a wider class of consumers (e.g., business partners, or other teams in a large organization), providers typically cannot predict consumer needs.  Given only predefined provider APIs, consumers are often forced to make multiple calls to obtain the data they need, or invoke APIs that return too much data.  These can increase network traffic.

That leads to a second class of APIs such as GraphQL and [JSON:API](https://jsonapi.org){:target="_blank" rel="noopener"}:

* ***Consumer-Defined APIs*** enable clients to provide parameters for exactly the fields and related data they need

  * This can __reduce network traffic__ and __minimize organizational dependencies.__

&nbsp;

## Swagger to construct API calls

Provider-defined API calls typically have more/longer arguments.  To facilitate creating invoking APIs, use swagger to obtain the url.

  > Tip: use Swagger to debug your API parameters, then use the copy/paste services to use these in your application.

&nbsp;

## Logic Enabled

API Logic Server is so-named because all the update APIs automatically enforce your [business Logic](../Logic-Why){:target="_blank" rel="noopener"}.

  > **Key Take-away:** your API encapsulates your logic, factoring it out of APIs for greater concisenss and sharing / consistency

&nbsp;

## Examples

The [Behave Tests](../Behave){:target="_blank" rel="noopener"} provide several examples of using the API.  You can [review them here](https://github.com/valhuber/ApiLogicServer/blob/main/api_logic_server_cli/project_prototype_nw/test/api_logic_server_behave/features/steps/place_order.py).


&nbsp;

## Key Usage: custom apps

The automatic Admin App is useful, but most systems will require custom User Interfaces.  Use your favorite framework (eg, React).
