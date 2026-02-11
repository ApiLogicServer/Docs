---
title: MCP AI Example
notes: gold source is docs
source: docs/Integration-MCP-AI-Example.md
do_process_code_block_titles: True
version: 0.3, for readme 2/8/2026
---
<style>
  -typeset h1,
  -content__button {
    display: none;
  }
</style>

!!! pied-piper "TL;DR - Integrated Deterministic and AI Rules"
    ## 
    **Prompt 1 (Create System):**

    *Create a system named basic_demo from samples/dbs/basic_demo.sqlite*

    **Prompt 2 (Add NL Logic):**

    *On Placing Orders, Check Credit:*<br>

    *1. The Customer's balance is less than the credit limit*<br>
    *2. The Customer's balance is the sum of the Order amount_total where date_shipped is null*<br>
    *3. The Order's amount_total is the sum of the Item amount*<br>
    *4. The Item amount is the quantity * unit_price*<br>
    *5. The Product count suppliers is the sum of the Product Suppliers*<br>
    *6. __Use AI__ to Set Item field unit_price by finding the optimal Product Supplier based on cost, lead time, and world conditions*

    *Use case: App Integration*

    *1. Send the Order to Kafka topic 'order_shipping' if the date_shipped is not None.*<br><br>

    (Developers review this DSL before execution, providing a natural human-in-the-loop checkpoint.)


    Test in the Browser, verify the AI Audit

&nbsp;


## A Unified Model for Governable Creativity

AI also provides creativity and reasoning that businesses want... how do we provide that, *with goverance?*. 

For example - a business can continue to operate even if a tanker has blocked the Suez canal by choosing a supplier:

```bash title="Step 1. Create a new project (e.g., from the Manager)"
genai-logic create --project_name=basic_demo_ai_rules --db_url=sqlite:///samples/dbs/basic_demo.sqlite
```

```bash title="Step 2. Open the project; provide Copilot prompt for deterministic and probabilistic logic (rule 6)"
Bootstrap Coplilot, and
Paste the logic above into your Copilot chat
```

<br>

<details markdown>

<summary>Unified Deterministic and Probabilistic Logic</summary>

<br>Enterprises want the best of both: the creativity of probabalistic logic, *with* the governability of deterministic logic -- all in one unified Business Logic Agent.  Here's an example, and we then generalize.

<br>

<details markdown>

<summary>A. Example: Choose Supplier, based on current world conditions</summary>

Agentic systems are evolving quickly, and a clearer architectural picture is forming:

> Not AI *vs* Rules — **AI and Rules together.**

Different kinds of logic naturally call for different tools, as in this unified example:

* **Deterministic Logic** — logic that must always be correct, consistent, and governed.  
*Example:* “Customer balance must not exceed credit limit.”

* **AI Logic** — logic that benefits from exploration, adaptation, and probabilistic reasoning.  
*Example:* “Which supplier can still deliver if shipping lanes are disrupted?”


    * **Creative reasoning needs boundaries.<br>Deterministic rules supply the guardrails that keep outcomes correct, consistent, and governed.**


And then, test via MCP-discovered API:**  *Constraint blocks bad data*: ️
```bash title='Test Logic with MCP Discovery'
On Alice's first order, include 100 Egyptian Cotton Sheets
```

<details markdown>

<summary>Data Model, including AI Audit Trail</summary>

<br> 

![basic_demo_data_model](images/basic_demo/basic_demo_data_model.png)

</details>

</details>

<br>

<details markdown>

<summary>B. The Business Logic Agent</summary>

<br> **The Business Logic Agent** processes a *declarative NL requests:*

- At declaration time (e.g., in Copilot):

    * **D1:** Accepts a unified declarative NL request
    * **D2.** Uses GenAI to create
        * Rules (in Python DSL: Domain Specific Logic) for deterministic Logic
        * LLM calls for Probablistic

- At runtime

    * **R1:** DSL is executed by the Rules Engine (deterministic - no NL pocessing occurs)
    * **R2:** LLM calls

![Bus-Logic-Engine](images/integration/mcp/Bus-Logic-Agent.png)

**Agentic systems become far more compelling when probabilistic intent is paired with deterministic enforcement.**

This "governable intent" model aligns with enterprise expectations —  
adaptive where helpful, reliable where essential.

**The Business Logic Agent unifies probabilistic intent with deterministic enforcement in a single model**

</details>

<br>

<details markdown>

<summary>C. Echoes Modern Thinking</summary>

<br>Lamanna: *"Sometimes customers don't want the model to freestyle…
They want hard-coded business rules."*
→ Exactly this hybrid: **probabilistic intent + deterministic enforcement**

> Governable AI

</details>

</details>

<br>

---

## Heads-Up: AI-Enabled Projects

<details markdown>

<summary>Copilot can help you understand, learn, and do... here's how</summary>

<br>

GenAI-Logic projects are already **AI-enabled**, meaning they come with built-in training materials (`context engineering`) that help assistants like **GitHub Copilot**, **Claude**, or **ChatGPT** understand your project context.  For more information, see [AI-Enabled Projects Overview](Project-AI-Enabled.md){:target="_blank" rel="noopener"}.

Once you’ve completed this demo, try engaging your AI assistant directly — it already knows about your project’s structure, rules, and examples.

*Understand* GenAI-Logic by **asking Copilot questions** such as:

- “Where are the declarative business rules defined?”
- “Explain how credit-limit validation works in this project.”
- “Show me how to add a new rule for discount calculation.”
- “Walk me through the AI Guided Tour.”

*Learn* about GenAI-Logic with the *AI-Guided Tour*.  **Just ask Copilot: *guide me through***.

- note: you should first delete `logic/logic_discovery/place_order/check_credit.py`)

In addition to all the things CoPilot can do natively, we've taught it about GenAI-Logic.  **Just ask Copilot: *what can you help me with?***

</details>