---
title: Web GenAI
Description: Instantly Create and Run Database Projects - GenAI, Flask, APIs, SQLAlchemy, React Apps, Rules, Low-Code, Python, Docker, Azure, Web Apps, Microservice, Declarative
---


!!! pied-piper ":bulb: WebGenAI - Web Interface for GenAI-Logic"

      Access WebGenAI via your browser to

      * Create systems from a Natural Language prompt: databases, APIs, an Admin Web App
      * Iterate them (add new tables, columns etc)
      * Add Logic
      * Download the project to your local desktop
      * Execute the project in GitHub Codespaces


&nbsp;

## Access GenAI

***[Access the site here](https://apifabric.ai/admin-app/){:target="_blank" rel="noopener"}*** to use GenAI:

1. Provide a prompt, and
2. The system creates a microservice: a database, an API, and a multi-page application

    * Review the project - running screens, with data - and the database diagram
    * Iterate to ***get the requirements right***

3. Download the project to continue development with rules and Python in your IDE

&nbsp;

> Web/GenAI is based on API Logic Server - [docs home here.](Doc-Home.md){:target="_blank" rel="noopener"}.  API Logic Server provides the CLI functions used by WebGenAI - for more on the GenAI CLI, [click here](WebGenAI-CLI.md){:target="_blank" rel="noopener"}.

*Click* the image below to watch a 2 minute video:

[![Web/GenAI Automation](images/web_genai/wg-1280x720-video.jpg)](https://www.youtube.com/watch?v=-tMGqDzxd2A&t=3s "Microservice Automation"){:target="_blank" rel="noopener"}

## About

<details markdown>

<summary>1. Instant Working Software - Get the Requirements Right</summary>

Automation has turned your prompt into a microservice: a **database**, a working **application**, and a **standard API.**

It simply cannot be faster or simpler.

* Eliminate weeks to months of complex framework coding, db design, or screen painting.  
* Far more effective than 'dead` wireframes, you can...

    * Collaborate with stakeholders using Working Software, live data

    * Iterate 15 times... before lunch.

</details>

</br>

<details markdown>

<summary>2. Microservice Development - Declarative Rules and Python in your IDE</summary>

The speed and simplicity of AI, plus all the flexibility of a framework.  

* Download the standard project, and [**customize in your IDE**](https://apilogicserver.github.io/Docs/Tutorial/#3-customize-and-debug-in-your-ide)

* Use standard Python: e.g. provide [Application integration](https://apilogicserver.github.io/Docs/Sample-Integration/) (custom APIs and kafka messaging) 

* [Declarative security](https://apilogicserver.github.io/Docs/Security-Overview/): configure keycloak authentication, declare role-based row authorization<br>

* [Declarative business logic](https://apilogicserver.github.io/Docs/Logic-Why/): multi-table constraints and derivations using ***unique rules*** that are 40X more concise than code, extensible with Python<br>

</details>
</br>

<details markdown>

<summary>3. Deploy - Standard container, no fees, no lock-in</summary>

Created projects include scripts to automate docker creation, so you can deploy anywhere.  

There are no runtime fees, no lock-in.

</details>
</br>
&nbsp;

## Develop

You can explore the created microservice on your own computer.

1. [Download]() your project (customize in your IDE to add logic & security)

    * Observe the project is a set of [models]() - not a huge pile of difficult-to-understand code

2. Executable Docker Image

    * The website provides a docker command to run the created project


&nbsp;

## Contact for full access

To create unlimited projects in your environment, contact `ApiLogicServer@gmail.com` for a free docker image, and project support.

The underlying services are also available in the [genai CLI](WebGenAI-CLI.md){:target="_blank" rel="noopener"}.

&nbsp;

## Prompt Design

Prompt design is "AI Programming".  Consider the following.

&nbsp;

### Business Area

You can provide a very general prompt, for example:

* `an auto dealership`, or
* `a restaurant`

&nbsp;

### Database Oriented

Or, you can provide a specific prompt that identifies specific tables, columns and relationships (for example, 

```bash title='Database, API and Web App'
Create a system for Customer, Orders, Items and Products
```

&nbsp;

### With Logic

Particularly interesting is that you can declare backend behavior with rules:

```bash title='Database, API, Web App and Logic'
Create a system with customers, orders, items and products.

Include a notes field for orders.

Use LogicBank to enforce the Check Credit:

1. Customer.balance <= credit_limit
2. Customer.balance = Sum(Order.amount_total where date_shipped is null)
3. Order.amount_total = Sum(Item.amount)
4. Item.amount = quantity * unit_price
5. Store the Item.unit_price as a copy from Product.unit_price
```

You can verify this by altering a sample order/item with a very high quantity, and verifying the credit limit is checked.  (Note this is not trivial - 3 table transaction.)

For more, see 

* the [logic editor](WebGenAI-logic-editor.md){:target="_blank" rel="noopener"}
* [natural languge logic](WebGenAI-CLI.md#natural-language-logic){:target="_blank" rel="noopener"}

&nbsp;

### Iterations

You can *iterate* your prompt to include more tables etc, while preserving the design you have already created.

* This enables you to break your system down into a set of "Use Cases", solving one at a time, and integrating back to the others.

&nbsp;

### Limitations

The created systems are basic database applications, not completed systems with sophisticated functionality such as images, custom screens, etc.

You can "build out" the project by downloading it and using your IDE with Python and rules, or perform the same functions using Codespaces (a browser-based version of VSCode - a link is provided for this).

&nbsp;

## Context

This explains the premise behind GenAI, and how it fits into a project life cycle.

&nbsp;

### Why GenAI

A common project experience is:

* Weeks (or months) to get running screens
* Then, when Business Users explore the screens, it becomes clear there were basic misunderstandings

Which leads to our premise:

1. **Instant screens** (Agile "Working Software"); collaborate, and iterate to ***get the requirements right***
2. Kickstart the project with a **solid backend** - a Database, API and Logic from declarative / Natural Language models

    * Logic in particular is key: security and multi-table derivations / constraints constitute as much as half your project: declarative rules make them 40X more concise  &nbsp; :trophy:

    * The remaining logic is built in your IDE using standard Python, providing the speed and simplicity of AI - including logic - with the flexibility of a framework

&nbsp;

### Project Life Cycle

As shown in the Life Cycle outline below, this approach is complementary to your existing UI Dev tools such as UI frameworks or Low Code Screen Painters. 

* In addition to existing UI Dev tools, please explore automation support for [Ontimize](App-Custom-Ontimize-Overview.md){:target="_blank" rel="noopener"}.

As illustrated by the green graphics below, we seek to provide value in the Inception Phase (get the requirements right), and for backend development. 

![life-cycle](images/web_genai/life-cycle.png)

&nbsp;
