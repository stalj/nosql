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

# Introduction to Redis
## High-Performance In-Memory Data Store

**Course:** NoSQL Databases  

---

# What is Redis?

* **RE**mote **DI**ctionary **S**erver
* Open-source, **In-Memory** Data Structure Store
* Operates primarily in **RAM** for ultra-fast read/write operations
* Serves as a **Database**, **Cache**
* Data model: **Key-Value Store**

---

# Disk vs. In-Memory Storage

| Feature | Relational / Document DBs (PostgreSQL, Mongo) | In-Memory Stores (Redis) |
| :--- | :--- | :--- |
| **Primary Storage** | Disk (NVMe / SSD / HDD) | **RAM** |
| **Latency** | Milliseconds ($\approx 1 - 10\text{ ms}$) | **Sub-millisecond** ($\approx 100 - 500\text{ }\mu\text{s}$) |
| **Throughput** | Thousands of ops/sec | **100,000+ ops/sec** per core |
| **Volatleness** | Persistent by default | Volatile (requires snapshotting) |

---

# Primary Use Cases

* **Caching Layer:** Accelerating database queries by holding hot data in RAM.
* **Session Management:** Storing user session tokens with automatic TTL expiration.
* **Real-time Leaderboards:** Ranking scores instantly using Sorted Sets.
* **Message Queues:** Background job processing (Pub/Sub, Lists, Streams).
* **Rate Limiting:** Restricting API request rates using atomic counters.

---

# Key-Value Architecture

Redis has **no tables, rows, or collections**. Everything is a **Key-Value** pair.

- **Keys:** Always strings (e.g., `"user:1001:email"`).
- **Values:** Can hold various specialized data structures.

```text
       KEY                         VALUE
+------------------+       +-------------------+
| "user:1001:name" |  ---> | "John Doe"        |
+------------------+       +-------------------+
| "user:1001:jobs" |  ---> | ["task1", "task2"]|
+------------------+       +-------------------+
```

---

# Key Naming Convention

Keys are stored in a flat namespace. We use colons (:) to create logical namespaces.

Standard Template: `resource : id : attribute`

- `user:1001:profile` $\rightarrow$ Profile object for User 1001
- `product:550:stock` $\rightarrow$ Stock count for Product 550
- `session:xyz987:ttl` $\rightarrow$ Authentication session token

> GUI Advantage: Visual tools (e.g., VS Code Database Client) automatically parse colons into virtual expandable folders!

---

# Core Data Structures

* `Strings`: Plain text, numbers, or serialized objects (max 512 MB).
* `Hashes`: Field-value maps representing objects.
* `Lists`: Linked lists of strings (ordered by insertion, ideal for queues).
* `Sets`: Unordered collections of unique elements (automatic deduplication).
* `Sorted Sets (ZSets)`: Unique elements ranked by a numeric score.

---

# Strings & Atomic Operations

Used for simple values, flags, and counters.

```bash
# Setting and getting values
SET user:1001:email "john@example.com"
GET user:1001:email

# Atomic Counter (Thread-safe increment)
SET stats:pageviews 100
INCR stats:pageviews               # Value becomes 101
INCRBY stats:pageviews 5           # Value becomes 106
```

---

# Hashes (Objects)

Ideal for storing structured objects without serializing/deserializing JSON.

```bash
# Set multiple fields in a Hash
HSET user:1001 name "John Doe" email "john@example.com" role "admin"

# Get a single field
HGET user:1001 email

# Get all fields and values
HGETALL user:1001

# Increment a numeric field inside a Hash
HINCRBY user:1001 login_count 1
```

---

# Lists (Queues & Stacks)

Doubly-linked lists for FIFO / LIFO message queues.

```bash
# Push items to the head (left) of the list
LPUSH queue:jobs "email_job_1"
LPUSH queue:jobs "email_job_2"

# Pop item from the tail (right) -> FIFO Queue
RPOP queue:jobs                    # Returns "email_job_1"

# Read range of elements
LRANGE queue:jobs 0 -1
```

---

# Sets & Sorted Sets (ZSets)

```bash
# SETS: Unique collections
SADD user:1001:tags "databases" "docker" "redis" "docker"
SMEMBERS user:1001:tags            # Returns "databases", "docker", "redis"

# SORTED SETS: Leaderboards with Scores
ZADD leaderboard 85.5 "user:1001" 92.0 "user:1002" 95.0 "user:1003"

# Get TOP 2 players (highest scores)
ZREVRANGE leaderboard 0 1 WITHSCORES
```

---

# Key Expiration & TTL (Time-To-Live)

- Keys can be configured to self-destruct after a specified time window.

- Useful for automatic cache invalidation and temporary session management.

```bash
# Set key with expiration (in seconds)
SET session:token "abc123token" EX 60

# Or add expiration to an existing key
EXPIRE session:token 30

# Check remaining time before deletion
TTL session:token                  # Returns seconds remaining (or -2 if expired)
```

---

# Persistence: How RAM Data Survives Restarts

Redis keeps data in memory, but persists it to disk using two mechanisms:

**RDB (Redis Database Backup)**

- Point-in-time compact snapshots of memory saved to disk.
- Fast recovery, but risks losing data between snapshots.

**AOF (Append Only File)**

- Logs every write command received by the server.
- Higher durability, rebuilt by replaying commands upon startup.

---

# Zapis danych na dysk

SAVE

`dump.rdb`


---

# Redis Cheet Sheet

https://redis.io/tutorials/howtos/quick-start/cheat-sheet/

https://devsheets.io/sheets/redis

https://quickref.me/redis.html

---

<!--
_class: lead invert
_paginate: false
-->

# Practical Tasks

---

# AAA

Przykład 2: Koszyk zakupowy w sklepie internetowym
Struktura Hash sprawdza się świetnie przy przechowywaniu stanu koszyka dla danego użytkownika, gdzie polem jest identyfikator produktu, a wartością jego ilość.

Bash
# Użytkownik "user:202" dodaje do koszyka przedmioty
HSET cart:user:202 product:550 2 product:880 1

# Dodanie kolejnej sztuki produktu 550
HINCRBY cart:user:202 product:550 1

# Usunięcie produktu 880 z koszyka (HDEL)
HDEL cart:user:202 product:880

# Sprawdzenie liczby unikalnych produktów w koszyku (HLEN)
HLEN cart:user:202
# Zwraca: 1

---

# Running Redis

1. `docker --version` sprawdź, czy docker działa

1. `docker pull redis:alpine` pobierz Redis 

1. `docker run --name redis_lab -p 6379:6379 -d redis:alpine` uruchom kontener z Redis

1. W VS Code, utwórz połączenie z Redis, login i hasło pozostaw puste

