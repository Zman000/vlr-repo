const router = require('express').Router();
const db = require('../config/db');

// GET /api/teams  ?region=NA|EU|APAC|SA
router.get('/', async (req, res) => {
    try {
        const { region } = req.query;
        const where = region ? 'WHERE t.region = ?' : '';
        const params = region ? [region] : [];

        const [rows] = await db.query(
            `SELECT t.team_id, t.name, t.logo, t.region, t.founded_date,
                    o.name AS org_name,
                    c.name AS coach_name,
                    s.name AS status,
                    COUNT(DISTINCT tp.player_id) AS player_count
             FROM Team t
             LEFT JOIN Organization o ON t.org_id = o.org_id
             LEFT JOIN Coach c ON t.coach_id = c.coach_id
             LEFT JOIN Status s ON t.status_id = s.status_id
             LEFT JOIN Team_Player tp ON tp.team_id = t.team_id AND tp.leave_date IS NULL
             ${where}
             GROUP BY t.team_id
             ORDER BY t.name`,
            params
        );
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// GET /api/teams/:id
router.get('/:id', async (req, res) => {
    try {
        const [[team]] = await db.query(
            `SELECT t.*, o.name AS org_name, c.name AS coach_name, s.name AS status
             FROM Team t
             LEFT JOIN Organization o ON t.org_id = o.org_id
             LEFT JOIN Coach c ON t.coach_id = c.coach_id
             LEFT JOIN Status s ON t.status_id = s.status_id
             WHERE t.team_id = ?`,
            [req.params.id]
        );
        if (!team) return res.status(404).json({ error: 'Team not found' });

        // Roster
        const [players] = await db.query(
            `SELECT p.player_id, p.name, p.username, p.country, p.rank, p.profile_image,
                    tp.join_date
             FROM Team_Player tp
             JOIN Player p ON tp.player_id = p.player_id
             WHERE tp.team_id = ? AND tp.leave_date IS NULL
             ORDER BY p.name`,
            [req.params.id]
        );

        // Recent matches (last 10)
        const [matches] = await db.query(
            `SELECT m.match_id, m.date, m.score_team1, m.score_team2, m.round,
                    t1.name AS t1_name, t1.logo AS t1_logo,
                    t2.name AS t2_name, t2.logo AS t2_logo,
                    w.name  AS winner_name,
                    s.name  AS status,
                    tr.name AS tournament_name
             FROM Matches m
             JOIN Team t1 ON m.team1_id = t1.team_id
             JOIN Team t2 ON m.team2_id = t2.team_id
             LEFT JOIN Team w  ON m.winner_team_id = w.team_id
             LEFT JOIN Status s ON m.status_id = s.status_id
             JOIN Tournament tr ON m.tournament_id = tr.tournament_id
             WHERE (m.team1_id = ? OR m.team2_id = ?)
             ORDER BY m.date DESC LIMIT 10`,
            [req.params.id, req.params.id]
        );

        // Tournaments participated in
        const [tournaments] = await db.query(
            `SELECT tr.tournament_id, tr.name, tr.start_date, tr.end_date, tr.type, tr.prize_pool,
                    s.name AS status
             FROM Tournament_Team tt
             JOIN Tournament tr ON tt.tournament_id = tr.tournament_id
             LEFT JOIN Status s ON tr.status_id = s.status_id
             WHERE tt.team_id = ?
             ORDER BY tr.start_date DESC`,
            [req.params.id]
        );

        res.json({ ...team, players, matches, tournaments });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
