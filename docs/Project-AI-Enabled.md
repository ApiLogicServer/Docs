!!! pied-piper ":robot: Every Project Comes Pre-Configured for AI Assistance"

    Every project created by GenAI-Logic includes comprehensive training materials, readme's with code examples, and integration points that work seamlessly with GitHub Copilot, Claude, ChatGPT, and other AI assistants.

    Your project includes `.github/.copilot-instructions.md`, AI training documents (`docs/training`), and working code examples that serve as a ***"message in a bottle"*** for AI assistants.

    No more explaining your project structure from scratch - AI assistants can immediately understand your codebase and underlying software to help you build features.

    AI assistants can help you add business logic rules, customize APIs, create test scenarios, and integrate with external services.

    They also provide an AI Guided Tour, where an intelligent AI Assistant introduces you to the key concepts of GenAI-Logic.

&nbsp;

This page describes:

• what makes your project AI-enabled out of the box  
• the training materials included as your "message in a bottle"  
• how to get started with AI assistance  
• the AI-friendly workflows built into every project  

&nbsp;

## AI-Enabled Projects

When you open a project, activate the AI Assitant:

![AI-Enabled Projects](images/ui-vibe/assistant/copilot-hello.png)


When you create a new project with `genai-logic create`, you're not just getting a basic API and admin interface. Each project is thoughtfully designed to be **AI-friendly** from day one.

&nbsp;

### 🛠️ Main Capabilities

As shown above, your AI-enabled project includes these key capabilities:

✅ **Run the Project** - F5 or `python api_logic_server_run.py`  
✅ **Add Business Logic** - Declarative rules with 44x code reduction  
✅ **Create Custom APIs** - B2B integration with natural language  
✅ **Customize Data Models** - Schema modifications, derived attributes  
✅ **Automated Testing** - Behave framework with logic traceability  
✅ **Security & Authentication** - Multiple providers, role-based access  
✅ **React App Generation** - Complete frontend creation  
✅ **MCP Client Integration** - Model Context Protocol support  
✅ **Admin UI Customization** - YAML-driven configuration  
✅ **Events & Triggers** - Advanced business logic scenarios  

&nbsp;

### 🤖 Built-in AI Guidance

Your project includes comprehensive training materials that serve as a "message in a bottle" for AI assistants:

1. **`.github/.copilot-instructions.md`** - this is the "message in a bottle" that enabled your AI Assitant to understand GenAI-Logic projects, and deliver the services above
2. **`docs/training/`** - AI training documents with detail examples and patterns
3. **`readme.md`** - Project overview with quick start instructions
4. **Code examples** - real working examples in the `readme's` throughout the project

&nbsp;

### 🧠 Context-Aware Architecture

The project structure itself provides rich context for AI understanding:

• **Declarative logic patterns** in `logic/declare_logic.py`  
• **API endpoint examples** with SQLAlchemy models  
• **Test scenarios** that demonstrate business requirements  
• **Integration templates** for common patterns  

&nbsp;

### 💡 AI-Friendly Workflows

Your project supports natural AI-assisted development:

• **Natural language to business rules** - Describe requirements, get executable logic  
• **Automated testing** - Behave scenarios that serve as living documentation  
• **Code completion** - Rich type hints and patterns for IDE assistance  
• **Documentation generation** - Self-documenting APIs and logic  

&nbsp;

## Training

There are important resources to help you get started.


&nbsp;

### 🎓 AI Guided Tour

It's been clear for quite some time that lab-based training was far superior to *death by powerpoint*.  But running labs is not simple - it usually requires in-person expertise to deal with inevitable problems.

AI enables us to put a "message in a bottle" - an AI tutor that can walk you through the tutorial, and, unlike a readme, support you:

* answer questions ("*how do I customize this*")
* get you unstuck (*"ah, you forgot to start the server"*)

Key aspects of the tour:

* *Provocation-based* learning (not instruction)
* *Hands-on* discovery (doing, not reading)
* AI as companion *during* the lab (not before/after)

The tour begins in the [manager](Manager.md), which encourages you to create the basic demo.  That creates the `basic_demo` project, which provides a special readme to start the tour:

![tour](images/ui-vibe/assistant/sample-basic-tour.png)

&nbsp;


> Ed: this was an interesting technical problem - AI prefers to be reactive (not driving a tutorial), and make decisions about 'that seems to be working'.  We needed it to be proactive and not skip steps - to act outside its comfort zone.  To read more, [click here](Tech-AI-Tutor.md).

&nbsp;

### 🚀 Quick Reference `readmes`

Each project includes working examples (see various `readme` files within the project) you can build upon:

• Pre-configured rules demonstrating common business patterns  
• Sample API calls with proper request/response formats  
• Test data and scenarios for immediate experimentation  
• Integration hooks for external services  

&nbsp;

### 🎯 Next Steps

To find more:

• [Logic Guide](Logic/) - Learn about declarative business rules  
• [API Documentation](API/) - Understand your auto-generated API  
• [Testing Guide](Behave/) - Write and run business scenarios  
• [Sample Projects](Sample-Database/) - Explore working examples  

Your AI-enabled project is ready to evolve with your needs. Just describe what you want, and let AI help you build it! 

