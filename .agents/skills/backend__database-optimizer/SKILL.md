---
name: database-optimizer
description: Diagnose and resolve database performance issues across PostgreSQL and MySQL with query analysis and optimization strategies. Use this skill when analyzing slow queries, designing index strategies, tuning database configuration, optimizing schemas, or improving performance metrics.
supported-databases:
  - PostgreSQL
  - MySQL
---

# Database Optimizer Skill

Comprehensive skill for diagnosing and resolving database performance issues with systematic query analysis and optimization strategies.

---

## Overview

This skill provides step-by-step guidance for identifying and fixing database performance bottlenecks. It uses `EXPLAIN ANALYZE` to understand execution plans, designs optimal indexing strategies, and provides database-specific tuning recommendations.

**Support:** PostgreSQL, MySQL
**Approach:** Data-driven analysis with before/after metrics

---

## When to Use This Skill

- **Slow Queries** — User reports slow application performance or specific slow queries
- **Index Design** — Need to optimize query performance through strategic indexes
- **Configuration Tuning** — Adjust database parameters for better performance
- **Schema Optimization** — Improve performance through schema design changes
- **Lock Contention** — Experiencing deadlocks or lock contention issues
- **Memory & Cache** — Improve cache hit rates and memory usage
- **Scaling Issues** — Prepare database for increased load

---

## Input Requirements

### Required
- Database type (PostgreSQL or MySQL)
- Slow query or list of problematic queries
- Baseline performance metrics (execution time, row count)

### Optional
- Current index list (`\d table_name` in psql or `SHOW INDEXES`)
- Database configuration parameters
- Expected query frequency and data volume
- Replication lag or cache hit rate current status
- Schema definition (table structures)

---

## Core Workflow: 5-Step Process

### Step 1: Analyze Performance
**Goal:** Establish baseline and understand current state

- Collect query execution time
- Run `EXPLAIN ANALYZE` on slow queries
- Document baseline metrics:
  - Execution time (ms)
  - Rows examined vs rows returned
  - Current indexes present
  - Cache hit rates (if available)

### Step 2: Identify Bottlenecks
**Goal:** Find root causes of performance issues

Look for:
- **Sequential scans** on large tables (should use indexes)
- **Missing indexes** on frequently filtered columns
- **Full table scans** in joins
- **Bad join order** or inefficient join strategies
- **Subquery inefficiencies** that could use CTEs or window functions
- **Configuration issues** (work_mem too low, shared_buffers not optimized)
- **Schema issues** (denormalization opportunities, partitioning needs)

### Step 3: Design Solutions
**Goal:** Create optimization strategy

Deliverables:
- Index creation statements (with rationale)
- Query rewrites (if needed)
- Configuration parameter changes
- Schema design improvements
- Partitioning strategy (if applicable)

### Step 4: Implement Changes
**Goal:** Apply optimizations safely

Process:
1. Create indexes on non-production first
2. Run `ANALYZE` to update table statistics
3. Re-run `EXPLAIN ANALYZE` to verify improvement
4. Deploy to production with monitoring
5. Monitor query performance and replication lag

**Critical:** Test changes in non-production first. Revert immediately if:
- Write performance degrades
- Replication lag increases significantly
- Memory usage spikes

### Step 5: Validate Results
**Goal:** Confirm improvements and document changes

- Re-run `EXPLAIN ANALYZE` on optimized queries
- Compare execution plans (before/after)
- Measure performance improvement (% faster)
- Verify no negative side effects
- Document all changes with rationale

---

## Deliverables

After completing the 5-step process, produce:

1. **Performance Analysis Report** — Baseline metrics and bottleneck analysis
2. **Optimization Strategy** — Recommended changes with rationale
3. **Implementation SQL** — Index creation, configuration changes
4. **Validation Queries** — `EXPLAIN ANALYZE` output before/after
5. **Metrics Summary** — Performance improvement percentages
6. **Rollback Plan** — How to revert changes if needed

---

## PostgreSQL-Specific Guidance

### EXPLAIN ANALYZE Output
```
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'user@example.com';

Key metrics to analyze:
- Seq Scan vs Index Scan
- Rows (estimated vs actual) — large differences indicate stale stats
- Buffers (hits vs reads) — cache effectiveness
- Total cost vs startup cost
```

### Index Strategies

**B-tree Indexes (default)** — Best for equality and range queries
```sql
CREATE INDEX idx_users_email ON users(email);
```

**Covering Indexes** — Include additional columns to avoid table lookup
```sql
CREATE INDEX idx_users_email_name ON users(email) INCLUDE (first_name, last_name);
```

**Partial Indexes** — Index only rows matching condition
```sql
CREATE INDEX idx_active_users ON users(email) WHERE is_active = true;
```

**Multi-column Indexes** — For combined WHERE clauses
```sql
CREATE INDEX idx_users_email_status ON users(email, status);
```

### Configuration Tuning
```sql
-- Increase work_mem for complex queries (per connection)
SET work_mem = '256MB';

-- Increase shared_buffers (25% of system RAM, restart required)
shared_buffers = 16GB

-- Increase effective_cache_size (50-75% of available RAM)
effective_cache_size = 64GB

-- Random page cost (lower = favor index scans)
random_page_cost = 1.1  -- SSD: 1.1, HDD: 4.0
```

---

## MySQL-Specific Guidance

### EXPLAIN Output
```
EXPLAIN SELECT * FROM users WHERE email = 'user@example.com'\G

Key metrics:
- type: system > const > eq_ref > ref > range > index > ALL
- rows: estimated rows examined
- Extra: Using where, Using index, Using filesort
```

### Index Strategies

**Simple Index** — Single column index
```sql
CREATE INDEX idx_email ON users(email);
```

**Composite Index** — Multi-column with proper column order
```sql
CREATE INDEX idx_email_status ON users(email, status);
```

**Full-text Index** — For text search
```sql
CREATE FULLTEXT INDEX idx_bio ON users(bio);
```

**Spatial Index** — For location queries
```sql
CREATE SPATIAL INDEX idx_location ON locations(coordinates);
```

### Configuration Tuning
```sql
-- Buffer pool size (key parameter, 70-80% of available RAM)
innodb_buffer_pool_size = 16G

-- Log file size for faster recovery
innodb_log_file_size = 512M

-- Threads to allow concurrent connections
innodb_write_io_threads = 8
innodb_read_io_threads = 8

-- Increase query cache if enabled
query_cache_size = 256M  -- Note: deprecated in MySQL 5.7.20+
```

---

## Common Performance Problems & Solutions

| Problem | Cause | Solution |
|---------|-------|----------|
| Full table scan on large table | Missing index | Add index on WHERE column |
| Slow JOIN | No join condition index | Index join columns |
| Slow aggregation | Computing on millions of rows | Use indexed columns, add materialized view |
| High memory usage | Sorting large dataset | Add index to avoid sorting, increase memory limits |
| Deadlocks | Transaction lock ordering | Standardize transaction order, reduce lock duration |
| Slow INSERT/UPDATE | Too many indexes | Review and drop unused indexes |
| High CPU with low I/O | Complex computation | Use database functions, batch operations |
| Replication lag | Slow queries on replica | Optimize queries, use parallel replication |

---

## Query Optimization Patterns

### Before: Inefficient Subquery
```sql
SELECT u.id, u.email, COUNT(o.id) as order_count
FROM users u
WHERE u.id IN (SELECT user_id FROM orders WHERE created_at > NOW() - INTERVAL '30 days')
GROUP BY u.id;
```

### After: Efficient JOIN
```sql
SELECT u.id, u.email, COUNT(o.id) as order_count
FROM users u
INNER JOIN orders o ON u.id = o.user_id AND o.created_at > NOW() - INTERVAL '30 days'
GROUP BY u.id;
```

---

## Performance Validation Checklist

Before moving optimization to production:

- [ ] Run EXPLAIN ANALYZE on original slow query
- [ ] Verify indexes were created successfully
- [ ] Run ANALYZE to update table statistics
- [ ] Re-run EXPLAIN ANALYZE on optimized query
- [ ] Compare execution time (document % improvement)
- [ ] Verify query plan changed (different index used)
- [ ] Test write performance (INSERT/UPDATE/DELETE unaffected)
- [ ] Monitor replication lag (if applicable)
- [ ] Check memory/CPU usage
- [ ] Document all changes with rationale

---

## Critical Safety Constraints

🚨 **Always Test First**
- Never apply changes directly to production
- Test on staging or non-production replica first
- Monitor for 30+ minutes after deployment

🚨 **Revert Immediately If:**
- Write performance degrades
- Replication lag increases significantly
- Memory usage spikes unexpectedly
- Query timeout issues appear

🚨 **Monitor During Deployment:**
- Watch slow query log
- Check replication lag
- Monitor disk I/O and CPU
- Alert on transaction locks

---

## Related Skills

- **Database Schema Design** — Understand schema structure before optimizing
- **Backend Builder** — Implement optimized queries in application code
- **Backend QA** — Test performance improvements thoroughly

---

**Last Updated:** 2026-04-08
