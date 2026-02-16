*[parent]: One side of a one-to-many relationship (e.g., Customer for Orders)
*[Parent]: One side of a one-to-many relationship (e.g., Customer for Orders)
*[child]: Many side of a one-to-many relationship (e.g., Orders for Customer)
*[Child]: Many side of a one-to-many relationship (e.g., Orders for Customer)
*[lookup]: User Interface to get list of parent rows, select one, and fill child Foreign Key (e.g. Lookup Product for OrderDetail)
*[Lookup]: User Interface to get list of parent rows, select one, and fill child Foreign Key (e.g. Lookup Product for OrderDetail)
*[Lookups]: User Interface to get list of parent rows, select one, and fill child Foreign Key (e.g. Lookup Product for OrderDetail)
*[lookups]: User Interface to get list of parent rows, select one, and fill child Foreign Key (e.g. Lookup Product for OrderDetail)
*[Foreign Key]: one or more fields in child rows that identify a parent row (e.g., OrderDetail.ProductId identifies a Product)
*[foreign key]: one or more fields in child rows that identify a parent row (e.g., OrderDetail.ProductId identifies a Product)
*[Multi-Page]: Applications providing multiple pages, e.g. a Customer Page and an Order Page, with filtering, pagination and sorting
*[Multi-page]: Applications providing multiple pages, e.g. a Customer Page and an Order Page, with filtering, pagination and sorting
*[multi-page]: Applications providing multiple pages, e.g. a Customer Page and an Order Page, with filtering, pagination and sorting
*[Multi-Table]: Backend logic covering multiple tables, e.g., adding an Order adjusts the Customers' balance and checks the credit limit.  Also, frontend application forms displaying multiple table, e.g., an Order with a (Parent) Sales Rep, and (children) OrderDetails;  Tab sheets for related data, lookups, automatic joins. 
*[Multi-table]: Backend logic covering multiple tables, e.g., adding an Order adjusts the Customers' balance and checks the credit limit.  Also, frontend application forms displaying multiple table, e.g., an Order with a (Parent) Sales Rep, and (children) OrderDetails;  Tab sheets for related data, lookups, automatic joins. 
*[multi-table]: Backend logic covering multiple tables, e.g., adding an Order adjusts the Customers' balance and checks the credit limit.  Also, frontend application forms displaying multiple table, e.g., an Order with a (Parent) Sales Rep, and (children) OrderDetails;  Tab sheets for related data, lookups, automatic joins.  
*[Declarative Hide/Show]: Support for Application fields that are displayed/hidden based on an expression for the current row declared in the Admin.yaml file
*[Automatic Joins]: Automatically joined parent data, e.g., the ProductName (instead of the ProductId) for OrderDetails; these defaults can be overridden in the Admin.yaml file
*[Automatic joins]: Automatically joined parent data, e.g., the ProductName (instead of the ProductId) for OrderDetails; these defaults can be overridden in the Admin.yaml file
*[automatic joins]: Automatically joined parent data, e.g., the ProductName (instead of the ProductId) for OrderDetails; these defaults can be overridden in the Admin.yaml file
*[Page Transitions]: form controls that enable users to navigate to forms for related data, e.g., from a Customer/Orders page to an Order/OrderDetails page
*[Page transitions]: form controls that enable users to navigate to forms for related data, e.g., from a Customer/Orders page to an Order/OrderDetails page
*[Cascade Add]: support for adding child rows (e.g., OrderDetails) after adding a parent row (e.g., Order)
*[Pagination]: support to show large lists of rows in page-size sets, to reduce database overhead and unwieldly pages
*[pagination]: support to show large lists of rows in page-size sets, to reduce database overhead and unwieldly pages
*[Declarative]: specifications that dictate _what_ should be done, instead of detailed that is _how_ the feature is provided.  Declarative specifications are much more concise, automatically ordered, automamatically optimized and automatically invoked (re-used).  Declarative specifications can be used for client, API and logic behavior
*[declarative]: specifications that dictate _what_ should be done, instead of detailed that is _how_ the feature is provided.  Declarative specifications are much more concise, automatically ordered, automamatically optimized and automatically invoked (re-used).  Declarative specifications can be used for client, API and logic behavior
*[Business Logic]: multi-table constraints and derivations, e.g., the Customer Balance may not exceed the CreditLimit, and is derived as the sum of unshipped Order AmountTotals.
*[business logic]: multi-table constraints and derivations, e.g., the Customer Balance may not exceed the CreditLimit, and is derived as the sum of unshipped Order AmountTotals.
*[ORM]: Object Relational Manager - dev-friendly sql access, such as row objects (e.g., SQLAlchemy)
*[orm]: Object Relational Manager - dev-friendly sql access, such as row objects (e.g., SQLAlchemy)
*[Codespaces]: a Github product that creates complete cloud-based dev environments for containerized Github projects, including Browser-based IDE development.
*[docker account]: create using your browser at hub.docker.com
*[docker repository]: can can be downloaded (pulled) to create a docker image on your local computer
*[docker image]: created from a docker repository, a set of local files that can be run as a docker container
*[Docker image]: created from a docker repository, a set of local files that can be run as a docker container
*[docker container]: a running image
*[Docker container]: a running image
*[Authentication]: a login function that confirms a user has access, usually by posting credentials and obtaining a token identifying the users' roles.
*[Authorization]: controlling access to row/columns based on assigned roles.
*[Role]: in security, users are assigned one or many roles.  Roles are authorized for access to data, potentially down to the row/column level.
*[Authentication-Provider]: Developer-supplied Class that, given a id/password, authenticates a user and returns the list of authorized roles (on None).  Invoked by the system when client apps log in.
*[Domain Specific Language]: A language focused on a specific domain (e.g., logic), providing speed and transparency by using a high-level declarative approach to specify behavior.
*[domain specific language]: A language focused on a specific domain (e.g., logic, SQL), providing speed and transparency by using a high-level declarative approach to specify behavior.
*[DSL]: A Domain Specific Language focuses on a specific domain (e.g., logic, SQL), providing speed and transparency by using a high-level declarative approach to specify behavior.
*[self-serve]: Instead of relying on custom server development, UI developers can use Swagger to formulate requests for filtering, sorting, and multi-table data content.
*[Self-Serve]: Instead of relying on custom server development, UI developers can use Swagger to formulate requests for filtering, sorting, and multi-table data content.
*[Self-serve]: Instead of relying on custom server development, UI developers can use Swagger to formulate requests for filtering, sorting, and multi-table data content.
*[ad hoc integration]: Self-serve APIs support unplanned integrations - authorized users can retrieve the attributes and related data they want, without custom server development
*[ad hoc integrations]: Self-serve APIs support unplanned integrations - authorized users can retrieve the attributes and related data they want, without custom server development
*[Ad Doc Integration]: Self-serve APIs support unplanned integrations - authorized users can retrieve the attributes and related data they want, without custom server development
*[ETL]: A traditional application integration approach - nightly Extract runs to obtain data, Transfer it to other systems, and Load it for local access.
*[API Automation]: Create JSON:APIs with 1 command - self-serve (analogous to GraphQL), with pagination, optimistic locking, filtering, sorting, and related data access.
*[Logic Automation]: Declare logic with spreadsheet-like Rules that are 40X more concise than code for multi-table derivations and constraints; add Python as required.
*[Maintenance Automation]: Rules are automatically re-ordered based on dependencies, and re-used over all relevant transactions.
*[App Automation]: Create Admin Apps automatically - multi-page, multi-table.
*[Microservice Automation]: Creation of customizable, executable projects with a single command, providing App Automation, API Automation and Logic Automation.
*[Deployment Automation]: Scripts automatically created to containerize your project, and deploy to Azure.
*[optimistic locking]: ensuring that updates do not overwrite changes made by others, by checking that the data has not changed since the user last read it; ideally done with a checksum so that no schema changes are required.
*[microservice]: self-contained, independently deployable, and scalable services that can be combined to create a larger application, with each service running in its own process and communicating with lightweight mechanisms, often an HTTP resource API.  Often provide an API, Logic, Data and UI.
*[Microservice]: self-contained, independently deployable, and scalable services that can be combined to create a larger application, with each service running in its own process and communicating with lightweight mechanisms, often an HTTP resource API.  Often provide an API, Logic, Data and UI.
*[Maintenance Automation]: rules are automatically invoked across insert/delete/update stories, automatically ordered per dependencies, and automatically chain to manage complexity.
*[maintenance automation]: rules are automatically invoked across insert/delete/update stories, automatically ordered per dependencies, and automatically chain to manage complexity.
*[Automatic Dependency Management]: declarative logic is 1) Automatically Executed when referenced data is changed, 2) in the proper order.  This reduces code by 40X, promotes quality, and automates maintenance.
*[dependency management]: declarative logic is 1) Automatically Executed when referenced data is changed, 2) in the proper order.  This reduces code by 40X, promotes quality, and automates maintenance.
*[MCP]: Model Context Protocol enables Business Users to use Natural Language to create multi-step execution flows across existing business-rule-enforced APIs.
*[Archaeology]: Maintenance of Procedural code requires extensive "archaeology" to understand dependencies to make changes; in Declarative code, dependency, ordering and chaining are automatic.
*[archaeology]: Maintenance of Procedural code requires extensive "archaeology" to understand dependencies to make changes; in Declarative code, dependency, ordering and chaining are automatic.