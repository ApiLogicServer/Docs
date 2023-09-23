**Under Construction - Preview**

[**See this page**](../Tech-AI-sqlite){:target="_blank" rel="noopener"} for information on issues deploying a single-container sqlite version.

!!! pied-piper ":bulb: TL;DR - Working Software, Now"

      Agile correctly advises getting **Working Software as fast as possible, to faciliate Business User Collaboration and Iteration**.  Using AI and API Logic Server helps you achieve this:

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

## Pre-reqs

You will need to:

* Install API Logic Server (and Python)

* Install docker 

* A GitHub account (though you can use ours for this demo)

* An Azure account

&nbsp;

## 1. ChatGPT Database Generation

&nbsp;

### Obtain the sql

Use ChapGPT to generate SQL commands for database creation:

!!! pied-piper "Create database definitions from ChatGPT"

    Create a sqlite database for customers, orders, items and product, with autonum keys and Decimal types.  

    Create a few rows of customer and product data.

    Enforce the following logic:

    1. Customer.Balance <= CreditLimit

    2. Customer.Balance = Sum(Order.AmountTotal where unshipped)

    3. Order.AmountTotal = Sum(Items.Amount)

    4. Items.Amount = Quantity * UnitPrice

    5. Items.UnitPrice = copy from Product


Copy the generated SQL commands into a file, say, `ai_customer_orders.sql`:

```sql
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT,
    LastName TEXT,
    Email TEXT,
    CreditLimit DECIMAL(10, 2),
    Balance DECIMAL(10, 2) DEFAULT 0.0
);

CREATE TABLE IF NOT EXISTS Products (
    ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProductName TEXT,
    UnitPrice DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerID INTEGER,
    OrderDate DATE,
    ShipDate DATE,
    AmountTotal DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE IF NOT EXISTS Items (
    ItemID INTEGER PRIMARY KEY AUTOINCREMENT,
    OrderID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    UnitPrice DECIMAL(10, 2),
    Amount DECIMAL(10, 2),
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

&nbsp;

### Add Security

In a terminal window for your project:

```bash
ApiLogicServer add-auth --project_name=. --db_url=authdb
```

&nbsp;

### Create the image

In a terminal window for your project:

```bash
sh devops/docker-image/build_image.sh .
```
&nbsp;

#### Test your Image

You can test the image in single container mode: `sh devops/docker-image/run_image.sh`.

&nbsp;

#### Upload Image (optional)

You would next upload the image to docker hub.  

> If you use the same names as here, skip that, and use our image: `apilogicserver/aicustomerorders`.

&nbsp;

### Push the project

It's also a good time to push your project to git.  Again, if you've used the same names as here, you can [use our project](https://github.com/ApiLogicServer/ApiLogicServer-src).

&nbsp;

## 3. Deploy for Collaboration

API Logic Server also creates scripts for deployment.

Login to the azure portal, and:

```bash
git clone https://github.com/ApiLogicServer/ai_customer_orders.git
cd ai_customer_orders
sh devops/docker-compose-dev-azure/azure-deploy.sh
```

&nbsp;

## 4. Iterate with Logic

!!! pied-piper "Logic Design ('Cocktail Napkin Design')"

    1. Customer.Balance <= CreditLimit

    2. Customer.Balance = Sum(Order.AmountTotal where unshipped)

    3. Order.AmountTotal = Sum(Items.Amount)

    4. Items.Amount = Quantity * UnitPrice

    5. Items.UnitPrice = copy from Product


Rules are an executable design.  Use your IDE (code completion, etc), to replace 280 lines of code with these 5 rules:

```python
    Rule.constraint(validate=models.Customer,       # logic design translates directly into rules
        as_condition=lambda row: row.Balance <= row.CreditLimit,
        error_msg="balance ({round(row.Balance, 2)}) exceeds credit ({round(row.CreditLimit, 2)})")

    Rule.sum(derive=models.Customer.Balance,        # adjust iff AmountTotal or ShippedDate or CustomerID changes
        as_sum_of=models.Order.AmountTotal,
        where=lambda row: row.ShipDate is None)  # adjusts - *not* a sql select sum...

    Rule.sum(derive=models.Order.AmountTotal,       # adjust iff Amount or OrderID changes
        as_sum_of=models.OrderItem.Amount)

    Rule.formula(derive=models.OrderItem.Amount,  # compute price * qty
        as_expression=lambda row: row.ItemPrice * row.Quantity)

    Rule.copy(derive=models.OrderItem.ItemPrice,  # get Product Price (e,g., on insert, or ProductId change)
        from_parent=models.Product.UnitPrice)
```

## Appendices

### Sqlite and persistence

For information on database and directory creation, [click here](../DevOps-Container-Configuration/#database-locations){:target="_blank" rel="noopener"}.  Since the database is stored and accessed in the container, cloud changes are not persisted over runs.  This is useful for demo systems where each run starts with fresh data.

An option for cloud sqlite persistence is under investigation.  Preliminary thoughts:

* Update the project to use [blob storage](https://pypi.org/project/azure-storage-blob/){:target="_blank" rel="noopener"}
* On Server start, **restore** the database from blob storage to the image
* On Server Exit, [use `atexit`](https://betterprogramming.pub/create-exit-handlers-for-your-python-appl-bc279e796b6b){:target="_blank" rel="noopener"} to **save** the database from the image to blob storage

You can use a database such as MySQL or Postgres, a [described here](..DevOps-Containers-Deploy-Multi/){:target="_blank" rel="noopener"}.