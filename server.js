require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// API Routes
app.use('/api/auth',        require('./routes/auth'));
app.use('/api/matches',     require('./routes/matches'));
app.use('/api/teams',       require('./routes/teams'));
app.use('/api/players',     require('./routes/players'));
app.use('/api/tournaments', require('./routes/tournaments'));
app.use('/api/rankings',    require('./routes/rankings'));
app.use('/api/admin',       require('./routes/admin'));
app.use('/api/stats',       require('./routes/stats'));
app.use('/api/sponsors',    require('./routes/sponsors'));
app.use('/api/contentions', require('./routes/contentions'));

// Global error handler
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Internal server error' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`\x1b[32m🎮 VLR Clone running → http://localhost:${PORT}\x1b[0m`);
});
