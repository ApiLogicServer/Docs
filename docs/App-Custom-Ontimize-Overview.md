**Under Construction - Preview**

!!! pied-piper ":bulb: TL;DR - Front Office App Dev"

    To complement the Admin App, API Logic Server can automatically create a 'starter kit' Angular app, using [**Ontimize**](https://ontimizeweb.github.io/docs/v15/introduction/), a proven app framework.  This approach provides the features outlined in [Custom Web Apps](App-Custom.md){:target="_blank" rel="noopener"}:

    1. **Faster and simpler automated creation:** the system creates a default app model, and uses that to create a default app, in seconds.
    
    2. **Simpler customization:** it is orders of magnitude simpler to tweak the properties of a generated app than to create the app by hand.  You can customize at 2 levels: 
    
        a. **The generated app for full control:** you can edit the generated app (html, typescript, css).
        
        b. **The app model:** the app is generated from a yaml model that designates the components for tables (grid, card, tree, dialog) and fields (text, image, combo, etc).  You can modify the yaml model to rebuild the app.
    
    This technology is currently in preview state - *not* ready for production.  Please contact us if you would like to try it, and provide feedback.

&nbsp;

# Ontimize - Angular Starter Kit

What is Ontimize Web?  See the Playground [Ontimize Web site](https://try.imatia.com/ontimizeweb/v15/playground/main/home){:target="_blank" rel="noopener"}:

> Ontimize Web is web application framework based on Angular for building business software. Ontimize Web makes use of Angular framework and its UI Component framework (Angular Material) to provide a set of reusable, well-tested and accessible components apart from a number of standard services and functionalities.  This includes a wealth of rich UI components (editable grid, graph, tree, etc).

&nbsp;

## API Logic Server Integration

While a separate product, Ontimize is highly integrated with API Logic Server:

1. **Unified Database:** driven by the same Data Model, and underlying JSON:API / logic
2. **Unified Repository:** Artifacts are files stored in your project directory for unified source, and managed by any standard IDE
3. **Shared Dev Server:** the API Logic Server serves the API, the Admin App, and the Ontimize App.  This simplifies development

> It should be possible for users with limited Python, Flask, SQLAlchemy, JavaScript technology (`npm` build, etc), or Ontimize knowledge to <br>1. Create a backend API<br>2. Declare rules for multi-table derivations and constraints<br>3. Create a front office Ontimize app, and<br>4. Make HTML UX page customizations

As you can see below, you are no longer limited to simple master/detail screens, as illustrated by the *nested grid* example below which nests an Item grid within an Order grid:

![Ontimize Nested Grid](images/ontimize/nested-grids.png)

&nbsp;

## Ontimize Components

Components (like nested grid) are a key element.  As you can see from the [grid component](https://try.imatia.com/ontimizeweb/v15/playground/main/data/grid/basic){:target="_blank" rel="noopener"}, using a component means you provide a **combination of html, css and typescript**.  There are analogous components for cards, trees, dialogs, graphs, charts, maps and fields (text, image, combo, etc).  

&nbsp;

# Concepts: Templates, Models

Each component has its own unique html code (including properties), css and typescript.  So, changing from a list to a grid would be a complex task.

So, API Logic Server introduces a template-based application model:

* **Template**: a macro-expansible version of a template, bundling its html, css and typescript.  The template is a 'generation ready' component.

* **Model**: a YAML file that designates the templates for tables (grid, card, tree, dialog) and fields (text, image, combo, date, currency, etc).  The creation process macro-expands the designated templates, creating the full app, which you can then customize.

> So, typical dev cycle would be to tune the model to designate the templates, </br>
then fine-tune the generated app by editing components.

&nbsp;

# Custom App Procedures

A default Ontimize app is created automatically when you create projects with security.  You can also create additional apps using the `als app-create` as described below.

&nbsp;

## 1. Create Project

One way is to `create` an ApiLogicServer project, specifying `--auth-provider-type=sql`:

```bash
als create --project_name=ApiLogicProject --db-url= --auth-provider-type=sql
```

This creates a project from your database (here, the [default sample](Sample-Database.md){:target="_blank" rel="noopener"}), which you can open and execute in your IDE.  It includes an API, the Admin App, and the default custom app.

Initially, you may wish to skip to [step 2 to run the default custom app](#2-run).

&nbsp;

### &emsp;&emsp;- Default App Created

If you create your app with authorization, a default Ontimize app will be created as a `ui/app` directory, with a full Ontimize default app.

&nbsp;

### &emsp;&emsp;- Parallel Logic/API Dev

At this point, distinct dev teams can safely proceed in parallel:

* backend: develop logic and custom APIs (e.g., for application integration)
* ui: proceed as described below

As noted earlier:

* logic is **automatically factored out of ui code** (in particular, not in controllers).  This increases re-use across apps, and re-use for integration

* **ui dev is not dependent on server api creation** -- JSON:APIs are self-serve, so ui developers are not blocked by backend api 

&nbsp;

## 2. Run

Execution is standard to Ontimize (assumes the installation of NPM and NodeJS). 

```bash
cd ui/app
npm install
npm start
```

Browse to [localhost:4299](http://localhost:4299), and login as `user: admin password:p`.

&nbsp;

## 3. Customize

The simplest way to introduce rich components is to specify them in the app model, and the rebuild the app.  Iterate this process until you have the right templates, then customize the created app.

![customize](images/ontimize/customize-overview.png)

### 3a. Enable Security

To enable Keycloak - in the ui/app/admin_model.yaml file - go to the settings/style_guide and change these values and use the app-build to activate keyloak.

    use_keycloak: true
    keycloak_url: http://localhost:8080
    keycloak_realm: kcals
    keycloak_client_id: alsclient

&nbsp;
Enable keycloak for the ALS server use
    als add-auth --provider-type=keycloak
&nbsp;   
### 3b. Edit App Model

Edit to remove unwanted entities, order columns, set templates, etc. 

You can edit the yaml file directly, or use the [provided model editor gui](#model-editor).

<details markdown>

<summary> Show me how -- Edit Model </summary>

&nbsp;

![app_create](images/ontimize/app-model.png)

</details>

### 3c. Rebuild App

Then, rebuild your application:

```bash
ApiLogicServer app-build --app=app
```

### 3d. Customize Created App

This will the the data model to build out the Ontimize app.  It's executable.

You can then use your IDE or other tooling (e.g., Ontimize CLI) to edit the artifacts to customize the look and feel.

Then, repeat [2. Run](#2-run), above.

<details markdown>

<summary> Show me how -- Customize Application </summary>

&nbsp;

![app_create](images/ontimize/app-cust.png)

</details>


&nbsp;

## 4. Create Additional Apps

With the project open in your IDE, use the **terminal window** to create a new Ontimize application in a named directory under 'ui':

```bash
ApiLogicServer app-create --app=app2
cd ui/app2
npm install
```

This creates `ui/app2/app_model.yaml` and installs the Ontimize 'seed' NodejS package and dependent node_modules.

# Appendices

## Yaml Model Editor
The Yaml editor allows the developer the ability to manage yaml files for editing using an Ontimize built application. Use the "Manage yaml files" New - to add your yaml file and then click upload to populate the screens with entities, attributes, and tab groups. Once complete, use the download flag to export the yaml to the 'ui' directory (ui/admin_model_merge.yaml) and compare to your original admin_model.yaml in the ontimize application folder.
```
git clone https://github.com/tylerm007/ontimize_yaml_view
cd ontimize_yaml_view

code .
#press F5 to start ApiLogicServer

cd ui/yaml
npm install
npm start

#go to http://localhost:5655 (user: admin password: p)
```
