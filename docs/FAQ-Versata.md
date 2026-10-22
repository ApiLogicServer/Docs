!!! pied-piper ":bulb: TL;DR - Is This Like Versata"

      Versata was a major innovator for business rules on J2EE.  We believe GenAI-Logic is a superior approach, because:

      1. **IDE as Studio:** Pre-IDEs, the Versata Studio presented challenges in debugging, source control, etc.  
      
         * ***GenAI-Logic uses your IDE*** (debugger, source control), and deploys with standard containers.
      
      2.  **Open Client:** While rules were effective, some clients found it difficult to achieve the look and feel they desired.  
      
         * In addition to an instant automatic client, ***GenAI-Logic provides open APIs*** that work with any client.

      Versata provided remarkable value, made compelling by "riding the J2EE wave".  Like Versata, GenAI-Logic is riding waves of interest:

      * **GenAI**
      * **MCP**
      * **Vibe**

      For more information, [click here](https://www.genai-logic.com/why-genai-logic/join-the-ai-party){:target="_blank" rel="noopener"}.
&nbsp;

---

## What does Versata tell us about rules at scale?

A fair question about any rules approach: it works on a small example, but what happens with hundreds of rules?

The rule types here (sum, count, formula, copy, constraint, and events) have the same semantics as the rules Versata ran in production, so Versata's experience is a reasonable guide to what to expect.  That is an inference, not a measurement of this product.

At Versata we measured it with an Automation Analyzer, run across several dozen production enterprise systems.  It reported how much of each system's logic was declared as rules, and how much was custom code.  The result: **94-97% rules, 3-6% custom code.**  Rule counts ran on the order of a dozen rules per table.

This was not a limit.  Developers could write custom code anywhere, and chose rules for almost all of it.  The custom code typically handled integration adapters, complex multi-step workflows, custom reporting, and business-specific algorithms.  That is where custom code belongs.

What this does and doesn't say:

- It says rules were not a niche tool; they carried nearly all of the logic in real, large systems.
- It does not say the same percentages will hold for any given project here.  Events and handlers in GenAI-Logic are Python, and the [Requirements Traceability Report](Behave-Logic_Report-bd-eai.md) counts them separately from the declarative rules, so you can see the split for your own system.
