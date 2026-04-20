-- =============================================
--  VLR Clone Database Schema
--  Compatible with MySQL 8 (XAMPP)
-- =============================================

CREATE DATABASE IF NOT EXISTS vlr_clone CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vlr_clone;

-- Core System
CREATE TABLE Role (
    role_id     INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE Permission (
    permission_id INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Role_Permission (
    role_id       INT,
    permission_id INT,
    PRIMARY KEY(role_id, permission_id),
    FOREIGN KEY(role_id)       REFERENCES Role(role_id),
    FOREIGN KEY(permission_id) REFERENCES Permission(permission_id)
);

CREATE TABLE Users(
    user_id  INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id  INT,
    FOREIGN KEY(role_id) REFERENCES Role(role_id)
);

CREATE TABLE Game (
    game_id      INT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(100) UNIQUE NOT NULL,
    type         VARCHAR(50),
    publisher    VARCHAR(100),
    release_year INT NOT NULL,
    official_youtube_url VARCHAR(255) -- New column for dynamic link
);

-- Admin
-- CREATE TABLE Admins(
--     admin_id   INT PRIMARY KEY AUTO_INCREMENT,
--     user_id    INT UNIQUE,
--     email      VARCHAR(100) UNIQUE NOT NULL,
--     contact_no VARCHAR(15) UNIQUE,
--     game_id    INT,
--     FOREIGN KEY(user_id) REFERENCES Users(user_id),
--     FOREIGN KEY(game_id) REFERENCES Game(game_id)
-- );

CREATE TABLE Admins(
    admin_id   INT PRIMARY KEY AUTO_INCREMENT,
    user_id    INT UNIQUE,
    email      VARCHAR(100) UNIQUE NOT NULL,
    contact_no VARCHAR(15) UNIQUE,
    game_id    INT,
    FOREIGN KEY(user_id) REFERENCES Users(user_id) ON DELETE CASCADE, -- Added CASCADE
    FOREIGN KEY(game_id) REFERENCES Game(game_id)
);

-- Lookup Tables
CREATE TABLE Status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    name      VARCHAR(20) UNIQUE
);

CREATE TABLE Organization (
    org_id INT PRIMARY KEY AUTO_INCREMENT,
    name   VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Coach (
    coach_id INT PRIMARY KEY AUTO_INCREMENT,
    name     VARCHAR(100) NOT NULL
);


-- Player & Team
-- CREATE TABLE Player (
--     player_id        INT PRIMARY KEY AUTO_INCREMENT,
--     user_id          INT UNIQUE,
--     name             VARCHAR(100) NOT NULL,
--     username         VARCHAR(50) UNIQUE,
--     email            VARCHAR(100) UNIQUE NOT NULL,
--     country          VARCHAR(50),
--     profile_image    TEXT,
--     bio              TEXT,
--     region           VARCHAR(50),
--     age              INT CHECK(age >= 13),
--     rank             VARCHAR(50),
--     status_id        INT,
--     role_id          INT,
--     -- Admin approval workflow
--     approval_status  VARCHAR(20) DEFAULT 'pending',  -- pending | approved | rejected
--     approved_by      INT,                        -- admin_id
--     approved_at      DATETIME,
--     rejection_reason TEXT,
--     created_at       DATE NOT NULL,
--     FOREIGN KEY(user_id)     REFERENCES Users(user_id),
--     FOREIGN KEY(role_id)     REFERENCES Role(role_id),
--     FOREIGN KEY(status_id)   REFERENCES Status(status_id),
--     FOREIGN KEY(approved_by) REFERENCES Admins(admin_id)
-- );
CREATE TABLE Player (
    player_id        INT PRIMARY KEY AUTO_INCREMENT,
    user_id          INT UNIQUE,
    name             VARCHAR(100) NOT NULL,
    username         VARCHAR(50) UNIQUE,
    email            VARCHAR(100) UNIQUE NOT NULL,
    country          VARCHAR(50),
    profile_image    TEXT,
    bio              TEXT,
    region           VARCHAR(50),
    age              INT CHECK(age >= 13),
    rank             VARCHAR(50),
    status_id        INT,
    role_id          INT,
    -- Admin approval workflow
    approval_status  VARCHAR(20) DEFAULT 'pending',  -- pending | approved | rejected
    approved_by      INT,                        -- admin_id
    approved_at      DATETIME,
    rejection_reason TEXT,
    created_at       DATE NOT NULL,
    FOREIGN KEY(user_id)     REFERENCES Users(user_id) ON DELETE CASCADE, -- Added CASCADE
    FOREIGN KEY(role_id)     REFERENCES Role(role_id),
    FOREIGN KEY(status_id)   REFERENCES Status(status_id),
    FOREIGN KEY(approved_by) REFERENCES Admins(admin_id)
);

CREATE TABLE Team (
    team_id      INT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(100) UNIQUE NOT NULL,
    org_id       INT,
    logo         TEXT,
    founded_date DATE NOT NULL,
    coach_id     INT,
    region       VARCHAR(50),
    status_id    INT,
    created_at   DATE NOT NULL,
    FOREIGN KEY(org_id)     REFERENCES Organization(org_id),
    FOREIGN KEY(coach_id)   REFERENCES Coach(coach_id),
    FOREIGN KEY(status_id)  REFERENCES Status(status_id)
);

CREATE TABLE Team_Player (
    team_id    INT,
    player_id  INT,
    join_date  DATE NOT NULL,
    leave_date DATE,
    PRIMARY KEY(team_id, player_id, join_date),
    FOREIGN KEY(team_id)   REFERENCES Team(team_id)   ON DELETE CASCADE,
    FOREIGN KEY(player_id) REFERENCES Player(player_id) ON DELETE CASCADE,
    CHECK (leave_date IS NULL OR leave_date >= join_date)
);

CREATE TABLE Game_Account (
    game_id      INT,
    player_id    INT,
    username     VARCHAR(100) NOT NULL,
    tag          VARCHAR(20),
    rank         VARCHAR(50),
    level        INT,
    date_created DATE NOT NULL,
    last_active  DATE NOT NULL,
    is_primary   BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(game_id, player_id),
    FOREIGN KEY(game_id)   REFERENCES Game(game_id)   ON DELETE CASCADE,
    FOREIGN KEY(player_id) REFERENCES Player(player_id) ON DELETE CASCADE
);

-- Player ↔ Game registration with per-game approval
CREATE TABLE Player_Game (
    player_id        INT NOT NULL,
    game_id          INT NOT NULL,
    approval_status  VARCHAR(20) DEFAULT 'pending',  -- pending | approved | rejected
    approved_by      INT,
    approved_at      DATETIME,
    rejection_reason TEXT,
    registered_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(player_id, game_id),
    FOREIGN KEY(player_id)  REFERENCES Player(player_id) ON DELETE CASCADE,
    FOREIGN KEY(game_id)    REFERENCES Game(game_id)     ON DELETE CASCADE,
    FOREIGN KEY(approved_by) REFERENCES Admins(admin_id)
);

-- Tournament & Match
CREATE TABLE Tournament (
    tournament_id   INT PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(100) NOT NULL,
    game_id         INT NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    type            VARCHAR(50),
    format          VARCHAR(50),
    prize_pool      DECIMAL(12,2) CHECK (prize_pool >= 0),
    location        VARCHAR(100),
    organizer       VARCHAR(100),
    number_of_teams INT CHECK(number_of_teams > 0),
    status_id       INT,
    FOREIGN KEY(game_id)   REFERENCES Game(game_id),
    FOREIGN KEY(status_id) REFERENCES Status(status_id),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE Matches (
    match_id       INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id  INT NOT NULL,
    game_id        INT NOT NULL,
    team1_id       INT,
    team2_id       INT,
    winner_team_id INT,
    score_team1    INT DEFAULT 0,
    score_team2    INT DEFAULT 0,
    round          VARCHAR(50),
    best_of        INT,
    map_name       VARCHAR(50),
    match_type     VARCHAR(20),
    status_id      INT,
    date           DATE NOT NULL,
    start_time     TIME NOT NULL,
    duration       INT,
    CHECK(team1_id <> team2_id),
    CHECK(winner_team_id IS NULL OR winner_team_id IN (team1_id, team2_id)),
    FOREIGN KEY(tournament_id)  REFERENCES Tournament(tournament_id),
    FOREIGN KEY(game_id)        REFERENCES Game(game_id),
    FOREIGN KEY(team1_id)       REFERENCES Team(team_id),
    FOREIGN KEY(team2_id)       REFERENCES Team(team_id),
    FOREIGN KEY(winner_team_id) REFERENCES Team(team_id),
    FOREIGN KEY(status_id)      REFERENCES Status(status_id)
);

CREATE TABLE Tournament_Team (
    tournament_id INT,
    team_id       INT,
    PRIMARY KEY(tournament_id, team_id),
    FOREIGN KEY(tournament_id) REFERENCES Tournament(tournament_id) ON DELETE CASCADE,
    FOREIGN KEY(team_id)       REFERENCES Team(team_id) ON DELETE CASCADE
);

CREATE TABLE Player_Matches (
    player_id INT,
    match_id  INT,
    PRIMARY KEY(player_id, match_id),
    FOREIGN KEY(player_id) REFERENCES Player(player_id) ON DELETE CASCADE,
    FOREIGN KEY(match_id)  REFERENCES Matches(match_id) ON DELETE CASCADE
);


-- Sponsorship
CREATE TABLE Sponsor (
    sponsor_id       INT PRIMARY KEY AUTO_INCREMENT,
    name             VARCHAR(100) NOT NULL,
    industry         VARCHAR(50),
    contact_email    VARCHAR(100),
    logo             VARCHAR(255),
    total_investment DECIMAL(12,2) DEFAULT 0 CHECK (total_investment >= 0)
);

CREATE TABLE Sponsorable (
    sponsor_id     INT,
    entity_type    VARCHAR(20), -- i.e 'Team' or 'Tournament' or 'Player'
    entity_id      INT,
    contract_start DATE NOT NULL,
    contract_end   DATE,
    amount         DECIMAL(12,2) DEFAULT 0 CHECK (amount >= 0),
    PRIMARY KEY(sponsor_id, entity_type, entity_id),
    FOREIGN KEY(sponsor_id) REFERENCES Sponsor(sponsor_id)
);

-- Contention & Ban
-- CREATE TABLE Contention (
--     contention_id   INT PRIMARY KEY AUTO_INCREMENT,
--     status_id       INT,
--     -- Who filed: exactly one of these will be set
--     filer_type      VARCHAR(10) NOT NULL DEFAULT 'player', -- 'player','team','coach'
--     raised_by       INT,          -- player_id  (if filer_type='player')
--     raised_by_team  INT,          -- team_id    (if filer_type='team')
--     raised_by_coach INT,          -- coach_id   (if filer_type='coach')
--     reason          TEXT NOT NULL,
--     description     TEXT,
--     created_at      DATE NOT NULL,
--     resolved_at     DATE,
--     game_id         INT,
--     FOREIGN KEY(status_id)       REFERENCES Status(status_id),
--     FOREIGN KEY(raised_by)       REFERENCES Player(player_id),
--     FOREIGN KEY(raised_by_team)  REFERENCES Team(team_id),
--     FOREIGN KEY(raised_by_coach) REFERENCES Coach(coach_id),
--     FOREIGN KEY(game_id)         REFERENCES Game(game_id)
-- );
-- Contention Table
-- CREATE TABLE Contention (
--     contention_id   INT PRIMARY KEY AUTO_INCREMENT,
--     status_id       INT,
--     filer_type      VARCHAR(10) NOT NULL DEFAULT 'player',
--     raised_by       INT, -- player_id
--     raised_by_team  INT,
--     raised_by_coach INT,
--     reason          TEXT NOT NULL,
--     description     TEXT,
--     created_at      DATE NOT NULL,
--     resolved_at     DATE,
--     game_id         INT,
--     FOREIGN KEY(status_id)       REFERENCES Status(status_id),
--     FOREIGN KEY(raised_by)       REFERENCES Player(player_id) ON DELETE CASCADE, -- Added CASCADE
--     FOREIGN KEY(raised_by_team)  REFERENCES Team(team_id),
--     FOREIGN KEY(raised_by_coach) REFERENCES Coach(coach_id),
--     FOREIGN KEY(game_id)         REFERENCES Game(game_id)
-- );
-- schema.sql: Replace your CREATE TABLE Contention block
CREATE TABLE Contention (
    contention_id   INT PRIMARY KEY AUTO_INCREMENT,
    status_id       INT,
    filer_type      VARCHAR(10) NOT NULL DEFAULT 'player',
    raised_by       INT, -- player_id
    raised_by_team  INT, -- team_id
    raised_by_coach INT, -- coach_id
    
    -- NEW TARGET COLUMNS
    target_player_id INT NULL,
    target_team_id   INT NULL,
    
    reason          TEXT NOT NULL,
    description     TEXT,
    created_at      DATE NOT NULL,
    resolved_at     DATE,
    game_id         INT,
    
    FOREIGN KEY(status_id)       REFERENCES Status(status_id),
    FOREIGN KEY(raised_by)       REFERENCES Player(player_id) ON DELETE CASCADE,
    FOREIGN KEY(raised_by_team)  REFERENCES Team(team_id),
    FOREIGN KEY(raised_by_coach) REFERENCES Coach(coach_id),
    FOREIGN KEY(game_id)         REFERENCES Game(game_id),
    
    -- Target Foreign Keys
    FOREIGN KEY(target_player_id) REFERENCES Player(player_id) ON DELETE SET NULL,
    FOREIGN KEY(target_team_id)   REFERENCES Team(team_id)   ON DELETE SET NULL
);

CREATE TABLE Contention_History (
    history_id    INT PRIMARY KEY AUTO_INCREMENT,
    contention_id INT,
    status_id     INT,
    changed_by    INT,
    note          TEXT,
    changed_at    DATE,
    FOREIGN KEY(contention_id) REFERENCES Contention(contention_id),
    FOREIGN KEY(status_id)     REFERENCES Status(status_id),
    FOREIGN KEY(changed_by)    REFERENCES Admins(admin_id)
);

CREATE TABLE Ban (
    ban_id        INT PRIMARY KEY AUTO_INCREMENT,
    contention_id INT,
    ban_type      VARCHAR(30) NOT NULL, -- 'player_ban','team_ban','tournament_ban','warning','permanent'
    duration      INT,                  -- days; NULL = indefinite/permanent
    start_date    DATE NOT NULL,
    end_date      DATE,
    description   TEXT,
    evidence      TEXT,
    issued_by     INT,
    FOREIGN KEY(contention_id) REFERENCES Contention(contention_id),
    FOREIGN KEY(issued_by)     REFERENCES Admins(admin_id),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

-- Flexible ban targets: a single ban can hit players AND/OR a whole team
CREATE TABLE Ban_Target (
    ban_target_id INT PRIMARY KEY AUTO_INCREMENT, -- Added a dedicated, simple primary key
    ban_id    INT NOT NULL,
    -- At least one of player_id / team_id must be set
    player_id INT,
    team_id   INT,
    game_id   INT,
    -- scope     VARCHAR(20) DEFAULT 'all_games', -- 'all_games','specific_game','tournament_only'
    
    -- Optional: This helps prevent duplicate entries
    UNIQUE (ban_id, player_id, team_id), 
    
    FOREIGN KEY(ban_id)    REFERENCES Ban(ban_id) ON DELETE CASCADE,
    FOREIGN KEY(player_id) REFERENCES Player(player_id),
    FOREIGN KEY(team_id)   REFERENCES Team(team_id),
    FOREIGN KEY(game_id)   REFERENCES Game(game_id)
);

-- Streaming
CREATE TABLE Platform (
    platform_id INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100),
    description TEXT
);

CREATE TABLE Platform_Streaming (
    match_id     INT,
    platform_id  INT,
    link         VARCHAR(255),
    viewer_count INT DEFAULT 0,
    quality      VARCHAR(20),
    language     VARCHAR(50) DEFAULT 'English',
    PRIMARY KEY(match_id, platform_id),
    FOREIGN KEY(match_id)    REFERENCES Matches(match_id) ON DELETE CASCADE,
    FOREIGN KEY(platform_id) REFERENCES Platform(platform_id)
);

-- Prize
CREATE TABLE Prize (
    prize_id      INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id INT NOT NULL,
    position      INT,
    amount        DECIMAL(12,2) CHECK (amount >= 0),
    currency      VARCHAR(10),
    FOREIGN KEY(tournament_id) REFERENCES Tournament(tournament_id)
);

-- Statistics
CREATE TABLE Stat (
    stat_id      INT PRIMARY KEY AUTO_INCREMENT,
    owner_type   VARCHAR(20),
    owner_id     INT,
    context_type VARCHAR(20),
    context_id   INT,
    visibility   VARCHAR(20) DEFAULT 'public',
    source       VARCHAR(50),
    confidence   FLOAT,
    stat_name    VARCHAR(50),
    value        FLOAT,
    unit         VARCHAR(20),
    recorded_at  DATE,
    CHECK(owner_type IN ('player','team','match','tournament')),
    CHECK(context_type IN ('player','team','match','tournament') OR context_type IS NULL)
);

-- Support System
-- CREATE TABLE Customer_Support (
--     support_id  INT PRIMARY KEY AUTO_INCREMENT,
--     player_id   INT,
--     admin_id    INT,
--     type        VARCHAR(50),
--     category    VARCHAR(50),
--     subject     VARCHAR(100),
--     description TEXT,
--     status_id   INT,
--     priority    VARCHAR(20) DEFAULT 'medium',
--     created_at  DATE NOT NULL,
--     resolved_at DATE,
--     FOREIGN KEY(player_id) REFERENCES Player(player_id),
--     FOREIGN KEY(admin_id)  REFERENCES Admins(admin_id),
--     FOREIGN KEY(status_id) REFERENCES Status(status_id)
-- );
-- Customer Support Table
CREATE TABLE Customer_Support (
    support_id  INT PRIMARY KEY AUTO_INCREMENT,
    player_id   INT,
    admin_id    INT,
    type        VARCHAR(50),
    category    VARCHAR(50),
    subject     VARCHAR(100),
    description TEXT,
    status_id   INT,
    priority    VARCHAR(20) DEFAULT 'medium',
    created_at  DATE NOT NULL,
    resolved_at DATE,
    FOREIGN KEY(player_id) REFERENCES Player(player_id) ON DELETE CASCADE, -- Added CASCADE
    FOREIGN KEY(admin_id)  REFERENCES Admins(admin_id),
    FOREIGN KEY(status_id) REFERENCES Status(status_id)
);



CREATE TABLE Appeal_Contention (
    support_id    INT,
    contention_id INT,
    PRIMARY KEY(support_id, contention_id),
    FOREIGN KEY(support_id)    REFERENCES Customer_Support(support_id),
    FOREIGN KEY(contention_id) REFERENCES Contention(contention_id)
);

-- Logging and Notifications
CREATE TABLE Audit_Log (
    log_id       INT PRIMARY KEY AUTO_INCREMENT,
    entity_type  VARCHAR(50),
    entity_id    INT,
    action       VARCHAR(50),
    performed_by INT,
    timestamp    DATETIME,
    ip_address   VARCHAR(50),
    details      TEXT,
    FOREIGN KEY(performed_by) REFERENCES Admins(admin_id)
);

-- CREATE TABLE Notification (
--     notification_id INT PRIMARY KEY AUTO_INCREMENT,
--     player_id       INT,
--     message         TEXT,
--     is_read         BOOLEAN DEFAULT FALSE,
--     created_at      DATETIME,
--     FOREIGN KEY(player_id) REFERENCES Player(player_id)
-- );
-- Notification Table
CREATE TABLE Notification (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id       INT,
    message         TEXT,
    is_read         BOOLEAN DEFAULT FALSE,
    created_at      DATETIME,
    FOREIGN KEY(player_id) REFERENCES Player(player_id) ON DELETE CASCADE -- Added CASCADE
);

-- ─── NEW: Player Transfer History ──────────────────
-- Tracks every team a player has been on, with optional transfer notes
CREATE TABLE Player_History (
    history_id   INT PRIMARY KEY AUTO_INCREMENT,
    player_id    INT NOT NULL,
    team_id      INT,                         -- NULL = free agent period
    role         VARCHAR(50),                  -- e.g. 'Duelist', 'Controller', 'IGL'
    join_date    DATE NOT NULL,
    leave_date   DATE,
    transfer_fee DECIMAL(12,2) DEFAULT 0,
    notes        TEXT,                         -- e.g. "Loan", "Trial", "Signed permanently"
    recorded_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(player_id) REFERENCES Player(player_id) ON DELETE CASCADE,
    FOREIGN KEY(team_id)   REFERENCES Team(team_id)     ON DELETE SET NULL,
    CHECK(leave_date IS NULL OR leave_date >= join_date)
);

-- ─── NEW: Match Map results ──────────────────────────
-- Stores individual map scores within a Best-of series
CREATE TABLE Match_Map (
    map_entry_id  INT PRIMARY KEY AUTO_INCREMENT,
    match_id      INT NOT NULL,
    map_number    INT NOT NULL,               -- 1 = Map 1, 2 = Map 2 …
    map_name      VARCHAR(50),
    score_team1   INT DEFAULT 0,
    score_team2   INT DEFAULT 0,
    winner_team_id INT,
    duration_mins INT,                        -- duration of just this map
    FOREIGN KEY(match_id)       REFERENCES Matches(match_id)  ON DELETE CASCADE,
    FOREIGN KEY(winner_team_id) REFERENCES Team(team_id),
    UNIQUE(match_id, map_number)
);

-- ─── NEW: Social Links ──────────────────────────────
-- Attach Twitter, Twitch, YouTube, Instagram etc. to players, teams, orgs, sponsors
CREATE TABLE Social_Link (
    link_id     INT PRIMARY KEY AUTO_INCREMENT,
    entity_type VARCHAR(20) NOT NULL,          -- 'player','team','org','sponsor'
    entity_id   INT NOT NULL,
    platform    VARCHAR(30) NOT NULL,          -- 'twitter','twitch','youtube','instagram','liquipedia','website'
    url         VARCHAR(255) NOT NULL,
    display_name VARCHAR(100),
    is_verified  BOOLEAN DEFAULT FALSE,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK(entity_type IN ('player','team','org','sponsor'))
);

-- ─── NEW: Team Ban ───────────────────────────────────
-- Dedicated team-level suspensions (separate from Ban_Target so team bans
-- can carry their own metadata and be queried efficiently)
CREATE TABLE Team_Ban (
    team_ban_id   INT PRIMARY KEY AUTO_INCREMENT,
    ban_id        INT NOT NULL,               -- links to the parent Ban record
    team_id       INT NOT NULL,
    affects_roster BOOLEAN DEFAULT TRUE,      -- TRUE = all current players also banned
    ban_scope     VARCHAR(30) DEFAULT 'tournament', -- 'tournament','league','all','roster_lock'
    FOREIGN KEY(ban_id)   REFERENCES Ban(ban_id)   ON DELETE CASCADE,
    FOREIGN KEY(team_id)  REFERENCES Team(team_id) ON DELETE CASCADE,
    UNIQUE(ban_id, team_id)
);

-- Security Views
CREATE VIEW Player_Public AS
SELECT player_id, name, username, region, rank FROM Player;

CREATE VIEW Ban_Public AS
SELECT ban_id, ban_type, duration, start_date, end_date FROM Ban;

CREATE VIEW Support_Public AS
SELECT support_id, subject, status_id, created_at FROM Customer_Support;
