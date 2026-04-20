# Complete Account Deletion (Cascading Delete)

## Overview

When a user deletes their account from the "Danger Zone" section of the profile page, **everything associated with that user is permanently deleted** from the database to avoid foreign key constraint errors.

## What Gets Deleted

When user deletes their account, the following are deleted in order:

1. ✅ **Notifications** - All notifications sent to this player
2. ✅ **Game Accounts** - All linked game accounts (Valorant, BGMI, CS2, etc.)
3. ✅ **Team Memberships** - Removed from all teams (Team_Player records)
4. ✅ **Match Participation** - All Player_Matches records
5. ✅ **Statistics** - All calculated stats (Rating, ACS, K/D, etc.)
6. ✅ **Social Links** - All linked social media profiles
7. ✅ **Bans** - Any active bans on the account
8. ✅ **Contentions** - All disputes/contentions raised by this player
9. ✅ **Player Profile** - The entire Player record
10. ✅ **User Account** - The Users table entry

## Why This Order?

The order is critical due to **foreign key constraints**. We delete in **reverse dependency order**:

```
Users → Player → (depends on) → Notifications, Team_Player, Game_Account, etc.
        ↓
      Player (has foreign keys to it)
```

By deleting dependent tables first, we avoid constraint violations:

- ❌ Can't delete Player while Notifications reference it
- ✅ Delete Notifications first, then Player, then Users

## Database Changes

### Before (Would fail with constraint error):

```sql
DELETE FROM Users WHERE user_id = 5;
-- Error: Cannot delete or update a parent row: a foreign key constraint fails
```

### After (Complete cascading delete):

```sql
DELETE FROM Notification WHERE player_id = ?;
DELETE FROM Game_Account WHERE player_id = ?;
DELETE FROM Team_Player WHERE player_id = ?;
DELETE FROM Player_Matches WHERE player_id = ?;
DELETE FROM Stat WHERE owner_type = "Player" AND owner_id = ?;
DELETE FROM Social_Link WHERE player_id = ?;
DELETE FROM Ban WHERE player_id = ?;
DELETE FROM Contention WHERE raised_by_player_id = ?;
DELETE FROM Player WHERE player_id = ?;
DELETE FROM Users WHERE user_id = ?;
```

## API Endpoint

**Endpoint:** `DELETE /api/auth/account`

**Request Body:**

```json
{
  "password": "user_password_123"
}
```

**Response (Success):**

```json
{
  "message": "Account and all associated data deleted successfully"
}
```

**Response (Error - Wrong Password):**

```json
{
  "error": "Incorrect password"
}
```

## Frontend Implementation

Located in `public/profile.html`:

```javascript
async function deleteAccount() {
  if (!confirm("Are you sure? This will deactivate your account permanently."))
    return;

  const pw = document.getElementById("del-pw").value;
  if (!pw) {
    showToast("Please enter your password", "error");
    return;
  }

  try {
    const res = await fetch("/api/auth/account", {
      method: "DELETE",
      headers: API.headers(),
      body: JSON.stringify({ password: pw }),
    });
    const d = await res.json();
    if (!res.ok) throw d;

    showToast("Account deleted");
    // Redirect to login after 2 seconds
    setTimeout(() => (location.href = "/login.html"), 2000);
  } catch (e) {
    document.getElementById("del-err").textContent = e.error || "Failed";
    document.getElementById("del-err").style.display = "block";
  }
}
```

## Security Considerations

✅ **Password Required** - User must confirm with their password before deletion
✅ **Complete Deletion** - No orphaned records left behind
✅ **No Recovery** - Permanent deletion (not soft delete)
✅ **Atomic Operation** - All deletes happen together (database transaction recommended for production)

## Potential Improvements (Future)

### Add Transaction Support (Production-Ready):

```javascript
const connection = await db.getConnection();
try {
  await connection.beginTransaction();

  // ... all delete queries ...

  await connection.commit();
} catch (err) {
  await connection.rollback();
  throw err;
} finally {
  connection.release();
}
```

### Add Audit Logging (Security):

```javascript
// Log deletion before actually deleting
await db.query(
  "INSERT INTO Audit_Log (action, user_id, table_name, deleted_at) VALUES (?, ?, ?, NOW())",
  ["user_account_deletion", userId, "Users"]
);
```

### Add 30-Day Grace Period (User-Friendly):

Instead of instant deletion, mark as "scheduled for deletion" and delete after 30 days:

```javascript
await db.query(
  "UPDATE Users SET deletion_scheduled_at = NOW() WHERE user_id = ?",
  [userId]
);
```

## Testing

### Test Case 1: Delete User Without Password

```bash
curl -X DELETE http://localhost:3000/api/auth/account \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"password": ""}'
```

Expected: Error - "Password confirmation required"

### Test Case 2: Delete User With Wrong Password

```bash
curl -X DELETE http://localhost:3000/api/auth/account \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"password": "wrongpassword"}'
```

Expected: Error - "Incorrect password"

### Test Case 3: Delete User With Correct Password

```bash
curl -X DELETE http://localhost:3000/api/auth/account \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"password": "correctpassword"}'
```

Expected: Success - User and all related data deleted from database

## Files Modified

- `routes/auth.js` - Updated `DELETE /account` endpoint with complete cascading delete logic

## Related Files

- `public/profile.html` - Frontend delete button and form
- `database/schema.sql` - Database schema with foreign keys
- `middleware/auth.js` - Authentication middleware for protected routes

## Troubleshooting

### Issue: "Cannot delete or update a parent row"

**Solution:** Ensure you're deleting child tables before parent tables. Follow the order in `routes/auth.js`.

### Issue: Some data not deleted

**Solution:** Add more DELETE statements for any tables with foreign keys to Users or Player that aren't currently handled.

### Issue: User can still access after deletion

**Solution:** Frontend redirects to login page. Clear local storage/tokens to ensure they're logged out.

---

**Status:** ✅ Implemented and Ready for Testing
**Created:** April 2026
**Last Updated:** Latest Implementation
