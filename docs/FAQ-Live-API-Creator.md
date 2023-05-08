!!! pied-piper ":bulb: TL;DR - Migration from CA/Live API Creator (LAC)"

      CA/Live API Creator was recently discontinued.  For customers seeking to migrate, API Logic Server offers a migration path worth considering:

      * Built by the same engineering leadership team, the products are quite similar.  They both offer instant **multi-table APIs**, **multi-page Admin Apps**, and **business logic** using rules extensible with code.

      * LAC provides **Custom Resources**.  This is not provided by API Logic Server, which affects dependent clients.  
      
         * Migration tools are underway, and are past the proof-of-concept phase.

      * API Logic Server offers superior services for:

         * Development: uses standard IDEs for debugger and source code management.

         * Deployment: scripts are provided to containerize applications for deployment.

      Consulting services are available to assess specific applications, and provide migration tools.

&nbsp;

## Conceptually Similar

Both products provide:

* Instant creation of projects with **multi-table APIs***.  The APIs both provide filtering, sorting, pagination, and multi-table retrieval

* Instant creation of **multi-page Admin Apps**

* Declarative business logic - **rules, extensible with code**

&nbsp;

## Key Difference Summary

&nbsp;

### LAC Only

#### API Style: Custom Resources

The styles are different:

* LAC APIs are **server-defined**, with custom Resource definition.

      * These are suitable for in-house clients whose needs are known in advance

* ALS APIs are **client-defined** ([see here for more information](..API/#provider-defined-vs-consumer-defined)).  

      * These are suitable for general clients who can request exactly the data they require, without the performance costs and complexity of integrating several bespoke APIs

&nbsp;

#### Optimistic Locking

This is provided by LAC, and currently under investigation.

&nbsp;

#### Column Level Security

Both provide role-based row security.  Additionally, LAC provides role-based column security.

&nbsp;

### API Logic Server Only

#### Open Source Stability

API Logic Server is open source.  Besides obvious pricing advantages, open source is not subject to business cycles and whims of vendors.

&nbsp;

#### Leverage IDE, Containers

API Logic Server does not provide a "studio UI", instead using a [Standard IDE](../IDE-Customize){:target="_blank" rel="noopener"} using [Python as a DSL](../Tech-DSL){:target="_blank" rel="noopener"}.  This leverages signficant tooling, such as **standard debuggers and source control**.

API Logic Server leverages [containers for Dev and Deploy](../DevOps-Containers){:target="_blank" rel="noopener"}, for more **more standards-based deployment**.

&nbsp;

#### Python (as a DSL)

Both products provide a code-by-exception approach for APIs and logic.  API Logic Server uses Python.  While this may be new to some shops, the general approach is declarative using [Python as a DSL](../Tech-DSL){:target="_blank" rel="noopener"} and scripting language.  This level of Python is extremely easy to pick up.

&nbsp;

## Migration Evaluation Services

The sections above indentigy the highlights, but the needs of specific projects may differ.  As noted above, we served as lead engineers on both, so we are uniquely positioned to help explore migrating your project.  Please contact us.

Such efforts are already underway.  Migration tools are past the proof-of-concept phase and are under development:

* API Custom Resources

* Rules

