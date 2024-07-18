## TL;DR - Low Code *For Developers*: Standards, Unique Bus Rules

The Low Code promise of business agility has tremendous potential.  To realize it, we must enlist developers by addressing their concerns:

* For Business Users, API Logic Server (ALS) provides the fastest and simplest way to create Working Software, directly from an existing database or a GenAI prompt.  
    * **No screen painting is required**
    * **Database definition is automated from GenAI**
* For Developers, API Logic Server leverages your existing infrastructure, including 
    * **Your IDE**, existing libraries, and
    * **Flexible container-based deployment**
* API Logic Server provides unique Logic Automation with **spreadsheet-like rules - 40X more concise** 
    * Such backend logic is *half* of your system - front-end-only automation falls short

&nbsp;

## Current Approaches

### Enable Business Users

Typical Low Code approaches provide a Studio with designers for databases and screens, so that citizen developers can create systems.  Products are typically cloud based, to enable sharing/collaboration without the complexity of traditional IT deployment.

&nbsp;

### Issues: Standards, Cost

Developers share the basic business agility objective of reducing time and cost.  Developers have been understandably reluctant to embrace Low Code, because they require:

* Proprietary Studio - modern IDEs provide "must-have" services for debugging, code management, profiling, using external libraries, etc.
* Proprietary Deployment - developers expect to create containers that can be deployed anywhere, able to leverage extensive functionality such as Kubernetes
* A modern and flexible application architecture, for integration (eg., APIs and Messaging), and maximizing re-use (e.g., shared logic between apps and headless services)

And finally, there are issues of cost.

&nbsp;

## ALS: Developer Low Code

ALS is designed for Developers, to address these challenges.

&nbsp;

### Devs: Standards, Architecture

ALS meets the basic requirements for Developers:

* **Standard IDE:** use your debugger, libraries, etc
* **Standard Container-based Deployment:** local, cloud, etc, compatible with enterprise options such as Kubernetes for dynamic scaling
* **Architecture:** APIs are created automatically, enabling basic application integration and unblocking UI development.  Messaging is also supported, for robust application integration.

&nbsp;

### Unique Logic

Backend logic is typically nearly half the effort for systems providing update capabilities.  Procedural approaches - whether code-based or graphical - do not provide meaningful automation.

A declarative approach is required.  API Logic Server provides spreadsheet-like rules, leveraging Python as a Domain Specific Language, are 40X more concise for such logic.

&nbsp;

### Business Users: GenAI 

While API Logic Server is focused on Developers, extreme levels of automation provide important benefits for business users: 

* **Instant Working Software** is created directly from an existing database, or a GenAI prompt.  This eliminates tedious database design and screen painting, for earlier collaboration and more rapid iteration.
* **Business Logic is transparent** and readable - much like a design document, *but executable*

&nbsp;

#### Web/GenAI

An important element of collaboration is rapid deployment so colleagues can review screens.  While API Logic Server targets local development, we have working prototypes that can be deployed on your infrastructure or cloud:

> In your browser, provide a GenAI prompt describing your system.  Press create, and it runs in a few seconds... *zero* deployment required. Then, Developers can download the project to customize, integrate, etc. 

Please contact us if you would like to preview this software.

&nbsp;

## Summary

The following table contrasts traditional "Current" Low Code with "Developer" Low Code:

| **Aspect** | ***Current* Low Code**  | ***Developer* Low Code** |
:-------|:-----------|:-----------|
| Screen Painter | **Commonly Provided** | Not Provided |
| Customizations | Proprietary Studio | Standard IDE |
| Rich UI | Via Screen Painter | **Declarative App Models** |
| Instant Working Software<br>for Agile Collaboration | Can be tedious | **Instant App Automation**<br>No Screen Painting Required |
| Database Creation | Via Forms <br>Can be complicated | **Gen AI** Natural Language<br>Break-through simplicity |
| Business Logic<br>(It's nearly half the system) | Proprietary Code<br>Procedural | :trophy:&nbsp;&nbsp;**Unique Spreadsheet-like Rules**<br>Declarative - 40X More Concise |
| Architecture | Proprietary - rigid | **Automated Microservice**<br>**Standard Docker**<br>**Flexibile: Cloud, Internal** |

