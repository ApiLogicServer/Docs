**Under Construction - Preview**

!!! pied-piper ":bulb: TL;DR - Use Python (code completion, named arguments) to declare behavior"

    Python works well at multiple levels:
    
    1. a **ChatGPT Database Generation** 

    2. a **ApiLogicServer Automation** for Working Software

        * API, UI

        * Project Creation, Configuration
    
    3. **DevOps Automation** 

    4. **Collaboration**

    5. **Iteration with Declarative Logic** and Python 


&nbsp;

!!! pied-piper ":bulb: TL;DR - Working Software, Now"

      Agile correctly advises getting Working Software as fast as possible, to faciliate Business User Collaboration and Iteration.  API Logic Server help you achieve this:

      1. a **ChatGPT Database Generation** 

      2. **Create Working Software *Now:*** API Logic Server creates an API, and Admin screens from your database

      3. **Publish to GitHub:** for dev team collaboration

      4. **Deploy for *Collaboration:*** automated cloud deployment enables collaboration:
      
         * Engage Business Users with running Admin screens - spot data model misunderstandings, and uncover logic requirements
         * Unblock UI Developers with the API

      5. **Iterate with *logic:*** use [declarative rules](../Logic-Why) for logic and [security](../Security-Overview), extensible with Python as required.  Rules are a unique aspect of API Logic Server:
      
         * logic is 40X more concise, and 
         * automatically ordered per system-discovered dependencies, to facilite rapid iteration

      With API Logic Server, if you have a database, you can create and deploy for collaboration ***within an hour***.

      Use the [Deployment Tutorial](../Tutorial-Deployment) to see the complete cycle of creation through deployment.  Examples are provided for MySQL and Postgres.  No install - docker databases are pre-supplied.

![ai-driven-automation](images/ai-driven-automation/ai-driven-automation.png)


## 4. Deploy for Collaboration

tl;dr:

```bash
login to portal
git clone https://github.com/ApiLogicServer/ai_customer_orders.git
cd ai_customer_orders
sh devops/docker-compose-dev-azure/azure-deploy.sh

az container create --resource-group myResourceGroup --name aicustomerorders_rg --image mcr.microsoft.com/azuredocs/aci-helloworld --dns-name-label aci-demo --ports 80

??
az webapp create --resource-group aicustomerorders_rg --plan myAppServicePlan --name aicustomerorders --image apilogicserver/aicustomerorders  

++

az container create --resource-group aicustomerorders_rg --name aicustomerorderscontainer --image apilogicserver/aicustomerorders:latest --dns-name-label aicustomerorderscontainer --ports 5656 --environment-variables 'VERBOSE'='True'

docker run -it --name api_logic_project --rm --net dev-network -p 5656:5656 -p 5002:5002 apilogicserver/aicustomerorders


ports?

```

Run multi-container at [https://aicustomerorders.azurewebsites.net](https://aicustomerorders.azurewebsites.net).

Run image at [aicustomerorders.westus.azurecontainer.io:5656](aicustomerorders.westus.azurecontainer.io:5656)

http://localhost:5656/api
https://aicustomerorders.westus.azurecontainer.io:5656/api

http://localhost:5656/api/auth/login
https://aicustomerorders.westus.azurecontainer.io:5656api/auth/login

curl -X 'GET' \
  'http://localhost:5656/api/Customer/?include=OrderList&fields%5BCustomer%5D=CustomerID%2CFirstName%2CLastName%2CEmail%2CCreditLimit%2CBalance%2C_check_sum_%2CS_CheckSum&page%5Boffset%5D=0&page%5Blimit%5D=10&sort=id' \
  -H 'accept: application/vnd.api+json' \
  -H 'Content-Type: application/vnd.api+json'

  curl -X 'GET' \
  'https://aicustomerorders.westus.azurecontainer.io:5656/api/Customer/?include=OrderList&fields%5BCustomer%5D=CustomerID%2CFirstName%2CLastName%2CEmail%2CCreditLimit%2CBalance%2C_check_sum_%2CS_CheckSum&page%5Boffset%5D=0&page%5Blimit%5D=10&sort=id' \
  -H 'accept: application/vnd.api+json' \
  -H 'Content-Type: application/vnd.api+json'

  