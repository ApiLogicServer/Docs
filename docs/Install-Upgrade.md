!!! pied-piper ":bulb: TL;DR - Upgrade genai-logic using pip, and the Manager"

    Upgrading GenAI-Logic to a new version requires that you update the libraries, and the Manager contents for new Prompt/Context Engineering.


## Software Upgrade

```bash title="software upgrade"
cd ~/dev/genai-logic
. venv/bin/activate                    # windows: venv\Scripts\activate 
pip install --upgrade ApiLogicServer
genai-logic start --clean              # this does not delete your projects
```