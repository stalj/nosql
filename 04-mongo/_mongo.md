---
marp: true
theme: default
paginate: true
size: 16:9
---

<!--
_class: lead invert
_paginate: false
-->

# INTRODUCTION

_Course: NoSQL Databases_

---

# MongoDB & Document Databases
# Schema-Flexible NoSQL

**Course:** NoSQL Databases  

---

# What is MongoDB?

- Open-source, document-oriented NoSQL database
- Stores data as flexible, JSON-like documents (**BSON**)
- **Schema-Less / Dynamic Schema:** Documents in the same collection do not require the same fields
- Designed for high availability, horizontal scaling, and developer productivity
- Widely used in modern web apps, real-time analytics, and content management

---

# Core Concepts: SQL vs. MongoDB

| Relational Term (SQL) | MongoDB Term | Description |
| :--- | :--- | :--- |
| **Database** | **Database** | Container for collections |
| **Table** | **Collection** | Group of related MongoDB documents |
| **Row / Record** | **Document** | Single data record (field-value pairs) |
| **Column** | **Field** | Key-value pair inside a document |
| **Primary Key** | **`_id` Field** | Mandatory unique identifier (ObjectId) |

---

# How Data is Stored: BSON

- **BSON = Binary JSON** (Binary Serialization of JSON-like documents)
- Extends standard JSON with additional data types:
  - `ObjectId` (12-byte unique identifier)
  - `Date` (64-bit integer date/time)
  - `Decimal128` (High-precision numbers for financial data)
- Faster to parse and traverse compared to plain text JSON

---

# Document Structure Example

```json
{
  "_id": {"$oid": "66f1a8c2e4b0a1a2b3c4d5e6"},
  "product_name": "Wireless Mouse",
  "price": 29.99,
  "in_stock": true,
  "tags": ["electronics", "peripherals"],
  "specs": {
    "dpi": 1600,
    "color": "black"
  }
}
```

---

# Embedded Documents vs. References

- Embedding (Denormalization - Preferred):

  - Storing nested data directly inside a single document.

  - Best for: 1:1 or 1:N relationships where child data is queried together with the parent.

- Referencing (Normalization):

  - Storing _id references to documents in another collection.

  - Best for: N:M relationships or frequently changing independent entities.

---

# CRUD Operations Overview

- **Create**: insertOne(), insertMany()

- **Read**: find(filter, projection), findOne()

- **Update**: updateOne(), updateMany() with operators ($set, $inc, $push)

- **Delete**: deleteOne(), deleteMany()

```javascript
// Example: Find active users in Krakow
db.users.find({ status: "active", "address.city": "Krakow" })
```

---

# Aggregation Pipeline Framework

Data processing through multi-stage pipelines:

[ Collection ] ➔ $match ➔ $group ➔ $project ➔ $sort ➔ [ Result ]

- `$match`: Filters documents (equivalent to `WHERE`)

- `$group`: Aggregates data by key (equivalent to `GROUP BY`)

- `$project`: Shapes output fields (equivalent to `SELECT`)

- `$sort`: Sorts results (equivalent to `ORDER BY`)

---

<!--
_class: lead invert
_paginate: false
-->

# Practical Tasks

---

# Running MongoDB

1. Clone `nosql` repository in VS Code.
2. Open a terminal window in the `mongo` folder.
3. Run MongoDB: `docker compose up -d`
4. Create a connection to MongoDB in VS Code (use Database Client extension).
   - Username: `root`
   - Password: `password`
   
---


