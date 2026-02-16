---
title: basic_demo_vibe
source: docs/Sample-Basic-Demo-Vibe.md
notes: gold is proto (-- doc); alert for apostrophe
propagation: api_logic_server_cli/sample_mgr/basic_demo_setup.py
do_process_code_block_titles: True
version: 0.24 from docsite, for readme 7/11/2025
---
<style>
  -typeset h1,
  -content__button {
    display: none;
  }
</style>

![vibe-cards](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/ui-vibe/nw/vibe-gallery.png?raw=true)

<br>

```bash title='🤖 Bootstrap Copilot by pasting the following into the chat'
Please load `.github/.copilot-instructions.md`
```

<br>

GenAI-Logic works works quite well with *"vibe"* tools: use GenAI-Logic to create your server and logic, and vibe to create custom apps.  You can mix and match 2 alternatives for Vibe:

1. Use popular vibe tools, such as Cursor.ai.  For more information, [click here](https://www.genai-logic.com/#h.75s0zu9xo7sa)
2. GenAI-Logic provides Context Engineering you can use in IDEs such as VSCode - these include support for basic vibe creation.  This page described those services. 


<br>

<details markdown>

<summary>Demo Overview: &emsp;1. Create from Existing DB &emsp; 2. Vibe Apps &emsp; 3. Add Logic &emsp;pre-reqs </summary>

<br>Here we will use Vibe to:

1. **[Create From Existing DB](#1-create-from-existing-db)** - Provides a MCP-enabled API and an Admin App
   - [Project Opens: Run](#1a-project-opens-run) - Launch and verify your system

2. **[Vibe Custom Apps](#2-custom-ui-genai-vibe)** - Vibe: Custom Apps from natural language

3. **[Declare Business Logic](#3-declare-logic-and-security)** - Add rules with natural language


Pre-reqs:

1. Install
2. OpenAI API Key is useful but not required; [click here](WebGenAI-CLI.md#configuration){:target="_blank" rel="noopener"}.

  * The `integration/mcp/mcp_client_executor.py` has `create_tool_context_from_llm` set to bypass LLM calls and use saved context; alter as required.


The entire process takes 20 minutes; usage notes:

* You may find it **more convenient** to view this in your Browser; [click here](Sample-Basic-Demo-MCP-Send-Email.md)
* A slide show summary is available [on our Web Site](https://www.genai-logic.com/product/tour){:target="_blank" rel="noopener"}
* Tip: look for **readme files** in created projects

![product-tour](images/basic_demo/product-tour.png)

</details>

<br>

<details markdown>

<summary>How to Use This Demo </summary>

<br>This demo teaches AI-assisted development patterns. Each step is a **natural language prompt** you copy/paste into Copilot chat. The prompts are self-documenting - they explain what they do.

**Vibe Philosophy:** AI makes errors. That's expected. When something fails, tell Copilot: *"Error X occurred, fix it"*. Copilot is exceptionally good at finding and correcting its own mistakes.

**Recommended Path:** If you're new to GenAI-Logic, start with the [Standard Demo](Sample-Basic-Demo.md) (creates `basic_demo` with guided tutor) to learn platform fundamentals. Then return here to explore AI-assisted development with `basic_demo_vibe`.
</details markdown>

<br>

## 1. Create From Existing DB


```bash title="In the Manager: Create a project from an existing database (probably already done)"
Create a database project named basic_demo_vibe from samples/dbs/basic_demo.sqlite
```

This recreates the basic demo.  We recommend this as your first project.  For more information, [click here](Sample-Basic-Demo.md){:target="_blank" rel="noopener"}.

<br><br>


## 2. Custom UI: GenAI, Vibe

The app above is suitable for collaborative iteration to nail down the requirements, and back office data maintenance.  It's also easy to make simple customizations, using the yaml file.

For more custom apps, you get complete control by generating app source code, which you can then customize in your IDE, e.g. using Vibe Natural Language:

```bash
# create react source (requires OpenAI key)
genai-logic genai-add-app --vibe
cd ui/react-app
npm install
npm start
```

**Customize using Natural Language:**
```txt title='Customize using Natural Language'
In the ui/react app, Update the Product list to provide users an option to see results in a list, or in cards.
```
<br>

> Below is an example from Northwind: for more information on vibe, [click here](https://apilogicserver.github.io/Docs/Admin-Vibe-Sample)

![vibe-cards](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/ui-vibe/nw/vibe-gallery.png?raw=true)

<br>

## 3. Declare Logic And Security

Declaring logic and security was described in the basic demo.  The sections below provide context on how this relates to using vibe for custom apps.

<br>

## Implications for the Team

### Admin App - *with* custom apps

The Admin App is created when you create the project.  It is automatic and simple to customize, but customizations are limited.  You will find it convenient for getting started, prototyping, and data repair.  

The Admin App is ***not instead*** of custom apps -  is a *complement* to custom apps.

<br>

### Distill Logic - no fat client

A common scenario is for schedule pressure to result in business logic built into apps.  This *"fat client"* approach is not recommended, since it provides no sharing between apps, or with services.

Given that your vibe app is using the GenAI-Logic API, and that these are logic-enabled, you should rely on the API.  This will greatly simplify vibe - focus on the user experience.

<br>

### Parallel App / Logic Dev

A very common scenario in traditional app dev is that the UI team has to wait until APIs are ready.  Such serialized development can be stressful for UI developers, and Business Users who want to try things out.

This unfortunate scenario is eliminated:

1. Project creation creates the API, so **App Dev can start immmediately** with a real API and real data
2. Backend dev (logic, custom APIs etc) can **proceed in parallel**.  New logic will automatically be "inherited" for apps already built.

