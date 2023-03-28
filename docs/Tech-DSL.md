!!! pied-piper ":bulb: TL;DR - Use Python (code completion) to declare behavior"

    Declarative specifications are captured in Python, providing:

    * Natural source control, code review etc.

    * Type Checking, based on IDE support for Python typing

    * Lookups, based on IDE support for Code Completion


Declarative is a powerful technology, designed to provide agility and transparency with high level definitions.  Such definitions comprise a DSL - a Domain Specific Language.  This article explores how such language elements are captured and stored.

## API Logic Server Declarative

API Logic Server provides declarative support for:

* API - the `api/expose_api_models.py` file declares (lists) which tables are exposed in the [API](../API).

* Logic - using spreadsheet-like rules - [see here for more information](../Logic-Why).

* User Interface - using a yaml file  - [see here for more information](../Admin-Customization).

&nbsp;

## Capture with a User Interface

Declarations express and document system behavior, so it's important how they are captured.  One way is a user interface.  This affords the some opportunities to make things simple, but offer some challenges on persisting the language elements (meta data).  These are described below.

### Type checking, Lookups

It's valuable to ensure that the language elements are properly typed - numbers are valid, etc.  Capturing these in a User Interface enables such checking.

Even more important, a User Interface can "teach" language elements to developers - provide a list of rules, a list of tables or columns for defining rules, and so forth.

### Persist in a database?

There must of course be provisions for persisting the language elements ("meta data") in a way they can be viewed and editing later.  They could be stored in a database, opening up attractive "eat your own dogfood" opportunities to use rules to validate rules.

This is attractive.  I've personally used this approach.  The drawback is that databases really don't provide source control at a low level of granularity.  Developers need to check in rules, back them out - all of these are very cumbersome in a database.  You can't just use GitHub.

### Persist as markup language?

Another approach, also one I've used, is to store language elements as markup files - xml, json, yaml etc.  This works well - the meta data is now files, and can be used with source control systems, can be diff'd, etc.

However, such files represent a transformation from what the developer supplied in the User Interface.  This adds some burden to developers - perhaps not onerous, but not natural.

&nbsp;

## Capture as Python Code

A completely different approach is to abandon a User Interface, and use the IDE and Python.  So, for example, a rule looks like this:

![Declaring Rules](images/logic/rule-declaration.png)

This shows how a modern IDE provides virtually all of the advantages of a User Interface.

### Rule Learning

Observe how code completion lists the possible rules, with documentation on their meaning, examples, etc.

### Transparent

Python named arguments make the rules read very much like the design comments at the top of the screen shot.

### Code Completion

Code completion addresses not only rule types, but the list of valid tables and columns.  These are derived from the (system-generated) `database/models.py` file.

### Type Checking

Runtime services employ Python type checking for their arguments.  

> Special thanks to Mike Bayer (creator of SQLAlchemy) for a heads-up on this as I was learning Python.

### Consistent Persistence

Using Python files for rules eliminates the persistence question.  All the tools that work with source files operate on the DSL - editors, source control, diff, merge, etc.

### Debugging is natural

A huge advantage is that debugging is built into the same IDE used for editing.  No additional tools to learn and coordinate.

### Integrated, Consistent Environment

Well, that's what IDE means, isn't it?  Using Python as a DSL expands our notion of development from code, to include DSLs, all in one integrated environment.
