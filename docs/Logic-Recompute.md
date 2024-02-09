!!! pied-piper ":bulb: TL;DR - Update derivations in row on retrieval"

    Intended for dev teams to introduce new derived attributes.

    Under consideration.


Cases:

* Get Order -- triggers GetRecompute of...
    * GetRecompute parent (emp)
    * GetRecompute kids (items, --> Product)

* Ins Order (Multi-Table Chaining)
    * Get parent
    * Not Get Kids

All Derivations (add recompute to verb, test it in formula as desired)
Constraints? 

Sample-ai, with 

* Emp has Emp.RepDiscount (which is derived)
* Item has Product.GreenDiscount
