!!! pied-piper ":bulb: TL;DR - Rebuild Test Data"

Proper rule operation requires existing data be correct - see [Data ModelD esign](Data-Model-Design){:target="_blank" rel="noopener"}.

ChatGPT sometimes fails to properly compute the tests data.  You can rebuild your test data to match the derivation rules by using `genai-utils --rebuild-test-data`.


## Overview
Basic operation:

1. Builds database/test_data/test_data.py from docs/response.json
2. Runs it to create database/test_data/db.sqlite
3. Copies database/test_data/db.sqlite to database/db.sqlite

&nbsp;

## Example

Fixes project issues by rebuilding the database to conform to the derivation rules:

1. Create genai_demo: `als genai --using=system/genai/examples/genai_demo/genai_demo.prompt --project-name=genai_demo`
2. Rebuild:
```
cd genai_demo
als genai-utils --rebuild-test-data
```

&nbsp;
