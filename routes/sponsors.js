const router = require('express').Router();
const db = require('../config/db');
const { authMiddleware, adminOnly } = require('../middleware/auth');

// ── PUBLIC: List sponsors ──────────────────────────
router.get('/', async (req, res) => {
    try {
        const [sponsors] = await db.query(
            `SELECT s.*, COUNT(DISTINCT sp.entity_id) AS entity_count,
                    SUM(sp.amount) AS total_committed
             FROM Sponsor s
             LEFT JOIN Sponsorable sp ON sp.sponsor_id = s.sponsor_id
             GROUP BY s.sponsor_id
             ORDER BY s.total_investment DESC`
        );
        res.json(sponsors);
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ── PUBLIC: Get sponsor detail ─────────────────────
router.get('/:id', async (req, res) => {
    try {
        const [[sponsor]] = await db.query('SELECT * FROM Sponsor WHERE sponsor_id = ?', [req.params.id]);
        if (!sponsor) return res.status(404).json({ error: 'Not found' });

        const [deals] = await db.query(
            `SELECT sp.*,
                    CASE sp.entity_type
                      WHEN 'team'       THEN t.name
                      WHEN 'tournament' THEN tr.name
                      WHEN 'player'     THEN p.name
                    END AS entity_name,
                    CASE sp.entity_type
                      WHEN 'team'       THEN t.logo
                      WHEN 'player'     THEN p.profile_image
                    END AS entity_logo
             FROM Sponsorable sp
             LEFT JOIN Team       t  ON sp.entity_type='team'       AND sp.entity_id=t.team_id
             LEFT JOIN Tournament tr ON sp.entity_type='tournament'  AND sp.entity_id=tr.tournament_id
             LEFT JOIN Player     p  ON sp.entity_type='player'      AND sp.entity_id=p.player_id
             WHERE sp.sponsor_id = ?
             ORDER BY sp.amount DESC`, [req.params.id]);

        res.json({ ...sponsor, deals });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ── PUBLIC: Get all orgs ───────────────────────────
router.get('/orgs/list', async (req, res) => {
    try {
        const [orgs] = await db.query(
            `SELECT o.*, COUNT(t.team_id) AS team_count
             FROM Organization o
             LEFT JOIN Team t ON t.org_id = o.org_id
             GROUP BY o.org_id ORDER BY o.name`
        );
        res.json(orgs);
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ── PUBLIC: Get org detail ─────────────────────────
router.get('/orgs/:id', async (req, res) => {
    try {
        const [[org]] = await db.query('SELECT * FROM Organization WHERE org_id = ?', [req.params.id]);
        if (!org) return res.status(404).json({ error: 'Not found' });
        const [teams] = await db.query(
            `SELECT t.*, s.name AS status FROM Team t
             LEFT JOIN Status s ON t.status_id=s.status_id
             WHERE t.org_id = ? ORDER BY t.name`, [req.params.id]);
        const [sponsors] = await db.query(
            `SELECT sp.*, s.name AS sponsor_name, s.industry FROM Sponsorable sp
             JOIN Sponsor s ON sp.sponsor_id=s.sponsor_id
             WHERE sp.entity_type='team' AND sp.entity_id IN (
               SELECT team_id FROM Team WHERE org_id=?
             )`, [req.params.id]);
        res.json({ ...org, teams, sponsors });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ── PUBLIC: Get all coaches ────────────────────────
router.get('/coaches/list', async (req, res) => {
    try {
        const [coaches] = await db.query(
            `SELECT c.*, t.team_id, t.name AS team_name, t.logo AS team_logo, t.region
             FROM Coach c
             LEFT JOIN Team t ON t.coach_id = c.coach_id
             ORDER BY c.name`
        );
        res.json(coaches);
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ── ADMIN: Add sponsor ─────────────────────────────
router.post('/', authMiddleware, adminOnly, async (req, res) => {
    const { name, industry, contact_email, total_investment } = req.body;
    if (!name) return res.status(400).json({ error: 'name required' });
    try {
        const [r] = await db.query(
            'INSERT INTO Sponsor (name, industry, contact_email, logo, total_investment) VALUES (?,?,?,?,?)',
            [name, industry||null, contact_email||null, logo||null, total_investment||0]
        );
        res.status(201).json({ sponsor_id: r.insertId });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ── ADMIN: Add sponsorship deal ────────────────────
router.post('/deal', authMiddleware, adminOnly, async (req, res) => {
    const { sponsor_id, entity_type, entity_id, contract_start, contract_end, amount } = req.body;
    if (!sponsor_id || !entity_type || !entity_id || !contract_start)
        return res.status(400).json({ error: 'sponsor_id, entity_type, entity_id, contract_start required' });
    try {
        await db.query(
            `INSERT INTO Sponsorable (sponsor_id, entity_type, entity_id, contract_start, contract_end, amount)
             VALUES (?,?,?,?,?,?)
             ON DUPLICATE KEY UPDATE contract_start=VALUES(contract_start), contract_end=VALUES(contract_end), amount=VALUES(amount)`,
            [sponsor_id, entity_type, entity_id, contract_start, contract_end||null, amount||0]
        );
        // Update total_investment on Sponsor
        await db.query(
            'UPDATE Sponsor SET total_investment = (SELECT COALESCE(SUM(amount),0) FROM Sponsorable WHERE sponsor_id=?) WHERE sponsor_id=?',
            [sponsor_id, sponsor_id]
        );
        res.status(201).json({ message: 'Deal created' });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ── ADMIN: Delete deal ─────────────────────────────
router.delete('/deal', authMiddleware, adminOnly, async (req, res) => {
    const { sponsor_id, entity_type, entity_id } = req.body;
    try {
        await db.query('DELETE FROM Sponsorable WHERE sponsor_id=? AND entity_type=? AND entity_id=?',
            [sponsor_id, entity_type, entity_id]);
        res.json({ message: 'Deleted' });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;
