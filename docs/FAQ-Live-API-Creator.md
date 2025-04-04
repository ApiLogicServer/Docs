!!! pied-piper ":bulb: TL;DR - Migration from CA/Live API Creator (LAC)"

      CA/Live API Creator was a compelling product that offered instant API creation.  We believe API Logic Server is a superior approach, because:

      1. **GenAI:** provides order of magnitude more simplicity and speed
      
      2.  **IDE-driven vs Studio:** modern IDEs provide all the services required to maintain ease of use in a standards-based environment

      3. **Self-serve API:** users (for apps, integration, remote access) are not reliant on custom server development for multi-table APIs

      4. **File-based vs. repository:** all artifacts, including rules, are expressed in files that can be managed in GitHub
      
      CA/Live API Creator has reached end-of-life and soon end-of-support.  Customers seeking to migrate have many options for creating APIs.  API Logic Server offers a migration path worth considering:

      * API Logic Server provides ***unique* support for declarative logic and security**

      * We also provide a **migration utility** for logic and security

         * **Consulting services** are available to assess specific applications, and provide migration tools for LAC feature such as custom resources

         * Technology migrations are enabled by declarative models, and represent significant business value in preserving technology investments.

      * API Logic Server is **open source**, and offers superior services for:

         * **Development:** uses standard IDEs for debugger and source code management

             * **IDE-Driven Development**, not via a UI

         * **Deployment:** scripts are provided to containerize applications for deployment

      * API Logic Server is a **self-serve** API style, well suited for supporting other organizations with ad hoc integrations without requiring central creation of customized APIs

         * Use standard Flask for custom APIs - still rule-enabled
         
         * An **Extensible ORM** enables access to other data sources

&nbsp;

## Conceptually Similar

Both products provide:

* Instant creation of projects with ***multi-table APIs***.  The APIs both provide filtering, sorting, pagination, and multi-table retrieval

* Instant creation of ***multi-page Admin Apps***

* Declarative business logic - ***rules, extensible with code***

&nbsp;

## Key Difference Summary

&nbsp;

### LAC Only

#### API Style: Custom Resources

The styles are different:

* LAC APIs are **server-defined**, with custom Resource definition.

      * These are suitable for in-house clients whose needs are known in advance

* ALS APIs are **self-serve, client-defined** ([see here for more information](API-Self-Serve.md)).  

      * These are suitable for general clients who can request exactly the data they require, without the performance costs and complexity of integrating several bespoke APIs

&nbsp;

#### Column Level Security

Both provide role-based row security.  Additionally, LAC provides role-based column security.

&nbsp;

### API Logic Server Only

#### Open Source Stability

API Logic Server is open source.  Besides obvious pricing advantages, open source is not subject to business cycles and whims of vendors.

&nbsp;

#### Leverage IDE, Containers

API Logic Server does not provide a "studio UI", instead using a [Standard IDE](IDE-Customize.md){:target="_blank" rel="noopener"} using [Python as a DSL](Tech-DSL.md){:target="_blank" rel="noopener"}.  This leverages signficant tooling, such as **standard debuggers and source control**.

API Logic Server leverages [containers for Dev and Deploy](DevOps-Containers.md){:target="_blank" rel="noopener"}, for more **more standards-based deployment**.

&nbsp;

#### Python (as a DSL)

Both products provide a code-by-exception approach for APIs and logic.  API Logic Server uses Python.  While this may be new to some shops, the general approach is declarative using [Python as a DSL](Tech-DSL.md){:target="_blank" rel="noopener"} and scripting language.  This level of Python is extremely easy to pick up.

&nbsp;

## Migration Evaluation Services

The sections above identify the highlights, but the needs of specific projects may differ.  As noted above, we served as lead engineers on both, so we are uniquely positioned to help explore migrating your project.  Please contact us.

The [Migration Migration Service](https://github.com/tylerm007/model_migration_service.git) provides LAC transformation for:

* Custom Resources

* FreeSQL

* Rules

* Functions

* Security

* Pipelines

