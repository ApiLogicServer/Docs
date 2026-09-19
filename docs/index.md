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

    GenAI-Logic turns your requirements into enterprise-class database transaction systems, governed by rules that can't be bypassed.

    And it uses your methodology, standard tools, and shared artifacts, fostering collaboration between Business Users and Developers.

    For more, see the [Introduction](Introduction.md){:target="_blank" rel="noopener"}.

---

## Your AI Assistant Already Knows This System

![AI Log Analysis](images/logic/log-analysis.png)

A developer panics: *"help! my project failed!!"*

The AI reads the log, understands the rules, and responds calmly:

> *"Your server is healthy — all APIs are responding.  This is your credit limit constraint working correctly.  Someone tried to set Item quantity → 14,444.  That would make Customer[Alice]'s balance → $1,299,960, exceeding her $5,000 credit limit.  The rule correctly blocked it with a 400 response."*

The AI isn't reading generated spaghetti.  It's reading the same rules you wrote — the same rules that appear in the logic log, the same rules a business analyst can read.  Everyone is looking at the same thing.

The thousands of lines of Context Engineering built into every project mean your AI assistant can explain behavior, diagnose problems, generate new rules, and create tests — without you having to explain the codebase first.

It's all standard tools underneath: your IDE, your debugger, your source control all work normally.  Rules live in your project as plain Python files, committed to git like everything else.  The stack is Python, Flask, SQLAlchemy, and Docker.  Deployment is standard containers.  Works with MySQL, Postgres, SQL Server, Oracle, and SQLite.  Nothing proprietary, nothing to unlearn.

---

## Generates Executable Models, Not Code

Rules **preserve design intent** — the rule and the requirement are the same thing.  When something breaks, you read the rule, not 200 lines of generated procedure.  When the business requirement changes, you change the rule; the engine handles the rest.

See [Model Driven](Tech-DSL.md){:target="_blank" rel="noopener"} for how declaring behavior in Python works.  For how the pieces fit together, see [Architecture](Architecture-What-Is.md){:target="_blank" rel="noopener"}.

---

## Getting Started


### 1. Install

```bash
mkdir genai-logic && cd genai-logic
python3 -m venv venv && source venv/bin/activate   # windows: venv\Scripts\activate
pip install ApiLogicServer
genai-logic start                                   # opens the Manager
```

Notes:

1. Windows users will need to run the terminal in Admin mode, with scripts enabled
2. For `genai` functions, you will need an [OpenAI Key](Sample-Basic-Tour.md#get-an-openai-apikey){:target="_blank" rel="noopener"}
3. If you are using SqlServer, you also need to [install `pyodbc`](Install-pyodbc.md)
4. If you are using VSCode, we ***strongly recommend*** you create the VSCode CLI - for more information, [click here](IDE-Customize.md#vscode-cli){:target="_blank" rel="noopener"}.  Do this before the next step

See [Express Install](Install-Express.md) for details, including Docker and Codespaces options.  The `start` commands loads the [Manager](Manager.md){:target="_blank" rel="noopener"} (a directory for creating and managing projects):

![Manager](images/manager/readme.png)

&nbsp;

### 2. AI-Guided Tour

The Manager opens automatically and walks you through creating `basic_demo`.  Allow 30-45 minutes.

Inside the created project, say to your AI assistant:

> *"Guide me through basic_demo"*

This is a hands-on tour covering API creation, declarative rules, security, and Python customization.  The AI acts as a knowledgeable colleague — running commands, explaining what happens, answering questions.  Scripts ensure no coding errors.  This is the recommended starting point.

![tutot](images/manager/tutor.png)

&nbsp;

### 3. Samples

The [Manager](Manager.md) provides a full sample catalog, each illustrating key patterns.  Each project is AI-enabled — ask your AI assistant how it works.  

Note you can create projects from existing databases, or new database projects from prompts.  In both cases, the presumption is that development continues in a classic iterative manner in the created project.

![training](images/manager/Manager-Training.png)

---

## Questions?

We'd love to hear from you...

1. Email: apilogicserver@gmail.com
2. Issues: [github](https://github.com/ApiLogicServer/ApiLogicServer-src/issues){:target="_blank" rel="noopener"}
3. Discord: we use Discord for support - join [here](https://discord.gg/HcGxbBsgRF){:target="_blank" rel="noopener"}.  You should install the Discord app.

It can be tricky to use Discord for screen sharing - here is the procedure for a mac:

1. Start a call with a contact
2. Share your screen:

![discord-1](images/support/discord/discord-1.png)
