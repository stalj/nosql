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

> _GUI Advantage: Visual tools (e.g., VS Code Database Client) automatically parse colons into virtual expandable folders!_

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

# Running Redis

1. Clone `nosql` repository in VS Code.
2. Open a terminal window in the `redis` folder.
3. Run Redis: `docker compose up -d`
4. Create a connection to Redis in VS Code (use Database Client extension), 

   > _Leave username and password blank._

---

# Task 1: Basic Key-Value Data Management & Caching

Scenario:

You are building an in-memory caching layer for a high-traffic web application. You need to store user session tokens, manage page view counters, and handle temporary promotional discount codes that automatically expire.

Execute commands step-by-step to populate Redis and perform required operations.

---

**Step A: Managing User Sessions (Strings & Expiration)**

Create a session key for a logged-in user and set it to expire automatically after 30 seconds to simulate session timeout.

```bash
-- 1. Create a session key with value 'user_42'
SET session:token:xyz987 "user_42"

-- 2. Set an expiration time of 30 seconds on the session
EXPIRE session:token:xyz987 30

-- 3. Check the remaining Time-To-Live (TTL) in seconds
TTL session:token:xyz987

-- 4. Retrieve the session value before it expires
GET session:token:xyz987
```

---

**Step B: Building Atomic Counters (INCR / INCRBY)**

Track real-time statistics for page views and website visits using atomic increment operations.

```bash
-- 1. Initialize a page view counter for the homepage
SET stats:pageviews:home 100

-- 2. Increment the counter by 1 (simulating a new visit)
INCR stats:pageviews:home

-- 3. Add 50 views at once (simulating a batch update)
INCRBY stats:pageviews:home 50

-- 4. Read the updated counter value
GET stats:pageviews:home
```

---

**Step C: Temporary Promo Codes (SET with EX)**

Store a temporary discount code SUMMER2026 that offers a 20% discount and automatically expires in 60 seconds using a single atomic command.

```bash
-- Create key 'promo:summer' with value '20_OFF' that expires in 60 seconds
SET promo:summer "20_OFF" EX 60

-- Verify the key exists and check its TTL
TTL promo:summer
```

---

**Step D: Key Inspection & Cleanup**

Practice inspecting existing keys and removing expired or unused entries.

```bash
-- 1. List all keys matching the pattern 'stats:*'
KEYS stats:*

-- 2. Check if the promo key exists (returns 1 if exists, 0 if not)
EXISTS promo:summer

-- 3. Delete the pageview counter key manually
DEL stats:pageviews:home
```

---

# Task 2: Basic Key-Value Operations & Strings

**Scenario:**

You are tasked with setting up an in-memory caching and configuration store for an e-learning platform. First, you will populate Redis with initial data. Then, you will perform a series of operations to inspect, modify, and manage this data.

---

**Part 1: Data Setup (Populating the Database)**

Run commands contained in the `platform.txt` to initialize the dataset.

**Part 2: Student Exercises (Instructions / Tasks to Perform)**

Write and execute the appropriate Redis commands to perform the following actions:

---

**A. Basic Retrieval & Bulk Reading**

1. Fetch Configuration: Read and display the site name stored in `config:site_name`.

2. Bulk Read User Profile: Retrieve all three attributes (`name`, `email`, and `status`) for User 101 using a single query.

---

**B. Managing TTL & Expiration Timers**

1. Check Promo TTL: Check how many seconds are remaining before the promotional code `promo:code:FALL2026` expires.

2. Extend Session: The user `user:101` performed an action. Extend their active session token `session:token:usr101_abc` so that it stays valid for another 120 seconds.

3. Create Password Reset Code: Create a new key `reset:code:usr101` with the value `"883912"` that automatically deletes itself after 30 seconds.

---

**C. Atomic Counter Operations**

1. Track Daily Logins: A new user just logged in. Atomically increment the `metrics:daily_active_users` counter by 1.

2. Batch Update Metrics: A bulk import added 50 new active users. Increase `metrics:daily_active_users` by 50 in a single operation.

3. Manage Available Slots: A student just registered for a course. Decrement `metrics:available_course_slots` by 1.

---

**D. Conditional Updates & Key Cleanup**

1. Safe Configuration Update: Attempt to update `config:site_name` to `"EduCloud Pro"` only if the key does not already exist (ensure you do not overwrite existing configuration).

2. Key Existence Check: Check if the key `promo:code:FALL2026` is still active in the system.

3. Manual Cleanup: Manually delete the maintenance mode setting `config:maintenance_mode`.

---











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
