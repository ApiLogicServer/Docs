## Standards-based

Development and runtime architectures are what programmers expect:

* As noted above, the [Key Project Components](../Architecture-What-Is){:target="_blank" rel="noopener"} are standard Python packages for APIs, data access.
* Projects developed in standard IDEs, and deployed in standard containers.

## Near-Zero Learning Curve - no frameworks, etc

ApiLogicServer has a near-zero learning curve:

* You do not need to know Python, SQLAlchemy, React, Flask, or JSON / APIs to get started. 

* You should have a basic background in database - familiar with terms like Table, Column, Foreign Key.

&nbsp;

### Deliver While Learning

You have a running project in moments, customizable without requiring deep understanding of any of these frameworks.  Such instantly-available projects are valuable to Custom App Developers and Business Users, who can begin with these while you gain familiarity with Flask and SQLAlchemy.

Making extensions, of course, begins to require more technical background.

&nbsp;

#### Facilitate Python Adoption

For organizations seeking to leverage the value of Python, API Logic Server enables you to 

* Start without Python background, and 

* Use the created systems / examples to learn Python, based on working software

&nbsp;

### Allow a few days for learning logic

Logic represents the starkest different between procedural code and declarative rules.  It requires a few days to get the hang of it.  We recommend you [explore this documentation](https://github.com/valhuber/LogicBank#next-steps).

&nbsp;

## Business Agility

ApiLogicServer automation creates a running project nearly instantly, but it also is designed to help you adapt to business changes more rapidly:

* [Rebuild](../Project-Rebuild) support to update existing projects from database or data model changes
* Logic provides automatic [reordering and reoptimization](../Logic-Why/#key-aspects-of-logic) as logic is altered

&nbsp;

## Technology Agility - an Application Virtual Machine

Models are, somewhat by their very nature, rather technology independent.  Instead of React, the UI specification could be implemented on Angular.  Instead of interpreted, the logic could be code-generated onto any language.  And so forth.

You can think of the [Key Project Components](#key-project-components) as an Application Virtual Machine that executes ApiLogicProjects.  As new underlying technology becomes available, new AVMs could be developed that migrate the declarative elements of your UI, API and Logic - ***without coding change***.  Because, they are models, not code.

   > This provides an unprecedented preservation of your application investment over underlying technology change. 

&nbsp;

## Automation Reduces Risk

Automation not only gets results fast and simplifies adapting to change, it also reduces risk.

### Coding Risk

The most troublesome bugs are silent failures - no stacktrace, but the wrong answer.

Automation address this by designing out whole classes of error:

* the UI and API just work
* logic is [automatically re-used](../Logic-Why/#automatic-reuse) over all Use Cases

### Architectural Risk

Technology complexity makes it get hard to get projects that even work, much less work right.  Projects commonly suffer from a wide variety of architectural flaws:

* business logic is not shared, but repeated in each UI controller... and each integration
* pagination may not be provided for all screens

And so forth.  These cause project failures, far too often.

But automation can help - since your declarative models only stipulate _what_, the _system_ bears the responsibility for the _how -- and getting it right_.  Each of the architectural items above are automated by the system.

### Requirements Risk

Requirements risk can represent an even greater challenge.  The reality that users may only realize the real requirements when they actually use running screens with real data.  The problem, of course, is that these are often available after considerable time and effort.

That's why _working software **now**_ is so important - users get screens right away.  These can identify data model errors (_"hey... customers have more than one address"_) or business logic requirements (_"hey.... we need to check the credit limit"_).

&nbsp;

## Unifying User Groups

While it may at first seem that an IDE, language-based approach may be for developers only, this is not the case:

| Python Level | Users | Usage |
| :--- |:---|:---|
| **DSL** | Business Users | - Read Rules<br>- BDD |
| **Scripting** | Power Users | - Logic Events<br>- Customize Admin App |
| **OO Language** | Developers | - Full Capability |

In particular:

* **Business Users**

   * Can read rules (e.g. identify that *"the tax calculation is missing"*).  For more information, see [Python as a DSL](../Tech-DSL){:target="_blank" rel="noopener"}
   
   * Oo not need to load an IDE - they can access the project on GitHub and use Shift + "." to view the rules, and the [BDD Report](../Behave-Logic-Report){:target="_blank" rel="noopener"}

* **Power Users** will be very comfortable with Python as a Scripting language, using the examples to quick become adept with enhancing declarative services

This is one of the major advantages of declarative.  Unlike procedural code that is impenetrable to Business / Power users, declarative logic means anyone in the organization can go directly to the source


