const mysql = require('mysql2/promise');

const pool = mysql.createPool({
    host:     process.env.DB_HOST || 'localhost',
    user:     process.env.DB_USER || 'root',
    password: process.env.DB_PASS || '',
    database: process.env.DB_NAME || 'vlr_clone',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Test connection on startup
pool.getConnection()
    .then(conn => {
        console.log('\x1b[32m✓ MySQL connected\x1b[0m');
        conn.release();
    })
    .catch(err => {
        console.error('\x1b[31m✗ MySQL connection failed:\x1b[0m', err.message);
    });

module.exports = pool;
