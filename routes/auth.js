const router  = require('express').Router();
const bcrypt  = require('bcryptjs');
const jwt     = require('jsonwebtoken');
const db      = require('../config/db');
const { authMiddleware } = require('../middleware/auth');

router.get('/games', async (req, res) => {
    try {
        // Fetches game_id, name, and logo for the frontend cards
        const [rows] = await db.query('SELECT game_id, name FROM Game');
        res.json(rows);
    } catch (err) {
        console.error("Database error while fetching games:", err);
        res.status(500).json({ error: 'Failed to fetch games' });
    }
});

// ─── Register (Players only — Admin created via setup.js) ──────────────────
router.post('/register', async (req, res) => {
    const { username, password, email, name, country, region, age, game_ids } = req.body;

    if (!username || !password || !email || !name)
        return res.status(400).json({ error: 'username, password, email and name are required' });
    if (password.length < 8)
        return res.status(400).json({ error: 'Password must be at least 8 characters' });
    if (!Array.isArray(game_ids) || !game_ids.length)
        return res.status(400).json({ error: 'Select at least one game to register for' });

    try {
        const [[roleRow]] = await db.query("SELECT role_id FROM Role WHERE name = 'Player'");
        if (!roleRow) return res.status(500).json({ error: 'Player role not found — run seed.sql first' });

        const hashed = await bcrypt.hash(password, 10);

        // Create the Users row
        const [userRes] = await db.query(
            'INSERT INTO Users (username, password, role_id) VALUES (?, ?, ?)',
            [username, hashed, roleRow.role_id]
        );
        const userId = userRes.insertId;

        // Create Player with approval_status = 'pending'
        const [playerRes] = await db.query(
            `INSERT INTO Player
             (user_id, name, username, email, country, region, age,
              approval_status, created_at, status_id, role_id)
             VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', CURDATE(), 6, ?)`,
            [userId, name, username, email, country||null, region||null, age||null, roleRow.role_id]
        );
        const playerId = playerRes.insertId;

        // Register player for each selected game (pending approval per game)
        for (const gid of game_ids) {
            await db.query(
                'INSERT IGNORE INTO Player_Game (player_id, game_id, approval_status) VALUES (?, ?, ?)',
                [playerId, gid, 'pending']
            ).catch(() => {}); // silently skip invalid game_ids
        }

        // Notify all admins of the new pending registration
        const [admins] = await db.query('SELECT admin_id FROM Admins');
        // (Notification table is player-scoped; log in Audit_Log for admins)
        await db.query(
            `INSERT INTO Audit_Log (entity_type, entity_id, action, timestamp, details)
             VALUES ('Player', ?, 'registration_pending', NOW(), ?)`,
            [playerId, `New player registration pending approval: ${username} for games: ${game_ids.join(',')}`]
        ).catch(() => {});

        // Issue a pending token (role = Player but approval_status = pending)
        const token = jwt.sign(
            { userId, username, role: 'Player', playerId, approval_status: 'pending' },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        );
        res.status(201).json({
            token, username, role: 'Player', player_id: playerId,
            approval_status: 'pending',
            message: 'Registration submitted! Your account is pending admin approval. You can log in but access is limited until approved.'
        });
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY')
            return res.status(409).json({ error: 'Username or email already exists' });
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── Login ─────────────────────────────────────────────────────────────────
router.post('/login', async (req, res) => {
    const { username, password } = req.body;
    if (!username || !password)
        return res.status(400).json({ error: 'Username and password are required' });

    try {
        const [[user]] = await db.query(
            `SELECT u.user_id, u.username, u.password, r.name AS role
             FROM Users u
             JOIN Role r ON u.role_id = r.role_id
             WHERE u.username = ?`,
            [username]
        );

        if (!user)
            return res.status(401).json({ error: 'Invalid username or password' });

        const valid = await bcrypt.compare(password, user.password);
        if (!valid)
            return res.status(401).json({ error: 'Invalid username or password' });

        // Get player_id + approval status if Player
        let playerId = null, approvalStatus = 'approved';
        if (user.role === 'Player') {
            const [[p]] = await db.query(
                'SELECT player_id, approval_status FROM Player WHERE user_id = ?', [user.user_id]
            );
            if (p) { playerId = p.player_id; approvalStatus = p.approval_status; }
        }

        const token = jwt.sign(
            { userId: user.user_id, username: user.username, role: user.role, playerId, approval_status: approvalStatus },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        );

        res.json({ token, username: user.username, role: user.role, player_id: playerId, approval_status: approvalStatus });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── GET /me ────────────────────────────────────────────────────────────────
router.get('/me', authMiddleware, async (req, res) => {
    try {
        const [[user]] = await db.query(
            `SELECT u.user_id, u.username, r.name AS role
             FROM Users u JOIN Role r ON u.role_id = r.role_id
             WHERE u.user_id = ?`,
            [req.user.userId]
        );
        if (!user) return res.status(404).json({ error: 'User not found' });

        // Attach player profile if Player
        if (user.role === 'Player') {
            const [[player]] = await db.query(
                `SELECT p.*, s.name AS status, t.team_id, t.name AS team_name, t.logo AS team_logo
                 FROM Player p
                 LEFT JOIN Team_Player tp ON tp.player_id = p.player_id AND tp.leave_date IS NULL
                 LEFT JOIN Team t ON tp.team_id = t.team_id
                 LEFT JOIN Status s ON p.status_id = s.status_id
                 WHERE p.user_id = ?`,
                [req.user.userId]
            );
            return res.json({ ...user, player });
        }

        // Admin profile
        if (user.role === 'Admin') {
            const [[admin]] = await db.query(
                'SELECT * FROM Admins WHERE user_id = ?', [req.user.userId]
            );
            return res.json({ ...user, admin });
        }

        res.json(user);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── PUT /profile  — update player profile fields ──────────────────────────
router.put('/profile', authMiddleware, async (req, res) => {
    try {
        const { name, bio, country, region, age, profile_image } = req.body;

        if (req.user.role === 'Player') {
            const [[player]] = await db.query(
                'SELECT player_id FROM Player WHERE user_id = ?', [req.user.userId]
            );
            if (!player) return res.status(404).json({ error: 'Player profile not found' });

            const updates = [];
            const params  = [];

            if (name !== undefined)          { updates.push('name = ?');          params.push(name); }
            if (bio !== undefined)           { updates.push('bio = ?');           params.push(bio); }
            if (country !== undefined)       { updates.push('country = ?');       params.push(country); }
            if (region !== undefined)        { updates.push('region = ?');        params.push(region); }
            if (age !== undefined)           { updates.push('age = ?');           params.push(parseInt(age)||null); }
            if (profile_image !== undefined) { updates.push('profile_image = ?'); params.push(profile_image); }

            if (!updates.length) return res.status(400).json({ error: 'Nothing to update' });

            params.push(player.player_id);
            await db.query(`UPDATE Player SET ${updates.join(', ')} WHERE player_id = ?`, params);

            res.json({ message: 'Profile updated successfully' });
        }

        else if (req.user.role === 'Admin') {
            const { email, contact_no } = req.body;
            const [[admin]] = await db.query('SELECT admin_id FROM Admins WHERE user_id = ?', [req.user.userId]);
            if (!admin) return res.status(404).json({ error: 'Admin profile not found' });

            const updates = [], params = [];
            if (email)      { updates.push('email = ?');      params.push(email); }
            if (contact_no) { updates.push('contact_no = ?'); params.push(contact_no); }

            if (updates.length) {
                params.push(admin.admin_id);
                await db.query(`UPDATE Admins SET ${updates.join(', ')} WHERE admin_id = ?`, params);
            }
            res.json({ message: 'Admin profile updated' });
        }
        else {
            res.status(403).json({ error: 'Cannot update profile for this role' });
        }
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY')
            return res.status(409).json({ error: 'Email already in use' });
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── PUT /username  — change username ──────────────────────────────────────
router.put('/username', authMiddleware, async (req, res) => {
    const { new_username } = req.body;
    if (!new_username || new_username.length < 3)
        return res.status(400).json({ error: 'Username must be at least 3 characters' });
    if (!/^[a-zA-Z0-9_]+$/.test(new_username))
        return res.status(400).json({ error: 'Username can only contain letters, numbers and underscores' });

    try {
        await db.query('UPDATE Users SET username = ? WHERE user_id = ?', [new_username, req.user.userId]);

        // Keep Player.username in sync
        if (req.user.role === 'Player') {
            await db.query('UPDATE Player SET username = ? WHERE user_id = ?', [new_username, req.user.userId]);
        }

        // Issue a new token with updated username
        const token = jwt.sign(
            { userId: req.user.userId, username: new_username, role: req.user.role, playerId: req.user.playerId },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        );
        res.json({ token, username: new_username, message: 'Username updated' });
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY')
            return res.status(409).json({ error: 'Username already taken' });
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── PUT /password  — change password ──────────────────────────────────────
router.put('/password', authMiddleware, async (req, res) => {
    const { current_password, new_password } = req.body;
    if (!current_password || !new_password)
        return res.status(400).json({ error: 'current_password and new_password are required' });
    if (new_password.length < 8)
        return res.status(400).json({ error: 'New password must be at least 8 characters' });

    try {
        const [[user]] = await db.query('SELECT password FROM Users WHERE user_id = ?', [req.user.userId]);
        if (!user) return res.status(404).json({ error: 'User not found' });

        const valid = await bcrypt.compare(current_password, user.password);
        if (!valid) return res.status(401).json({ error: 'Current password is incorrect' });

        const hashed = await bcrypt.hash(new_password, 10);
        await db.query('UPDATE Users SET password = ? WHERE user_id = ?', [hashed, req.user.userId]);
        res.json({ message: 'Password changed successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── DELETE /account  — HARD DELETE: delete user and all related data ─────
router.delete('/account', authMiddleware, async (req, res) => {
    const { password } = req.body;
    if (!password) return res.status(400).json({ error: 'Password confirmation required' });

    try {
        const [[user]] = await db.query('SELECT password FROM Users WHERE user_id = ?', [req.user.userId]);
        if (!user) return res.status(404).json({ error: 'User not found' });

        const valid = await bcrypt.compare(password, user.password);
        if (!valid) return res.status(401).json({ error: 'Incorrect password' });

        // PERFORM ACTUAL DELETION
        // This will remove the User and (if cascaded) the Player profile
        await db.query('DELETE FROM Users WHERE user_id = ?', [req.user.userId]);

        res.json({ message: 'Account permanently deleted' });
    } catch (err) {
        // If you get a Foreign Key error here, it means your tables aren't set to CASCADE
        console.error(err);
        res.status(500).json({ error: 'Server error: Could not delete due to linked data.' });
    }
});

// ─── GET /notifications  — player notifications ─────────────────────────────
router.get('/notifications', authMiddleware, async (req, res) => {
    try {
        const [[player]] = await db.query('SELECT player_id FROM Player WHERE user_id = ?', [req.user.userId]);
        if (!player) return res.json([]);

        const [notifs] = await db.query(
            'SELECT * FROM Notification WHERE player_id = ? ORDER BY created_at DESC LIMIT 30',
            [player.player_id]
        );
        res.json(notifs);
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});

// ─── PUT /notifications/read  — mark all read ──────────────────────────────
router.put('/notifications/read', authMiddleware, async (req, res) => {
    try {
        const [[player]] = await db.query('SELECT player_id FROM Player WHERE user_id = ?', [req.user.userId]);
        if (!player) return res.json({ message: 'ok' });
        await db.query('UPDATE Notification SET is_read = TRUE WHERE player_id = ?', [player.player_id]);
        res.json({ message: 'All notifications marked as read' });
    } catch(err) { res.status(500).json({ error: 'Server error' }); }
});

// ─── POST /game-account  — link a new game account per player ──────────────
router.post('/game-account', authMiddleware, async (req, res) => {
    const { player_id, game_id, username, tag, rank, level, is_primary } = req.body;
    if (!player_id || !game_id || !username)
        return res.status(400).json({ error: 'player_id, game_id, username required' });
    try {
        // If setting as primary, remove primary flag from others
        if (is_primary) {
            await db.query(
                'UPDATE Game_Account SET is_primary=FALSE WHERE player_id=? AND game_id=?',
                [player_id, game_id]
            );
        }
        await db.query(
            `INSERT INTO Game_Account (game_id, player_id, username, tag, rank, level, is_primary, date_created, last_active)
             VALUES (?,?,?,?,?,?,?,CURDATE(),CURDATE())
             ON DUPLICATE KEY UPDATE tag=VALUES(tag), rank=VALUES(rank), level=VALUES(level),
               is_primary=VALUES(is_primary), last_active=CURDATE()`,
            [game_id, player_id, username, tag||null, rank||null, level||null, is_primary||false]
        );
        res.status(201).json({ message: 'Game account linked' });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ─── GET /game-accounts  — all accounts for logged-in player ───────────────
router.get('/game-accounts', authMiddleware, async (req, res) => {
    try {
        const [[player]] = await db.query('SELECT player_id FROM Player WHERE user_id=?', [req.user.userId]);
        if (!player) return res.json([]);
        const [rows] = await db.query(
            `SELECT ga.*, g.name AS game_name, g.publisher, g.type AS game_type
             FROM Game_Account ga
             JOIN Game g ON ga.game_id = g.game_id
             WHERE ga.player_id = ?
             ORDER BY ga.game_id, ga.is_primary DESC, ga.last_active DESC`,
            [player.player_id]
        );
        res.json(rows);
    } catch(err) { res.status(500).json({ error: err.message }); }
});

// ─── DELETE /game-account  — remove a game account ─────────────────────────
router.delete('/game-account', authMiddleware, async (req, res) => {
    const { account_id } = req.body;
    if (!account_id) return res.status(400).json({ error: 'account_id required' });
    try {
        const [[player]] = await db.query('SELECT player_id FROM Player WHERE user_id=?', [req.user.userId]);
        const [[acct]] = await db.query('SELECT player_id FROM Game_Account WHERE account_id=?', [account_id]);
        if (!acct || acct.player_id !== player?.player_id)
            return res.status(403).json({ error: 'Not your account' });
        await db.query('DELETE FROM Game_Account WHERE account_id=?', [account_id]);
        res.json({ message: 'Account removed' });
    } catch(err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;

