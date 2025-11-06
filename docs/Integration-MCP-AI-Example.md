!!! pied-piper ":bulb: TL;DR - MCP via AI"

    This tutorial shows how **Copilot**, using the **Model Context Protocol (MCP)**, can discover and interact with your **GenAI-Logic (aka API Logic Server)** projects.
    
    To create this system:

    1. Create a Project from an existing database
    2. Use Copliot to add Natural Language Logic
    3. Use Copilot to test the MCP/API-enabled logic


![Declarative logic in action](images/integration/mcp/Integration-MCP-AI-Example.png)

## 🥇 Step 1 – Create a Project from an Existing Database
Use the **GenAI-Logic CLI** to instantly create an application — complete with Admin App, API, and MCP discovery.
```bash
genai-logic create --project_name=basic_demo --db_url=sqlite:///sample_ai.sqlite
```
This command:

* Creates a new project folder (`basic_demo`)
* Generates a full **JSON:API** with auto-discovered tables (Customer, Order, Item, Product)
* Builds a **React Admin App** for instant data access
* Exposes **MCP metadata** at `/.well-known/mcp.json`, enabling Copilot or ChatGPT to automatically discover the schema and usage patterns  
✅ **Result:** a working three-tier system in under a minute — *database → API → web app → MCP discovery*.

## 🧠 Step 2 – Use Copilot to Add Business Logic
Copilot reads the MCP schema and responds to a natural-language instruction such as:
> “Add a credit-limit rule: a customer’s balance must not exceed their credit limit.”

It then inserts the following rules into `logic/declare_logic.py`:
```python
Rule.constraint(validate=Customer, as_condition=lambda row: row.balance <= row.credit_limit)
Rule.sum(derive=Customer.balance, as_sum_of=Order.amount_total)
Rule.sum(derive=Order.amount_total, as_sum_of=Item.amount)
Rule.formula(derive=Item.amount, as_expression=lambda row: row.quantity * row.unit_price)
Rule.copy(derive=Item.unit_price, from_parent=Product)
```
These **five declarative lines** replace hundreds of lines of procedural code, automatically providing:

* Credit-limit validation  
* Multi-table derivations  
* Cascading updates  
* Unit-price propagation  

All enforced by the **LogicBank** engine during each API transaction.

## 🧪 Step 3 – Use Copilot to Test the API and Logic
Copilot can now test the new rule using the MCP-discovered API — no manual coding required.
> “Update Alice’s order so that the quantity of item 2 is 100.”

Copilot constructs and issues this JSON:API request:
```bash
curl -X PATCH http://localhost:5656/api/Item/2   -H "Content-Type: application/vnd.api+json"   -d '{"data": {"type": "Item", "id": "2", "attributes": {"quantity": 100}}}'
```

### ⚡ Automatic Cascade of Logic
| Trigger | Effect |
|----------|---------|
| `Item.quantity` | Recalculates `Item.amount` |
| `Item.amount` | Updates `Order.amount_total` |
| `Order.amount_total` | Updates `Customer.balance` |
| `Customer.balance` | Fires credit-limit constraint |

**Outcome:** The logic engine detects that Alice’s balance would exceed her credit limit and **rejects the transaction automatically**.

### 🧩 Runtime Trace
```
.Item[2] {update}
.Order[2] {update – Adjusting order.amount_total}
.Customer[1] {update – Adjusting customer.balance}
.Customer[1] {Constraint Failure: Customer balance > credit limit}
```
![VS Code logic trace](Nat-Lang-Update.png)

### 💬 Copilot’s Response
> ✅ *Business logic working correctly!*  
> 🚫 *Update prevented automatically to enforce credit limit.*

Copilot used MCP to discover the schema, executed the update, and interpreted the deterministic response — proof that **AI + Logic collaboration** can be both natural and reliable.

## 🧱 Architecture Summary
| Layer | Role | Description |
|-------|------|-------------|
| **Database** | Existing model | e.g. `sample_ai.sqlite` |
| **GenAI-Logic** | Auto-generated API + Logic runtime | Declarative rules via LogicBank |
| **MCP** | Discovery protocol | Enables AI to understand and safely invoke APIs |
| **Copilot** | Natural-language interface | Adds and tests business logic |

## 🔁 Connecting to MCP Integration
This example continues the flow described in [**MCP Integration**](../Integration-MCP/): 

* **MCP Server Executors** = your logic-enabled APIs  
* **MCP Client Executors** = AI agents like Copilot that translate NL requests into Tool Context Blocks  
* **Declarative Logic** ensures every AI-driven transaction remains safe and auditable  

## 📚 Related Docs

* [Integration: MCP](../Integration-MCP/)  
* [Logic: Rule Types](../Logic/)  
* [Sample: Basic Demo](../Sample-Basic-Demo/)  
* [Probabilistic and Deterministic Logic](../Tech-Prob-Deterministic/)  

_This example illustrates the **Business Logic Agent** pattern — Copilot supplies intent, GenAI-Logic guarantees deterministic execution._
