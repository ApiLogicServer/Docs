!!! pied-piper ":bulb: TL;DR - Rich Custom Apps - Full Control"

    The Admin App is useful, but most systems will require custom User Interfaces.  Use your favorite framework (eg, React, Angular, Vue) to create rich, custom apps.  
    
    * App creation is much simpler since you can use the API to access your data, with **logic automation**.  This reduces your app code, within a modern architecture that shares logic for both apps and services.

    * The API is available instantly.  **App Dev is not blocked on API creation.**


&nbsp;

# App Dev: Open, Faster, Simpler

API Logic Server provides for open App Dev.  Use any framework you are comfortable with.  

App Dev can be complex and time-consuming.  Below are some considerations to make it simpler and faster.

&nbsp;

## Model-Driven Automation

A proven approach is provide a simple description of an app, identifying the tables, fields, with some basic layout hints.  This is **much simpler** than the detailed JavaScript/HTML that ultimately execute.

* In the ideal case, the system can create a **default app model** from the data model.

This model can be automated to create a complete application **much faster** -- saving weeks of effort.  

This approach supports ***agile* collaboration** with stake holders.  If the app is not even close, little effort is wasted (*"fail fast"*).

&nbsp;

## Edit vs. Create

In most cases, it's easier to edit an running app, instead of creating the entire thing from scratch.

> This avoids starting from a "clean white sheet of paper".

&nbsp;

## Template-Driven

Template are fragments of app code (html, JavaScript, CSS, etc).  They might define small items like buttons, or fields, or larger constructs like grids or forms.

These are then "macro-expanded" during automated creation, providing proper values from the data / app models (column names etc).)

> This approach pre-specifies the set of properties apprpriate for the type of control.  The simplifies app dev, and reduces errors.

&nbsp;


# Consider Ontimize

In addition to any API-based framework, API Logic Server is integrated with Ontimize.  It is based on the approach described above, and can create apps with rich features such as **maps, charts, and nested grids**, like this:

![Ontimize Nested Grid](images/ontimize/nested-grids.png)

For more information, [click here](App-Custom-Ontimize-Overview.md).