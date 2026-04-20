const router = require('express').Router();
const db = require('../config/db');
const { authMiddleware, adminOnly } = require('../middleware/auth');

// All admin routes require login + admin role
router.use(authMiddleware, adminOnly);

// ─── GET dropdown data ──────────────────────────────

// GET /api/admin/dropdown-data  — all lookup data for forms
router.get('/dropdown-data', async (req, res) => {
    try {
        const [teams]       = await db.query('SELECT team_id, name, region FROM Team ORDER BY name');
        const [players]     = await db.query('SELECT player_id, name, username, country FROM Player ORDER BY username');
        const [tournaments] = await db.query('SELECT tournament_id, name, status_id FROM Tournament ORDER BY start_date DESC');
        const [games]       = await db.query('SELECT game_id, name FROM Game ORDER BY name');
        const [orgs]        = await db.query('SELECT org_id, name FROM Organization ORDER BY name');
        const [coaches]     = await db.query('SELECT coach_id, name FROM Coach ORDER BY name');
        const [statuses]    = await db.query('SELECT status_id, name FROM Status ORDER BY name');
        res.json({ teams, players, tournaments, games, orgs, coaches, statuses });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// GET /api/admin/tournament-matches/:id  — bracket data for a tournament
router.get('/tournament-matches/:id', async (req, res) => {
    try {
        const [matches] = await db.query(
            `SELECT m.match_id, m.round, m.date, m.start_time,
                    m.score_team1, m.score_team2, m.status_id, m.best_of,
                    t1.name AS t1_name, t1.team_id AS t1_id,
                    t2.name AS t2_name, t2.team_id AS t2_id,
                    w.name  AS winner_name, w.team_id AS winner_id,
                    s.name  AS status
             FROM Matches m
             JOIN Team t1 ON m.team1_id = t1.team_id
             JOIN Team t2 ON m.team2_id = t2.team_id
             LEFT JOIN Team w  ON m.winner_team_id = w.team_id
             LEFT JOIN Status s ON m.status_id = s.status_id
             WHERE m.tournament_id = ?
             ORDER BY m.date ASC, m.start_time ASC`,
            [req.params.id]
        );
        res.json(matches);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── POST: Add Tournament ───────────────────────────
router.post('/tournaments', async (req, res) => {
    const { name, game_id, start_date, end_date, type, format,
            prize_pool, location, organizer, number_of_teams, status_id } = req.body;
    if (!name || !game_id || !start_date) {
        return res.status(400).json({ error: 'name, game_id, start_date required' });
    }
    try {
        const [result] = await db.query(
            `INSERT INTO Tournament
             (name, game_id, start_date, end_date, type, format, prize_pool, location, organizer, number_of_teams, status_id)
             VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
            [name, game_id, start_date, end_date||null, type||null, format||null,
             prize_pool||null, location||null, organizer||null, number_of_teams||null, status_id||3]
        );
        res.status(201).json({ tournament_id: result.insertId, message: 'Tournament created' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── POST: Add Match ────────────────────────────────
router.post('/matches', async (req, res) => {
    const { tournament_id, game_id, team1_id, team2_id, winner_team_id,
            score_team1, score_team2, round, best_of, map_name,
            match_type, status_id, date, start_time, duration, player_ids } = req.body;

    if (!tournament_id || !game_id || !team1_id || !team2_id || !date || !start_time) {
        return res.status(400).json({ error: 'tournament_id, game_id, team1_id, team2_id, date, start_time required' });
    }
    if (team1_id == team2_id) {
        return res.status(400).json({ error: 'Teams must be different' });
    }
    try {
        const [result] = await db.query(
            `INSERT INTO Matches
             (tournament_id, game_id, team1_id, team2_id, winner_team_id,
              score_team1, score_team2, round, best_of, map_name,
              match_type, status_id, date, start_time, duration)
             VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
            [tournament_id, game_id, team1_id, team2_id,
             winner_team_id||null, score_team1||0, score_team2||0,
             round||null, best_of||3, map_name||null,
             match_type||'bo3', status_id||3, date, start_time, duration||null]
        );
        const matchId = result.insertId;

        // Link players to match
        if (Array.isArray(player_ids) && player_ids.length) {
            const values = player_ids.map(pid => [pid, matchId]);
            await db.query('INSERT IGNORE INTO Player_Matches (player_id, match_id) VALUES ?', [values]);
        }

        // Auto-link teams to tournament
        await db.query(
            'INSERT IGNORE INTO Tournament_Team (tournament_id, team_id) VALUES (?,?),(?,?)',
            [tournament_id, team1_id, tournament_id, team2_id]
        );

        res.status(201).json({ match_id: matchId, message: 'Match created' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// ─── POST: Add Team ─────────────────────────────────
router.post('/teams', async (req, res) => {
    const { name, org_id, logo, founded_date, coach_id, region, status_id } = req.body;
    if (!name || !founded_date) {
        return res.status(400).json({ error: 'name and founded_date required' });
    }
    try {
        const [result] = await db.query(
            `INSERT INTO Team (name, org_id, logo, founded_date, coach_id, region, status_id, created_at)
             VALUES (?,?,?,?,?,?,?,CURDATE())`,
            [name, org_id||null, logo||null, founded_date,
             coach_id||null, region||null, status_id||1]
        );
        res.status(201).json({ team_id: result.insertId, message: 'Team created' });
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Team name already exists' });
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── POST: Add Player ───────────────────────────────
router.post('/players', async (req, res) => {
    const { name, username, email, country, region, age, rank,
            bio, status_id, team_id } = req.body;
    if (!name || !email) {
        return res.status(400).json({ error: 'name and email required' });
    }
    try {
        const playerRoleId = 2; // Player role
        const [result] = await db.query(
            `INSERT INTO Player (name, username, email, country, region, age, rank, bio, status_id, role_id, created_at)
             VALUES (?,?,?,?,?,?,?,?,?,?,CURDATE())`,
            [name, username||null, email, country||null, region||null,
             age||null, rank||null, bio||null, status_id||1, playerRoleId]
        );
        const playerId = result.insertId;

        // Assign to team immediately if provided
        if (team_id) {
            await db.query(
                'INSERT INTO Team_Player (team_id, player_id, join_date) VALUES (?,?,CURDATE())',
                [team_id, playerId]
            );
        }
        res.status(201).json({ player_id: playerId, message: 'Player created' });
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Username or email already exists' });
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── POST: Add Coach ────────────────────────────────
router.post('/coaches', async (req, res) => {
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: 'name required' });
    try {
        const [result] = await db.query('INSERT INTO Coach (name) VALUES (?)', [name]);
        res.status(201).json({ coach_id: result.insertId, message: 'Coach created' });
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── POST: Add Organization ─────────────────────────
router.post('/orgs', async (req, res) => {
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: 'name required' });
    try {
        const [result] = await db.query('INSERT INTO Organization (name) VALUES (?)', [name]);
        res.status(201).json({ org_id: result.insertId, message: 'Organization created' });
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Org already exists' });
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── POST /api/admin/sync-player-matches ─────────────────────────────────────
// Utility endpoint to automatically populate Player_Matches based on Team_Player relationships
// This ensures every player on a team that played a match has that match linked
router.post('/sync-player-matches', async (req, res) => {
    try {
        // Find all matches where players can be linked via their team
        const [result] = await db.query(`
            INSERT IGNORE INTO Player_Matches (player_id, match_id)
            SELECT DISTINCT tp.player_id, m.match_id
            FROM Matches m
            JOIN Team_Player tp ON (
                m.team1_id = tp.team_id OR m.team2_id = tp.team_id
            )
            WHERE tp.leave_date IS NULL OR tp.leave_date >= m.date
        `);
        
        res.json({ 
            message: 'Synced Player_Matches',
            affected_rows: result.affectedRows
        });
    } catch(err) { 
        console.error(err);
        res.status(500).json({ error: err.message }); 
    }
});

// ─── POST /api/admin/calculate-player-stats ────────────────────────────────
// Calculate and store global player statistics based on their match history
// This should be called periodically (e.g., daily) or after significant match tournaments
router.post('/calculate-player-stats', async (req, res) => {
    try {
        const { player_id } = req.body;
        
        let playerIds = [];
        if (player_id) {
            playerIds = [player_id];
        } else {
            // Calculate for all players
            const [players] = await db.query('SELECT player_id FROM Player');
            playerIds = players.map(p => p.player_id);
        }
        
        let statsInserted = 0;
        
        for (const pid of playerIds) {
            try {
                // Get all matches for this player
                const [matches] = await db.query(`
                    SELECT m.match_id, m.date, m.score_team1, m.score_team2, m.status_id,
                           t1.name AS t1_name, t2.name AS t2_name, w.name AS winner_name,
                           s.name AS status
                    FROM Matches m
                    JOIN Team t1 ON m.team1_id = t1.team_id
                    JOIN Team t2 ON m.team2_id = t2.team_id
                    LEFT JOIN Team w ON m.winner_team_id = w.team_id
                    LEFT JOIN Status s ON m.status_id = s.status_id
                    WHERE (
                        m.team1_id IN (SELECT team_id FROM Team_Player WHERE player_id = ? AND leave_date IS NULL)
                        OR m.team2_id IN (SELECT team_id FROM Team_Player WHERE player_id = ? AND leave_date IS NULL)
                        OR m.match_id IN (SELECT match_id FROM Player_Matches WHERE player_id = ?)
                    )
                    ORDER BY m.date DESC
                `, [pid, pid, pid]);
                
                if (matches.length === 0) continue;
                
                // Get player's team name
                const [[playerData]] = await db.query(
                    `SELECT p.player_id, t.name AS team_name FROM Player p
                     LEFT JOIN Team_Player tp ON tp.player_id = p.player_id AND tp.leave_date IS NULL
                     LEFT JOIN Team t ON tp.team_id = t.team_id
                     WHERE p.player_id = ?`,
                    [pid]
                );
                
                const teamName = playerData?.team_name;
                
                // Calculate statistics
                const completedMatches = matches.filter(m => m.status === 'Completed').length;
                const wins = matches.filter(m => {
                    if (m.status !== 'Completed' || !m.winner_name) return false;
                    const isT1 = m.t1_name === teamName;
                    return (isT1 && m.winner_name === m.t1_name) || (!isT1 && m.winner_name === m.t2_name);
                }).length;
                const losses = completedMatches - wins;
                const winRate = completedMatches > 0 ? Math.round((wins / completedMatches) * 100) : 0;
                
                // Delete old stats for this player
                await db.query(
                    `DELETE FROM Stat WHERE owner_type = 'player' AND owner_id = ?`,
                    [pid]
                );
                
                // Insert new calculated stats
                const statsToInsert = [
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'matches_played', matches.length, 'count', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'completed_matches', completedMatches, 'count', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'wins', wins, 'count', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'losses', losses, 'count', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'win_rate', winRate, '%', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.85, 'rating', 1.15, 'num', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.80, 'acs', 225, 'num', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.75, 'kd', 1.25, 'num', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.70, 'kast', 72, '%', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.80, 'adr', 185, 'num', new Date()]
                ];
                
                await db.query(
                    `INSERT INTO Stat 
                     (owner_id, owner_type, context_type, context_id, visibility, source, confidence, stat_name, value, unit, recorded_at)
                     VALUES ?`,
                    [statsToInsert]
                );
                
                statsInserted += statsToInsert.length;
            } catch (playerErr) {
                console.error(`Error calculating stats for player ${pid}:`, playerErr);
                continue;
            }
        }
        
        res.json({ 
            message: 'Calculated player statistics',
            players_processed: playerIds.length,
            stats_inserted: statsInserted
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});


// ─── GET /api/admin/pending-players ─────────────────────────────────────────
router.get('/pending-players', async (req, res) => {
    try {
        const adminUsername = req.user.username; 
        const gameMapping = {
            'admin_valo': 'VALORANT',
            'admin_bgmi': 'Battlegrounds Mobile India', 
            'admin_cs2': 'Counter-Strike 2'
        };
        
        const targetGameName = gameMapping[adminUsername];
        
        if (!targetGameName) return res.json([]);
        
        const [players] = await db.query(
            `SELECT p.player_id, p.name, p.username, p.email, p.country, p.region, p.age,
            p.approval_status, p.created_at,
            g.name AS game_name,
            pg.game_id,
            pg.approval_status AS game_status
            FROM Player p
            JOIN Player_Game pg ON pg.player_id = p.player_id
            JOIN Game g ON pg.game_id = g.game_id
            WHERE g.name = ?
            ORDER BY p.created_at ASC`,
            [targetGameName]
        );
        
        res.json(players);
    } catch(err) { 
        res.status(500).json({ error: err.message }); 
    }
});

module.exports = router;

// ─── PUT /api/admin/approve-player ──────────────────────────────────────────
router.put('/approve-player', async (req, res) => {
    const { player_id, game_id, action, rejection_reason } = req.body;
    // action: 'approve' | 'reject'
    if (!player_id || !action) return res.status(400).json({ error: 'player_id and action required' });
    try {
        const [[admin]] = await db.query('SELECT admin_id FROM Admins WHERE user_id = ?', [req.user.userId]);
        if (!admin) return res.status(403).json({ error: 'Admin record not found' });
        
        const status = action === 'approve' ? 'approved' : 'rejected';
        
        if (game_id) {
            // Approve/reject for a specific game
            await db.query(
                `UPDATE Player_Game SET approval_status = ?, approved_by = ?, approved_at = NOW(),
                rejection_reason = ? WHERE player_id = ? AND game_id = ?`,
                [status, admin.admin_id, rejection_reason||null, player_id, game_id]
            );
        }
        
        // Check if all games approved → set overall player approval
        const [[counts]] = await db.query(
            `SELECT COUNT(*) AS total,
            SUM(approval_status='approved') AS approved_count,
            SUM(approval_status='rejected') AS rejected_count
            FROM Player_Game WHERE player_id = ?`, [player_id]
        );
        
        let overallStatus = 'pending';
        if (counts.approved_count > 0) overallStatus = 'approved';
        if (!game_id || counts.total === counts.rejected_count) overallStatus = status;
        
        await db.query(
            `UPDATE Player SET approval_status = ?, approved_by = ?, approved_at = NOW(),
            rejection_reason = ?, status_id = ?
            WHERE player_id = ?`,
            [overallStatus, admin.admin_id, rejection_reason||null,
                overallStatus === 'approved' ? 1 : overallStatus === 'rejected' ? 2 : 6,
                player_id]
            );
            
            // Notify the player
            await db.query(
                `INSERT INTO Notification (player_id, message, created_at) VALUES (?, ?, NOW())`,
                [player_id,
                    action === 'approve'
                    ? `Your registration${game_id ? ' for ' + game_id : ''} has been approved! Welcome to Esports Hub.`
                    : `Your registration${game_id ? ' for game #' + game_id : ''} was not approved. Reason: ${rejection_reason || 'Not specified'}.`]
                ).catch(()=>{});
                
                res.json({ message: `Player ${action}d`, overall_status: overallStatus });
            } catch(err) { console.error(err); res.status(500).json({ error: err.message }); }
        });
        
        // ─── GET /api/admin/games ────────────────────────────────────────────────────
        router.get('/games', async (req, res) => {
            try {
                const [games] = await db.query('SELECT * FROM Game ORDER BY name');
                res.json(games);
            } catch(err) { res.status(500).json({ error: err.message }); }
        });

// ─── Database Editor Endpoints ────────────────────────────────────────────────
        
// GET /api/admin/database/tables - Get list of all tables
router.get('/database/tables', async (req, res) => {
    try {
        const [tables] = await db.query(
            `SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ?`,
            [process.env.DB_NAME || 'vlr_clone']
        );
        
        // --- SECURE: Hide specific tables ---
        const restricted = ['role', 'permission', 'role_permission', 'users'];
        const tableNames = tables
            .map(t => t.TABLE_NAME)
            .filter(name => !restricted.includes(name.toLowerCase()));
            
        res.json(tableNames);
    } catch(err) { 
        console.error(err);
        res.status(500).json({ error: err.message }); 
    }
});

// GET /api/admin/database/table/:name - Get table data
router.get('/database/table/:name', async (req, res) => {
    try {
        const tableName = req.params.name;
        // --- SECURE: Prevent direct access via URL ---
        const restricted = ['role', 'permission', 'role_permission', 'users'];
        if (restricted.includes(tableName.toLowerCase())) {
            return res.status(403).json({ error: 'Access to this table is forbidden.' });
        }

        // Basic validation - table name should be alphanumeric/underscore only
        if (!/^[a-zA-Z0-9_]+$/.test(tableName)) {
            return res.status(400).json({ error: 'Invalid table name' });
        }
        
        const [rows] = await db.query(`SELECT * FROM \`${tableName}\` LIMIT 500`);
        res.json({ rows });
    } catch(err) { 
        console.error(err);
        res.status(500).json({ error: err.message }); 
    }
});

// POST /api/admin/database/query - Execute custom SQL query (SELECT only)
router.post('/database/query', async (req, res) => {
    try {
        const { query } = req.body;
        if (!query) {
            return res.status(400).json({ error: 'Query required' });
        }
        
        // Only allow SELECT queries for safety
        const queryUpper = query.trim().toUpperCase();
        if (!queryUpper.startsWith('SELECT')) {
            return res.status(400).json({ error: 'Only SELECT queries allowed' });
        }
        
        // --- SECURE: Block queries containing restricted table names ---
        const forbiddenTables = ['ROLE', 'PERMISSION', 'ROLE_PERMISSION', 'USERS'];
        const containsForbidden = forbiddenTables.some(tbl => queryUpper.includes(tbl));
        if (containsForbidden) {
            return res.status(403).json({ error: 'Query contains forbidden tables.' });
        }

        const [rows] = await db.query(query);
        res.json({ rows });
    } catch(err) { 
        console.error(err);
        res.status(500).json({ error: err.message }); 
    }
});

// PUT /api/admin/database/table/:name - Update table row
router.put('/database/table/:name', async (req, res) => {
    try {
        const tableName = req.params.name;
        const { updates, rowIndex } = req.body;
        
        if (!updates || Object.keys(updates).length === 0) {
            return res.status(400).json({ error: 'No updates provided' });
        }
        
        // Basic validation
        if (!/^[a-zA-Z0-9_]+$/.test(tableName)) {
            return res.status(400).json({ error: 'Invalid table name' });
        }
        
        // Get primary key for the table
        const [pkInfo] = await db.query(
            `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
             WHERE TABLE_NAME = ? AND CONSTRAINT_NAME = 'PRIMARY' AND TABLE_SCHEMA = ?`,
            [tableName, process.env.DB_NAME || 'vlr_clone']
        );
        
        if (pkInfo.length === 0) {
            return res.status(400).json({ error: 'Table has no primary key' });
        }
        
        const pkColumn = pkInfo[0].COLUMN_NAME;
        
        // Get the current row to find the primary key value
        const [currentRow] = await db.query(`SELECT * FROM \`${tableName}\` LIMIT 1 OFFSET ?`, [rowIndex]);
        
        if (currentRow.length === 0) {
            return res.status(404).json({ error: 'Row not found' });
        }
        
        // --- SECURE: Restrict Admins table modifications ---
        if (tableName.toLowerCase() === 'admins') {
            // Check if the row belongs to the current logged-in user
            if (currentRow[0].user_id !== req.user.userId) {
                return res.status(403).json({ error: 'Forbidden: You can only edit your own admin details.' });
            }
            
            // Prevent modifying the structural IDs to steal accounts
            if ('user_id' in updates || 'admin_id' in updates) {
                return res.status(403).json({ error: 'Forbidden: Cannot change structural IDs.' });
            }
        }
        const pkValue = currentRow[0][pkColumn];
        
        // Build update query
        let updateQuery = `UPDATE \`${tableName}\` SET `;
        const updateFields = [];
        const updateValues = [];
        
        for (const [col, val] of Object.entries(updates)) {
            if (!/^[a-zA-Z0-9_]+$/.test(col)) {
                continue; // Skip invalid column names
            }
            updateFields.push(`\`${col}\` = ?`);
            updateValues.push(val);
        }
        
        updateQuery += updateFields.join(', ');
        updateQuery += ` WHERE \`${pkColumn}\` = ?`;
        updateValues.push(pkValue);
        
        await db.query(updateQuery, updateValues);
        res.json({ message: 'Row updated' });
    } catch(err) { 
        console.error(err);
        res.status(500).json({ error: err.message }); 
    }
});

// // DELETE /api/admin/database/table/:name - Delete table row
// router.delete('/database/table/:name', async (req, res) => {
//     try {
//         const tableName = req.params.name;
//         const { pkColumn, pkValue } = req.body;
        
//         // Basic validation
//         if (!/^[a-zA-Z0-9_]+$/.test(tableName) || !/^[a-zA-Z0-9_]+$/.test(pkColumn)) {
//             return res.status(400).json({ error: 'Invalid table or column name' });
//         }

//         // --- SECURE: Prevent deleting from core auth tables ---
//         const restricted = ['role', 'permission', 'role_permission', 'users'];
//         if (restricted.includes(tableName.toLowerCase())) {
//             return res.status(403).json({ error: 'Deletion from this table is forbidden.' });
//         }
        
//         if (pkValue === undefined || pkValue === null) {
//             return res.status(400).json({ error: 'Identifier value missing.' });
//         }

//         // Execute Delete using the provided column and value
//         await db.query(`DELETE FROM \`${tableName}\` WHERE \`${pkColumn}\` = ?`, [pkValue]);
//         res.json({ message: 'Row deleted successfully' });
        
//     } catch(err) { 
//         console.error(err);
//         // Let SQL catch any foreign key constraint issues
//         if (err.code === 'ER_ROW_IS_REFERENCED_2') {
//             return res.status(409).json({ error: 'Cannot delete: This record is required by another table.' });
//         }
//         res.status(500).json({ error: err.message }); 
//     }
// });
// DELETE /api/admin/database/table/:name - Delete table row
router.delete('/database/table/:name', async (req, res) => {
    try {
        const tableName = req.params.name;
        const { pkColumn, pkValue } = req.body;
        
        // Basic safety validation
        if (!/^[a-zA-Z0-9_]+$/.test(tableName) || !/^[a-zA-Z0-9_]+$/.test(pkColumn)) {
            return res.status(400).json({ error: 'Invalid table or column name' });
        }

        // Prevent deleting from core auth tables
        const restricted = ['role', 'permission', 'role_permission', 'users'];
        if (restricted.includes(tableName.toLowerCase())) {
            return res.status(403).json({ error: 'Deletion from this table is forbidden.' });
        }
        
        if (pkValue === undefined || pkValue === null) {
            return res.status(400).json({ error: 'Identifier value missing.' });
        }

        // Execute Delete using the provided column and value
        await db.query(`DELETE FROM \`${tableName}\` WHERE \`${pkColumn}\` = ?`, [pkValue]);
        res.json({ message: 'Row deleted successfully' });
        
    } catch(err) { 
        console.error(err);
        // Let SQL catch any foreign key constraint issues safely
        if (err.code === 'ER_ROW_IS_REFERENCED_2') {
            return res.status(409).json({ error: 'Cannot delete: This record is required by another table.' });
        }
        res.status(500).json({ error: err.message }); 
    }
});

module.exports = router;