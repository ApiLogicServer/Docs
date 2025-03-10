!!! pied-piper ":bulb: TL;DR - Fixup Missing Attributes"

    When adding rules, such as using suggestions, you may introduce new attributes.
    If these are missing, you will see exceptions when you start your project.
    
    The `genai-utils` fixes such project issues by updating the Data Model and Test Data:

    1. Collects the latest model, rules, and test data from the project. 
    2. Calls ChatGPT (or similar) to resolve missing columns or data in the project.
    3. Saves the fixup request/response under a `docs/fixup` folder.
    4. You then use this to create a new project

## Using Fixup

Fixes project issues by updating the Data Model and Test Data.
When adding rules, such as using suggestions, you may introduce new attributes.
If these are missing, you will see exceptions when you start your project.

The `genai-utils --fixup` fixes such project issues by updating the Data Model and Test Data:

1. Collects the latest model, rules, and test data from the project. 
2. Calls ChatGPT (or similar) to resolve missing columns or data in the project.
3. Saves the fixup request/response under a 'fixup' folder.
4. You then use this to create a new project

This procedure is available in the Manager README (see *Explore Creating Projects > Fixup - update data model with new attributes from rules*).

&nbsp;

### Setup
After starting the [Manager](Manager.md){:target="_blank" rel="noopener"}: 

```bash title="0. Create Project Requiring Fixup"
# 0. Create a project requiring fixup
als genai --using=genai_demo.prompt --repaired-response=system/genai/examples/genai_demo/genai_demo_fixup_required.json --project-name=genai_demo_fixup_required
```

If you run this project, you will observe that it fails with:
```bash
Logic Bank Activation Error -- see https://apilogicserver.github.io/Docs/WebGenAI-CLI/#recovery-options
Invalid Rules:  [AttributeError("type object 'Customer' has no attribute 'balance'")]
Missing Attrs (try als genai-utils --fixup): ['Customer.balance: constraint']
```
&nbsp;

### Fixup
To Fix it:
```bash title="1. Run FixUp to add missing attributes to the fixup response data model"
# 1. Run FixUp to add missing attributes to the data model
cd genai_demo_fixup_required
als genai-utils --fixup
```

Finally, rebuild the project:
```bash title="2. Rebuild the project from the fixup response data model"
# 2. Rebuild the project from the fixup response data model
cd ../
als genai --using=genai_demo.prompt --repaired-response=genai_demo_fixup_required/docs/fixup/response_fixup.json
```

> Fixup does not update your `ui/admin/admin.yaml`; you can update it manually.
    
&nbsp;
