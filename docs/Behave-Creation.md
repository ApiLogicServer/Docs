!!! pied-piper ":bulb: TL;DR - Executable Test Suite, Documentation"

      As of 15.01.18, you can create Behave tests from declarative rules, execute test suites, and generate automated documentation with complete logic traceability.  The tests focus on dependencies discovered from logic, and use the API to run run transactions and test for expected results.  
      
      **Important:** 
      
      1. tests update your database
      2. tests can be re-sun

&nbsp;&nbsp;

This guide explains how to create Behave tests from declarative rules, execute test suites, and generate automated documentation with complete logic traceability.

## Overview: Behave BDD Testing Framework

[Behave](https://behave.readthedocs.io/en/stable/tutorial.html) is a framework for defining and executing tests based on [TDD (Test Driven Development)](http://dannorth.net/introducing-bdd/), an Agile approach for defining system requirements as executable tests.

**The Key Innovation:** Behave tests in API Logic Server create **living documentation** that connects:

1. Business Requirements (Features)
2. Test Scenarios (Given/When/Then)
3. Test Implementation (Python code)
4. **Declarative Rules** (the actual business logic)
5. **Execution Trace** (Logic Log showing which rules fired)


## Explore with basic_demo

Use basic_demo to explore:

1. Open the Manager
2. Create basic_demo: `genai-logic create --project_name=basic_demo --db_url=sqlite:///samples/dbs/basic_demo.sqlite`
3. Add logic

  * Open the project, and establish your virtual environment
  * Add rules: `gail add-cust`
  
4. Use your AI Assistant: `Create Logic`


## Prerequisites and Configuration

### Critical: Security Configuration

**Tests must match the project's security settings** defined in `config/default.env`:

```bash
# In config/default.env
SECURITY_ENABLED = false  # or True
```

**The test framework automatically adapts:**

- `test_utils.login()` returns empty headers `{}` when `SECURITY_ENABLED = false`
- `test_utils.login()` authenticates and returns token headers when `SECURITY_ENABLED = True`

**Common Bug:** Tests fail with `405 Method Not Allowed` on `/auth/login`

- **Cause:** Server running without security, but tests expect security enabled (or vice versa)
- **Solution:** Check `config/default.env` - ensure `SECURITY_ENABLED` matches how server was started
- **Test Location:** Behave runs from `test/api_logic_server_behave/` and logs found in `logs/behave.log`

### Test Data Requirements

Tests require specific database state:

1. **Document test data** in `TEST_SUITE_OVERVIEW.md` or feature file comments
2. **Restore data** after test runs (tests should be idempotent)
3. **Seed database** with known customer IDs, product IDs, order IDs before first run

**Example:** If testing Customer balance rules, document:
```
Test Data Used:

- Customer: CUST-1 (balance 0, credit_limit 1000)
- Product: PROD-A (unit_price 5.00)
- Order: ORD-1 (customer CUST-1, not shipped)
```

### Running the Server

Before running tests, start the API Logic Server:

**Option 1: VS Code Launch Configuration**

- Use **"ApiLogicServer"** launch config
- Respects `config/default.env` settings

**Option 2: Command Line**
```bash
python api_logic_server_run.py
```

**Verify server is running:**
```bash
curl http://localhost:5656/api/Customer/
```


## Executing Tests

### Run Test Suite

Use Launch Configuration **"Behave Run"** (or **"Windows Behave Run"** on Windows):

```bash
# Or from terminal:
cd test/api_logic_server_behave
behave
```

**Output:**

- `logs/behave.log` - Test execution summary
- `logs/scenario_logic_logs/<scenario>.log` - Logic execution trace for each scenario

**Prerequisites:**
- Server must be running (use "ApiLogicServer" launch config or `python api_logic_server_run.py`)

### Run Single Scenario (Debug)

Use Launch Configuration **"Behave Scenario"** - useful for:

- Debugging specific tests
- Setting breakpoints in test code
- Iterating on test development

## Generating Documentation

### Create Behave Logic Report

Run Launch Configuration **"Behave Report"**:

```bash
# Or from terminal:
cd test/api_logic_server_behave
python behave_logic_report.py run
```

**Output:**
- `reports/Behave Logic Report.md` - Complete wiki documentation

**What Gets Generated:**

1. **Test Results** - All scenarios with pass/fail status
2. **Logic Documentation** - Docstrings from `@when` steps
3. **Rules Used** - Which declarative rules fired during each scenario
4. **Logic Log** - Detailed execution trace showing rule chaining

### Example Output

```markdown
### Scenario: Good Order Custom Service
  Given Customer Account: ALFKI
  When Good Order Placed
  Then Logic adjusts Balance (demo: chain up)

<details>
**Logic Doc** for scenario: Good Order Custom Service
  Place an order with multiple items.
  This tests the complete dependency chain:
  - OrderDetail.UnitPrice copied from Product.UnitPrice
  - OrderDetail.Amount = Quantity * UnitPrice
  ...

**Rules Used** in Scenario:
  Rule.copy(OrderDetail.UnitPrice from Product.UnitPrice)
  Rule.formula(OrderDetail.Amount = Quantity * UnitPrice)
  Rule.sum(Order.AmountTotal from OrderDetail.Amount)
  Rule.sum(Customer.Balance from Order.AmountTotal)

**Logic Log** in Scenario:
  Logic Phase: ROW LOGIC
  ..OrderDetail[1040] {Insert - client}
  ....OrderDetail.UnitPrice [None-->18.0000000000] (copy from Product.UnitPrice)
  ....OrderDetail.Amount [None-->18.0000000000] (formula: Quantity * UnitPrice)
  ......Order.AmountTotal [1086-->1104] (sum OrderDetail.Amount)
  ........Customer.Balance [2102-->2120] (sum Order.AmountTotal)
</details>
```

## Requirements Traceability

The Behave Logic Report provides complete traceability:

```
Business Requirement (Feature)
  ↓
Test Scenario (Given/When/Then)
  ↓
Test Implementation (Python code)
  ↓
Declarative Rules (5 lines)
  ↓
Execution Trace (Logic Log)
```

**This solves the traditional problem:**
- **Before:** Requirements → Code (opaque, 200+ lines)
- **Now:** Requirements → Tests → Rules → Trace (transparent, 5 lines)

The **44X advantage** extends to testing:
- Tests are simple API calls
- Business logic verified by checking which rules fired
- Complete audit trail from requirement to execution
- Living documentation auto-generated from test runs


## Internals

Training instruction for the AI Assistant (e.g., Copilot) is included in your project at `docs/training/testing.md`.  It is usually discovered by the Best Practice to load `.github/.copilot-instructions.md` when opening the project.

---

## Summary

**Creating tests from rules provides:**

1. **Correctness verification** - Ensures rules work as intended
2. **Dependency chain validation** - Tests transitive effects (Product → Item → Order → Customer)
3. **Foreign key change testing** - Verifies old/new parent adjustments (the "missed bugs")
4. **Automated documentation** - Living documentation with complete traceability
5. **Regression prevention** - Executable test suite protects against future breaks

**The key insight:** Declarative rules make testing **dramatically simpler** because:

- Tests focus on "what" not "how"
- Rule execution is logged automatically
- Dependency chains are traced automatically
- Complete audit trail from requirement to execution


