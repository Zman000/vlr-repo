const router = require('express').Router();
const db = require('../config/db');

// GET /api/tournaments  ?status= &game_id=
router.get('/', async (req, res) => {
    try {
        const { status, game_id } = req.query;
        let where = [];
        let params = [];

        if (status)  { where.push('s.name = ?');         params.push(status.charAt(0).toUpperCase() + status.slice(1)); }
        if (game_id) { where.push('tr.game_id = ?');     params.push(game_id); }

        const whereSQL = where.length ? 'WHERE ' + where.join(' AND ') : '';

        const [rows] = await db.query(
            `SELECT tr.tournament_id, tr.name, tr.start_date, tr.end_date,
                    tr.type, tr.format, tr.prize_pool, tr.location,
                    tr.organizer, tr.number_of_teams,
                    s.name AS status,
                    g.name AS game_name, g.game_id,
                    COUNT(DISTINCT tt.team_id) AS registered_teams
             FROM Tournament tr
             JOIN Game g ON tr.game_id = g.game_id
             LEFT JOIN Status s ON tr.status_id = s.status_id
             LEFT JOIN Tournament_Team tt ON tt.tournament_id = tr.tournament_id
             ${whereSQL}
             GROUP BY tr.tournament_id
             ORDER BY tr.start_date DESC`,
            params
        );
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// GET /api/tournaments/:id
router.get('/:id', async (req, res) => {
    try {
        const [[tournament]] = await db.query(
            `SELECT tr.*, s.name AS status, g.name AS game_name
             FROM Tournament tr
             JOIN Game g ON tr.game_id = g.game_id
             LEFT JOIN Status s ON tr.status_id = s.status_id
             WHERE tr.tournament_id = ?`,
            [req.params.id]
        );
        if (!tournament) return res.status(404).json({ error: 'Tournament not found' });

        // Teams in tournament
        const [teams] = await db.query(
            `SELECT t.team_id, t.name, t.logo, t.region
             FROM Tournament_Team tt
             JOIN Team t ON tt.team_id = t.team_id
             WHERE tt.tournament_id = ?
             ORDER BY t.name`,
            [req.params.id]
        );

        // Matches in tournament
        const [matches] = await db.query(
            `SELECT m.match_id, m.date, m.start_time, m.round, m.score_team1, m.score_team2,
                    m.best_of, m.map_name,
                    t1.name AS t1_name, t1.logo AS t1_logo,
                    t2.name AS t2_name, t2.logo AS t2_logo,
                    w.name  AS winner_name,
                    s.name  AS status
             FROM Matches m
             JOIN Team t1 ON m.team1_id = t1.team_id
             JOIN Team t2 ON m.team2_id = t2.team_id
             LEFT JOIN Team w  ON m.winner_team_id = w.team_id
             LEFT JOIN Status s ON m.status_id = s.status_id
             WHERE m.tournament_id = ?
             ORDER BY m.date DESC, m.start_time DESC`,
            [req.params.id]
        );

        // Prize breakdown
        const [prizes] = await db.query(
            `SELECT * FROM Prize WHERE tournament_id = ? ORDER BY position`,
            [req.params.id]
        );

        res.json({ ...tournament, teams, matches, prizes });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
