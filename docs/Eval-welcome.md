# Welcome Evaluators

## Quick Start: What GenAI-Logic Does

**Two prompts demonstrate the system:**

#### Prompt 1: Create Infrastructure (5 seconds)
```bash
genai-logic create --project_name=basic_demo --db_url=sqlite:///samples/dbs/basic_demo.sqlite
```

**Result:** Complete microservice - API, Admin UI, models, Docker-ready

---

#### Prompt 2: Declarative Business Logic
```
On Placing Orders, Check Credit:
1. The Customer's balance is less than the credit limit
2. The Customer's balance is the sum of the Order amount_total where date_shipped is null
3. The Order's amount_total is the sum of the Item amount
4. The Item amount is the quantity * unit_price
5. The Product count suppliers is the sum of the Product Suppliers
6. Use AI to Set Item field unit_price by finding the optimal Product Supplier 
   based on cost, lead time, and world conditions

Use case: App Integration
1. Send the Order to Kafka topic 'order_shipping' if the date_shipped is not None.
```

**Result:** Declarative rules = 200+ lines of procedural code

Multi-table derivations, constraints, automatic cascading, probabilistic logic (AI), event integration.

---

**I have some key concepts you'll probably want to explore.**

**Just ask.**

---

**Published:** https://apilogicserver.github.io/Docs/welcome-eval/
