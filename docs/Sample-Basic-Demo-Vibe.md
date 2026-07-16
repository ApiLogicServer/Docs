---
title: basic_demo_vibe
source: docs/Sample-Basic-Demo-Vibe.md
notes: gold is proto (-- doc); alert for apostrophe
propagation: copy_md() -> readme_vibe.md in every created project (see project_overlay.py)
do_process_code_block_titles: True
version: 1.1 (Jul 2026) - Section 2 updated for the Claude/CE React-app generation
  path (direct AI-assistant generation from admin.yaml, no OpenAI key) as the default,
  matching Admin-Vibe.md; old genai-add-app --vibe CLI is now the documented fallback.
  Fixed stale `cd ui/react-app` path and dead propagation front-matter reference.
---

<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

![vibe-cards](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/ui-vibe/nw/vibe-gallery.png?raw=true)

<br>

```bash title='🤖 Bootstrap your AI assistant — paste into chat (Agent mode, Claude Sonnet 4.6 recommended)'
Please load `.github/.copilot-instructions.md`
```

<br>

GenAI-Logic works works quite well with *"vibe"* tools: 

* Use GenAI-Logic to create your server and logic, and 
* Use vibe to create custom apps.  

You can mix and match 2 alternatives for Vibe:

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


</details>

<br>

<details markdown>

<summary>How to Use This Demo </summary>

<br>This demo teaches AI-assisted development patterns. Each step is a **natural language prompt** you copy/paste into Copilot chat. The prompts are self-documenting - they explain what they do.

**Vibe Philosophy:** AI makes errors. That's expected. When something fails, tell Copilot: *"Error X occurred, fix it"*. Copilot is exceptionally good at finding and correcting its own mistakes.

**Recommended Path:** If you're new to GenAI-Logic, start with the [Standard Demo](Sample-Basic-Demo.md) (creates `basic_demo` with guided tutor) to learn platform fundamentals. Then return here to explore AI-assisted development with `demo_vibe`.
</details markdown>

<br>

## 1. Create From Existing DB

If you arrived here from the Manager README's **Use Case 4: Vibe Dev Backend**, this
project already exists — created via the CLI (faster than an AI prompt for this step):

```bash title="In the Manager: Create a project from an existing database (already done, if you followed Use Case 4)"
genai-logic create --project_name=demo_vibe --db_url=sqlite:///samples/dbs/basic_demo.sqlite
```

This recreates the basic demo, under the name `demo_vibe`.  For more information, [click here](Sample-Basic-Demo.md){:target="_blank" rel="noopener"}.

<br><br>


## 2. Custom UI: GenAI, Vibe

The app above is suitable for collaborative iteration to nail down the requirements, and back office data maintenance.  It's also easy to make simple customizations, using the yaml file.

For more custom apps, you get complete control by generating app source code, which you can then customize in your IDE, e.g. using Vibe Natural Language.

**Default method — ask your AI assistant directly.** No OpenAI key, no separate API
call — your assistant (already in this session) generates a customized React Admin
app directly from `ui/admin/admin.yaml`, very much *like* the Admin App, but with
full customizable source:

```text title="Ask your AI assistant to generate the app"
Create a new react app named my-app-name from ui/admin/admin.yaml.
```

```bash title="Run the generated app"
cd ui/my-app-name
npm install
npm start
```

See [Admin-Vibe](Admin-Vibe.md){:target="_blank" rel="noopener"} for the full
generation guide (the "iterate `admin.yaml` first" workflow, what gets generated,
and the OpenAI-driven CLI fallback for environments with no AI assistant session).

**Customize using Natural Language:**
```txt title='Customize using Natural Language'
In ui/my-app-name, update the Product list to provide users an option to see results in a list, or in cards.
```
<br>

> The screen shot above is an example from Northwind: for more information on vibe, [click here](https://apilogicserver.github.io/Docs/Admin-Vibe-Sample)

<br>

## 3. Declare Logic And Security

Declaring logic and security was described in the basic demo.  The sections below provide context on how this relates to using vibe for custom apps.

<br>

## Implications for the Team

### Admin App - *with* custom apps

The Admin App is ***not instead*** of custom apps — it's a *complement*: automatic,
simple to customize, convenient for getting started, prototyping, and data repair,
but with limited customization. See [Admin-Vibe: Get the Data Model Right Fast, *Then*
Build the UI](Admin-Vibe.md#generation){:target="_blank" rel="noopener"} for why we
recommend iterating there first, before generating a custom app.

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


&nbsp;

<br>
---

## Apendix: Training Process

The Copilot-trained vibe commands typically are more reliable than untrained, since their training explains details of using the API.  You can train Copilot further for your own custom UIs.  Our proess was:

1. Show it an example - code, screen shots, whatever
2. Ask it to create
3. Ask it to fix
4. Ask it to create/fix training
5. Repeat