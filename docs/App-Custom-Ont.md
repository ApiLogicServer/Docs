!!! pied-piper ":bulb: TL;DR - Rich Custom Apps, Automated, Full Control"

    The Admin App is useful, but most systems will require custom User Interfaces.  Use your favorite framework (eg, React, Angular, Vue) to create rich, custom apps.  
    
    * App creation is much simpler since you can use the API to access your data, with **logic automation**.  This reduces your app code, within a modern architecture that shares logic for both apps and services.

    * The API is available instantly.  **App Dev is not blocked on API creation.**

    In addition, the system can automatically create a 'starter kit' Angular app, using [**Ontimize**](https://ontimizeweb.github.io/docs/v8/), a proven app framework.  This approach provides:

    1. **Faster and simpler automated creation:** learning a framework requires months of training, and app dev is slow and tedious.  This approach creates a full app in seconds.
    
    2. **Simpler customization:** it is orders of magnitude simpler to tweak the properties of a generated app than to create the app by hand.  You can customize at 2 levels: 
    
        a. **The generated app for full control:** you can edit the generated app (html, typescript, css).
        
        b. **The app model:** the app is generated from the model that designates the components for tables (grid, card, tree, dialog) and fields (text, image, combo, etc).  You can modify the model to change the app.
    
    This technology is currently in preview state - *not* ready for production.  Please contact us if you would like to try it, and provide feedback.

&nbsp;

# Ontimize - Angular Starter Kit

What is Ontimize Web?  From the [Ontimize Web site](https://try.imatia.com/ontimizeweb/v15/playground/main/home){:target="_blank" rel="noopener"}:

> Ontimize Web is web application framework based on Angular for building business software. Ontimize Web makes use of Angular framework and its UI Component framework (Angular Material) to provide a set of reusable, well-tested and accesible components apart from a number of standard services and functionalities.

As you can see, you are no longer limited to simple master/detail screens, as illustrated by the *nested grid* example below which nests an Item grid within an Order grid:

![Ontimize Nested Grid](images/ontimize/nested-grids.png)

Components (like nested grid) are a key element.  As you can see from the [grid component](https://try.imatia.com/ontimizeweb/v15/playground/main/data/grid/basic){:target="_blank" rel="noopener"}, you provide a combination of html, css and typescript.  There are analogous components for cards, trees, dialogs, graphs, charts, maps and fields (text, image, combo, etc).  


&nbsp;

# API Logic Server Automation

Creating a complete application requires an extensive number of components.  API Logic Server creates a complete app from the data model, which you can then customize.

## Automation: Templates, Models

Each component has its own unique html code (including properties), css and typescript.  So, changing from a list to a grid would be a complex task.

So, API Logic Server introduces a template-based application model:

* **Template**: a macro-expansible version of a template, bundling its html, css and typescript.  The template is a 'generation ready' component.

* **Model**: a YAML file that designates the templates for tables (grid, card, tree, dialog) and fields (text, image, combo, etc).  The creation process macro-expands the designated templates, creating the full app, which you can then customize.

> So, typical dev cycle would be to tune the model to designate the templates, then fine-tune the generated app by editing components.


## Procedures

The simplist way is to `create` a project, specifying `--auth-provider-type=sql`.  This will create a `ui/app` directory with a full Ontimize app:

```bash
als create --project_name=ApiLogicProject --db-url= --auth-provider-type=sql
```

You can run it using pre-created run configurations.  After starting the server:

1. **Install Ontimize (npm install)**
2. **Start Ontimize (npm start)**

Then, open a browser to `http://localhost:4299`.
