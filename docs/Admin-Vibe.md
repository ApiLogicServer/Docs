!!! pied-piper ":bulb: TL;DR - instant multi-page, multi-table apps"

      The *generated* Admin App is a standard react app,
      ***fully customizable*** use GenAI Vibe tools and/or your IDE.

      * With minimal background on html, javascript etc, you can begin using Vibe/Natural Language tools to create custom User Interfaces 
      
      Contrast this to the [*automated* Admin App](Admin-Tour.md){:target="_blank" rel="noopener"}, which focuses on speeed and simplicity.
      
      It provides:
      
      | Feature  | Provides         | Example         |
      |:---------------------------|:-----------------|:-------------------------------------------------------------------------------|
      | Multi-Page | List/Show pages for each table<br>Built-in **search, sort, export**    | Customer Page, Order Page, etc | 
      | Multi-Table | **Tab Sheet** for related child data <br>**Page Transitions** for related data | Customer page has OrderList<br>Click --> Order/OrderDetails | 
      |             | **Automatic Joins** for Parent Data    | Product _Name_ - not just the Id | 
      |             | **Lookups** for foreign keys    | Find Product for OrderDetail | 
      | Customize | Use GenAI Vibe tools and/or your IDE   | Add new pages, controls, etc | 

      > See status, at end.


<br>

## Generation

Once your project is created, you can create a UI Application like this (e.g., use the Terminal Window of your project):

```bash
als genai-app
cd react-admin
npm install
npm start
```

## Generated App

The GenAI process uses these to drive creation:

1. You projects' `ui/admin/admin.yaml` [(click here)](Admin-Architecture.md#appendix-sample-adminyml){:target="_blank" rel="noopener"}, which provides information about the schema and basic layout
2. [Admin-App-Learning](Admin-App-Learning.md){:target="_blank" rel="noopener"} 

It creates applications like this:

![genai-app-run](images/ui-vibe/genai-app-created.png)

<br>

## Running App

The running app looks like this:

![genai-app-run](images/ui-vibe/genai-app-run.png)

<br>

## Appendix: Status

As of June 17 2025, this is **under construction**.  Please contact us at `support@genai-logic.com` for more information and early access.  We are actively seeking collaboration.

ToDo:

* Grid for multi-field rows on `show` page
* Validation errors
* Security
* Use standard dataProvider

