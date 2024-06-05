**Under Construction - Preview**

!!! pied-piper ":bulb: TL;DR - Front Office App Dev"

    To complement the Admin App, API Logic Server can automatically create a 'starter kit' Angular app, using [**Ontimize**](https://ontimizeweb.github.io/docs/v8/), a proven app framework.  This approach provides the features outined in [Custom Web Apps](App-Custom.md){:target="_blank" rel="noopener"}:

    1. **Faster and simpler automated creation:** the system creates a default app model, and uses that to create a default app, in seconds.
    
    2. **Simpler customization:** it is orders of magnitude simpler to tweak the properties of a generated app than to create the app by hand.  You can customize at 2 levels: 
    
        a. **The generated app for full control:** you can edit the generated app (html, typescript, css).
        
        b. **The app model:** the app is generated from a model that designates the components for tables (grid, card, tree, dialog) and fields (text, image, combo, etc).  You can modify the model to rebuild the app.
    
    This technology is currently in preview state - *not* ready for production.  Please contact us if you would like to try it, and provide feedback.

&nbsp;

# Ontimize - Angular Starter Kit

What is Ontimize Web?  From the [Ontimize Web site](https://try.imatia.com/ontimizeweb/v15/playground/main/home){:target="_blank" rel="noopener"}:

> Ontimize Web is web application framework based on Angular for building business software. Ontimize Web makes use of Angular framework and its UI Component framework (Angular Material) to provide a set of reusable, well-tested and accesible components apart from a number of standard services and functionalities.  This includes a wealth of rich UI components (editable grid, graph, tree, etc).

&nbsp;

## API Logic Server Integration

While a separate product, Ontimize is highly integrated with API Logic Server:

1. **Unified Database:** driven by the same Data Model, and underlying JSON:API / logic
2. **Unified Repository:** Artifacts are files stored in your project directory for unified source, and managed by any standard IDE
3. **Shared Dev Server:** the API Logic Server serves the API, the Admin App, and the Ontimize App.  This simplfies development

> It should be possible for users with limited Python, Flask, SQLAlchemy, JavaScipt technology (`npm` build, etc), or Ontimize knowledge to <br>1. Create a backend API<br>2. Declare rules for multi-table derivations and constraints<br>3. Create a front office Ontimize app, and<br>4. Make significant customizations

As you can see below, you are no longer limited to simple master/detail screens, as illustrated by the *nested grid* example below which nests an Item grid within an Order grid:

![Ontimize Nested Grid](images/ontimize/nested-grids.png)

&nbsp;

## Ontimize Components

Components (like nested grid) are a key element.  As you can see from the [grid component](https://try.imatia.com/ontimizeweb/v15/playground/main/data/grid/basic){:target="_blank" rel="noopener"}, using a component means you provide a **combination of html, css and typescript**.  There are analogous components for cards, trees, dialogs, graphs, charts, maps and fields (text, image, combo, etc).  

&nbsp;

# Custom App Automation

## Concepts: Templates, Models

Each component has its own unique html code (including properties), css and typescript.  So, changing from a list to a grid would be a complex task.

So, API Logic Server introduces a template-based application model:

* **Template**: a macro-expansible version of a template, bundling its html, css and typescript.  The template is a 'generation ready' component.

* **Model**: a YAML file that designates the templates for tables (grid, card, tree, dialog) and fields (text, image, combo, etc).  The creation process macro-expands the designated templates, creating the full app, which you can then customize.

> So, typical dev cycle would be to tune the model to designate the templates, then fine-tune the generated app by editing components.

&nbsp;

## Procedures

A default Ontimize app is created automatically when you create projects with security.  You can also create additional apps using the `als app-create` as described below.

&nbsp;

### 0. Create Project With Auth

The simplist way is to `create` a project, specifying `--auth-provider-type=keycloak`:

```bash
als create --project_name=ApiLogicProject --db-url= --auth-provider-type=keycloak
```

This creates a project from your database (here, the [default sample](Sample-Database.md){:target="_blank" rel="noopener"}), which you can open and execute in your IDE.  It includes an API, the Admin App, and the default custom app.

Initially, you may wish to skip to [step 2 to run the default custom app](#2-run).

&nbsp;

#### &emsp;&emsp;Default Custom App Created

If you create your app with authorization, a default Ontimize app will be created as a `ui/app` directory, with a full Ontimize default app.

&nbsp;

### 1. Create App Manually

With the project open in your IDE, use the **terminal window** to create an app:

```bash
ApiLogicServer app-create --app=ont_1
```

This creates `ui/ont_1/app_model.yaml`.

&nbsp;

#### &emsp;&emsp;Parallel dev

At this point, distinct dev teams can safely proceed in parallel:

* backend: develop logic and custom APIs (e.g., for application integration)
* ui: proceed as described below

As noted earlier:

* logic is **automatically factored out of ui code** (in particular, not in controllers).  This increases re-use across apps, and re-use for integration

* **ui dev is not dependent on server api creation** -- JSON:APIs are self-serve, so ui developers are not blocked by backend api 

&nbsp;

### 2. Run

Execution is standard to Ontimize:

```bash
cd ui/app
npm install
npm start
```

Browse to [localhost:4299](http://localhost:4299), and login as `admin/p`.

&nbsp;

### 3. Customize

The simplest way to introduce rich components is to specify them in the app model, and the rebuild the app.  Iterate this process until you have the right templates, then customize the created app.

![customize](images/ontimize/customize-overview.png)

#### 3a. Edit Model

Edit to remove unwanted entities, order columns, set templates, etc.

You can edit the yaml file directly, or use the [provided model editor gui](#model-editor).

<details markdown>

<summary> Show me how -- Edit Model </summary>

&nbsp;

![app_create](images/ontimize/app-model.png)

</details>

#### 3b. Rebuild

Then, rebuild your application:

```bash
ApiLogicServer app-build --app=ont_1
```

#### 3c. Customize Application

This will the the data model to build out the Ontimize app.  It's executable.

You can then use your IDE or other tooling (e.g., Ontimize CLI) to edit the artifacts to customize the look and feel.

<details markdown>

<summary> Show me how -- Customize Application </summary>

&nbsp;

![app_create](images/ontimize/app-cust.png)

</details>

# Appendices

## Model Editor

To be supplied.