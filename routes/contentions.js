const router = require('express').Router();
const db     = require('../config/db');
const { authMiddleware, adminOnly } = require('../middleware/auth');

// ════════════════════════════════════════════════
//  HELPERS
// ════════════════════════════════════════════════

// Get admin's assigned game (null = super-admin, sees all)
async function getAdminGame(userId) {
    const [[admin]] = await db.query(
        'SELECT admin_id, game_id FROM Admins WHERE user_id = ?', [userId]
    );
    return admin || null;
}

// Get player record from user
async function getPlayer(userId) {
    const [[p]] = await db.query(
        'SELECT player_id, name, username FROM Player WHERE user_id = ?', [userId]
    );
    return p || null;
}

// Send a notification to a player
async function notify(playerId, message) {
    await db.query(
        'INSERT INTO Notification (player_id, message, is_read, created_at) VALUES (?,?,FALSE,NOW())',
        [playerId, message]
    ).catch(() => {});
}

// Notify all admins of a game (or all super-admins if game_id null)
async function notifyAdmins(gameId, message) {
    const [admins] = await db.query(
        `SELECT a.admin_id, p.player_id FROM Admins a
         LEFT JOIN Player p ON p.user_id = a.user_id
         WHERE a.game_id = ? OR a.game_id IS NULL`,
        [gameId || null]
    ).catch(() => [[]]);
    for (const a of admins) {
        if (a.player_id) await notify(a.player_id, message);
    }
    // Also insert into Audit_Log for admin visibility
    await db.query(
        'INSERT INTO Audit_Log (entity_type, action, timestamp, details) VALUES (?,?,NOW(),?)',
        ['Contention', 'new_filed', message]
    ).catch(() => {});
}

const FILER_SELECT = `
    c.filer_type,
    c.raised_by,       p_f.name     AS filer_player_name,  p_f.username AS filer_player_username,
    c.raised_by_team,  t_f.name     AS filer_team_name,    t_f.logo     AS filer_team_logo,
    c.raised_by_coach, co_f.name    AS filer_coach_name`;

const FILER_JOINS = `
    LEFT JOIN Player p_f   ON c.raised_by       = p_f.player_id
    LEFT JOIN Team   t_f   ON c.raised_by_team   = t_f.team_id
    LEFT JOIN Coach  co_f  ON c.raised_by_coach  = co_f.coach_id`;

// ════════════════════════════════════════════════
//  PUBLIC: Active Bans — only relevant to viewer
// ════════════════════════════════════════════════

// routes/contentions.js
router.get('/bans/active', async (req, res) => {
    try {
        // Determine who is asking (to scope visibility)
        let viewerPlayerId = null;
        let viewerTeamId   = null;
        const token = req.headers['authorization']?.split(' ')[1];

        // Safely extract viewer info if token exists
        if (token) {
            try {
                const jwt = require('jsonwebtoken');
                const decoded = jwt.verify(token, process.env.JWT_SECRET);
                if (decoded.role === 'Player' && decoded.playerId) {
                    viewerPlayerId = decoded.playerId;
                    // Get their team
                    const [[tp]] = await db.query(
                        'SELECT team_id FROM Team_Player WHERE player_id = ? AND leave_date IS NULL LIMIT 1',
                        [decoded.playerId]
                    );
                    if (tp) viewerTeamId = tp.team_id;
                }
            } catch(e) { /* Token invalid, proceed as guest */ }
        }

        // Player bans: show only if viewer is that player, OR if admin, OR no auth (show all)
        let playerBanWhere = '';
        let teamBanWhere   = '';
        const params1 = [], params2 = [];

        // Players only see their own bans; guests/admins see all
        if (viewerPlayerId) {
            playerBanWhere = 'AND bt.player_id = ?';
            params1.push(viewerPlayerId);
            teamBanWhere = viewerTeamId ? 'AND tb.team_id = ?' : 'AND 1=0';
            if (viewerTeamId) params2.push(viewerTeamId);
        }

        const [playerBans] = await db.query(
            `SELECT b.*, bt.player_id, -- Removed bt.scope here
                    p.name AS player_name, p.username AS player_username,
                    g.name AS game_name,
                    u.username AS issued_by_username,
                    c.reason AS contention_reason
            FROM Ban b
            LEFT JOIN Ban_Target bt ON bt.ban_id = b.ban_id AND bt.player_id IS NOT NULL
            LEFT JOIN Player p      ON bt.player_id = p.player_id
            LEFT JOIN Game   g      ON bt.game_id   = g.game_id
            LEFT JOIN Admins a      ON b.issued_by  = a.admin_id
            LEFT JOIN Users  u      ON a.user_id    = u.user_id
            LEFT JOIN Contention c  ON b.contention_id = c.contention_id
            WHERE bt.player_id IS NOT NULL
            AND (b.end_date IS NULL OR b.end_date >= CURDATE())
            ${playerBanWhere}
            ORDER BY b.start_date DESC`,
            params1
        );

        // Clean SQL for Team Bans
        const [teamBans] = await db.query(
            `SELECT b.*, tb.team_id, tb.affects_roster, tb.ban_scope,
                    t.name AS team_name, t.logo AS team_logo, t.region AS team_region,
                    u.username AS issued_by_username,
                    c.reason AS contention_reason
             FROM Ban b
             JOIN Team_Ban tb   ON tb.ban_id    = b.ban_id
             JOIN Team t        ON tb.team_id   = t.team_id
             LEFT JOIN Admins a ON b.issued_by  = a.admin_id
             LEFT JOIN Users  u ON a.user_id    = u.user_id
             LEFT JOIN Contention c ON b.contention_id = c.contention_id
             WHERE (b.end_date IS NULL OR b.end_date >= CURDATE())
               ${teamBanWhere}
             ORDER BY b.start_date DESC`,
            params2
        );

        res.json({ player_bans: playerBans, team_bans: teamBans });
    } catch(err) {
        console.error("SQL Error in /bans/active:", err);
        res.status(500).json({ error: "Database error fetching bans" });
    }
});

// routes/contentions.js - Add this new route
router.get('/games/list', async (req, res) => {
    const [rows] = await db.query('SELECT game_id, name FROM Game ORDER BY name');
    res.json(rows);
});

const TARGET_SELECT = `
    c.target_player_id, p_t.username AS target_player_username, p_t.name AS target_player_name,
    c.target_team_id,   t_t.name     AS target_team_name,   t_t.logo AS target_team_logo`;

const TARGET_JOINS = `
    LEFT JOIN Player p_t ON c.target_player_id = p_t.player_id
    LEFT JOIN Team   t_t ON c.target_team_id   = t_t.team_id`;
// ════════════════════════════════════════════════
//  GET /  — list contentions
//   - Admin sees only contentions for their game (or all if super-admin)
//   - Player sees ONLY their own + their team's contentions
// ════════════════════════════════════════════════
router.get('/', authMiddleware, async (req, res) => {
    try {
        const isAdmin = req.user.role === 'Admin';

        if (isAdmin) {
            const admin = await getAdminGame(req.user.userId);
            // Super-admin (game_id IS NULL) sees everything; game-admin sees only their game
            const gameFilter = admin?.game_id
                ? 'WHERE c.game_id = ? OR c.game_id IS NULL'
                : '';
            const params = admin?.game_id ? [admin.game_id] : [];

            const [rows] = await db.query(
                `SELECT c.contention_id, c.reason, c.description, c.created_at, c.resolved_at,
                        c.filer_type, c.game_id, g.name AS game_name,
                        ${FILER_SELECT},
                        ${TARGET_SELECT},
                        s.name AS status_name,
                        b.ban_id, b.ban_type, b.duration,
                        b.start_date AS ban_start, b.end_date AS ban_end,
                        tb.team_id AS banned_team_id
                 FROM Contention c
                 JOIN Status s ON c.status_id = s.status_id
                 LEFT JOIN Game g ON c.game_id = g.game_id
                 ${FILER_JOINS}
                 ${TARGET_JOINS}
                 LEFT JOIN Ban b       ON b.contention_id = c.contention_id
                 LEFT JOIN Team_Ban tb ON tb.ban_id = b.ban_id
                 ${gameFilter}
                 ORDER BY c.created_at DESC`,
                params
            );
            return res.json(rows);
        }

        // Player: only see their own contentions
        const player = await getPlayer(req.user.userId);
        if (!player) return res.json([]);

        // Get their team
        const [[teamMem]] = await db.query(
            `SELECT tp.team_id, t.coach_id FROM Team_Player tp
             JOIN Team t ON tp.team_id = t.team_id
             WHERE tp.player_id = ? AND tp.leave_date IS NULL LIMIT 1`,
            [player.player_id]
        );

        const [rows] = await db.query(
            `SELECT c.contention_id, c.reason, c.description, c.created_at, c.resolved_at,
                    c.filer_type, c.game_id, g.name AS game_name,
                    ${FILER_SELECT},
                    s.name AS status_name,
                    b.ban_id, b.ban_type, b.duration,
                    b.start_date AS ban_start, b.end_date AS ban_end,
                    bt_p.player_id AS banned_player_id,
                    tb.team_id     AS banned_team_id
             FROM Contention c
             JOIN Status s ON c.status_id = s.status_id
             LEFT JOIN Game g ON c.game_id = g.game_id
             ${FILER_JOINS}
             LEFT JOIN Ban b        ON b.contention_id = c.contention_id
             LEFT JOIN Ban_Target bt_p ON bt_p.ban_id   = b.ban_id AND bt_p.player_id = ?
             LEFT JOIN Team_Ban tb  ON tb.ban_id = b.ban_id AND tb.team_id = ?
             WHERE
               -- Filed by this player
               c.raised_by = ?
               -- Filed by their team
               OR c.raised_by_team = ?
               -- Filed by their coach
               OR c.raised_by_coach = ?
               -- This player was BANNED under this contention
               OR bt_p.player_id = ?
               -- This player's TEAM was banned
               OR tb.team_id = ?
             ORDER BY c.created_at DESC`,
            [
                player.player_id,
                teamMem?.team_id || 0,
                player.player_id,
                teamMem?.team_id || 0,
                teamMem?.coach_id || 0,
                player.player_id,
                teamMem?.team_id || 0
            ]
        );
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

router.get('/targets/players', async (req, res) => {
    const [rows] = await db.query('SELECT player_id, username, name FROM Player ORDER BY username');
    res.json(rows);
});

router.get('/targets/teams', async (req, res) => {
    const [rows] = await db.query('SELECT team_id, name FROM Team ORDER BY name');
    res.json(rows);
});

// ════════════════════════════════════════════════
//  ADMIN: GET /all-appeals/list
// ════════════════════════════════════════════════
router.get('/all-appeals/list', authMiddleware, adminOnly, async (req, res) => {
    try {
        const admin = await getAdminGame(req.user.userId);
        const gameFilter = admin?.game_id ? 'WHERE c.game_id = ? OR c.game_id IS NULL' : '';
        const params = admin?.game_id ? [admin.game_id] : [];

        const [rows] = await db.query(
            `SELECT cs.*, s.name AS status_name,
                    p.name AS player_name, p.username AS player_username,
                    ac.contention_id,
                    c.reason AS contention_reason
             FROM Customer_Support cs
             JOIN Appeal_Contention ac ON cs.support_id = ac.support_id
             JOIN Contention c ON ac.contention_id = c.contention_id
             JOIN Status s ON cs.status_id = s.status_id
             LEFT JOIN Player p ON cs.player_id = p.player_id
             ${gameFilter}
             ORDER BY cs.created_at DESC`,
            params
        );
        res.json(rows);
    } catch(err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// ════════════════════════════════════════════════
//  GET /:id — full detail
// ════════════════════════════════════════════════
router.get('/:id', authMiddleware, async (req, res) => {
    try {
        const [[c]] = await db.query(
            `SELECT c.*, g.name AS game_name,
                    ${FILER_SELECT},
                    s.name AS status_name
             FROM Contention c
             JOIN Status s ON c.status_id = s.status_id
             LEFT JOIN Game g ON c.game_id = g.game_id
             ${FILER_JOINS}
             WHERE c.contention_id = ?`,
            [req.params.id]
        );
        if (!c) return res.status(404).json({ error: 'Not found' });

        // Access check: player can only see if they're involved
        if (req.user.role === 'Player') {
            const player = await getPlayer(req.user.userId);
            if (!player) return res.status(403).json({ error: 'Forbidden' });
            const [[tp]] = await db.query(
                'SELECT tp.team_id, t.coach_id FROM Team_Player tp JOIN Team t ON tp.team_id=t.team_id WHERE tp.player_id=? AND tp.leave_date IS NULL LIMIT 1',
                [player.player_id]
            );
            const involved =
                c.raised_by === player.player_id ||
                c.raised_by_team === tp?.team_id ||
                c.raised_by_coach === tp?.coach_id;
            // Also allowed if they are the ban target
            if (!involved) {
                const [[banTarget]] = await db.query(
                    `SELECT 1 FROM Ban b
                     LEFT JOIN Ban_Target bt ON bt.ban_id=b.ban_id AND bt.player_id=?
                     LEFT JOIN Team_Ban tb   ON tb.ban_id=b.ban_id AND tb.team_id=?
                     WHERE b.contention_id=? AND (bt.player_id IS NOT NULL OR tb.team_id IS NOT NULL) LIMIT 1`,
                    [player.player_id, tp?.team_id||0, req.params.id]
                );
                if (!banTarget) return res.status(403).json({ error: 'Access denied' });
            }
        }

        const [history] = await db.query(
            `SELECT ch.*, s.name AS status_name, u.username AS admin_username, ch.note
             FROM Contention_History ch
             JOIN Status s ON ch.status_id = s.status_id
             JOIN Admins a ON ch.changed_by = a.admin_id
             JOIN Users  u ON a.user_id     = u.user_id
             WHERE ch.contention_id = ?
             ORDER BY ch.changed_at ASC`,
            [req.params.id]
        );

        const [[ban]] = await db.query(
            `SELECT b.*,
                    GROUP_CONCAT(DISTINCT p.name ORDER BY p.name SEPARATOR ', ')     AS banned_player_names,
                    GROUP_CONCAT(DISTINCT p.username ORDER BY p.name SEPARATOR ', ') AS banned_player_usernames,
                    GROUP_CONCAT(DISTINCT btm.player_id SEPARATOR ',')               AS banned_player_ids,
                    tbn.team_id AS team_ban_team_id, tbn.affects_roster, tbn.ban_scope,
                    t.name AS banned_team_name,
                    g.name AS game_name,
                    u.username AS issued_by_username
             FROM Ban b
             LEFT JOIN Ban_Target btm ON btm.ban_id   = b.ban_id AND btm.player_id IS NOT NULL
             LEFT JOIN Player p       ON btm.player_id = p.player_id
             LEFT JOIN Team_Ban tbn   ON tbn.ban_id    = b.ban_id
             LEFT JOIN Team t         ON tbn.team_id   = t.team_id
             LEFT JOIN Game  g        ON btm.game_id   = g.game_id
             LEFT JOIN Admins a       ON b.issued_by   = a.admin_id
             LEFT JOIN Users  u       ON a.user_id     = u.user_id
             WHERE b.contention_id = ?
             GROUP BY b.ban_id`,
            [req.params.id]
        ).catch(() => [[null]]);

        // Appeals — only the filer (or their team) and admin see them
        const [appeals] = await db.query(
            `SELECT cs.*, s.name AS status_name,
                    p.name AS player_name, p.username AS player_username
             FROM Appeal_Contention ac
             JOIN Customer_Support cs ON ac.support_id    = cs.support_id
             JOIN Status s            ON cs.status_id     = s.status_id
             LEFT JOIN Player p       ON cs.player_id     = p.player_id
             WHERE ac.contention_id = ?
             ORDER BY cs.created_at DESC`,
            [req.params.id]
        );

        res.json({ ...c, history, ban: ban || null, appeals });
    } catch(err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// ════════════════════════════════════════════════
//  POST /  — file a contention
// ════════════════════════════════════════════════
router.post('/', authMiddleware, async (req, res) => {
    const { reason, description, filer_type, team_id, game_id, target_player_id, target_team_id } = req.body;
    if (!reason)   return res.status(400).json({ error: 'reason is required' });
    if (!game_id)  return res.status(400).json({ error: 'game_id is required — specify which game this contention is for' });

    try {
        const player = await getPlayer(req.user.userId);
        if (!player) return res.status(403).json({ error: 'Only players can file contentions' });

        let raised_by = null, raised_by_team = null, raised_by_coach = null;

        if (filer_type === 'player') {
            raised_by = player.player_id;
        } else if (filer_type === 'team') {
            if (!team_id) return res.status(400).json({ error: 'team_id required' });
            const [[mem]] = await db.query(
                'SELECT 1 FROM Team_Player WHERE team_id=? AND player_id=? AND leave_date IS NULL',
                [team_id, player.player_id]
            );
            if (!mem) return res.status(403).json({ error: 'You are not on this team' });
            raised_by_team = team_id;
        } else if (filer_type === 'coach') {
            if (!coach_id) return res.status(400).json({ error: 'coach_id required' });
            raised_by_coach = coach_id;
        }

        //was set to 6 earlier caused problem
        const [r] = await db.query(
        `INSERT INTO Contention 
         (status_id, filer_type, raised_by, raised_by_team, game_id, reason, description, target_player_id, target_team_id, created_at)
         VALUES (7, ?, ?, ?, ?, ?, ?, ?, ?, CURDATE())`,
        [filer_type, raised_by, raised_by_team, game_id, reason, description, target_player_id || null, target_team_id || null]
    );

        // Notify the admin(s) responsible for this game
        const [[game]] = await db.query('SELECT name FROM Game WHERE game_id=?', [game_id]);
        await notifyAdmins(game_id,
            `🔔 New contention filed for ${game?.name||'game #'+game_id}: "${reason}" by ${player.name} (@${player.username})`
        );

        res.status(201).json({
            contention_id: r.insertId,
            message: `Contention filed for ${game?.name||'game'}. The assigned admin will review it.`
        });
    } catch(err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// ════════════════════════════════════════════════
//  POST /:id/appeal  — file appeal
// ════════════════════════════════════════════════
router.post('/:id/appeal', authMiddleware, async (req, res) => {
    const { subject, description } = req.body;
    if (!subject || !description) return res.status(400).json({ error: 'subject and description required' });

    try {
        const player = await getPlayer(req.user.userId);
        if (!player) return res.status(403).json({ error: 'Only players can file appeals' });

        // Must be a ban target or filer to appeal
        const [[c]] = await db.query(
            'SELECT contention_id, game_id, raised_by, raised_by_team FROM Contention WHERE contention_id=?',
            [req.params.id]
        );
        if (!c) return res.status(404).json({ error: 'Contention not found' });

        // Check they are involved (filer or ban target)
        const [[tp]] = await db.query(
            'SELECT team_id FROM Team_Player WHERE player_id=? AND leave_date IS NULL LIMIT 1',
            [player.player_id]
        );
        const [[banTarget]] = await db.query(
            `SELECT 1 FROM Ban b
             LEFT JOIN Ban_Target bt ON bt.ban_id=b.ban_id AND bt.player_id=?
             LEFT JOIN Team_Ban tb   ON tb.ban_id=b.ban_id AND tb.team_id=?
             WHERE b.contention_id=? LIMIT 1`,
            [player.player_id, tp?.team_id||0, req.params.id]
        );
        const isFiler = c.raised_by === player.player_id || c.raised_by_team === tp?.team_id;
        if (!isFiler && !banTarget) {
            return res.status(403).json({ error: 'You can only appeal contentions where you are the filer or ban target' });
        }

        const [r] = await db.query(
            `INSERT INTO Customer_Support
             (player_id, type, category, subject, description, status_id, priority, created_at)
             VALUES (?, 'Appeal', 'ban_appeal', ?, ?, 6, 'high', CURDATE())`,
            [player.player_id, subject, description]
        );
        await db.query(
            'INSERT INTO Appeal_Contention (support_id, contention_id) VALUES (?,?)',
            [r.insertId, req.params.id]
        );

        // Notify game admin of the appeal
        if (c.game_id) {
            await notifyAdmins(c.game_id,
                `⚖️ New appeal filed for Contention #${req.params.id} by @${player.username}: "${subject}"`
            );
        }

        res.status(201).json({ support_id: r.insertId, message: 'Appeal filed — the admin will review it' });
    } catch(err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// ════════════════════════════════════════════════
//  ADMIN: PUT /:id/status
// ════════════════════════════════════════════════
router.put('/:id/status', authMiddleware, adminOnly, async (req, res) => {
    const { status_id, note } = req.body;
    if (!status_id) return res.status(400).json({ error: 'status_id required' });
    try {
        const admin = await getAdminGame(req.user.userId);
        if (!admin) return res.status(403).json({ error: 'Admin record not found' });

        // Verify admin manages this game
        const [[c]] = await db.query(
            'SELECT contention_id, game_id, raised_by, raised_by_team FROM Contention WHERE contention_id=?',
            [req.params.id]
        );
        if (!c) return res.status(404).json({ error: 'Not found' });
        if (admin.game_id && c.game_id && admin.game_id !== c.game_id) {
            return res.status(403).json({ error: 'You can only manage contentions for your assigned game' });
        }

        await db.query(
            'UPDATE Contention SET status_id=?, resolved_at=IF(? IN (5,7),CURDATE(),NULL) WHERE contention_id=?',
            [status_id, status_id, req.params.id]
        );
        await db.query(
            'INSERT INTO Contention_History (contention_id,status_id,changed_by,note,changed_at) VALUES (?,?,?,?,CURDATE())',
            [req.params.id, status_id, admin.admin_id, note||null]
        );

        // Notify filer about status change
        const statusNames = { 5:'Completed', 6:'Pending', 7:'Resolved' };
        const statusLabel = statusNames[status_id] || `Status #${status_id}`;
        if (c.raised_by) {
            await notify(c.raised_by,
                `📋 Your contention #${req.params.id} status changed to: ${statusLabel}${note?' — '+note:''}`
            );
        }

        res.json({ message: 'Status updated' });
    } catch(err) {
        console.error(err); res.status(500).json({ error: err.message });
    }
});

// ════════════════════════════════════════════════
//  ADMIN: POST /:id/ban
// ════════════════════════════════════════════════
router.post('/:id/ban', authMiddleware, adminOnly, async (req, res) => {
    const { ban_type, duration, start_date, end_date, description, evidence,
            player_ids, team_id, affects_roster, ban_scope, game_id } = req.body;

    if (!ban_type || !start_date)
        return res.status(400).json({ error: 'ban_type and start_date required' });
    if ((!player_ids || !player_ids.length) && !team_id)
        return res.status(400).json({ error: 'Provide player_id(s) or team_id' });

    try {
        const admin = await getAdminGame(req.user.userId);
        if (!admin) return res.status(403).json({ error: 'Admin not found' });

        // Verify admin manages this contention's game
        const [[c]] = await db.query(
            'SELECT contention_id, game_id, raised_by FROM Contention WHERE contention_id=?',
            [req.params.id]
        );
        if (!c) return res.status(404).json({ error: 'Contention not found' });
        if (admin.game_id && c.game_id && admin.game_id !== c.game_id) {
            return res.status(403).json({ error: 'You can only issue bans for your assigned game' });
        }

        const [banRes] = await db.query(
            `INSERT INTO Ban (contention_id, ban_type, duration, start_date, end_date,
              description, evidence, issued_by)
             VALUES (?,?,?,?,?,?,?,?)`,
            [req.params.id, ban_type, duration||null, start_date, end_date||null,
             description||null, evidence||null, admin.admin_id]
        );
        const banId = banRes.insertId;

        const targets = Array.isArray(player_ids) ? player_ids : (player_ids ? [player_ids] : []);

        // Player targets
        for (const pid of targets) {
            await db.query(
                'INSERT IGNORE INTO Ban_Target (ban_id, player_id, team_id, game_id) VALUES (?,?,NULL,?)',
                [banId, pid, game_id||c.game_id||null]
            );
            if (ban_type !== 'warning' && ban_type !== 'tournament_ban') {
                await db.query('UPDATE Player SET status_id=8 WHERE player_id=?', [pid]);
            }
            // Notify the banned player
            await notify(pid,
                `⛔ You have been issued a ${ban_type.replace(/_/g,' ')} starting ${start_date}.${duration?' Duration: '+duration+' days.':''}${description?' Reason: '+description:''}`
            );
        }

        // Team target
        if (team_id) {
            await db.query(
                'INSERT IGNORE INTO Team_Ban (ban_id, team_id, affects_roster) VALUES (?,?,?)',
                [banId, team_id, affects_roster !== false, ban_scope||'tournament']
            );
            await db.query(
                'INSERT IGNORE INTO Ban_Target (ban_id, player_id, team_id, game_id) VALUES (?,NULL,?,?)',
                [banId, team_id, game_id||c.game_id||null, ban_scope||'tournament']
            );

            if (affects_roster !== false) {
                const [roster] = await db.query(
                    'SELECT player_id FROM Team_Player WHERE team_id=? AND leave_date IS NULL', [team_id]
                );
                for (const { player_id } of roster) {
                    if (ban_type !== 'warning') {
                        await db.query('UPDATE Player SET status_id=8 WHERE player_id=?', [player_id]);
                    }
                    await notify(player_id,
                        `⛔ Your team has been issued a ${ban_scope||'tournament'} ban starting ${start_date}.${description?' Reason: '+description:''}`
                    );
                }
            }
            if (ban_type === 'permanent' || ban_type === 'team_ban') {
                await db.query('UPDATE Team SET status_id=2 WHERE team_id=?', [team_id]);
            }
        }

        await db.query(
            'UPDATE Contention SET status_id=8, resolved_at=CURDATE() WHERE contention_id=?',
            [req.params.id]
        );
        await db.query(
            'INSERT INTO Contention_History (contention_id,status_id,changed_by,note,changed_at) VALUES (?,8,?,?,CURDATE())',
            [req.params.id, admin.admin_id, `Ban issued: ${ban_type}`]
        );
        res.status(201).json({ ban_id: banId, message: 'Ban issued' });
    } catch(err) {
        console.error(err); res.status(500).json({ error: err.message });
    }
});

// ════════════════════════════════════════════════
//  ADMIN: PUT /appeals/:support_id
// ════════════════════════════════════════════════
router.put('/appeals/:support_id', authMiddleware, adminOnly, async (req, res) => {
    const { status_id, lift_ban, rejection_note } = req.body;
    try {
        const admin = await getAdminGame(req.user.userId);
        if (!admin) return res.status(403).json({ error: 'Admin not found' });

        await db.query(
            'UPDATE Customer_Support SET status_id=?,resolved_at=CURDATE(),admin_id=? WHERE support_id=?',
            [status_id||5, admin.admin_id, req.params.support_id]
        );

        // Get the player who filed the appeal for notification
        const [[cs]] = await db.query(
            'SELECT player_id FROM Customer_Support WHERE support_id=?',
            [req.params.support_id]
        );
        const [[ac]] = await db.query(
            'SELECT contention_id FROM Appeal_Contention WHERE support_id=?',
            [req.params.support_id]
        );

        if (lift_ban && ac) {
            const [[ban]] = await db.query(
                'SELECT * FROM Ban WHERE contention_id=?', [ac.contention_id]
            );
            if (ban) {
                const [pts] = await db.query(
                    'SELECT player_id FROM Ban_Target WHERE ban_id=? AND player_id IS NOT NULL', [ban.ban_id]
                );
                for (const { player_id } of pts) {
                    await db.query('UPDATE Player SET status_id=1 WHERE player_id=?', [player_id]);
                    await notify(player_id,
                        `✅ Your appeal (Support #${req.params.support_id}) has been GRANTED. Your ban has been lifted. Welcome back!`
                    );
                }
                const [tts] = await db.query('SELECT team_id FROM Team_Ban WHERE ban_id=?', [ban.ban_id]);
                for (const { team_id } of tts) {
                    await db.query('UPDATE Team SET status_id=1 WHERE team_id=?', [team_id]);
                    // Notify all team players
                    const [roster] = await db.query(
                        'SELECT player_id FROM Team_Player WHERE team_id=? AND leave_date IS NULL', [team_id]
                    );
                    for (const { player_id } of roster) {
                        await notify(player_id,
                            `✅ Your team's ban appeal has been granted. The team ban has been lifted!`
                        );
                    }
                }
                await db.query('UPDATE Ban SET end_date=CURDATE() WHERE ban_id=?', [ban.ban_id]);
            }
        } else if (cs?.player_id) {
            // Notify appeal was denied
            await notify(cs.player_id,
                `📋 Your appeal (Support #${req.params.support_id}) has been reviewed and ${lift_ban ? 'granted' : 'denied'}.${rejection_note ? ' Note: '+rejection_note : ''}`
            );
        }

        res.json({ message: lift_ban ? 'Appeal granted — ban lifted' : 'Appeal reviewed' });
    } catch(err) {
        console.error(err); res.status(500).json({ error: err.message });
    }
});

// ════════════════════════════════════════════════
//  Social Links
// ════════════════════════════════════════════════
router.get('/social/:entity_type/:entity_id', async (req, res) => {
    try {
        const [links] = await db.query(
            'SELECT * FROM Social_Link WHERE entity_type=? AND entity_id=? ORDER BY platform',
            [req.params.entity_type, req.params.entity_id]
        );
        res.json(links);
    } catch(err) { res.status(500).json({ error: err.message }); }
});

router.post('/social', authMiddleware, adminOnly, async (req, res) => {
    const { entity_type, entity_id, platform, url, display_name, is_verified } = req.body;
    if (!entity_type || !entity_id || !platform || !url)
        return res.status(400).json({ error: 'entity_type, entity_id, platform, url required' });
    try {
        const [r] = await db.query(
            'INSERT INTO Social_Link (entity_type, entity_id, platform, url, display_name, is_verified) VALUES (?,?,?,?,?,?)',
            [entity_type, entity_id, platform, url, display_name||null, is_verified||false]
        );
        res.status(201).json({ link_id: r.insertId });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ════════════════════════════════════════════════
//  Player History
// ════════════════════════════════════════════════
router.get('/history/player/:player_id', async (req, res) => {
    try {
        const [rows] = await db.query(
            `SELECT ph.*, t.name AS team_name, t.logo AS team_logo, t.region
             FROM Player_History ph
             LEFT JOIN Team t ON ph.team_id = t.team_id
             WHERE ph.player_id = ?
             ORDER BY ph.join_date DESC`,
            [req.params.player_id]
        );
        res.json(rows);
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ════════════════════════════════════════════════
//  Match Maps
// ════════════════════════════════════════════════
router.get('/maps/match/:match_id', async (req, res) => {
    try {
        const [maps] = await db.query(
            `SELECT mm.*, t.name AS winner_name
             FROM Match_Map mm
             LEFT JOIN Team t ON mm.winner_team_id = t.team_id
             WHERE mm.match_id = ?
             ORDER BY mm.map_number`,
            [req.params.match_id]
        );
        res.json(maps);
    } catch(err) { res.status(500).json({ error: err.message }); }
});

router.post('/maps', authMiddleware, adminOnly, async (req, res) => {
    const { match_id, map_number, map_name, score_team1, score_team2, winner_team_id, duration_mins } = req.body;
    if (!match_id || !map_number) return res.status(400).json({ error: 'match_id and map_number required' });
    try {
        await db.query(
            `INSERT INTO Match_Map (match_id,map_number,map_name,score_team1,score_team2,winner_team_id,duration_mins)
             VALUES (?,?,?,?,?,?,?)
             ON DUPLICATE KEY UPDATE map_name=VALUES(map_name),score_team1=VALUES(score_team1),
             score_team2=VALUES(score_team2),winner_team_id=VALUES(winner_team_id),duration_mins=VALUES(duration_mins)`,
            [match_id, map_number, map_name||null, score_team1||0, score_team2||0, winner_team_id||null, duration_mins||null]
        );
        res.status(201).json({ message: 'Map result saved' });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;
