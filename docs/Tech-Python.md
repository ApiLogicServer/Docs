I quite like Python.  I've used assembler, PL/1, and Java.  Python (particularly with good IDEs) is my favorite.

Though, there were some surprises I wish I'd been told about.  So, here you go.

&nbsp;

## Python and ApiLogicServer

Using ApiLogicServer means you'll be looking at **levels of Python use:**

1. **Automation:** automated project creation eliminates all the fiddly configuration required to build a web app -- without any Pyton at all

2. **Python as a DSL:** declarative logic and the admin app require minimal Python - it's really a Domain Specific Language using Python keyword arguments and IDE code complation

3. **Python as a 4GL:** creating custom endpoints requires Python at it's simplest level, particuarly when coupled with a moder IDE.

4. **Full Python:** it's important that there are no restrictions on using full power of Python - classes, exceptions, etc.  In normal cases, this is probably less than 5 or 10% of the project.

&nbsp;

## Basics

You'll discover these soon enough:

1. Indents vs. braces - obvious, but the real implication is that _you need an IDE_, because they keep track of indents (vs. spaces).  I've used PyCharm and VSCode, both are wonderful: great editors, debuggers.

2. Non-typed - well-known, but you can (should) use [Type Hints](https://docs.python.org/3/library/typing.html){:target="_blank" rel="noopener"}
 for clarity, and code completion.

3. CLI - Python includes great tools for making Command Line Interfaces, like __Click__.  A little fiddly, you might want to have a look at [these examples](https://github.com/valhuber/ApiLogicServer/blob/main/api_logic_server_cli/cli.py){:target="_blank" rel="noopener"}
 (near the end), which uses __ArgParse__.

4. Modules - are not packages.  There is a magic file `__init.py__` that makes a directory into a module.

5.  Key Data Structures

    * [Dict - keyword/value](https://www.w3schools.com/python/python_dictionaries.asp){:target="_blank" rel="noopener"}; easy to convert to json (for rest response)  -- ordered, [`for each_key, each_value in thisdict.items():`](https://www.w3schools.com/python/gloss_python_loop_dictionary_items.asp){:target="_blank" rel="noopener"}

    * [List - ordered list](https://www.w3schools.com/python/python_lists.asp){:target="_blank" rel="noopener"} -- `for each_item in list`

    * [Tuple - set of values](https://www.w3schools.com/python/python_tuples.asp){:target="_blank" rel="noopener"}

&nbsp;

### Using the `Debug Console`

A truly wonderful by-product of having an interpreter is that you issue language commands - in the context of the currently running program.  Your IDE supports this; use it at breakpoints to:

1. Evaulate expressions
2. Test methods
3. Explore objects, and their APIs - I have saved days of time using API discovery

&nbsp;

## Pip, environments and PythonPath

Pip is how to load libraries (packages) - not by setting up folder.  It's great, but quickly leads to Pyton's version of "DLL Hell" where libraries interfere from different projects.  So, the best practice is to set up [Virtual Environments](https://docs.python.org/3/library/venv.html?highlight=virtual%20environment){:target="_blank" rel="noopener"}
.

A related issue is loading classes / modules at runtime.  Be clear on your `PythonPath`.  And, be aware the some IDEs (PyCharm is one) provide super-friendly support to simplify things by setting this automatically.  Which is nice, until you discover that a program that runs in the IDE fails outside it.  Days of fun.

&nbsp;

## Import is a 4 letter word

Oy, where do I start.

&nbsp;

### Executable - non-class code runs on import

First, imports are executable... so what does _that_ mean.

* The key underlying fact is that Python does not require all code to be in a class.  

* On import, all the non-class/function code ___actually runs___.  It is not just setting up paths.

* If you want to know whether your module was run (directly) or imported, use:

```python title="determine run directly vs. import"
if __name__ == '__main__':   # prounounced:   "dunder name" == "dunder main"
    pass  # I was run directly
else:
    pass  # I was imported
```

&nbsp;

### Imports often fail to compile

> Note: import compile failures and circular imports are unlikely to be issues for API Logic Server projects, since these are created correctly.  The following alerts are for using full Python for complex requirements.

I still do not understand where Python and the IDE figure out what I can import.  You'll find lots of Stack Overflow articles on imports (e.g., sibling imports).

For me, it usually degenerates into a trial and error exercise.

* You might find [sibling imports](https://github.com/valhuber/SiblingImports){:target="_blank" rel="noopener"}
 a useful project to fiddle with.

* You can also see many import examples in the created project.

Note that imports often require a "module", which means you create a (usually empty) file called `__init.py__`.

&nbsp;

### Circular Imports

I understand that Python's 1-pass nature means your imports have to be in a certain order to work.  I have spent days battling this.  I hope you have better luck, but at least you have a heads up.  As always, introduce changes in small numbers to avoid having lots of potential problems.

&nbsp;

## Mac Installs

If you like imports, you'll love Mac installs.

Way back when, Apple installed Python.  Python 2.  Which is very old - Python3 is now the standard.

But Mac was stuck with Python == Python2.  Which probably gets you the wrong version.

I guess as folks dealt with this, there arose many ways of installing - brew, the Python installer, maybe others.

And that was further compounded by alternate ways of running Pip, things like `venv`.

As I flailed, I tried many of them.  The end result was that I finally concluded I did not know what I was running.

So, and __I hope you avoid this__, I wound having to re-install my computer.  Just wow.

Where I wound up was simple:

* stick with the Python.org installer
* I am not using `venv` or `pip` directly; I use them with Python(3) so I know they are consistent:

```
python3 -m venv venv  # of course, it *might* be Python, not Python3 (!)
python3 -m pip install ApiLogicServer
```

## Debugging

Python is very well supported by modern IDEs, with code completion, syntax checking, docstrings, and the debugger.

In addition to expected debug support (break, inspect, step, watch etc), Python's fully interpretive nature means you can enter Python code while the program is running.  This enables you to test expressions etc.  See, for example, the `Debug Console` in VSCode.