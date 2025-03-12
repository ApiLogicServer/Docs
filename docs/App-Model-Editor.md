**Under Construction - Beta (Images broken)**

!!! pied-piper ":bulb: TL;DR - Model-Based App Definitions"

    The fastest way to develop your custom app is to edit the model file before you alter the created components.  Edit the model file to make changes such as:
    
    1. Choose which Entities / Attributes are exposed, and their order

    2. Specify the [templates](App-Custom-Ontimize-Overview.md#concepts-templates-models){:target="_blank" rel="noopener"} for Entities and Attributes.

    The App Model Editor is a simpler way of editing the [App Yaml file](#ontimize-app_modelyaml){:target="_blank" rel="noopener"}.
    
&nbsp;

## App Model Editor

The Yaml editor allows the developer the ability to manage yaml files for editing using an Ontimize built application. Use the "Manage yaml files" New - to add your yaml file and then click upload to populate the screens with entities, attributes, and tab groups. Once complete, use the download flag to export the yaml to the 'ui' directory (ui/admin_model_merge.yaml) and compare to your original admin_model.yaml in the ontimize application folder.

The App Model Editor is installed automatically in the Manager (`system/app_model_editor`).  It runs on a different port, so you can run it at the same time as your app.

&nbsp;

### 1. Run > Prepare

Use the Run Config as shown below:

![ame-prepare](images/app-model-editor/1%20-%20Prepare.png)

### 2. Run > Start Server

Execute **Run Config > `Start Server`**.  This starts an API Logic Server.

### 3. Run > Start

Execute **Run Config > `Start`**.  This starts the App Model Editor (an Ontimize App).

### 4. Open in the Browser

Browse to [http://localhost:4298](http://localhost:4298){:target="_blank" rel="noopener"}

![ame-browse](images/app-model-editor/4%20-%20Browse.png)

### 5. Create New yaml entry

The App Model Editor operates by editing a yaml file that represents the App Model.  

Create a new entry:

![ame-new](images/app-model-editor/5%20-%20New.png)

### 6. Upload 

And upload your app_model.yaml file to the server.

![ame-upload](images/app-model-editor/6%20-%20Upload.png)

### 7. Process Yaml
The process button will replace all the Entities, Attributes, and Relationships with the uploaded content.

![process-yanl](images/app-model-editor/7%20-%20Process.png)

### 8. Edit Model

Edit your `Entities`, `Attributes` and `Relationships` using the various screens.

![ame-edit](images/app-model-editor/8%20-%20Edit.png)

### 9. Process or Download
The big Process Yaml button will take the 'original content' and process this into entities, attributes, and relationships. Once you have edited these values, use the download flag (and save) to populate the downloaded content box.  

![ame-download](images/app-model-editor/9%20-%20Download.png)

### 10. Copy to your app

Copy the downloaded yaml file to your ontimize `app_model.yaml` project, as shown in the screenshot below.

![ame-copy](images/app-model-editor/10%20-%20Copy.png)

### 11. Rebuild

Rebuild your Ontimize app using the command line below.
```
als app-build --app=${name_of_ontimize_app}
```

![ame-rebuild](images/app-model-editor/10%20-%20Rebuild.png)


&nbsp;

## Ontimize app_model.yaml 

The app_model.yaml file is created during the "app-create" or "create" phase and is based on the react-admin ui/admin.yaml file. Each entity, column, and tab_group is exposed with additional metadata.  When the Ontimize "app-build" is invoked, these properties are used to populate the templates (html, scss, and typescript) for each page. If the "exclude" flag is set to 'true' - the entity or attribute will be excluded from the page. The "visible" column flag only applies to the Home table columns appearing in the grid (all columns are true by default).

```
entities:
  {EntityName}
    detail_template: detail_template.html
    home_template: home_template.html
    new_template:: new_template.html
    favorite: {SomeAttribute}
    mode: {tab | dialog}
    primary_key: 
       - {SomeAttribute(s)}
    type: {Entity}
    title: {title}
    info_list: {Html}
    group: menu_group 
    columns:
        enabled: true
        exclude: false
        label: {Label}
        name: {Attribute}
        required: false
        search: false
        sort: false
        template: {template}
        type: {DataType}
        visible: true
        default: 'some string'
    tab_groups:
        direction: tomany | toone
        exclude: false
        fks:
            - {SomeAttribute(s)}
        label: {Label}
        name: {Entity Relationship}
        resource: {Entity}
settings:
  style_guide:
    include_translation: false
    use_keycloak: false
```

&nbsp;

### Existing Column Templates
```
    ("checkbox", "o_checkbox.html"),
    ("combo", "o_combo_input.html"),
    ("currency", "currency_template.html"),
    ("date", "date_template.html"),
    ("email", "email_template.html"),
    ("file", "file_template.html"),
    ("html", "html_template.html"),
    ("integer", "integer_template.html"),
    ("list", "list-picker.html"),
    ("nif", "o_nif_input.html"),
    ("password", "password_template.html"),
    ("percent", "percent_template.html"),
    ("phone", "phone_template.html"),
    ("real", "real_template.html"),
    ("text", "text_template.html"),
    ("textarea", "textarea_template.html"),
    ("time", "time_template.html"),
    ("timestamp", "timestamp_template.html"),
    ("toggle", "o_slide_toggle.html")
```

## Entity Fields
|field|Description|
:------|:---------------|
|Entity name|name of API endpoint {{ entity }}|
|Title|display name used for {{ title }} |
|Primary Key|array of primary keys {{ primaryKeys }}|
|Favorite|used for list-picker display|
|Mode|tab or dialog style {{ editMode }}|
|Menu Group|used to organize entity into side bar menu groups(moved to menu_group)|
|Exclude|if true - skip this API endpoint in the first page generation|
|home_template|This is the grid or home template used for the Entity (moved to pages)|
|detail_template|This is the drill down page from home for each row - it can include relationships (tabgroup) (moved to pages)|
|new_template|This template is used to insert new rows into the selected Entity (moved to pages)|

## Attribute Fields
Use the Ontimize editor to change the label, tooltip, exclude selected attributes, include attribute in the search or sort, enable or mark fields as required, and include visible in the home table display.

|field|Description|
:------|:---------------|
|Entity Name|name of api endpoint (case sensitive)|
|Attribute|name of API attribute {{ attr }}|
|Title|label used for this attribute {{ label }} |
|Template Name|column template (used by template pick list)|
|Search|is this field included in search|
|Sort|is this field included in sort|
|Required|is this field marked as required|
|Excluded|exclude this attribute from detail/new/home pages|
|Visible|is this attribute visible on home table {{ visibleColumns }}|
|DataType|the internal datatype (do not change)|
|Tooltip|hover value for the attribute|
|Default Value|string value to show on new page|

## Relationship Fields (aka TabGroup)
Use the Ontimize editor to exclude tab on detail page (tomany) or change the tile used to display.
|field|Description|
:------|:---------------|
|Entity Name|name of api endpoint|
|Tab Entity|the name of the other end of the relationship|
|Direction|toone (to parent - used by list_picker) or tomnay (to children - used by tab panel)|
|Relationship name|defined in SQLAlchemy database/models.py|
|label|Tab Display name|
|Exclude|skip this relationship for all tabs and lookups|
|Foreign Keys|array of values (do not change)|

## Global Settings
These values are injected into the various entity and attribute to provide and set global values.  New values will be added for any templates created.

|field|Description|
:------|:---------------|
|Include Translation|set to true and then do an app-build to generate Spanish translation (assets/Ii8n/es.json)|
|Currency Symbol|set for locale $ |

### Existing Column Templates 
These templates can be found in the directory ui/app/templates and can be modified or cloned. When the app-build is invoked these local templates are used first (then the global system templates are used).
```
    ("checkbox", "o_checkbox.html"),
    ("check_circle", "check_circle_template.html"),
    ("combo", "o_combo_input.html"),
    ("currency", "currency_template.html"),
    ("date", "date_template.html"),
    ("email", "email_template.html"),
    ("file", "file_template.html"),
    ("html", "html_template.html"),
    ("integer", "integer_template.html"),
    ("list", "list-picker.html"),
    ("nif", "o_nif_input.html"),
    ("password", "password_template.html"),
    ("percent", "percent_template.html"),
    ("phone", "phone_template.html"),
    ("real", "real_template.html"),
    ("text", "text_template.html"),
    ("textarea", "textarea_template.html"),
    ("time", "time_template.html"),
    ("timestamp", "timestamp_template.html"),
    ("toggle", "o_slide_toggle.html")
```
## Application
|field|Description|
:------|:---------------|
|name|app name|
|short_name|abbreviation|
|description|notes|

## Menu Group
|field|Description|
:------|:---------------|
|menu_name|name of group|
|menu_title|Title for group|
|icon|material icon|
|opened|is the group open (default:True)|

## Menu Item
|field|Description|
:------|:---------------|
|entity_name|API Entity for module|
|menu_name|name on menu|
|template_name|default: module.jinja|
|icon|material icon to display|


## Page (new, home, detail)
|field|Description|
:------|:---------------|
|page_name| new, home, detail|
|title|used on page|
|template_name|new, home, detail html template|
|typescript_name|new, home, detail jinja|
|columns|list of columns|
|visible_columns|used on home page grid|
|include_children|boolean - detail page only|