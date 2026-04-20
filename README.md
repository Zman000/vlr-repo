# 🎮 Esports Hub Clone — Valorant Esports Tracker

A full-stack clone of VLR.gg built with **Node.js + Express** backend and **plain HTML/CSS/JS** frontend, connected to **MySQL** (XAMPP).

---

## 📁 Project Structure

```
esports-hub/
├── server.js               ← Express entry point
├── .env                    ← Environment variables
├── package.json
├── config/
│   └── db.js               ← MySQL connection pool
├── middleware/
│   └── auth.js             ← JWT auth + admin guard
├── routes/
│   ├── auth.js             ← Login / Register / Me
│   ├── matches.js          ← Match listing + detail
│   ├── teams.js            ← Team listing + detail
│   ├── players.js          ← Player listing + detail
│   ├── tournaments.js      ← Event listing + detail
│   └── rankings.js         ← Team + player rankings
├── database/
│   ├── schema.sql          ← Full database schema
│   └── seed.sql            ← Sample data (8 teams, 40 players, 20 matches, 5 events)
└── public/
    ├── css/style.css       ← Full dark theme stylesheet
    ├── js/api.js           ← Shared API utilities + Components
    ├── index.html          ← Home page
    ├── matches.html        ← Match listings
    ├── match-detail.html   ← Match detail page
    ├── teams.html          ← Teams grid
    ├── team-detail.html    ← Team detail + roster + history
    ├── players.html        ← Players table
    ├── player-detail.html  ← Player profile + stats
    ├── events.html         ← Tournaments/Events listing
    ├── event-detail.html   ← Event detail + bracket + prizes
    ├── rankings.html       ← Team + Player rankings
    ├── login.html          ← Login form
    └── register.html       ← Registration form
```

---

## ⚙️ Setup Instructions

### Step 1 — Prerequisites
- [XAMPP](https://www.apachefriends.org/) with MySQL running
- [Node.js](https://nodejs.org/) v18+

### Step 2 — Database Setup
1. Open **phpMyAdmin** → `http://localhost/phpmyadmin`
2. Run `database/schema.sql` (creates the `vlr_clone` database + all tables)
3. Run `database/seed.sql` (inserts 8 teams, 40 players, 5 tournaments, 20 matches)

### Step 3 — Install Dependencies
```bash
cd esports-hub
npm install
```

### Step 4 — Configure Environment
Edit `.env` if your MySQL credentials differ:
```
DB_HOST=localhost
DB_USER=root
DB_PASS=          ← XAMPP default has no password
DB_NAME=vlr_clone
JWT_SECRET=change_this_to_something_long_and_random
```

### Step 5 — Create Admin Account ⭐ NEW
```bash
npm run setup
```
This will prompt you for a username, email and password and create the admin account with a correctly hashed password. Run this **once** after the first database setup.

> ⚠️ **Do NOT add admins through the Register page** — registration is for Players only. Always use `npm run setup` to create or reset admin accounts.

### Step 6 — Run the Server
```bash
# Development (auto-restart on file change)
npm run dev

# Production
npm start
```

Open → **http://localhost:3000**

---

## 📄 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register user |
| POST | `/api/auth/login` | Login → returns JWT |
| GET  | `/api/auth/me` | Get current user (auth required) |
| GET  | `/api/matches?status=live\|upcoming\|completed` | List matches |
| GET  | `/api/matches/:id` | Match detail + players + stats |
| GET  | `/api/teams?region=NA\|EU\|SA\|APAC` | List teams |
| GET  | `/api/teams/:id` | Team detail + roster + matches |
| GET  | `/api/players?q=search&region=NA` | List players |
| GET  | `/api/players/:id` | Player profile + stats + matches |
| GET  | `/api/tournaments?status=upcoming` | List tournaments |
| GET  | `/api/tournaments/:id` | Event detail + teams + matches + prizes |
| GET  | `/api/rankings/teams?region=NA` | Team rankings by win rate |
| GET  | `/api/rankings/players?region=EU` | Player rankings by rating |

---

## 🎨 Features
- ✅ Dark theme matching VLR.gg aesthetic
- ✅ Full authentication (JWT, bcrypt passwords)
- ✅ Admin + Player role system
- ✅ Live/Upcoming/Completed match filtering
- ✅ Team profiles with roster + match history
- ✅ Player profiles with stats (Rating, ACS, K/D, KAST, ADR)
- ✅ Tournament bracket/match view with prize pool
- ✅ Team + Player rankings with regional filtering
- ✅ Global search (players by name/IGN)
- ✅ Responsive design
- ✅ 40 players across 8 real VCT teams
- ✅ 20 historical matches across 5 tournaments

---

## 🛠️ Common Issues

**MySQL not connecting?**
- Make sure XAMPP MySQL is running
- Check `.env` credentials
- Default XAMPP has empty password (`DB_PASS=`)

**Port 3000 in use?**
- Change `PORT=3001` in `.env`

**Images not loading for teams?**
- The seed uses CDN image URLs — the fallback shows team initials if unavailable
