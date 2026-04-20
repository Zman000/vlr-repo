const router = require('express').Router();
const db = require('../config/db');

// GET /api/rankings/teams  ?region=&game=
router.get('/teams', async (req, res) => {
    try {
        const { region, game } = req.query;
        let where = [];
        let params = [];

        if (region) { where.push('t.region = ?'); params.push(region); }
        if (game) { where.push('g.name = ?'); params.push(game); } // Added game filter

        const whereClause = where.length ? 'WHERE ' + where.join(' AND ') : '';

        // Rank by win rate from completed matches (Filtered by Game)
        const [rows] = await db.query(
            `SELECT t.team_id, t.name, t.logo, t.region,
                    SUM(CASE WHEN m.winner_team_id = t.team_id THEN 1 ELSE 0 END)        AS wins,
                    SUM(CASE WHEN m.winner_team_id IS NOT NULL
                              AND m.winner_team_id != t.team_id THEN 1 ELSE 0 END)        AS losses,
                    COUNT(m.match_id)                                                     AS total,
                    ROUND(
                        SUM(CASE WHEN m.winner_team_id = t.team_id THEN 1 ELSE 0 END)
                        / NULLIF(COUNT(m.match_id),0) * 100, 1
                    )                                                                     AS win_rate
             FROM Team t
             LEFT JOIN Matches m ON (m.team1_id = t.team_id OR m.team2_id = t.team_id) AND m.winner_team_id IS NOT NULL
             LEFT JOIN Game g ON m.game_id = g.game_id -- Added Game Join
             ${whereClause}
             GROUP BY t.team_id
             ORDER BY wins DESC, win_rate DESC`,
            params
        );

        // Add rank number
        const ranked = rows.map((r, i) => ({ rank: i + 1, ...r }));
        res.json(ranked);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── Rankings Route: Fixes the infinite loading ────────────────────────────
router.get('/rankings/players', async (req, res) => {
    const region = req.query.region;
    try {
        let query = `
            SELECT p.player_id, p.username, p.name, p.region, 
                   t.name as team_name, t.logo_url as team_logo,
                   AVG(s.rating) as avg_rating, AVG(s.acs) as avg_acs, AVG(s.kd) as avg_kd,
                   RANK() OVER (ORDER BY AVG(s.rating) DESC) as \`rank\`
            FROM Player p
            LEFT JOIN Teams t ON p.team_id = t.team_id
            LEFT JOIN Stats s ON p.player_id = s.player_id
        `;
        
        if (region) {
            query += ` WHERE p.region = ? GROUP BY p.player_id`;
            const [rows] = await db.query(query, [region]);
            res.json(rows);
        } else {
            query += ` GROUP BY p.player_id`;
            const [rows] = await db.query(query);
            res.json(rows);
        }
    } catch (err) {
        res.status(500).json({ error: "Failed to fetch rankings" });
    }
});

// ─── Update Profile Route: Fixes the "No changes saved" issue ──────────────
router.post('/player/update', async (req, res) => {
    const { userId, name, country, region, age, avatar_url } = req.body;
    try {
        await db.query(
            `UPDATE Player SET name = ?, country = ?, region = ?, age = ?, avatar_url = ? 
             WHERE user_id = ?`,
            [name, country, region, age, avatar_url, userId]
        );
        res.json({ success: true, message: "Changes saved successfully!" });
    } catch (err) {
        res.status(500).json({ error: "Could not save changes to database" });
    }
});

// GET /api/rankings/players  ?region=&game=
router.get('/players', async (req, res) => {
    try {
        const { region, game } = req.query;
        let where = [];
        let params = [];

        if (region) { where.push('p.region = ?'); params.push(region); }
        if (game) { where.push('g.name = ?'); params.push(game); } // Added game filter
        const whereClause = where.length ? 'WHERE ' + where.join(' AND ') : '';

        // Added BGMI and CS2 missing columns to your existing query
        const [rows] = await db.query(
            `SELECT p.player_id, p.name, p.username, p.country, p.region,
                    p.rank, p.profile_image,
                    t.name AS team_name, t.logo AS team_logo,
                    AVG(CASE WHEN st.stat_name = 'rating' THEN st.value END) AS avg_rating,
                    AVG(CASE WHEN st.stat_name = 'acs'    THEN st.value END) AS avg_acs,
                    AVG(CASE WHEN st.stat_name = 'kd'     THEN st.value END) AS avg_kd,
                    AVG(CASE WHEN st.stat_name = 'kast'   THEN st.value END) AS avg_kast,
                    AVG(CASE WHEN st.stat_name = 'adr'    THEN st.value END) AS avg_adr,
                    MAX(CASE WHEN st.stat_name = 'chicken_dinners' THEN st.value END) AS chicken_dinners,
                    MAX(CASE WHEN st.stat_name = 'total_points'    THEN st.value END) AS total_points,
                    MAX(CASE WHEN st.stat_name = 'kill_points'     THEN st.value END) AS kill_points
             FROM Player p
             LEFT JOIN Team_Player tp ON tp.player_id = p.player_id AND tp.leave_date IS NULL
             LEFT JOIN Team t ON tp.team_id = t.team_id
             LEFT JOIN Stat st ON st.owner_type = 'player' AND st.owner_id = p.player_id
             LEFT JOIN Player_Game pg ON p.player_id = pg.player_id -- Added Player_Game Join
             LEFT JOIN Game g ON pg.game_id = g.game_id             -- Added Game Join
             ${whereClause}
             GROUP BY p.player_id`,
            params
        );

        // Sort dynamically based on the game
        if (game === 'BGMI') {
            rows.sort((a, b) => (b.total_points || 0) - (a.total_points || 0));
        } else if (game === 'CS2') {
            rows.sort((a, b) => (b.avg_rating || 0) - (a.avg_rating || 0));
        } else {
            rows.sort((a, b) => (b.avg_acs || 0) - (a.avg_acs || 0));
        }

        const ranked = rows.map((r, i) => ({ rank: i + 1, ...r }));
        res.json(ranked);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;