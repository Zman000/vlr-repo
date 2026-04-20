# User/Account Deletion Strategy - Complete Guide

## The Problem

When you delete a game account username and try to add a new one:

- ❌ The old entry stays in the database even after deletion
- ❌ You can't add a new account for the same game because composite key `(game_id, player_id)` still exists
- ❌ Can't delete user account because Notifications reference Player (foreign key constraint)
- ❌ Username can't be reused because it's locked in the Users table

## Root Causes

### 1. **Game Account Issue**: Hard Delete Creates Key Conflict

The database has a composite primary key:

```sql
PRIMARY KEY(game_id, player_id)
```

When you DELETE a row, it's completely gone from the DB, but... it doesn't matter because you can't reuse that key anyway.

**The real issue**: The ON DUPLICATE KEY UPDATE logic wasn't updating the `username` field (already fixed).

### 2. **User Deletion Issue**: Circular Foreign Key Dependencies

```
Users (user_id)
  ↓
Player (user_id)
  ↓ ← Notifications (player_id) [NO ON DELETE CASCADE]
Notification (player_id)
```

When you try to delete the User:

- Database tries to delete Player
- But Notifications still reference the Player
- Foreign key constraint violation!

## The Solution

### OPTION A: Soft Delete (RECOMMENDED) ✅

**Pros:**

- ✅ Preserves all historical data (matches, notifications, stats)
- ✅ Frees up username for reuse
- ✅ No foreign key conflicts
- ✅ Can recover deleted accounts if needed
- ✅ Clean audit trail

**Cons:**

- Database grows over time (but compress periodically)
- Must filter `WHERE deleted_at IS NULL` in all queries

**Implementation:**

```sql
-- 1. Add soft-delete columns
ALTER TABLE Users ADD COLUMN deleted_at DATETIME NULL;
ALTER TABLE Player ADD COLUMN deleted_at DATETIME NULL;
ALTER TABLE Game_Account ADD COLUMN deleted_at DATETIME NULL;

-- 2. When deleting user (in backend):
UPDATE Users SET deleted_at = NOW(), username = CONCAT('_deleted_', user_id, '_', UNIX_TIMESTAMP()) WHERE user_id = ?;
UPDATE Player SET deleted_at = NOW() WHERE user_id = ?;
UPDATE Game_Account SET deleted_at = NOW() WHERE player_id = ?;
```

### OPTION B: Hard Delete with Cascade ⚠️

**Pros:**

- ✅ Completely removes all data
- ✅ Frees up storage

**Cons:**

- ❌ Deletes all notifications/stats/records permanently
- ❌ Cannot recover
- ❌ May break historical match records

**Implementation:**

```sql
-- Add CASCADE to Notification
ALTER TABLE Notification
DROP FOREIGN KEY Notification_ibfk_1;
ALTER TABLE Notification
ADD CONSTRAINT Notification_ibfk_1
FOREIGN KEY(player_id) REFERENCES Player(player_id) ON DELETE CASCADE;

-- Then delete will cascade automatically
DELETE FROM Users WHERE user_id = ?;
```

## Recommended Action Plan

### Step 1: Deploy Soft Delete System

Run this SQL on your database:

```sql
-- Add soft-delete columns
ALTER TABLE Users ADD COLUMN IF NOT EXISTS deleted_at DATETIME NULL;
ALTER TABLE Player ADD COLUMN IF NOT EXISTS deleted_at DATETIME NULL;
ALTER TABLE Game_Account ADD COLUMN IF NOT EXISTS deleted_at DATETIME NULL;
ALTER TABLE Notification ADD COLUMN IF NOT EXISTS deleted_at DATETIME NULL;
ALTER TABLE Team_Player ADD COLUMN IF NOT EXISTS deleted_at DATETIME NULL;
```

### Step 2: Update Backend Queries

All SELECT queries need to filter deleted records:

```javascript
// Before (old)
const [rows] = await db.query("SELECT * FROM Users WHERE username = ?", [
  username,
]);

// After (new)
const [rows] = await db.query(
  "SELECT * FROM Users WHERE username = ? AND deleted_at IS NULL",
  [username]
);
```

### Step 3: Update Delete Endpoints

Instead of hard DELETE, do soft update:

```javascript
// Before (old)
await db.query("DELETE FROM Users WHERE user_id = ?", [userId]);

// After (new) - Soft delete
await db.query(
  'UPDATE Users SET deleted_at = NOW(), username = CONCAT("_deleted_", user_id, "_", UNIX_TIMESTAMP()) WHERE user_id = ?',
  [userId]
);
await db.query("UPDATE Player SET deleted_at = NOW() WHERE user_id = ?", [
  userId,
]);
await db.query(
  "UPDATE Game_Account SET deleted_at = NOW() WHERE player_id IN (SELECT player_id FROM Player WHERE user_id = ?)",
  [userId]
);
```

### Step 4: Test Username Reuse

After implementing soft delete:

1. Delete user "divyansh"
2. Can now register new user "divyansh" ✅
3. Old records are preserved in `deleted_at IS NOT NULL`

## Database Schema Recommendations

```sql
-- For future tables, always include:
CREATE TABLE MyTable (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ...other columns...,
    deleted_at DATETIME NULL,  -- Always add this
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- For critical relationships, always use CASCADE:
FOREIGN KEY(parent_id) REFERENCES Parent(id) ON DELETE CASCADE
```

## File: `database/user_deletion_strategy.sql`

Contains:

- Soft delete columns migration
- Stored procedure for safe user deletion
- Example usage
- Alternative hard-delete approach (if needed)

## What to Do Next?

1. **Choose your strategy**: Soft Delete (recommended) or Hard Delete
2. **Run the migration**: Execute the SQL from `database/user_deletion_strategy.sql`
3. **Update backend**: Modify all queries to check `deleted_at IS NULL`
4. **Test thoroughly**: Verify username reuse works
5. **Update frontend**: Show appropriate messages for deleted accounts

## Quick Reference

### Check if username is available

```sql
SELECT * FROM Users WHERE username = 'divyansh' AND deleted_at IS NULL;
```

### See all deleted accounts

```sql
SELECT user_id, username, deleted_at FROM Users WHERE deleted_at IS NOT NULL;
```

### Count active vs deleted

```sql
SELECT
  SUM(deleted_at IS NULL) as active_count,
  SUM(deleted_at IS NOT NULL) as deleted_count
FROM Users;
```

### Restore a deleted user (if needed)

```sql
UPDATE Users SET deleted_at = NULL WHERE user_id = 5;
UPDATE Player SET deleted_at = NULL WHERE user_id = 5;
```
