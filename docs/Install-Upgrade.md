!!! pied-piper ":bulb: TL;DR - Upgrade genai-logic using pip, and the Manager"

    Upgrading GenAI-Logic to a new version requires that you 
    
    * Update the software and associated libraries (updates your `venv`), and
    * Manager contents for new Prompt/Context Engineering.


## Upgrade Instructions

```bash title="Upgrade GenAI-Logic to new version"
cd ~/dev/genai-logic                   # your install location
. venv/bin/activate                    # windows: venv\Scripts\activate 
pip install --upgrade ApiLogicServer
genai-logic start --clean              # this does not delete your projects
```