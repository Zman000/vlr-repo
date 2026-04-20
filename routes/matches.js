const router = require('express').Router();
const db = require('../config/db');

// GET /api/matches  ?status=upcoming|live|completed  &tournament_id=  &team_id=
router.get('/', async (req, res) => {
    try {
        const { status, tournament_id, team_id, limit = 200 } = req.query;
        let where = [];
        let params = [];

        if (status) {
            where.push('s.name = ?');
            params.push(status.charAt(0).toUpperCase() + status.slice(1).toLowerCase());
        }
        if (tournament_id) { where.push('m.tournament_id = ?'); params.push(tournament_id); }
        if (team_id) { where.push('(m.team1_id = ? OR m.team2_id = ?)'); params.push(team_id, team_id); }

        const whereSQL = where.length ? 'WHERE ' + where.join(' AND ') : '';

        const [rows] = await db.query(
            `SELECT m.match_id, m.date, m.start_time, m.round, m.best_of, m.map_name,
                    m.score_team1, m.score_team2, m.duration,
                    t1.team_id AS t1_id, t1.name AS t1_name, t1.logo AS t1_logo, t1.region AS t1_region,
                    t2.team_id AS t2_id, t2.name AS t2_name, t2.logo AS t2_logo, t2.region AS t2_region,
                    w.team_id  AS w_id,  w.name  AS w_name,
                    s.name     AS status,
                    tr.tournament_id, tr.name AS tournament_name, tr.type AS tournament_type,
                    g.name     AS game_name
             FROM Matches m
             JOIN Team t1 ON m.team1_id = t1.team_id
             JOIN Team t2 ON m.team2_id = t2.team_id
             LEFT JOIN Team w  ON m.winner_team_id = w.team_id
             LEFT JOIN Status s ON m.status_id = s.status_id
             JOIN Tournament tr ON m.tournament_id = tr.tournament_id
             JOIN Game g ON m.game_id = g.game_id
             ${whereSQL}
             ORDER BY m.date DESC, m.start_time DESC
             LIMIT ?`,
            [...params, parseInt(limit)]
        );
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// GET /api/matches/count
router.get('/count', async (req, res) => {
    try {
        const [[{ total }]] = await db.query('SELECT COUNT(*) as total FROM Matches');
        res.json({ total });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

    // GET /api/matches/:id
// router.get('/:id', async (req, res) => {
//     try {
//         const [[match]] = await db.query(
//             `SELECT m.*, 
//                     t1.name AS t1_name, t1.logo AS t1_logo, t1.region AS t1_region,
//                     t2.name AS t2_name, t2.logo AS t2_logo, t2.region AS t2_region,
//                     w.name  AS winner_name,
//                     s.name  AS status,
//                     tr.name AS tournament_name, tr.type AS tournament_type, tr.prize_pool,
//                     g.name  AS game_name
//             FROM Matches m
//             JOIN Team t1 ON m.team1_id = t1.team_id
//             JOIN Team t2 ON m.team2_id = t2.team_id
//             LEFT JOIN Team w  ON m.winner_team_id = w.team_id
//             LEFT JOIN Status s ON m.status_id = s.status_id
//             JOIN Tournament tr ON m.tournament_id = tr.tournament_id
//             JOIN Game g ON m.game_id = g.game_id
//             WHERE m.match_id = ?`,
//             [req.params.id]
//         );
//         if (!match) return res.status(404).json({ error: 'Match not found' });

//         // Get players in this match
//         const [players] = await db.query(
//             `SELECT p.player_id, p.name, p.username, p.country, p.rank,
//                     tp.team_id
//             FROM Player_Matches pm
//             JOIN Player p ON pm.player_id = p.player_id
//             JOIN Team_Player tp ON tp.player_id = p.player_id AND tp.leave_date IS NULL
//             WHERE pm.match_id = ?`,
//             [req.params.id]
//         );

//         // Get stats for this match
//         const [stats] = await db.query(
//             `SELECT * FROM Stat WHERE context_type = 'match' AND context_id = ?`,
//             [req.params.id]
//         );

//         res.json({ ...match, players, stats });
//     } catch (err) {
//         console.error(err);
//         res.status(500).json({ error: 'Server error' });
//     }
// });
// GET /api/matches/:id
router.get('/:id', async (req, res) => {
    try {
        const [[match]] = await db.query(
            `SELECT m.*, 
                    t1.name AS t1_name, t1.logo AS t1_logo, t1.region AS t1_region,
                    t2.name AS t2_name, t2.logo AS t2_logo, t2.region AS t2_region,
                    w.name  AS winner_name,
                    s.name  AS status,
                    tr.name AS tournament_name, tr.type AS tournament_type, tr.prize_pool,
                    g.name  AS game_name,
                    g.official_youtube_url -- Added this line
             FROM Matches m
             JOIN Team t1 ON m.team1_id = t1.team_id
             JOIN Team t2 ON m.team2_id = t2.team_id
             LEFT JOIN Team w  ON m.winner_team_id = w.team_id
             LEFT JOIN Status s ON m.status_id = s.status_id
             JOIN Tournament tr ON m.tournament_id = tr.tournament_id
             JOIN Game g ON m.game_id = g.game_id
             WHERE m.match_id = ?`,
            [req.params.id]
        );

        if (!match) return res.status(404).json({ error: 'Match not found' });

        // NEW: Get match-specific streams from Platform_Streaming
        const [streams] = await db.query(
            `SELECT ps.link, ps.language, p.name AS platform_name 
             FROM Platform_Streaming ps
             JOIN Platform p ON ps.platform_id = p.platform_id
             WHERE ps.match_id = ?`,
            [req.params.id]
        );

        const [players] = await db.query(
            `SELECT p.player_id, p.name, p.username, p.country, p.rank, tp.team_id
             FROM Player_Matches pm
             JOIN Player p ON pm.player_id = p.player_id
             JOIN Team_Player tp ON tp.player_id = p.player_id AND tp.leave_date IS NULL
             WHERE pm.match_id = ?`,
            [req.params.id]
        );

        // Get stats for this match
        const [stats] = await db.query(
            `SELECT * FROM Stat WHERE context_type = 'match' AND context_id = ?`,
            [req.params.id]
        );

        // Include streams in the response
        res.json({ ...match, players, stats, streams });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
