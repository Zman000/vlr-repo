# Database Editor - Architecture & Flow

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     ADMIN PANEL                             │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              SIDEBAR MENU                           │   │
│  │  ├─ Overview                                        │   │
│  │  ├─ Add New (Tournament, Match, Team, Player)      │   │
│  │  ├─ Brackets                                        │   │
│  │  ├─ Moderation (Contentions, Approvals)            │   │
│  │  ├─ Sponsors & Orgs                                │   │
│  │  └─ DATABASE ← NEW!                                │   │
│  │     └─ Database Editor                             │   │
│  └─────────────────────────────────────────────────────┘   │
│                         ↓                                     │
│  ┌─────────────────────────────────────────────────────┐   │
│  │        DATABASE EDITOR SECTION                      │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │  ┌──────────────────┐  ┌──────────────────┐        │   │
│  │  │  Tables Tab ✓    │  │  SQL Query Tab   │        │   │
│  │  └──────────────────┘  └──────────────────┘        │   │
│  │         ↓                      ↓                    │   │
│  │  [Tables List]         [Query Textarea]            │   │
│  │  ├─ Users              [Execute Button]            │   │
│  │  ├─ Game               [Results Table]             │   │
│  │  ├─ Player             [Row Count]                 │   │
│  │  ├─ Team                                           │   │
│  │  ├─ Matches                                        │   │
│  │  ├─ Tournament                                     │   │
│  │  └─ ...                                            │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
         ↓ HTTPS Requests (with Authorization Header)
┌─────────────────────────────────────────────────────────────┐
│                    EXPRESS.JS SERVER                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Authentication Middleware                                   │
│  ├─ Verify JWT Token                                        │
│  └─ Check Admin Role                                        │
│                         ↓                                     │
│  API ROUTES (/api/admin)                                    │
│  ├─ GET /database/tables                                   │
│  │   └─ Returns: ['Users', 'Game', 'Player', ...]         │
│  │                                                          │
│  ├─ GET /database/table/:name                              │
│  │   ├─ Input: 'Player'                                    │
│  │   └─ Returns: { rows: [...] }                           │
│  │                                                          │
│  ├─ POST /database/query                                   │
│  │   ├─ Input: { query: "SELECT ..." }                     │
│  │   ├─ Validate: SELECT only                              │
│  │   └─ Returns: { rows: [...] }                           │
│  │                                                          │
│  └─ PUT /database/table/:name                              │
│      ├─ Input: { updates: {...}, rowIndex: 0 }             │
│      ├─ Find Primary Key                                   │
│      ├─ Build Safe UPDATE Query                            │
│      └─ Returns: { message: 'Row updated' }                │
│                                                               │
└─────────────────────────────────────────────────────────────┘
         ↓ MySQL Connection Pool
┌─────────────────────────────────────────────────────────────┐
│                    MYSQL DATABASE                           │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────────┐  │
│  │  Users   │  │  Game    │  │  Player  │  │   Team    │  │
│  ├──────────┤  ├──────────┤  ├──────────┤  ├───────────┤  │
│  │ user_id  │  │ game_id  │  │player_id │  │ team_id   │  │
│  │username  │  │ name     │  │ name     │  │ name      │  │
│  │password  │  │ type     │  │username  │  │ logo      │  │
│  │ role_id  │  │publisher │  │ email    │  │ region    │  │
│  └──────────┘  └──────────┘  └──────────┘  └───────────┘  │
│                                                               │
│  ... + 15+ more tables ...                                  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## User Flow - Editing a Record

```
1. ADMIN USER
   │
   └─→ Clicks "Database Editor" in sidebar
       │
       └─→ 2. FRONTEND LOADS
           │
           ├─→ GET /api/admin/database/tables
           │   │
           │   └─→ 3. SERVER RETURNS TABLE LIST
           │       │
           │       └─→ Displays as clickable cards
           │
           └─→ Admin clicks "Player" table
               │
               └─→ 4. GET /api/admin/database/table/Player
                   │
                   └─→ 5. SERVER RETURNS PLAYER DATA
                       │
                       └─→ Displays in grid (max 500 rows)
                           │
                           └─→ 6. ADMIN EDITS CELL
                               │
                               ├─ Clicks cell to edit (contenteditable)
                               ├─ Changes value (e.g., rank → "1200")
                               │
                               └─→ 7. ADMIN CLICKS "Save"
                                   │
                                   └─→ 8. PUT /api/admin/database/table/Player
                                       │
                                       ├─ Payload: { 
                                       │    updates: { rank: "1200" },
                                       │    rowIndex: 2 
                                       │  }
                                       │
                                       └─→ 9. SERVER PROCESSES
                                           │
                                           ├─ Validates table name: ✓ safe
                                           ├─ Validates column name: ✓ safe
                                           ├─ Finds Primary Key: player_id
                                           ├─ Builds query:
                                           │  UPDATE `Player` SET `rank`=?
                                           │  WHERE `player_id`=?
                                           ├─ Executes with params: ["1200", 5]
                                           │
                                           └─→ 10. DATABASE UPDATES
                                               │
                                               └─→ 11. RESPONSE SENT
                                                   │
                                                   └─→ 12. SUCCESS TOAST
                                                       │
                                                       └─→ Table refreshes
                                                           │
                                                           └─→ New value shown ✓
```

---

## User Flow - Running a Query

```
1. ADMIN USER
   │
   └─→ Clicks "Database Editor"
       │
       └─→ Clicks "SQL Query" tab
           │
           └─→ 2. ADMIN ENTERS QUERY
               │
               ├─ Example: SELECT * FROM Player 
               │           WHERE country = 'USA'
               │
               └─→ 3. CLICKS "Execute Query"
                   │
                   └─→ 4. POST /api/admin/database/query
                       │
                       ├─ Payload: {
                       │    query: "SELECT * FROM Player WHERE country = 'USA'"
                       │  }
                       │
                       └─→ 5. SERVER VALIDATES
                           │
                           ├─ Checks: Starts with SELECT? ✓
                           ├─ Checks: Not INSERT/UPDATE/DELETE? ✓
                           │
                           └─→ 6. EXECUTES QUERY
                               │
                               └─→ SELECT * FROM Player 
                                   WHERE country = 'USA'
                                   │
                                   └─→ 7. RETURNS RESULTS
                                       │
                                       ├─ Rows: [
                                       │    { player_id: 1, name: "John", country: "USA" },
                                       │    { player_id: 5, name: "Jane", country: "USA" }
                                       │  ]
                                       │
                                       └─→ 8. FRONTEND DISPLAYS
                                           │
                                           ├─ Results in table format
                                           ├─ Row count: 2
                                           │
                                           └─→ ✓ Complete
```

---

## Security Flow - SQL Injection Prevention

```
ATTACK ATTEMPT:
│
└─→ Admin enters: SELECT * FROM Player WHERE player_id = 1; DROP TABLE User;
    │
    └─→ VALIDATION LAYER 1: Query Type Check
        │
        ├─ Does query start with SELECT?
        │  └─ ✗ NO - Contains DROP command
        │     │
        │     └─→ SERVER BLOCKS: "Only SELECT queries allowed"
        │          │
        │          └─→ Error returned to user
        │
        └─→ Request blocked ✓

SAFE QUERY ATTEMPT:
│
└─→ Admin clicks Table cell and enters: '; DELETE FROM Team; --
    │
    └─→ VALIDATION LAYER 2: Parameterized Queries
        │
        ├─ Value: "'; DELETE FROM Team; --"
        ├─ Column: "rank" (validated safe)
        │
        ├─ SQL Built:
        │  UPDATE `Player` SET `rank` = ?
        │  WHERE `player_id` = ?
        │
        ├─ Parameters: ["'; DELETE FROM Team; --", 5]
        │
        └─→ Database treats entire value as string
            │
            └─→ ✓ SAFE - No code injection possible
```

---

## Security Layers

```
┌────────────────────────────────────────────┐
│         SECURITY STACK                     │
├────────────────────────────────────────────┤
│                                            │
│  Layer 1: Authentication                  │
│  ├─ JWT Token verification               │
│  ├─ Admin role check                     │
│  └─ Session validation                   │
│                                            │
│  Layer 2: Input Validation                │
│  ├─ Table name: ^[a-zA-Z0-9_]+$          │
│  ├─ Column name: ^[a-zA-Z0-9_]+$         │
│  └─ Query type: SELECT only               │
│                                            │
│  Layer 3: SQL Injection Prevention        │
│  ├─ Parameterized queries                │
│  ├─ Backtick escaping for identifiers    │
│  └─ Never string concatenation           │
│                                            │
│  Layer 4: Query Constraints               │
│  ├─ Max 500 rows per result              │
│  ├─ Primary key auto-detection           │
│  └─ Safe UPDATE construction             │
│                                            │
│  Layer 5: Error Handling                 │
│  ├─ Try-catch blocks                     │
│  ├─ Sanitized error messages            │
│  └─ User feedback                        │
│                                            │
└────────────────────────────────────────────┘
```

---

## API Response Formats

### Success Response

```javascript
// Tables list
GET /api/admin/database/tables
Response: ['Users', 'Game', 'Player', 'Team', 'Matches', ...]

// Table data
GET /api/admin/database/table/Player
Response: {
  rows: [
    { player_id: 1, name: "John", country: "USA", rank: 1200 },
    { player_id: 2, name: "Jane", country: "Canada", rank: 1150 }
  ]
}

// Query result
POST /api/admin/database/query
Response: {
  rows: [
    { player_id: 1, name: "John", country: "USA" }
  ]
}

// Update result
PUT /api/admin/database/table/Player
Response: {
  message: 'Row updated'
}
```

### Error Response

```javascript
// Invalid table name
Response (400): {
  error: 'Invalid table name'
}

// Non-SELECT query
Response (400): {
  error: 'Only SELECT queries allowed'
}

// Row not found
Response (404): {
  error: 'Row not found'
}

// Server error
Response (500): {
  error: 'Connection failed or query error'
}
```

---

## Component Dependencies

```
admin.html (Frontend)
    │
    ├─→ CSS (style.css)
    │   └─ .admin-section
    │   └─ .filter-tabs
    │   └─ .form-grid
    │   └─ etc.
    │
    ├─→ js/api.js
    │   ├─ API.get()
    │   ├─ API.post()
    │   └─ API.put() ← NEW
    │
    └─→ JavaScript Functions (inline)
        ├─ dbTab()
        ├─ loadTables()
        ├─ viewTableData()
        ├─ saveRowEdit()
        └─ executeQuery()
              ↓
        [HTTPS Requests]
              ↓
routes/admin.js (Backend)
    │
    ├─→ config/db.js
    │   └─ MySQL connection pool
    │
    ├─→ middleware/auth.js
    │   ├─ authMiddleware
    │   └─ adminOnly
    │
    └─→ New Endpoints
        ├─ GET /database/tables
        ├─ GET /database/table/:name
        ├─ POST /database/query
        └─ PUT /database/table/:name
              ↓
        [SQL Queries via parameterized statements]
              ↓
        MySQL Database
```

---

**Last Updated:** April 17, 2026
