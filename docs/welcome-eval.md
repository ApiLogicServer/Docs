# Welcome Evaluators

## Quick Start: What GenAI-Logic Does

**Two prompts demonstrate the system:**
- Prompt 1 = Infrastructure generation (fast, commodity)
- **Prompt 2 = Declarative business logic (where differentiation lies)**

### Prompt 1: Create Infrastructure (5 seconds)
```bash
genai-logic create --project_name=basic_demo --db_url=sqlite:///samples/dbs/basic_demo.sqlite
```

**Result:** Complete, production-ready microservice in ~5 seconds:

- Working JSON:API server with filtering, pagination, sorting
- Admin UI for data management at `/admin-app`
- SQLAlchemy models auto-generated from your database
- Container-ready for deployment (Docker/Kubernetes)
- Ready to run immediately

**This is commodity** - infrastructure generation. The differentiation is in Prompt 2...

### Prompt 2: Declarative Business Logic
```text
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

**Result:** Declarative rules that create equivalent of **200+ lines of procedural code**

**This is the strategic value:**
- Multi-table derivations (chain up from Item → Order → Customer)
- Constraints with commit-time enforcement (credit limit check)
- Automatic dependency resolution (change any parent, all children react)
- Probabilistic logic integration (AI sets optimal supplier)
- Event-driven integration (Kafka on state change)

**Want to understand the 200+ lines claim?** The comparison is documented with actual code examples.

&nbsp;

## Want to Know More?

**Your AI assistant is your guide.** Ask it questions using the evaluation resources:

➡️ **See it working:** [Integration-MCP-AI-Example](https://apilogicserver.github.io/Docs/Integration-MCP-AI-Example/)  
➡️ **Complete reference:** [Eval-copilot-instructions](https://apilogicserver.github.io/Docs/Eval-copilot-instructions/)  
➡️ **Logic patterns:** [Eval-logic_bank_api](https://apilogicserver.github.io/Docs/Eval-logic_bank_api/)

**Example questions for your AI:**
- "How do the 9 transaction paths work?"
- "Is this locked-in or open source?"
- "How does this work with vibe UIs?"
- "What's the learning curve?"
- "Show me the 200+ lines comparison"

**Or just try it:** [Install-Express](https://apilogicserver.github.io/Docs/Install-Express/)

---

**Published:** https://apilogicserver.github.io/Docs/welcome-eval/
