**Under Construction - Preview**

!!! pied-piper ":bulb: TL;DR - Working Software, Now"

      Agile correctly advises getting Working Software as fast as possible, to faciliate Business User Collaboration and Iteration.  Using AI and API Logic Server helps you achieve this:

      1. **Create Database With ChatGPT** 

      2. **Create *Working Software Now* with API Logic Server:**  creates an API, and Admin screens from your database

      3. **Deploy for *Collaboration* with API Logic Server:** automated cloud deployment enables collaboration:
      
         * Engage Business Users with running Admin screens - spot data model misunderstandings, and uncover logic requirements
         * Unblock UI Developers with the API

      4. **Declarative Logic Automates *Iteration:*** use [declarative rules](../Logic-Why) for logic and [security](../Security-Overview), extensible with Python as required.  Rules are a unique aspect of API Logic Server:
      
         * logic is 40X more concise, and 
         * automatically ordered per system-discovered dependencies, to facilite rapid iteration

      With API Logic Server, if you have a database, you can create and deploy for collaboration ***within hours***.

![ai-driven-automation](images/ai-driven-automation/ai-driven-automation.png)

## 1. ChatGPT Database Generation

&nbsp;

### Obtain the sql

Use ChapGPT to generate SQL commands for database creation:

!!! pied-piper "Create database definitions from ChatGPT"

    Create a sqlite database for customers, orders, items and product, with autonum keys.  

    Create a few rows of customer and product data.

    Maintain the customer's balance as the sum of the unshipped orders, and ensure it does not exceed the credit limit.  Derive items price from the product unit price.


Copy the generated SQL commands into a file, say, `ai_customer_orders.sql`:

```sql
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT,
    LastName TEXT,
    Email TEXT,
    CreditLimit REAL,
    Balance REAL DEFAULT 0.0
);

CREATE TABLE IF NOT EXISTS Products (
    ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProductName TEXT,
    UnitPrice REAL
);

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerID INTEGER,
    OrderDate DATE,
    ShipDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE IF NOT EXISTS OrderItems (
    OrderItemID INTEGER PRIMARY KEY AUTOINCREMENT,
    OrderID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    ItemPrice REAL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert customer data
INSERT INTO Customers (FirstName, LastName, Email, CreditLimit) VALUES
    ('John', 'Doe', 'john@example.com', 1000.00),
    ('Jane', 'Smith', 'jane@example.com', 1500.00);

-- Insert product data
INSERT INTO Products (ProductName, UnitPrice) VALUES
    ('Product A', 10.00),
    ('Product B', 15.00),
    ('Product C', 8.50);
```

&nbsp;

### Create the database

Sqlite is already installed in ApiLogicServer, so we avoid database installs by using it as our target database:

```bash
sqlite3 ai_customer_orders.sqlite < ai_customer_orders.sql
```

> Note: if you **use the names above**, you can save time by using the docker image and git project that we've already created.

&nbsp;

## 2. Create Working Software

Given a database, API Logic Server can create an executable, customizable project:

```bash
ApiLogicServer create --project_name=ai_customer_orders --db_url=sqlite:///ai_customer_orders.sqlite
```

This creates a project you can open with VSCode.  Establish your `venv`, and run it via the first pre-built Run Configuration.  To establish your venv:

```bash
python -m venv venv; venv\Scripts\activate     # win
python3 -m venv venv; . venv/bin/activate      # mac/linux
pip install -r requirements.txt
```

& nbsp;

## 3. Deploy for Collaboration

API Logic Server also creates scripts for deployment, as shown below:

&nbsp;

### Add Security

In a terminal window for your project:

```bash
ApiLogicServer add-auth
```

&nbsp;

### Create the image

In a terminal window for your project:

```bash
sh devops/docker-image/build_image.sh .
```
&nbsp;

#### Test

You can test the image in single container mode: `sh devops/docker-image/build_image.sh`.

You can also test the image with docker compose: `sh ./devops/docker-compose-dev-local/docker-compose.sh`.

&nbsp;

#### Upload Image (optional)

You would next upload the image to docker hub.  

> If you use the same names as here, skip that, and use our image: `apilogicserver/aicustomerorders`.

&nbsp;

### Push the project

It's also a good time to push your project to git.  Again, if you've used the same names as here, you can [use our project](https://github.com/ApiLogicServer/ApiLogicServer-src).

&nbsp;

### Deploy to Azure

> Note: This currently fails, and is under investigation.  See the Appendix below for more information.

Then, login to the azure portal, and:

```bash
git clone https://github.com/ApiLogicServer/ai_customer_orders.git
cd ai_customer_orders
sh devops/docker-compose-dev-azure/azure-deploy.sh
```

&nbsp;

## 4. Iterate with Logic

!!! pied-piper "Logic Design ('Cocktail Napkin Design')"

    Customer.Balance <= CreditLimit

    Customer.Balance = Sum(Order.AmountTotal where unshipped)

    Order.AmountTotal = Sum(OrderDetail.Amount)

    OrderDetail.Amount = Quantity * UnitPrice

    OrderDetail.UnitPrice = copy from Product


Rules are an executable design.  Use your IDE (code completion, etc), to replace 280 lines for code with these 5 rules:

> Note: the names below require correction:

```python

    Rule.constraint(validate=models.Customer,       # logic design translates directly into rules
        as_condition=lambda row: row.Balance <= row.CreditLimit,
        error_msg="balance ({round(row.Balance, 2)}) exceeds credit ({round(row.CreditLimit, 2)})")

    Rule.sum(derive=models.Customer.Balance,        # adjust iff AmountTotal or ShippedDate or CustomerID changes
        as_sum_of=models.Order.AmountTotal,
        where=lambda row: row.ShippedDate is None)  # adjusts - *not* a sql select sum...

    Rule.sum(derive=models.Order.AmountTotal,       # adjust iff Amount or OrderID changes
        as_sum_of=models.OrderDetail.Amount)

    Rule.formula(derive=models.OrderDetail.Amount,  # compute price * qty
        as_expression=lambda row: row.UnitPrice * row.Quantity)

    Rule.copy(derive=models.OrderDetail.UnitPrice,  # get Product Price (e,g., on insert, or ProductId change)
        from_parent=models.Product.UnitPrice)
```

# Appendix

## Azure Deployment

Following the first 2 steps above, I have created the git project and docker image note above.

Key facts about the application:

1. It uses flask and sqlite.  sqlite is an embedded database, so should not require a separate image.  However, azure refused to start a docker compose with just 1 service.

2. The sqlite database file is in `database/db.sqlite`

3. The generated docker compose moves this to `home/api_logic_project/database/db.sqlite`

4. You can run the container locally with:

```bash
docker run -it --name api_logic_project --rm --net dev-network -p 5656:5656 -p 5002:5002 apilogicserver/aicustomerorders
```

Then, login to the Azure portal, and:

tl;dr:

```bash
git clone https://github.com/ApiLogicServer/ai_customer_orders.git
cd ai_customer_orders
sh devops/docker-compose-dev-azure/azure-deploy.sh  # a docker compose
```

That has failed inconsistently; sometimes with 500 errors, sometimes with complaints about the docker compose.

So, I tried just a single container:

```bash
az container create --resource-group aicustomerorders_rg --name aicustomerorderscontainer --image apilogicserver/aicustomerorders:latest --dns-name-label aicustomerorderscontainer --ports 5656 --environment-variables 'VERBOSE'='True'
```

This starts, but fails with a series of console message like:

```log
10.92.0.26 - - [18/Sep/2023 22:58:28] code 400, message Bad request syntax ('\x16\x03\x01\x02\x00\x01\x00\x01ü\x03\x03èÒ\x1b.¸cqqzI0ö*j\x9fÃ\x7fv!')
10.92.0.26 - - [18/Sep/2023 22:58:28] "[31m[1m\x16\x03\x01\x02\x00\x01\x00\x01ü\x03\x03èÒ\x1b.¸cqqzI0ö*j\x9fÃ\x7fv![0m" 400 -
1
```

I also tried other alternatives:

```
az container create --resource-group myResourceGroup --name aicustomerorders_rg --image mcr.microsoft.com/azuredocs/aci-helloworld --dns-name-label aci-demo --ports 80

??
az webapp create --resource-group aicustomerorders_rg --plan myAppServicePlan --name aicustomerorders --image apilogicserver/aicustomerorders  

```

Run multi-container at [https://aicustomerorders.azurewebsites.net](https://aicustomerorders.azurewebsites.net).

Run single-container at [https://aicustomerorders.westus.azurecontainer.io:5656/api](https://aicustomerorders.westus.azurecontainer.io:5656/api).


## Azure IP address

These are not being returned as expected.  This means I need to manually supply this imformation in `ui/admin/admin.yml`.

The system is designed to replace these from the discovered IP (e.g, `http://localhost:5656/api`):

```yaml
api_root: '{http_type}://{swagger_host}:{port}/{api}'
info_toggle_checked: true
info:
  number_relationships: 13
  number_tables: 17
authentication:
  endpoint: '{http_type}://{swagger_host}:{port}/api/auth/login'
```

But, in the single container, I had to override them:

```yaml
api_root: https://aicustomerorders.westus.azurecontainer.io:5656/api
info_toggle_checked: true
info:
  number_relationships: 13
  number_tables: 17
authentication:
  endpoint: https://aicustomerorders.westus.azurecontainer.io:5656api/auth/login
```

## cURL

The API can be accessed by the admin app, or cURL:

```bash

curl -X 'GET' \
  'http://localhost:5656/api/Customer/?include=OrderList&fields%5BCustomer%5D=CustomerID%2CFirstName%2CLastName%2CEmail%2CCreditLimit%2CBalance%2C_check_sum_%2CS_CheckSum&page%5Boffset%5D=0&page%5Blimit%5D=10&sort=id' \
  -H 'accept: application/vnd.api+json' \
  -H 'Content-Type: application/vnd.api+json'

  curl -X 'GET' \
  'https://aicustomerorders.westus.azurecontainer.io:5656/api/Customer/?include=OrderList&fields%5BCustomer%5D=CustomerID%2CFirstName%2CLastName%2CEmail%2CCreditLimit%2CBalance%2C_check_sum_%2CS_CheckSum&page%5Boffset%5D=0&page%5Blimit%5D=10&sort=id' \
  -H 'accept: application/vnd.api+json' \
  -H 'Content-Type: application/vnd.api+json'

```