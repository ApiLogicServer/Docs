---
title: API Logic Server
Description: Instantly Create and Run Database Projects - GenAI, Flask, APIs, SQLAlchemy, React Apps, Rules, Low-Code, Python, Docker, Azure, Web Apps, Microservice
---
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>


&nbsp;

!!! pied-piper ":robot: Welcome to GenAI-Logic"

    API Logic Server creates governed microservices — JSON:API, Admin App, and declarative business logic — from an existing database or a natural language prompt, in one command.  It also provides runtime services for data access, api execution, logic enforcement, etc.
    
    If this is your first API Logic Server project, this page provides some key background — why it's built this way, and how to get productive fast.  For the full picture, see [genai-logic.com](https://www.genai-logic.com){:target="_blank" rel="noopener"}.

---

## Getting Started

**1. Install**

```bash
mkdir genai-logic && cd genai-logic
python3 -m venv venv && source venv/bin/activate   # windows: venv\Scripts\activate
pip install ApiLogicServer
genai-logic start                                   # opens the Manager
```

See [Express Install](Install-Express.md) for details, including Docker and Codespaces options.  The `start` commands loads the Manager:

![Manager](images/manager/readme.png)

&nbsp;

**2. Tour — AI-Guided, Hands-On (30–45 min)**

The Manager opens automatically and walks you through creating `basic_demo`.  Inside the project, say to your AI assistant:

> *"Guide me through basic_demo"*

This is a hands-on tour covering API creation, declarative rules, security, and Python customization.  The AI acts as a knowledgeable colleague — running commands, explaining what happens, answering questions.  Scripts ensure no coding errors.  This is the recommended starting point.

&nbsp;

**3. Samples**

The [Manager](Manager.md) provides a full sample catalog, each illustrating key patterns.  Each project is AI-enabled — ask your AI assistant how it works.

![training](images/manager/Manager-Training.png)

---

## Why It's Built This Way

AI delivers remarkable agility — creating APIs, logic, and systems from natural language.  The problem is correctness: AI generates logic path by path, and paths get missed.  **Rules** solve this structurally, enforced by a Rules Engine that governs every transaction at commit time.

<details markdown>

<summary>How the Rules Engine addresses both core problems</summary>

**1. Path-independent rules — automatic reuse**

AI generates procedural code that embeds logic in execution paths.  Change a requirement, and you must find and update every path that implements it.  Rules are different: they express *what* must be true on the data, not *how* you got there.  A rule declared once is reused automatically across every source, present and future.

The Rules Engine hooks into the ORM commit.  Every transaction — API call, agent action, workflow, UI update, bulk import — passes through the same commit gate.  There is no path that bypasses governance.  Add a new endpoint or agent tomorrow, and it inherits the rules automatically.

**2. Deterministic ordering — no subtle bugs**

Multi-table logic has dependencies.  When an Item quantity changes, the Order total must recompute before the Customer balance, which must recompute before the credit check fires.  Get the order wrong and results are silently incorrect.  The Rule Engine determines execution order automatically from the declared dependencies — no hand-coding, no ordering bugs.

![Logic Architecture](images/logic/logic-arch.png)

</details>

**Rules** replace procedural logic with declarations that express intent directly:

```python
    Rule.constraint(validate=models.Customer, as_condition=lambda row: row.balance <= row.credit_limit, error_msg="Customer balance exceeds credit limit")                    
    Rule.sum(derive=models.Customer.balance, as_sum_of=models.Order.amount_total, where=lambda row: row.date_shipped is None)    
    Rule.sum(derive=models.Order.amount_total, as_sum_of=models.Item.amount)
    Rule.formula(derive=models.Item.amount, as_expression=lambda row: row.quantity * row.unit_price)
    Rule.copy(derive=models.Item.unit_price, from_parent=models.Product.unit_price)
```

These five rules replace over 200 lines of procedural code — a 40X reduction — and they fire automatically, in the right order, from every transaction source.  See [Logic: Why](Logic-Why.md) for a detailed walkthrough.

---

## Standard Tools Throughout

Your IDE, your debugger, your source control — all work normally.  Rules live in your project as plain Python files, committed to git like everything else.  The stack is Python, Flask, SQLAlchemy, and Docker.  Deployment is standard containers.  Works with MySQL, Postgres, SQL Server, Oracle, and SQLite.  Nothing proprietary, nothing to unlearn.

<details markdown>

<summary>AI as colleague, not gatekeeper — see it in action</summary>

![AI Log Analysis](images/logic/log-analysis.png)

A developer panics: *"help! my project failed!!"*

The AI reads the log, understands the rules, and responds calmly:

> *"Your server is healthy — all APIs are responding.  This is your credit limit constraint working correctly.  Someone tried to set Item quantity → 14,444.  That would make Customer[Alice]'s balance → $1,299,960, exceeding her $5,000 credit limit.  The rule correctly blocked it with a 400 response."*

The AI isn't reading generated spaghetti.  It's reading the same rules you wrote — the same rules that appear in the logic log, the same rules a business analyst can read.  Everyone is looking at the same thing.

The thousands of lines of Context Engineering built into every project mean your AI assistant can explain behavior, diagnose problems, generate new rules, and create tests — without you having to explain the codebase first.

</details>

---

## Not a Code Generator

If you've been burned by code generators — thousands of lines of output nobody owns and everyone fears to touch — this is different.

Rules **preserve design intent**.  The rule and the requirement are the same thing.  When something breaks, you read the rule — 40X fewer lines than the procedural equivalent.  When the business requirement changes, you change the rule.  The engine handles the rest.

For how the pieces fit together, see [Architecture](Architecture-What-Is.md).  For the detailed case for declarative rules over procedural code, see [Logic: Why](Logic-Why.md).

---

*Questions?  Email [apilogicserver@gmail.com](mailto:apilogicserver@gmail.com) or join us on [Discord](https://discord.gg/HcGxbBsgRF).*
