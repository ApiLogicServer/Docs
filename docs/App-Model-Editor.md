**Under Construction - Beta**

!!! pied-piper ":bulb: TL;DR - Model-Based App Definitions"

    The fastest way to develop your custom app is to edit the model file before you alter the created components.  Edit the model file to:
    
    1. Choose which Entities / Attributes are exposed, and their order

    2. Specify the [templates](App-Custom-Ontimize-Overview.md#concepts-templates-models){:target="_blank" rel="noopener"} for Entities and Attributes.

    The App Model Editor is a simpler way of editing the [App Yaml file](#ontimize-app_modelyaml){:target="_blank" rel="noopener"}.
    
&nbsp;

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