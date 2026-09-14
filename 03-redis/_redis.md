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

1. Create a session key with value 'user_42'

       SET session:token:xyz987 "user_42"

2. Set an expiration time of 30 seconds on the session

       EXPIRE session:token:xyz987 30

---

3. Check the remaining Time-To-Live (TTL) in seconds

       TTL ...

4. Retrieve the session value before it expires

       GET ...

---

**Step B: Building Atomic Counters (INCR / INCRBY)**

Track real-time statistics for page views and website visits using atomic increment operations.

1. Initialize a page view counter for the homepage

       SET stats:pageviews:home 100

2. Increment the counter by 1 (simulating a new visit)

       INCR ...

---

3. Add 50 views at once (simulating a batch update)

       INCRBY ...

4. Read the updated counter value

       ...

---

**Step C: Temporary Promo Codes (SET with EX)**

Store a temporary discount code SUMMER2026 that offers a 20% discount and automatically expires in 60 seconds using a single atomic command.

1. Create key 'promo:summer' with value '20_OFF' that expires in 60 seconds

1. Verify the key exists and check its TTL

---

**Step D: Key Inspection & Cleanup**

Practice inspecting existing keys and removing expired or unused entries.

1. List all keys matching the pattern 'stats:*'

       KEYS stats:*

2. Check if the promo key exists (returns 1 if exists, 0 if not)

       EXISTS ...

3. Delete the pageview counter key manually

       ...

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

# Task 3: Advanced Data Structures (Hashes, Lists & Sets)

**Scenario:**

You are developing backend features for an e-commerce platform. You need to store structured user profiles (Hashes), process incoming customer support requests in a FIFO queue (Lists), and manage unique product tags and overlapping categories (Sets).

---

**Part 1: Data Setup (Populating the Database)**

Run commands contained in the `ecommerce.txt` to initialize the dataset.

**Part 2: Student Exercises (Instructions / Tasks to Perform)**

Write and execute the appropriate Redis commands to perform the following actions:

---

**A. Working with Hashes (Structured Objects)**

1. Retrieve User Profile Field: Fetch and display only the `email` of `user:1001`.

       HGET user:1001 email

1. Retrieve Full User Object: Read all fields and values stored inside `user:1002` in a single query.

       HGETALL ...

1. Update Profile & Increment Field:

   - Change the `city` of `user:1001` to `"Wroclaw"`.

   - Increment the `age` of `user:1001` by 1 year (using `HINCRBY`).

1. Inspect Hash Keys: List all field names (keys) stored inside `user:1001` without retrieving their values.

---

**B. Working with Lists (Queues & Logs)**

1. Inspect the Queue: View all pending support tickets currently in `support:queue` from first to last without deleting them.

       LRANGE support:queue 0 -1

2. Process Queue Items (FIFO): A support agent is ready to process a request. Pop and retrieve the oldest ticket from the queue.

       RPOP ...

3. Add Urgent Ticket: Push a new high-priority ticket `"ticket_104: VIP payment issue"` to the tail (right side) of `support:queue` so it gets processed next.

       RPUSH ...

---

**C. Working with Sets (Unique Collections & Intersections)**

1. Check Tag Membership: Check if the tag `"electronics"` exists inside `tags:smartphone`.

       SISMEMBER tags:smartphone "electronics"

2. Find Shared Attributes (Set Intersection): Find all common tags shared between laptops and smartphones (`tags:laptop` and `tags:smartphone`).

       SINTER ...

3. Combine Collections (Set Union): Get a list of all unique tags across both `tags:laptop` and `tags:clearance` (without duplicates).

4. Remove Tag: Remove the tag `"sale"` from `tags:laptop`.

---

# Task 4: Ranked Leaderboards & Score-Based Sorting (Sorted Sets)

**Scenario:**

You are developing the leaderboard and matchmaking module for an online gaming platform. You need to store player scores, rank players globally, update scores dynamically, and retrieve top performers or players within specific score ranges.

---

**Part 1: Data Setup (Populating the Database)**

Run commands contained in the `leaderboard.txt` to initialize the dataset.

**Part 2: Student Exercises (Instructions / Tasks to Perform)**

Write and execute the appropriate Redis commands to perform the following actions:

---

**A. Basic Ranking & Leaderboards**

1. Retrieve Bottom 3 Players: Fetch the 3 players with the lowest scores (ascending order) along with their actual scores.

       ZRANGE leaderboard:global 0 2 WITHSCORES

1. Retrieve Top 3 Players (Leaderboard): Fetch the 3 players with the highest scores (descending order) along with their scores.

       ZREVRANGE leaderboard:global 0 2 WITHSCORES

2. Check Specific Player Rank: Find the global rank of `"Player_Charlie"` (where rank 0 represents the player with the highest score).

       ZREVRANK ...

---

**B. Score Inspection & Filtering**

1. Get Player Score: Retrieve the exact current score of `"Player_Bravo"`.

       ZSCORE leaderboard:global "Player_Bravo"

1. Count Players in Range: Count how many players have a score between 1500 and 2500 (inclusive).

       ZCOUNT ...

1. Fetch Players by Score Range: List all players (and their scores) who have a score between 2000 and 3500, ordered from highest to lowest score.

       ZREVRANGEBYSCORE ...

---

**C. Score Updates & Player Removal**

1. Increment Player Score: `"Player_Alpha"` completed a quest and earned 400 bonus points. Update their score atomically using `ZINCRBY`.

1. Re-check Rank After Update: Check `"Player_Alpha"`'s new score and updated rank on the global leaderboard.

1. Remove Inactive Player: `"Player_Echo"` deleted their account. Remove them from the leaderboard.

