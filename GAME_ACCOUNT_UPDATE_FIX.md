# Game Account Username Update Fix

## Issue

When deleting a game account username and trying to add a new one with the same game:

- ❌ The new username was NOT created
- ❌ The old username was NOT deleted
- ❌ The field remained unchanged

## Root Cause

In `/routes/auth.js`, the `POST /game-account` endpoint used `INSERT...ON DUPLICATE KEY UPDATE` but **was not updating the `username` column** when a duplicate key was found.

**The Database Structure:**

- `Game_Account` table has a **composite primary key**: `(game_id, player_id)`
- This means: **One username per game per player**
- When adding a new account for the same game, it's a duplicate key update scenario

**The Bug:**

```javascript
// OLD CODE - Missing username in UPDATE clause
ON DUPLICATE KEY UPDATE tag=VALUES(tag), rank=VALUES(rank), level=VALUES(level),
  is_primary=VALUES(is_primary), last_active=CURDATE()
```

This meant:

1. When you tried to add a new username for a game you already had
2. The duplicate key was detected
3. But the `username` field was NOT in the UPDATE clause
4. So the old username remained unchanged
5. User couldn't change their username without first deleting and recreating

## Solution

Added `username=VALUES(username)` to the `ON DUPLICATE KEY UPDATE` clause:

```javascript
// NEW CODE - Includes username in UPDATE
ON DUPLICATE KEY UPDATE username=VALUES(username), tag=VALUES(tag), rank=VALUES(rank), level=VALUES(level),
  is_primary=VALUES(is_primary), last_active=CURDATE()
```

## File Modified

- `routes/auth.js` (Line ~345)

## How It Works Now

1. User has: `Valorant` account with username `OldName`
2. User clicks remove → Account is deleted
3. User wants to add new account with same game → Username `NewName`
4. API receives POST request with `(game_id=1, player_id=5, username='NewName')`
5. Database finds duplicate key `(1, 5)` exists
6. Executes UPDATE clause which NOW includes `username=VALUES(username)`
7. Username is updated to `NewName` ✅

## Alternative Approaches Considered

### Option A: DELETE then INSERT (rejected)

- More reliable but requires two queries
- Less efficient
- Risk of race conditions

### Option B: Always DELETE before INSERT (rejected)

- Forces extra validation step
- Would break if DELETE fails silently
- User gets confusing error messages

### Option C: ON DUPLICATE KEY UPDATE with username (✅ chosen)

- Single atomic operation
- Database handles it correctly
- Efficient and clean
- Works with the existing schema design

## Testing

To verify the fix works:

1. Go to Profile → Game Accounts
2. Add a Valorant account: `TestPlayer`
3. Remove it
4. Add a new Valorant account with different username: `NewTestPlayer`
5. ✅ The new username should display correctly
6. ✅ The old username should not appear anywhere

## Related Files

- `public/profile.html` - Frontend delete/add account buttons
- `routes/auth.js` - Backend game account endpoints
- `database/schema.sql` - Game_Account table structure
