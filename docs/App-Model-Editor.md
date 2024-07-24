**Under Construction - Beta**

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

Browse to [http://localhost:4298](http://localhost:4298)

![ame-browse](images/app-model-editor/4%20-%20Browse.png)

### 5. Create New yaml entry

The App Model Editor operates by editing a yaml file that represents the App Model.  

Create a new entry:

![ame-new](images/app-model-editor/5%20-%20New.png)

### 6. Upload 

And upload

![ame-upload](images/app-model-editor/6%20-%20Upload.png)

### 7. Edit Model

Edit your `Entities`, `Attributes` and `Relationships`.

### 8. Download

![ame-download](images/app-model-editor/9%20-%20Download.png)

### 9. Copy to your app

Copy the downloaded yaml file to your project, as shown below.

### 10. Rebuild

Rebuild the Ontimize app.

![ame-rebuild](images/app-model-editor/10%20-%20Rebuild.png)



&nbsp;

## Ontimize app_model.yaml 

The app_model.yaml file is created during the "app-create" or "create" phase and is based on the ui/admin.yaml file. Each entity, column, and tab_group is exposed with additional metadata.  When the "app-build" is invoked, these properties are used to populate the templates (html, scss, and typescript) for each page. If the "exclude" flag is set to 'false' - the entity or attribute will be excluded from the page. The "visible" column flag only applies to the Home table columns appearing in the grid.

```
entities:
  {EntityName}
    detail_template: detail_template.html
    home_template: home_template.html
    new_template:: new_template.html
    favorite: {SomeAttribute}
    mode: tab | dialog
    primary_key: 
        {SomeAttribute(s)}
    type: {Entity}
    info_list: {Html}
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