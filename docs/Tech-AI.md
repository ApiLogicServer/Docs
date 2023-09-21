**Under Construction - Preview**

[**See this page**](../Tech-AI-sqlite){:target="_blank" rel="noopener"} for information on issues deploying a single-container sqlite version.

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

## Pre-reqs

You will need to:

* Install API Logic Server (and Python)

* Install docker, and start the database: 

```bash
docker network create dev-network
docker run --name mysql-container --net dev-network -p 3306:3306 -d -e MYSQL_ROOT_PASSWORD=p apilogicserver/mysql8.0:latest
```

    * This is a MySQL we use for testing, simplified to store the data in the docker image to avoid managing docker volumes (useful for dev, not appropriate for production).

* A GitHub account (though you can use ours for this demo)

* An Azure account

&nbsp;

## 1. ChatGPT Database Generation

&nbsp;

### Obtain the sql

Use ChapGPT to generate SQL commands for database creation:

!!! pied-piper "Create database definitions from ChatGPT"

    Create a MySQL database for customers, orders, items and product, with autonum keys.  

    Create a few rows of customer and product data.

    Maintain the customer's balance as the sum of the unshipped orders amountotal, and ensure it does not exceed the credit limit.  Derive items price from the product unit price.


Copy the generated SQL commands into a file, say, `ai_customer_orders_mysql.sql`:

```sql
DROP DATABASE IF EXISTS ai_customer_orders;

CREATE DATABASE ai_customer_orders;

USE ai_customer_orders;

CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName TEXT,
    LastName TEXT,
    Email TEXT,
    CreditLimit DECIMAL,
    Balance DECIMAL DEFAULT 0.0
);

CREATE TABLE IF NOT EXISTS Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName TEXT,
    UnitPrice REAL
);

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INTEGER,
    AmountTotal DECIMAL,
    OrderDate DATE,
    ShipDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE IF NOT EXISTS OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    ItemPrice DECIMAL,
    Amount DECIMAL,
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
docker exec -it mysql-container bash
$ mysql -u root -p
# password is  p
# paste in the sql text to create your database
```

> Note: if you **use the names above**, you can save time by using the docker image and git project that we've already created.

&nbsp;

## 2. Create Working Software

Given a database, API Logic Server can create an executable, customizable project:

```bash
ApiLogicServer create --project_name=ai_customer_orders_mysql --db_url=mysql+pymysql://root:p@localhost:3306/ai_customer_orders
```

This creates a project you can open with VSCode.  Establish your `venv`, and run it via the first pre-built Run Configuration.  To establish your venv:

```bash
python -m venv venv; venv\Scripts\activate     # win
python3 -m venv venv; . venv/bin/activate      # mac/linux
pip install -r requirements.txt
```

&nbsp;

## 3. Deploy for Collaboration

API Logic Server also creates scripts for deployment, as shown below:

&nbsp;

### Add Security

In a terminal window for your project:

```bash
ApiLogicServer add-auth --project_name=. --db_url=mysql+pymysql://root:p@localhost:3306/authdb
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

#### Test - Multi-Container

Stop your docker database.

Test the image with docker compose: `sh ./devops/docker-compose-dev-local/docker-compose.sh`.

&nbsp;

#### Upload Image (optional)

You would next upload the image to docker hub.  

> If you use the same names as here, skip that, and use our image: `apilogicserver/aicustomerordersmysql`.

&nbsp;

### Push the project

It's also a good time to push your project to git.  Again, if you've used the same names as here, you can [use our project](https://github.com/ApiLogicServer/ApiLogicServer-src).

&nbsp;

### Deploy to Azure

Then, login to the azure portal, and:

```bash
git clone https://github.com/ApiLogicServer/ai_customer_orders_mysql.git
cd ai_customer_orders_mysql
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


Rules are an executable design.  Use your IDE (code completion, etc), to replace 280 lines of code with these 5 rules:

> Note: the names below require correction:

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
