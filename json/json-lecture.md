---
marp: true
theme: gaia
paginate: true
size: 16:9
---

<!--
_class: lead invert
_paginate: false
-->

# JSON
# Java Script Object Notation
_NoSQL Databases_

---

# JSON
- Java Script Object Notation
- Lightweight data interchange format
- Industry standard for REST APIs
- In document-based databases (e.g. MongoDB)
- Standard for configurations files
- Based on JavaScript (JavaScript in most web browsers)

---

# Manuals and tutorials
   - [Introducting JSON](https://www.json.org/json-en.html)
   - [What is JSON? 5 min tutorial](https://youtu.be/cj3h3Fb10QY?si=bcaGKYnFazXt0oag)
   - [What is JSON? simple tutorial](https://youtube.com/shorts/pMYTlfoZ1_4?si=SBI-BOCwtUsnfs_8)

---

# JSON Data Types

- Primitive types:
  **String (always enclosed in double quotes " "!), Number, Boolean (true/false), Null**

- Complex types:
  **Object {} and Array []**

---

# JSON Example

```json
{
    "first_name": "John",
    "last_name": "Doe",
    "student": true,
    "semester": 5,
    "subjects": ["math","computer science", "history"],
    "address": {
        "city": "Krakow",
        "country": "Poland"
    }
}
```

---

# Common Syntax Errors

- Trailing commas at the end of objects or arrays
- Single quotes ' ' instead of double quotes " "
- Unquoted object keys

---

# JSON Schema

![width:700](https://json-schema.org/img/json_schema.svg)

[JSON Schema Specification](https://json-schema.org/)

---

# JSON Schema Example


---

# JSON Schema Validators

- online
  - https://jsonschema.dev/
  - https://www.jsonschemavalidator.net/
- VS Code

---

<!--
_class: lead invert
_paginate: false
-->

# Practical Tasks

---

# Task 1