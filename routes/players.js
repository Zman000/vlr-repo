const router = require('express').Router();
const db = require('../config/db');

// GET /api/players  ?country=  &region=  &q= (search)
router.get('/', async (req, res) => {
    try {
        const { country, region, q, limit = 100 } = req.query;
        let where = [];
        let params = [];

        if (country) { where.push('p.country = ?'); params.push(country); }
        if (region)  { where.push('p.region = ?');  params.push(region); }
        if (q) {
            where.push('(p.name LIKE ? OR p.username LIKE ?)');
            params.push(`%${q}%`, `%${q}%`);
        }

        const whereSQL = where.length ? 'WHERE ' + where.join(' AND ') : '';

        const [rows] = await db.query(
            `SELECT p.player_id, p.name, p.username, p.country, p.region,
                    p.rank, p.age, p.profile_image,
                    t.team_id, t.name AS team_name, t.logo AS team_logo,
                    s.name AS status
             FROM Player p
             LEFT JOIN Team_Player tp ON tp.player_id = p.player_id AND tp.leave_date IS NULL
             LEFT JOIN Team t ON tp.team_id = t.team_id
             LEFT JOIN Status s ON p.status_id = s.status_id
             ${whereSQL}
             ORDER BY p.name
             LIMIT ?`,
            [...params, parseInt(limit)]
        );
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// GET /api/players/:id
router.get('/:id', async (req, res) => {
    try {
        const [[player]] = await db.query(
            `SELECT p.*, s.name AS status,
                    t.team_id, t.name AS team_name, t.logo AS team_logo
             FROM Player p
             LEFT JOIN Team_Player tp ON tp.player_id = p.player_id AND tp.leave_date IS NULL
             LEFT JOIN Team t ON tp.team_id = t.team_id
             LEFT JOIN Status s ON p.status_id = s.status_id
             WHERE p.player_id = ?`,
            [req.params.id]
        );
        if (!player) return res.status(404).json({ error: 'Player not found' });

        // Game accounts — all of them, grouped by game
        const [accounts] = await db.query(
            `SELECT ga.*, g.name AS game_name
             FROM Game_Account ga
             JOIN Game g ON ga.game_id = g.game_id
             WHERE ga.player_id = ?
             ORDER BY ga.game_id, ga.is_primary DESC, ga.last_active DESC`,
            [req.params.id]
        );

        // Recent matches — Follow the chain: Player → Team_Player → Matches (where team is team1 or team2) → Tournament
        // This also includes matches from Player_Matches for backwards compatibility
        const [matches] = await db.query(
            `SELECT DISTINCT m.match_id, m.date, m.score_team1, m.score_team2, m.round,
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
             WHERE (
               -- Player is on team1
               m.team1_id IN (SELECT team_id FROM Team_Player WHERE player_id = ? AND leave_date IS NULL)
               OR
               -- Player is on team2
               m.team2_id IN (SELECT team_id FROM Team_Player WHERE player_id = ? AND leave_date IS NULL)
               OR
               -- Player has direct match entry
               m.match_id IN (SELECT match_id FROM Player_Matches WHERE player_id = ?)
             )
             ORDER BY m.date DESC
             LIMIT 10`,
            [req.params.id, req.params.id, req.params.id]
        );

        // Stats — Calculate from match data
        // For now, we'll calculate basic stats from matches
        // In a production system, these would be updated after each match via webhooks
        let stats = [];
        
        if (matches.length > 0) {
            // Calculate aggregate stats from matches
            // Note: These are simplified calculations. Real stats would come from detailed match data.
            const totalMatches = matches.length;
            const completedMatches = matches.filter(m => m.status === 'Completed').length;
            const wins = matches.filter(m => {
                if (m.status !== 'Completed' || !m.winner_name) return false;
                const isT1 = m.t1_name === player.team_name;
                return (isT1 && m.winner_name === m.t1_name) || (!isT1 && m.winner_name === m.t2_name);
            }).length;
            const losses = completedMatches - wins;
            const winRate = completedMatches > 0 ? (wins / completedMatches * 100) : 0;
            
            // Create stat objects (these would normally come from detailed match data)
            stats = [
                { stat_name: 'matches_played', value: totalMatches, unit: 'count' },
                { stat_name: 'wins', value: wins, unit: 'count' },
                { stat_name: 'losses', value: losses, unit: 'count' },
                { stat_name: 'win_rate', value: winRate, unit: '%' }
            ];
            
            // Try to fetch pre-calculated stats from Stat table
            const [dbStats] = await db.query(
                `SELECT stat_name, value FROM Stat 
                 WHERE owner_type = 'player' AND owner_id = ? AND visibility = 'public'
                 ORDER BY recorded_at DESC`,
                [req.params.id]
            );
            
            if (dbStats.length > 0) {
                // Merge with database stats (these take priority)
                stats = dbStats;
            }
        }

        res.json({ ...player, accounts, matches, stats });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
