# Database Editor - Quick Start Guide

## What's New?

Admins can now **view and edit any database table directly from the admin panel** without writing SQL code.

## Accessing the Feature

1. Log in to the admin panel
2. Look for **"Database"** section in the left sidebar
3. Click **"Database Editor"**

---

## Two Ways to Edit Database

### Option 1: Table Browser & Editor

**Use this to:** View and edit specific table rows

**Steps:**
1. Click on the **"Tables"** tab
2. See all database tables displayed as cards
3. Click any table to open it
4. You'll see all rows in a grid format
5. **Edit a cell**: Click on any cell value to edit it
6. **Save changes**: Click the "Save" button in that row
7. **Go back**: Click "← Back to Tables" button

**Example:** To add a new sponsor name to the Sponsor table:
- Open Sponsors table
- Find the sponsor row
- Click the "name" cell
- Type new name
- Click "Save"

---

### Option 2: Custom SQL Query

**Use this to:** Run SELECT queries to get specific data

**Steps:**
1. Click on the **"SQL Query"** tab
2. Type your SELECT query (e.g., `SELECT * FROM Player WHERE country = 'USA'`)
3. Click **"Execute Query"**
4. Results appear in a table below
5. Row count is shown

**Example Queries:**
```sql
-- Get all players from USA
SELECT * FROM Player WHERE country = 'USA';

-- Get all teams in a tournament
SELECT t.name, t.region FROM Team t 
JOIN Tournament_Team tt ON t.team_id = tt.team_id 
WHERE tt.tournament_id = 1;

-- Get match results
SELECT m.match_id, t1.name, t2.name, m.score_team1, m.score_team2 
FROM Matches m 
JOIN Team t1 ON m.team1_id = t1.team_id 
JOIN Team t2 ON m.team2_id = t2.team_id 
WHERE m.status_id = 2 LIMIT 10;
```

**⚠️ Important:** Only SELECT queries are allowed. Cannot INSERT, UPDATE, or DELETE via this tab.

---

## Tables You Can Edit

### Core Data
- **Users** - System user accounts
- **Game** - Game information
- **Organization** - Sponsor/org details
- **Coach** - Coach information
- **Sponsor** - Sponsor data

### Players & Teams
- **Player** - Player profiles and stats
- **Team** - Team information
- **Team_Player** - Player-Team relationships
- **Player_Game** - Player game registrations

### Events & Matches
- **Tournament** - Tournament info
- **Matches** - Match details
- **Tournament_Team** - Tournament participants
- **Player_Matches** - Players in matches

### Support Data
- **Status** - Status lookup
- **Stat** - Player statistics
- **Permission** - User permissions
- **Role** - User roles
- **Role_Permission** - Role permissions
- **Admins** - Admin accounts
- **Game_Account** - Player game accounts
- **Player_Game** - Game registration
- **Notification** - User notifications

---

## What Each Column Means

### Players Table
| Column | Meaning |
|--------|---------|
| player_id | Unique ID (auto) |
| name | Full name |
| username | Unique username |
| email | Email address |
| country | Country (e.g., "USA") |
| region | Region (e.g., "North America") |
| age | Age of player |
| rank | Current rank/rating |
| status_id | 1=Active, 2=Inactive, etc. |
| approval_status | pending/approved/rejected |

### Teams Table
| Column | Meaning |
|--------|---------|
| team_id | Unique ID (auto) |
| name | Team name |
| org_id | Organization ID |
| logo | Logo image URL |
| founded_date | Creation date |
| coach_id | Coach ID |
| region | Team region |
| status_id | Active/Inactive status |

### Matches Table
| Column | Meaning |
|--------|---------|
| match_id | Unique ID (auto) |
| tournament_id | Which tournament |
| team1_id | First team |
| team2_id | Second team |
| score_team1 | Team 1 score |
| score_team2 | Team 2 score |
| winner_team_id | Winning team ID |
| status_id | Live/Upcoming/Completed |
| date | Match date |
| start_time | Match time |
| best_of | BO3/BO5/BO7 |

---

## Common Tasks

### ✏️ Update a player's rank
1. Open "Player" table
2. Find player row
3. Click "rank" cell
4. Type new rank value
5. Click "Save"

### ✏️ Change a team name
1. Open "Team" table
2. Find team row
3. Click "name" cell
4. Type new name
5. Click "Save"

### ✏️ Update tournament dates
1. Open "Tournament" table
2. Find tournament row
3. Click "start_date" or "end_date" cell
4. Enter new date
5. Click "Save"

### 🔍 Find all players from a country
1. Click "SQL Query" tab
2. Enter: `SELECT * FROM Player WHERE country = 'India';`
3. Click "Execute Query"

### 🔍 Get all upcoming matches
1. Click "SQL Query" tab
2. Enter: `SELECT * FROM Matches WHERE status_id = 3;`
3. Click "Execute Query"

---

## Tips & Best Practices

✅ **DO:**
- Make backups before bulk edits
- Use SQL Query for read-only lookups
- Use Table Editor for one-row edits
- Check data before saving
- Use descriptive names

❌ **DON'T:**
- Edit primary keys (IDs) directly
- Leave required fields empty
- Use special characters in names
- Make multiple rapid changes
- Edit system tables if unsure

---

## Limits

- Max 500 rows shown per table
- Max 500 rows returned from queries
- Can only run SELECT queries
- All changes require admin login
- Changes are logged with timestamp

---

## Need Help?

- **Problem**: Can't find a table
  - **Solution**: Scroll down in the tables list or search by name

- **Problem**: Edit isn't saving
  - **Solution**: Click the "Save" button. Green toast = success.

- **Problem**: Query returns no results
  - **Solution**: Check your WHERE clause and column names

- **Problem**: Error message appears
  - **Solution**: Read error carefully. Usually means invalid column name or table name.

---

## Security Notes

✅ **Your changes are safe because:**
- Only admins can access database editor
- Only SELECT queries allowed in query tab
- Table/column names are validated
- All queries use parameterized statements
- Changes are logged with admin ID

---

## Related Features

- **Add New** section: Add new tournaments, matches, teams, players
- **Approvals** section: Manage player registrations
- **Contentions**: Handle player disputes and bans
- **Sponsors**: Manage sponsorship deals

---

**Last Updated:** April 17, 2026
**Version:** 1.0
