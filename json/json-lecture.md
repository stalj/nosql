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

# JSON Main Structure

- A collection of name/value pairs (object)
- An ordered list of values (array)

https://www.json.org/json-en.html

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

# Syntax Errors Example

```json
{
  'store': "Green Grocery",
  "isOpen": true,
  "employeeCount": 5,
  city: "Cracow",
  "categories": ["fruit", "vegetables"],
  "discountPercent": null,
}
```
3 errors

---

# JSON Schema

![width:800](https://json-schema.org/img/json_schema.svg)

---

# Get Started with JSON Schema

[JSON Schema Specification](https://json-schema.org/learn)

---

# JSON Schema Example

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "id": { "type": "integer" },
    "username": { "type": "string" },
    "email": { "type": "string", "format": "email" },
    "age": { "type": "integer", "minimum": 18 }
  },
  "required": ["id", "username", "email"]
}
```

---

# JSON Schema Validators

- Online
  - https://jsonschema.dev/
  - https://www.jsonschemavalidator.net/
- VS Code
- Standalone apps

---

<!--
_class: lead invert
_paginate: false
-->

# Practical Tasks

---

# Building Nested JSON Structure

Design and create a JSON file named inventory.json to manage an electronics store's stock. The root element must be an object containing:

1. Store metadata: storeName (string), isActive (boolean), and lastUpdated (string in ISO-8601 format, e.g., "2026-09-08T10:00:00Z").

---

2. A products array containing at least 3 objects. Each product object must include:

- id (integer)
- name (string)
- price (number)
- tags (array of strings, e.g., ["laptop", "clearance"])
- specs (a nested object with at least two fields, e.g., manufacturer, warrantyMonths).

---

# Data Refactoring

You are provided with a simple courses.json file containing a flat array of programming courses: 

```json
[
  { "code": "CS101", "title": "Introduction to SQL", "instructor": "John Doe" },
  { "code": "CS102", "title": "MongoDB in Practice", "instructor": "Jane Smith" }
]
```

---

Refactor and expand this document so that:

- The root element is converted from a top-level array to a root object containing: university ("Tech University"), semester (5), and a courseList array holding the courses.
- The instructor field (currently a plain string) is converted into a nested object with fullName, academicTitle, and email.
- An enrolledStudents array is added to each course object. It should contain an array of objects, each with a studentId (integer) and a finalGrade (number, or null if the course is ongoing).

---


