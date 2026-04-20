# Database Editor Feature - Admin Panel

## Overview
Added a comprehensive **Database Editor** module to the admin panel that allows administrators to view and directly edit database tables from the frontend.

## Features Added

### 1. **Frontend UI (admin.html)**
- New "Database" section in admin sidebar with "Database Editor" option
- Two tabs: **Tables** and **SQL Query**

#### Tables Tab
- Displays all database tables as clickable cards
- Click any table to view its contents in an editable grid
- Features:
  - View up to 500 rows per table
  - Inline editing of cell values (contenteditable)
  - Save button to persist changes
  - Back button to return to tables list

#### SQL Query Tab
- Execute custom SQL SELECT queries
- Query results displayed in a formatted table
- Results show row count
- Error handling with error messages

### 2. **Backend API Endpoints (routes/admin.js)**

#### GET `/api/admin/database/tables`
- Returns list of all database tables
- Uses INFORMATION_SCHEMA to get table names

#### GET `/api/admin/database/table/:name`
- Returns all data from specified table (limit 500 rows)
- Parameters: `tableName` (validated against alphanumeric/underscore)

#### POST `/api/admin/database/query`
- Executes custom SELECT queries
- Request body: `{ query: "SELECT * FROM Table WHERE ..." }`
- Response: `{ rows: [...] }`
- **Security**: Only SELECT queries allowed (enforced server-side)

#### PUT `/api/admin/database/table/:name`
- Updates a table row
- Request body:
  ```json
  {
    "updates": { "column1": "newValue", "column2": "newValue" },
    "rowIndex": 0
  }
  ```
- Automatically finds primary key and updates row
- **Security**: Validates table/column names, uses parameterized queries

### 3. **Frontend JavaScript Functions (admin.html)**

#### `dbTab(el, tab)`
- Switches between Tables and SQL Query tabs

#### `loadTables()`
- Fetches all tables from database
- Displays them as clickable cards in a grid

#### `viewTableData(tableName)`
- Fetches and displays table contents
- Makes cells editable with contenteditable attribute
- Shows Save button for each row

#### `saveRowEdit(tableName, rowIndex)`
- Collects changed cell values
- Sends PUT request to update database
- Shows toast notification on success/error

#### `executeQuery()`
- Executes custom SQL query from textarea
- Formats results in a table
- Handles errors gracefully

### 4. **API Module Update (public/js/api.js)**
- Added `put()` method for PUT requests
- Follows same pattern as existing `get()` and `post()` methods
- Includes authentication headers

## Security Features

1. **Authentication**: All endpoints require admin login (authMiddleware, adminOnly)
2. **Query Validation**: 
   - SELECT-only queries for custom queries
   - Alphanumeric + underscore validation for table/column names
3. **SQL Injection Prevention**: Uses parameterized queries with backticks for identifiers
4. **Primary Key Detection**: Automatically finds table primary key for safe updates

## How to Use

### As Admin:
1. Login with admin account
2. Go to Admin Panel → Database → Database Editor
3. **To view/edit tables:**
   - Tables tab shows all database tables
   - Click a table to view its contents
   - Edit cell values directly (click cell to edit)
   - Click "Save" to persist changes
4. **To run custom queries:**
   - SQL Query tab
   - Enter SELECT query
   - Click "Execute Query"
   - View results in formatted table

## Limitations & Notes

- Displays max 500 rows per table (prevents memory issues)
- SQL Query tab only allows SELECT statements
- Editing is per-row (saves individual row changes)
- NULL values shown as "NULL" text
- All changes require admin authentication

## Files Modified

1. **public/admin.html** - Added UI and JavaScript functions
2. **routes/admin.js** - Added 4 new API endpoints
3. **public/js/api.js** - Added PUT method

## Testing

All files verified for:
- ✓ JavaScript syntax correctness
- ✓ Proper function definitions
- ✓ API endpoint routing
- ✓ Error handling

## Future Enhancements

- Add INSERT/DELETE functionality (with confirmation dialogs)
- Export table data to CSV
- Table relationships visualization
- Query builder UI
- Search within tables
- Pagination for large tables
- Field type-specific editors
