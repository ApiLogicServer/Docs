!!! pied-piper ":bulb: TL;DR - Debugging Logic"

    Debug rules using system-generated logging and your IDE debugger.

&nbsp;

## Using the debugger

Use the debugger as shown below.  Note you can stop in lambda functions.

![Logic Debugger](images/logic/logic-debug-cc.png) 

&nbsp;

## Logic Log

Logging is performed using standard Python logging, with a logger named `logic_logger`.  Use `info` for tracing, and `debug` for additional information (e.g., all declared rules are logged).

In addition, the system logs all rules that fire, to aid in debugging.  Referring the the screen shot above:

*   Each line represents a rule execution, showing row state (old/new values), and the _{reason}_ that caused the update (e.g., client, sum adjustment)
*   Log indention shows multi-table chaining



