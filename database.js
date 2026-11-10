const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Connect to local SQLite Database (Self-Hosted inside your server)
const dbPath = path.join(__dirname, 'spk_database.sqlite');
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('❌ Database Connection Error:', err.message);
    } else {
        console.log('✅ Connected to your private Self-Hosted SPK Database.');
    }
});

// Create Tables for Users and Video History
db.serialize(() => {
    db.run(`CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mobile TEXT UNIQUE,
        password TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )`);

    db.run(`CREATE TABLE IF NOT EXISTS videos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mobile TEXT,
        category TEXT,
        script TEXT,
        video_path TEXT,
        is_paid INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )`);
});

module.exports = db;
