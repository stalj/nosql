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

# Elasticsearch & Search Engines
# Distributed Full-Text Search

**Course:** NoSQL Databases  

---

# What is Elasticsearch

- Distributed, RESTful search and analytics engine
- Built on top of **Apache Lucene**
- Stores data as JSON documents with schema-free / dynamic mapping
- Designed for **Real-Time Search**, high scalability, and near-instant response times
- Core component of the **ELK Stack** (Elasticsearch, Logstash, Kibana)

---

# Key Use Cases

- **Full-Text Search:** E-commerce product catalogs, Wikipedia-style search, autocompletion
- **Log & Event Data Analysis:** System logs monitoring, SIEM, security analytics
- **Metrics & Operational Data:** Application Performance Monitoring (APM)
- **Geospatial Queries:** Location-aware filtering and radius searching

---

# Core Concepts: Relational vs. Elasticsearch

| Relational Term (SQL) | Elasticsearch Term | Description |
| :--- | :--- | :--- |
| **Database** | **Cluster / Index** | Logical namespace for related documents |
| **Table** | **Index** | Collection of JSON documents |
| **Row / Record** | **Document** | Single JSON object stored in ES |
| **Column** | **Field** | Key-value pair inside a document |
| **Schema** | **Mapping** | Definition of fields and their data types |

---

# How Search Works: Inverted Index

- Traditional DBs use B-Trees to index rows.
- Elasticsearch builds an **Inverted Index** (mapping words to documents):

**Sample Documents:**
- Doc 1: `"Elasticsearch is fast"`
- Doc 2: `"Lucene is powerful"`

**Inverted Index:**
- `"elasticsearch"` ➔ [Doc 1]
- `"fast"` ➔ [Doc 1]
- `"lucene"` ➔ [Doc 2]
- `"powerful"` ➔ [Doc 2]

---

# Document Structure Example

```json
{
  "_index": "products",
  "_id": "101",
  "_source": {
    "title": "Wireless Noise-Canceling Headphones",
    "brand": "AudioTech",
    "price": 199.99,
    "in_stock": true,
    "tags": ["audio", "bluetooth"],
    "created_at": "2026-09-14T10:00:00Z"
  }
}
```
---

# Query DSL Overview

Elasticsearch provides a rich JSON-based Query DSL via HTTP REST API:

- Match Query (Full-Text Search): Analyzes text before searching.

```json
GET /products/_search
{
  "query": {
    "match": { "title": "wireless headphones" }
  }
}
```

- Term Query (Exact Match): Used for precise filtering (e.g., numbers, booleans, exact status).

---

# Aggregations & Analytics

Summarize and extract statistics from data in real-time:

```json
GET /products/_search
{
  "aggs": {
    "avg_price_per_brand": {
      "terms": { "field": "brand.keyword" },
      "aggs": {
        "avg_price": { "avg": { "field": "price" } }
      }
    }
  }
}
```

---
