!!! pied-piper ":bulb: TL;DR - Executable Test Suite, Documentation"

      You can optionally use the Behave test framework to:

      1. **Capture Requirements as Tests:** Use Behave in your IDE to capture requirements as executable tests. Behave is based on Behavior Driven Design, so your requirements are phrased as tests that can be understood by both technical and business users.
      
      2. **Run Automated Test Suite:** Create Python code to execute tests. You can then execute your entire test suite with a single command.

      3. **Generate Requirements and Test Documentation:** Create wiki reports that document your requirements and the tests (**Scenarios**) that confirm their proper operation.

         * **Integrated Logic Documentation:** Reports integrate your declarative logic, showing rules and their execution traces. This makes logic transparent to business users and supports Agile Collaboration.

      For an Agile approach to using Behave, see [Logic Tutorial](Logic-Tutorial.md).

&nbsp;&nbsp;

# Why Testing Matters

Experienced professionals advocate comprehensive test suites for answering critical questions:

|   Key Question    | Best Practice   |
:-------|:-----------------|
| What is the formal definition of the system's functionality? | The test suite defines the functionality |
| Is the system ready to go-live? | The test suite passes |
| Did my maintenance change break something? | Run the test suite |
| How do the declarative rules actually execute? | Logic logs show execution traces |

## Testing Frameworks

API Logic Server does not dictate any particular framework. You can use popular frameworks such as:

- **`pytest`** - Modern, feature-rich testing framework (recommended)
- **`unittest`** - Python's built-in testing framework
- **`behave`** - BDD framework with built-in documentation generation (described here)

We use all three internally for different purposes.

&nbsp;

## The Behave Framework

**Behave** is particularly useful because it:

1. Uses natural language (Gherkin) for test definitions - readable by business users
2. Automatically generates documentation from tests
3. Integrates logic execution traces into reports
4. Supports Behavior Driven Development (BDD) workflows

![behave-summary](images/behave/behave-summary.png)

[Behave](https://behave.readthedocs.io/en/stable/tutorial.html) is a framework for defining and executing tests based on [BDD (Behavior Driven Development)](http://dannorth.net/introducing-bdd/), an Agile approach for defining system requirements as executable tests.

&nbsp;

# Using Behave - Quick Start

![tdd-ide](images/behave/TDD-ide.png)

Behave is pre-installed with API Logic Server. The typical workflow:

1. **Create `.feature` files** - Define test ***Scenarios*** (tests) for ***Features*** (stories) in natural language

2. **Code `.py` files** - Implement the scenario steps in Python

3. **Run Test Suite** - Execute all scenarios with Launch Configuration `Behave Run`

4. **Generate Report** - Create documentation with Launch Configuration `Behave Report`

The following sections provide detailed guidance for each step.

&nbsp;&nbsp;

## 1. Create `.feature` Files to Define Scenarios

Feature files use Gherkin syntax - a business-readable, domain-specific language that lets you describe software behavior without detailing implementation.

**Example:**
```gherkin
Feature: Order Processing with Business Logic

  Scenario: Good Order Placed
    Given Customer "Alice" with balance 0 and credit limit 1000
    When B2B order placed for "Alice" with 5 Widget
    Then Customer "Alice" balance should be 450
    And Order amount_total should be 450
    And Item amount should be 450
```

**Best Practices:**

- Use **Given** for setup/preconditions
- Use **When** for the action being tested  
- Use **Then/And** for assertions
- Write scenarios that business users can understand
- Keep scenarios focused on one behavior

Feature files are stored in `features/` directory with `.feature` extension.

&nbsp;&nbsp;

## 2. Implement Test Steps in Python

Each scenario step maps to a Python function using decorators like `@given`, `@when`, `@then`.

**Example Implementation:**
```python
from behave import given, when, then
import requests

@given('Customer "{name}" with balance {balance:d} and credit limit {limit:d}')
def step_impl(context, name, balance, limit):
    # Create test customer via API
    unique_name = f"{name} {int(time.time() * 1000)}"  # Unique for repeatability
    response = requests.post(
        f'{BASE_URL}/api/Customer/',
        json={"data": {"attributes": {
            "name": unique_name,
            "balance": balance,
            "credit_limit": limit
        }}}
    )
    context.customer_id = int(response.json()['data']['id'])
    context.customer_map = {name: {'id': context.customer_id, 'unique_name': unique_name}}
```

**Key Implementation Points:**

1. **Link scenarios with `@when/@given/@then` decorators** - Behave matches scenario text to these patterns

2. **Use `test_utils.prt()` for logic logging:**
   ```python
   scenario_name = context.scenario.name
   test_utils.prt(f'\n{scenario_name}\n', scenario_name)  # 2nd arg drives log filename
   ```

3. **Add docstrings for documentation** (optional but recommended):
   ```python
   @when('B2B order placed for "{customer}" with {qty:d} {product}')
   def step_impl(context, customer, qty, product):
       """
       Phase 2 test: Uses OrderB2B custom API.
       Creates complete order with items in single transaction.
       """
       scenario_name = context.scenario.name
       test_utils.prt(f'\n{scenario_name}\n', scenario_name)
       # ... implementation
   ```

4. **Store context for later steps:**
   ```python
   context.order_id = order_id
   context.customer_map[customer_name] = {'id': customer_id}
   ```

5. **Use unique test data** (see Rule #0 in `docs/training/testing.md`):
   ```python
   unique_name = f"TestCustomer {int(time.time() * 1000)}"
   ```

Step implementations are stored in `features/steps/` directory with `*_steps.py` naming pattern.

&nbsp;&nbsp;

## 3. Run Test Suite

### Prerequisites

**The server must be running!** Start it first:

```bash
# Option 1: Run with debugger
# Use Launch Configuration "ApiLogicServer"

# Option 2: Run without debugger (faster, doesn't restart on code changes)
python api_logic_server_run.py
```

### Running Tests

```bash
# Run all scenarios
python test/api_logic_server_behave/behave_run.py --outfile=logs/behave.log

# Or use Launch Configuration: "Behave Run"
```

**Test Execution Options:**

- **Run all tests:** `Behave Run` Launch Configuration
- **Run single scenario:** `Behave Scenario` Launch Configuration  
- **Windows users:** Use `Windows Behave Run` if needed
- **Debugging:** Set breakpoints in your step implementations

**Output Files:**

- `logs/behave.log` - Test results summary
- `logs/scenario_logic_logs/*.log` - Logic execution traces per scenario

&nbsp;&nbsp;

## 4. Generate Documentation Report

After running tests, generate the wiki-style report:

```bash
cd test/api_logic_server_behave
python behave_logic_report.py run

# Or use Launch Configuration: "Behave Report"
```

**Generated Report Includes:**

- ✅ All features and scenarios  
- ✅ Test results (pass/fail)
- ✅ **Logic execution traces** - Shows exactly which rules fired
- ✅ **Rules used** - Summary of rules involved
- ✅ Expandable logic detail sections
- ✅ Docstring documentation (if provided in steps)

The report is generated at: `reports/Behave Logic Report.md`

&nbsp;&nbsp;

## 5. Testing Best Practices

### Test Repeatability (Rule #0)

**CRITICAL:** Tests modify the database. Always create fresh test data with timestamps:

```python
# ❌ WRONG - Reuses contaminated data
customer = requests.get(f'/api/Customer/?filter[name]=Bob').json()['data'][0]

# ✅ CORRECT - Always creates fresh data
unique_name = f"Bob {int(time.time() * 1000)}"
response = requests.post(f'/api/Customer/', json={...})
```

See `docs/training/testing.md` for comprehensive testing patterns and common pitfalls.

### Optimistic Locking Considerations

When testing with optimistic locking enabled, set `PYTHONHASHSEED=0` for repeatable test execution.

See [API Optimistic Locking Testing](API-Opt-Lock.md#testing-and-pythonhashseed){:target="_blank" rel="noopener"} for details.

### Step Ordering (Rule #0.5)

Behave matches steps by FIRST pattern that fits. Always order from **most specific → most general**:

```python
# ✅ CORRECT ORDER
@when('Order for "{customer}" with {qty:d} carbon neutral {product}')  # Most specific
@when('Order for "{customer}" with {q1:d} {p1} and {q2:d} {p2}')     # More specific
@when('Order for "{customer}" with {qty:d} {product}')                # General

# ❌ WRONG - General pattern matches everything first!
```

Use `python check_step_order.py` to verify correct ordering.

&nbsp;&nbsp;

## Troubleshooting

### Tests Not Showing in Report

**Problem:** Scenarios appear in report but without logic traces.

**Solution:** Ensure `test_utils.prt(scenario_name, scenario_name)` is called in your `@when` step implementation.

### Logic Logs Empty

**Problem:** `logs/scenario_logic_logs/` files are empty or missing.

**Solution:** 
1. Verify server is running before tests
2. Check that `test_utils.prt()` second argument matches scenario name exactly
3. Ensure scenario names don't exceed 26 characters (gets truncated)

### Test Repeatability Issues

**Problem:** Tests pass first run, fail on second run.

**Solution:** Use timestamps in test data names: `f"Customer {int(time.time() * 1000)}"`

See Rule #0 in `docs/training/testing.md` for comprehensive guidance.

&nbsp;&nbsp;

## Advanced Topics

### Phase 1 vs Phase 2 Testing

- **Phase 1 (CRUD):** Test individual operations (POST, PATCH, DELETE) for granular rule testing
- **Phase 2 (Custom APIs):** Test complete business transactions using custom API endpoints

See `docs/training/testing.md` for the complete decision tree.

### Custom API Testing

When testing custom business APIs (e.g., OrderB2B), remember to include both `"method"` and `"args"` in the meta object:

```python
{
    "meta": {
        "method": "OrderB2B",  # ← REQUIRED!
        "args": {
            "data": { ... }
        }
    }
}
```

### Debugging Tests

1. Set breakpoints in step implementations
2. Use `Behave Scenario` to run single test
3. Check `logs/behave.log` for test execution details
4. Review `logs/scenario_logic_logs/*.log` for logic traces

&nbsp;&nbsp;

## Additional Resources

- **Complete Testing Guide:** `docs/training/testing.md` (1755 lines of AI training material)
- **Behave Official Docs:** [behave.readthedocs.io](https://behave.readthedocs.io/en/stable/tutorial.html)
- **BDD Introduction:** [Introducing BDD](http://dannorth.net/introducing-bdd/)
- **API Logic Server Docs:** [apilogicserver.github.io/Docs](https://apilogicserver.github.io/Docs/)

&nbsp;&nbsp;

3. Run Test Suite: Launch Configuration `Behave Run`.  This runs all your Scenarios, and produces a summary report of your Features and the test results.

4. Report: Launch Configuration `Behave Report` to create the wiki file shown [here](Behave-Logic-Report.md){:target="_blank" rel="noopener"}.

These steps are further defined, below.  Explore the samples in the sample project.

&nbsp;&nbsp;

## 1. Create `.feature` file to define Scenario

Feature (aka Story) files are designed to promote IT / business user collaboration.  

&nbsp;&nbsp;

## 2. Code `.py` file to implement test

Implement your tests in Python.  Here, the tests are largely _1. read existing data_, _2. run transaction_, and _3. test results_, using the API.  You can obtain the URLs for reading/updatind data from the swagger.

Key points (see items 2.1, 2.2 etc in the diagram above):

1. Link your scenario / implementations with `@when` annotations, as shown for _Order Placed with excessive quantity_.

2. Optionally, include a ___Python docstring___ on your `@when` implementation as shown above, delimited by `"""` strings (see _"Familiar logic pattern"_ in the screen shot, above). If provided, this will be written into the wiki report.

3. Important: the system assumes the line following the docstring identifies the `scenario_name`; be sure to include it.

4. Include the `test_utils.prt()` call; be sure to use specify the scenario name as the 2nd argument.  This is what drives the name of the Logic Log file, discussed below.

&nbsp;&nbsp;

## 3. Run Test Suite: Launch Configuration `Behave Run`

You can now execute your Test Suite.  Run the `Behave Run` Launch Configuration, and Behave will run all of the tests, producing the outputs (`behave.log` and `<scenario.logs>` shown above.

* Windows users may need to run `Windows Behave Run`

* You can run just 1 scenario using `Behave Scenario`

* You can set breakpoints in your tests

The server must be running for these tests.  Use the Launch Configuration `ApiLogicServer`, or `python api_logic_server_run.py`.  The latter does not run the debugger, which you may find more convenient since changes to your test code won't restart the server.

&nbsp;&nbsp;

## 4. Report: Launch Configuration `Behave Report'

Run this to create the wiki reports from the logs in step 3.


## 5. Testing considerations

Please [see here](API-Opt-Lock.md#testing-and-pythonhashseed){:target="_blank" rel="noopener"} for important considerations on optimistic locking and testing.