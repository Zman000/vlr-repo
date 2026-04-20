# Database Editor - Quick Reference Card

## 🎯 QUICK ACCESS

**Location in Admin Panel:**
```
Admin Sidebar
    └─ Database
        └─ Database Editor ← Click here
```

---

## 🖥️ TWO MODES

### MODE 1: BROWSE & EDIT TABLES
```
Tables Tab
    ├─ All database tables shown as cards
    ├─ Click table to open
    ├─ View data in grid
    ├─ Click cell to edit
    ├─ Click Save to update
    └─ Click Back to return
```

**Best for:** Editing individual records

### MODE 2: QUERY DATABASE
```
SQL Query Tab
    ├─ Enter SELECT query
    ├─ Click Execute Query
    ├─ View results
    ├─ See row count
    └─ Copy/export results
```

**Best for:** Finding specific data

---

## ⌨️ KEYBOARD SHORTCUTS

| Action | Keys |
|--------|------|
| Edit cell | Click cell |
| Save row | Click Save button |
| Go back | Click Back button |
| Execute query | Click Execute button |
| Clear query | Select all + Delete |

---

## 📊 MAIN TABLES YOU'LL USE

| Table | Purpose |
|-------|---------|
| **Player** | Player profiles, stats, rankings |
| **Team** | Team info, logos, regions |
| **Tournament** | Tournament data, dates, status |
| **Matches** | Match results, schedules |
| **Game** | Game info, versions |
| **Organization** | Sponsors and organizations |
| **Sponsor** | Sponsorship details |

---

## 🔧 COMMON EDITING TASKS

### Update Player Information
```
1. Open Players table
2. Find player row
3. Click field to edit (name, rank, country, etc.)
4. Type new value
5. Click Save
✓ Done
```

### Change Team Name
```
1. Open Team table
2. Find team row
3. Click name field
4. Type new name
5. Click Save
✓ Done
```

### Set Tournament Status
```
1. Open Tournament table
2. Find tournament row
3. Click status_id field
4. Enter: 1 (Active) or 2 (Inactive)
5. Click Save
✓ Done
```

---

## 🔍 COMMON QUERIES

### Find Players from Specific Country
```sql
SELECT * FROM Player WHERE country = 'India';
```

### Get Active Tournaments
```sql
SELECT * FROM Tournament WHERE status_id = 1;
```

### Find Teams by Region
```sql
SELECT * FROM Team WHERE region = 'Asia';
```

### Get Completed Matches
```sql
SELECT * FROM Matches WHERE status_id = 2;
```

### Count Players per Country
```sql
SELECT country, COUNT(*) as count FROM Player GROUP BY country;
```

### Find Players with High Rank
```sql
SELECT name, rank FROM Player WHERE rank > 1500;
```

---

## ⚠️ DO's & DON'Ts

### ✅ DO:
- Click Save after editing
- Use Tables for single edits
- Use Query for lookups
- Check data before saving
- Edit non-key columns

### ❌ DON'T:
- Edit ID columns
- Leave required fields empty
- Use special characters
- Refresh page mid-edit
- Edit system columns

---

## 🎨 COLUMN VALUE REFERENCE

### Status Values
```
status_id = 1  → Active
status_id = 2  → Inactive
status_id = 3  → Pending
```

### Gender/Role Values
```
'M' → Male
'F' → Female
'Admin' → Admin user
'Player' → Player user
```

### Approval Status
```
'pending'   → Awaiting approval
'approved'  → Approved
'rejected'  → Rejected
```

### Match Status
```
1 = Upcoming
2 = Live
3 = Completed
```

---

## 🚨 ERROR MESSAGES & SOLUTIONS

| Error | Cause | Solution |
|-------|-------|----------|
| "Invalid table name" | Typo in table name | Check table exists |
| "Row not found" | Row was deleted | Refresh browser |
| "No changes made" | Edited same value | Change value and retry |
| "Only SELECT queries allowed" | Using INSERT/UPDATE/DELETE | Use Table editor instead |
| "Query failed" | SQL syntax error | Check query syntax |

---

## 📈 QUERY TIPS

```sql
-- LIMIT results for safety
SELECT * FROM Player LIMIT 100;

-- Use WHERE to filter
SELECT * FROM Team WHERE region = 'Europe';

-- ORDER to sort results
SELECT * FROM Matches ORDER BY date DESC;

-- COUNT to get statistics
SELECT COUNT(*) FROM Player;

-- JOIN to combine tables
SELECT p.name, t.name FROM Player p 
JOIN Team_Player tp ON p.player_id = tp.player_id
JOIN Team t ON tp.team_id = t.team_id;
```

---

## 🔐 SECURITY REMINDERS

✅ **Protected by:**
- Admin login required
- Role verification
- SQL injection prevention
- Query validation

⚠️ **Remember:**
- Changes are permanent
- Backup before bulk edits
- Check data before saving
- Use queries for inspection only

---

## 📱 RESPONSIVE DESIGN

- ✓ Works on desktop
- ✓ Works on tablet (landscape)
- ✓ Tables scroll horizontally if needed
- ✓ Buttons remain accessible

---

## 🎯 WORKFLOW EXAMPLES

### Scenario 1: Fix a Player's Country
```
1. Database Editor → Tables Tab
2. Search/Open: Player
3. Find player with wrong country
4. Click country cell
5. Type correct country
6. Save
✓ Complete
```

### Scenario 2: Check Tournament Schedule
```
1. Database Editor → SQL Query
2. Enter: SELECT * FROM Tournament ORDER BY start_date;
3. Execute Query
4. View all tournaments sorted by date
✓ Complete
```

### Scenario 3: Bulk Update Team Region
```
1. Database Editor → SQL Query
2. View teams by region first
3. Switch to Tables tab
4. Open Team table
5. Edit each team's region as needed
6. Save each row
✓ Complete
```

---

## 💾 SAVING & BACKUP

**Auto-save:** ❌ Not automatic
**Save method:** Click "Save" button per row
**How many times can you edit?** Unlimited
**Undo available?** No - save is permanent

**Backup tips:**
- Export important data before bulk edits
- Use SQL Query tab to inspect first
- Make one change at a time

---

## 🆘 HELP & SUPPORT

**Problem: Need to undo a change**
- ❌ No undo available
- Solution: Manually revert the value
- Prevention: Always backup first

**Problem: Query is slow**
- Use WHERE clause to filter
- LIMIT results (e.g., LIMIT 500)
- Add ORDER BY to sort efficiently

**Problem: Can't find a table**
- Scroll in tables list
- Tables refresh on each visit
- Check exact table name spelling

---

## 📞 CONTACT INFO

For technical issues:
- Check DATABASE_EDITOR_GUIDE.md
- Review error message carefully
- Verify admin access
- Restart browser if needed

---

## 🎓 LEARNING PATH

### Beginner:
1. Open Database Editor
2. Browse a table (e.g., Game)
3. View the data structure
4. Make a single edit
5. Click Save
✓ Basics down!

### Intermediate:
1. Learn common tables
2. Try different queries
3. Edit multiple rows
4. Verify changes work
✓ Getting comfortable!

### Advanced:
1. Write complex queries
2. Join multiple tables
3. Use WHERE/ORDER BY
4. Export results
✓ Expert mode!

---

**Last Updated:** April 17, 2026
**Version:** 1.0

**Need help? See the full guides in the project documentation.**
