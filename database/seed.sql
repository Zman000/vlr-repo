-- =============================================
--  VLR Clone Database — Seed Data  v3 (Schema Updated)
--  Includes: Approvals, Player_Game maps, Player_History, 
--            Match_Map results, Social_Links, Contentions & Bans
-- =============================================

USE vlr_clone;

-- =============================================
-- ROLES & PERMISSIONS
-- =============================================
INSERT INTO Role (role_id, name, description) VALUES
(1, 'Super Admin', 'Full system access — all permissions'),
(2, 'Admin',       'Tournament, player and team management'),
(3, 'Player',      'Standard player account'),
(4, 'Moderator',   'Content moderation and support');

INSERT INTO Permission (permission_id, name) VALUES
(1, 'manage_users'),
(2, 'manage_tournaments'),
(3, 'manage_players'),
(4, 'manage_teams'),
(5, 'view_stats'),
(6, 'manage_matches'),
(7, 'manage_bans'),
(8, 'manage_support');

INSERT INTO Role_Permission (role_id, permission_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),
(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),
(4,5),(4,8),
(3,5);

-- =============================================
-- STATUS
-- =============================================
INSERT INTO Status (status_id, name) VALUES
(1, 'active'),
(2, 'inactive'),
(3, 'completed'),
(4, 'upcoming'),
(5, 'ongoing'),
(6, 'banned'),
(7, 'pending'),
(8, 'resolved');

-- =============================================
-- GAMES
-- =============================================
-- INSERT INTO Game (game_id, name, type, publisher, release_year) VALUES
-- (1, 'VALORANT',                   'Tactical Shooter', 'Riot Games', 2020),
-- (2, 'Battlegrounds Mobile India', 'Battle Royale',    'KRAFTON',    2021),
-- (3, 'Counter-Strike 2',           'Tactical Shooter', 'Valve',      2023);
INSERT INTO Game (game_id, name, type, publisher, release_year, official_youtube_url)
VALUES(1, 'Valorant', 'Tactical Shooter', 'Riot Games', 2020, 
 'https://www.youtube.com/@ValorantEsports'),
(2, 'BGMI', 'Battle Royale', 'Krafton', 2021, 
 'https://www.youtube.com/@KRAFTONIndiaEsports'),
(3, 'CS2', 'Tactical Shooter', 'Valve', 2023, 
 'https://www.youtube.com/@ESLCS');

-- =============================================
-- COACHES
-- =============================================
INSERT INTO Coach (coach_id, name) VALUES
(1,  'Chet Singh'),
(2,  'Matthew Dziewa'),
(3,  'Peter Dager'),
(4,  'brkN'),
(5,  'Hippzz'),
(6,  'YaBoiDre'),
(7,  'Gaga'),
(8,  'Karel Ašenbrener'),
(9,  'Antti Peltonen'),
(10, 'Andrii Horodenskyi'),
(11, 'Janusz Pogorzelski'),
(12, 'Yuri Prilepov'),
(13, 'Allan Mikkelsen'),
(14, 'Mathieu Quiquerez'),
(15, 'GodNixon'),
(16, 'Ghatak'),
(17, 'Dogispoet');

-- =============================================
-- USERS & ADMINS
-- =============================================
INSERT INTO Users (user_id, username, password, role_id) VALUES
-- (1, 'superadmin', '$2b$12$gJ3k9fLmP0qR7sT1uV5wXeYzA2bC4dE6fG8hI0jK2lM4nO6pQ8r', 1),
(2, 'admin_valo', '$2b$12$hK4l0gMnQ1rS8tU2vW6xYfZaB3cD5eF7gH9iJ1kL3mN5oP7qR9s', 2),
(3, 'admin_bgmi', '$2b$12$iL5m1hNoR2sT9uV3wX7yZgAaC4dE6fG8hI0jK2lM4nN6oP8qS0t', 2),
(4, 'admin_cs2',  '$2b$12$jM6n2iOpS3tU0vW4xY8zAhBbD5eF7gH9iJ1kL3mN5oN7pQ9rT1u', 2);

INSERT INTO Admins (admin_id, user_id, email, contact_no, game_id) VALUES
-- (1, 1, 'superadmin@vlrclone.gg', '+1-555-0001'),
(2, 2, 'admin.valo@vlrclone.gg', '+1-555-0002', 1),
(3, 3, 'admin.bgmi@vlrclone.gg', '+91-999-0003', 2),
(4, 4, 'admin.cs2@vlrclone.gg',  '+1-555-0004', 3);

-- =============================================
-- PLATFORMS
-- =============================================
INSERT INTO Platform (platform_id, name, description) VALUES
(1, 'Twitch',         'Live streaming platform by Amazon'),
(2, 'YouTube',        'Video streaming platform by Google'),
(3, 'YouTube Gaming', 'Gaming-focused YouTube channel'),
(4, 'Loco',           'Indian gaming and esports streaming platform'),
(5, 'AfreecaTV',      'Korean live streaming platform'),
(6, 'SteamTV',        'Valve official CS2 broadcast platform');

-- =============================================
-- VALORANT PLAYERS  (player_id 1 – 75)
-- =============================================
INSERT INTO Player
  (player_id, user_id, name, username, email, country, region, profile_image, age, rank, status_id, role_id, created_at)
VALUES
-- ── Sentinels ──────────────────────────────────────────────────────────
(1, NULL, 'Zachary Patrone', 'Zekken', 'zekken@sentinels.gg', 'United States', 'Americas', 'https://owcdn.net/img/69742b2cdd6c3.png', 21, 'Radiant', 1, 3, '2022-01-10'),
(2, NULL, 'Hunter Mims', 'SicK', 'sick@sentinels.gg', 'United States', 'Americas', 'https://owcdn.net/img/6399a54fc4472.png', 24, 'Radiant', 1, 3, '2021-03-05'),
(3, NULL, 'Jonathan Morales', 'johnqt', 'johnqt@sentinels.gg', 'United States', 'Americas', 'https://owcdn.net/img/69741441b9923.png', 22, 'Radiant', 1, 3, '2023-01-15'),
(4, NULL, 'Gabriel Ramiro', 'Sacy', 'sacy@sentinels.gg', 'Brazil', 'Americas', 'https://owcdn.net/img/6416954a0788d.png', 26, 'Radiant', 1, 3, '2023-01-20'),
(5, NULL, 'Bryan Luna', 'pANcada', 'pancada@sentinels.gg', 'Brazil', 'Americas', 'https://owcdn.net/img/6889ddd3735b1.png', 25, 'Radiant', 1, 3, '2023-01-20'),
-- ── 100 Thieves ────────────────────────────────────────────────────────
(6, NULL, 'Peter Mazuryk', 'Asuna', 'asuna@100thieves.com', 'Canada', 'Americas', 'https://owcdn.net/img/69704e530cfac.png', 22, 'Radiant', 1, 3, '2021-01-01'),
(7, NULL, 'Kelden Pupello', 'Boostio', 'boostio@100thieves.com', 'United States', 'Americas', 'https://owcdn.net/img/641693760f427.png', 21, 'Radiant', 1, 3, '2022-07-01'),
(8, NULL, 'Daniel Vucenovic', 'eeiu', 'eeiu@100thieves.com', 'United States', 'Americas', 'https://owcdn.net/img/6984ecacc0ffe.png', 22, 'Radiant', 1, 3, '2022-07-01'),
(9, NULL, 'Sean Bezerra', 'bang', 'bang@100thieves.com', 'United States', 'Americas', 'https://owcdn.net/img/69704e67e3e2b.png', 20, 'Radiant', 1, 3, '2023-10-01'),
(10, NULL, 'Matthew Panganiban', 'Cryocells', 'cryocells@100thieves.com', 'United States', 'Americas', 'https://owcdn.net/img/69704e38872a4.png', 21, 'Radiant', 1, 3, '2022-01-01'),
-- ── G2 Esports ─────────────────────────────────────────────────────────
(11, NULL, 'Jacob Batio', 'valyn', 'valyn@g2esports.com', 'United States', 'Americas', 'https://owcdn.net/img/65e4660ee20e5.png', 25, 'Radiant', 1, 3, '2023-11-20'),
(12, NULL, 'Jonah Pulice', 'JonahP', 'jonahp@g2esports.com', 'United States', 'Americas', 'https://owcdn.net/img/65e4636c00e46.png', 21, 'Radiant', 1, 3, '2023-11-20'),
(13, NULL, 'Nathan Orf', 'leaf', 'leaf@g2esports.com', 'United States', 'Americas', 'https://www.vlr.gg/img/base/ph/sil.png', 23, 'Radiant', 1, 3, '2023-11-20'),
(14, NULL, 'Jacob Lange', 'icy', 'icy@g2esports.com', 'United States', 'Americas', 'https://owcdn.net/img/6877368f626ce.png', 20, 'Radiant', 1, 3, '2023-11-20'),
(15, NULL, 'Trent Cairns', 'trent', 'trent@g2esports.com', 'Canada', 'Americas', 'https://owcdn.net/img/65e466071ca19.png', 24, 'Radiant', 1, 3, '2023-11-20'),
-- ── LEVIATÁN ───────────────────────────────────────────────────────────
(16, NULL, 'Francisco Aravena', 'kiNgg', 'kingg@leviatan.gg', 'Chile', 'Americas', 'https://owcdn.net/img/69234b213a609.png', 25, 'Radiant', 1, 3, '2021-06-01'),
(17, NULL, 'Roberto Rivas', 'Mazino', 'mazino@leviatan.gg', 'Chile', 'Americas', 'https://owcdn.net/img/69742ba0b7d17.png', 23, 'Radiant', 1, 3, '2022-01-01'),
(18, NULL, 'Erick Santos', 'aspas', 'aspas@leviatan.gg', 'Brazil', 'Americas', 'https://owcdn.net/img/6977f8cf0996f.png', 23, 'Radiant', 1, 3, '2023-12-01'),
(19, NULL, 'Ian Botsch', 'tex', 'tex@leviatan.gg', 'Brazil', 'Americas', 'https://owcdn.net/img/69742b4f94c53.png', 22, 'Radiant', 1, 3, '2023-12-01'),
(20, NULL, 'Corbin Lee', 'C0M', 'c0m@leviatan.gg', 'United States', 'Americas', 'https://owcdn.net/img/641693c3a0312.png', 24, 'Radiant', 1, 3, '2023-12-01'),
-- ── Paper Rex ──────────────────────────────────────────────────────────
(21, NULL, 'Wang Jing Jie', 'Jinggg', 'jinggg@paperrex.gg', 'Singapore', 'Pacific', 'https://owcdn.net/img/69735f0889a6b.png', 23, 'Radiant', 1, 3, '2021-06-01'),
(22, NULL, 'Jason Susanto', 'f0rsakeN', 'forsaken@paperrex.gg', 'Singapore', 'Pacific', 'https://owcdn.net/img/69735f135cf21.png', 23, 'Radiant', 1, 3, '2021-06-01'),
(23, NULL, 'Alessandro Leonhart', 'mindfreak', 'mindfreak@paperrex.gg', 'Australia', 'Pacific', 'https://owcdn.net/img/67c70182b6186.png', 26, 'Radiant', 1, 3, '2021-09-01'),
(24, NULL, 'Ilya Petrov', 'something', 'something@paperrex.gg', 'Australia', 'Pacific', 'https://owcdn.net/img/69735f396861f.png', 22, 'Radiant', 1, 3, '2022-01-01'),
(25, NULL, 'Ahmad Khalish', 'd4v41', 'd4v41@paperrex.gg', 'Malaysia', 'Pacific', 'https://owcdn.net/img/69735f207c9bf.png', 24, 'Radiant', 1, 3, '2022-05-01'),
-- ── DRX ────────────────────────────────────────────────────────────────
(26, NULL, 'Kim Tae-sang', 'stax', 'stax@drx.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/696cbe19de8ff.png', 26, 'Radiant', 1, 3, '2021-12-01'),
(27, NULL, 'Goo Sang-min', 'Rb', 'rb@drx.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/69d5f87b7c32d.png', 22, 'Radiant', 1, 3, '2022-01-01'),
(28, NULL, 'Yu Byung-chul', 'BuZz', 'buzz@drx.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/696cbe96ec066.png', 22, 'Radiant', 1, 3, '2022-01-01'),
(29, NULL, 'Kim Myeong-gwan', 'MaKo', 'mako@drx.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/676b9d064081b.png', 24, 'Radiant', 1, 3, '2023-01-01'),
(30, NULL, 'Nam Dong-hyun', 'Foxy9', 'foxy9@drx.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/676ba0170dbab.png', 21, 'Radiant', 1, 3, '2023-11-01'),
-- ── Gen.G Esports ──────────────────────────────────────────────────────
(31, NULL, 'Kim Jong-min', 'Lakia', 'lakia@geng.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/65f66e9636e73.png', 27, 'Radiant', 1, 3, '2022-01-01'),
(32, NULL, 'Byeon Sang-beom', 'Munchkin', 'munchkin@geng.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/696cbebe97d8d.png', 22, 'Radiant', 1, 3, '2023-01-01'),
(33, NULL, 'Kim Na-Ra', 't3xture', 't3xture@geng.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/676ba04aee5f9.png', 23, 'Radiant', 1, 3, '2023-01-01'),
(34, NULL, 'Kim Tae-O', 'Meteor', 'meteor@geng.gg', 'South Korea', 'Pacific', 'https://owcdn.net/img/696cbecabc2af.png', 21, 'Radiant', 1, 3, '2023-01-01'),
(35, NULL, 'Kim Won-tae', 'Karon', 'karon@geng.gg', 'South Korea', 'Pacific', 'https://www.vlr.gg/img/base/ph/sil.png', 23, 'Radiant', 1, 3, '2024-01-01'),
-- ── EDward Gaming ──────────────────────────────────────────────────────
(36, NULL, 'Liu He', 'nobody', 'nobody@edg.gg', 'China', 'China', 'https://www.vlr.gg/img/base/ph/sil.png', 24, 'Radiant', 1, 3, '2023-01-01'),
(37, NULL, 'Zheng Yongkang', 'ZmjjKK', 'zmjjkk@edg.gg', 'China', 'China', 'https://owcdn.net/img/677fe40edf9da.png', 23, 'Radiant', 1, 3, '2023-01-01'),
(38, NULL, 'Chen Haodong', 'Haodong', 'haodong@edg.gg', 'China', 'China', NULL, 22, 'Radiant', 1, 3, '2023-01-01'),
(39, NULL, 'Zhao Yinan', 'Smoggy', 'smoggy@edg.gg', 'China', 'China', NULL, 21, 'Radiant', 1, 3, '2023-05-01'),
(40, NULL, 'Cheng Chichoo', 'CHICHOO', 'chichoo@edg.gg', 'China', 'China', NULL, 22, 'Radiant', 1, 3, '2023-01-01'),
-- ── Team Heretics ──────────────────────────────────────────────────────
(41, NULL, 'Ondrej Bukovsky', 'paTiTek', 'patitek@heretics.gg', 'Czech Republic', 'EMEA', 'https://owcdn.net/img/665b77192b060.png', 24, 'Radiant', 1, 3, '2023-01-01'),
(42, NULL, 'Oliver Steffensen', 'Boo', 'boo@heretics.gg', 'Denmark', 'EMEA', 'https://owcdn.net/img/69778b1c2192b.png', 20, 'Radiant', 1, 3, '2023-11-01'),
(43, NULL, 'David Moschetto', 'RieNs', 'riens@heretics.gg', 'France', 'EMEA', 'https://owcdn.net/img/69778b71c9366.png', 23, 'Radiant', 1, 3, '2023-01-01'),
(44, NULL, 'David Jonsson', 'Wo0t', 'wo0t@heretics.gg', 'Sweden', 'EMEA', NULL, 23, 'Radiant', 1, 3, '2022-01-01'),
(45, NULL, 'Benjamin Fish', 'benjyfishy', 'benjyfishy@heretics.gg', 'United Kingdom', 'EMEA', NULL, 20, 'Radiant', 1, 3, '2023-11-01'),
-- ── FNATIC ─────────────────────────────────────────────────────────────
(46, NULL, 'Jake Howlett', 'Boaster', 'boaster@fnatic.com', 'United Kingdom', 'EMEA', 'https://owcdn.net/img/687e2c495dcc6.png', 26, 'Radiant', 1, 3, '2021-04-01'),
(47, NULL, 'Timofey Shikhin', 'Chronicle', 'chronicle@fnatic.com', 'Russia', 'EMEA', 'https://owcdn.net/img/6977a6d8e354a.png', 22, 'Radiant', 1, 3, '2021-04-01'),
(48, NULL, 'Leo Jannesson', 'Leo', 'leo@fnatic.com', 'Sweden', 'EMEA', 'https://owcdn.net/img/65d5cb904fc7c.png', 22, 'Radiant', 1, 3, '2022-11-01'),
(49, NULL, 'Emil Reif', 'Derke', 'derke@fnatic.com', 'Finland', 'EMEA', 'https://owcdn.net/img/6977a70c4ff1b.png', 23, 'Radiant', 1, 3, '2021-04-01'),
(50, NULL, 'Emir Beder', 'Alfajer', 'alfajer@fnatic.com', 'Turkey', 'EMEA', 'https://owcdn.net/img/687e2c40ac175.png', 20, 'Radiant', 1, 3, '2022-11-01'),
-- ── FUT Esports ────────────────────────────────────────────────────────
(51, NULL, 'Mehmet Yagiz Ipek', 'cNed', 'cned@fut.gg', 'Turkey', 'EMEA', 'https://owcdn.net/img/696fd4808fcf3.png', 24, 'Radiant', 1, 3, '2023-01-01'),
(52, NULL, 'Melih Karakoc', 'qRaxs', 'qraxs@fut.gg', 'Turkey', 'EMEA', 'https://owcdn.net/img/65dbc2508d984.png', 23, 'Radiant', 1, 3, '2023-01-01'),
(53, NULL, 'Ali Cak', 'AtaKaptan', 'atakaptan@fut.gg', 'Turkey', 'EMEA', 'https://owcdn.net/img/65dbdd988fc0f.png', 21, 'Radiant', 1, 3, '2023-01-01'),
(54, NULL, 'Kerem Tokur', 'MrFaliN', 'mrfalin@fut.gg', 'Turkey', 'EMEA', 'https://owcdn.net/img/697aba35e69bd.png', 22, 'Radiant', 1, 3, '2023-01-01'),
(55, NULL, 'Muhammed Yetisgen', 'yetujey', 'yetujey@fut.gg', 'Turkey', 'EMEA', NULL, 21, 'Radiant', 1, 3, '2023-01-01'),
-- ── KRÜ Esports ────────────────────────────────────────────────────────
(56, NULL, 'Nicolas Gonzalez', 'NagZ', 'nagz@kru.gg', 'Argentina', 'Americas', 'https://owcdn.net/img/63828f5c39782.png', 22, 'Radiant', 1, 3, '2022-01-01'),
(57, NULL, 'Agustin Ibarra', 'Melser', 'melser@kru.gg', 'Argentina', 'Americas', 'https://owcdn.net/img/687bf97be0429.png', 21, 'Radiant', 1, 3, '2022-01-01'),
(58, NULL, 'Klaus Nader', 'Klaus', 'klaus@kru.gg', 'Chile', 'Americas', 'https://owcdn.net/img/63828f6495831.png', 25, 'Radiant', 1, 3, '2021-01-01'),
(59, NULL, 'Mauricio Grijalba', 'Shyy', 'shyy@kru.gg', 'Colombia', 'Americas', NULL, 22, 'Radiant', 1, 3, '2023-01-01'),
(60, NULL, 'Benjamin Paszkiewicz', 'delz1k', 'delz1k@kru.gg', 'Argentina', 'Americas', 'https://owcdn.net/img/60b6c9224021c.png', 20, 'Radiant', 1, 3, '2023-01-01'),
-- ── Bilibili Gaming ────────────────────────────────────────────────────
(61, NULL, 'Wang Wei', 'yuicaw', 'yuicaw@blg.gg', 'China', 'China', 'https://owcdn.net/img/677d1d79e76fc.png', 22, 'Radiant', 1, 3, '2023-01-01'),
(62, NULL, 'Zhang Hao', 'lmemore', 'lmemore@blg.gg', 'China', 'China', 'https://owcdn.net/img/65a8fcde5ed6a.png', 21, 'Radiant', 1, 3, '2023-01-01'),
(63, NULL, 'Li Ming', 's1Mon', 's1mon@blg.gg', 'China', 'China', 'https://owcdn.net/img/677fe418eaaf8.png', 20, 'Radiant', 1, 3, '2023-01-01'),
(64, NULL, 'Chen Jing', 'biank', 'biank@blg.gg', 'China', 'China', NULL, 22, 'Radiant', 1, 3, '2023-01-01'),
(65, NULL, 'Liu Yang', 'Aqua', 'aqua@blg.gg', 'China', 'China', 'https://www.vlr.gg/img/base/ph/sil.png', 21, 'Radiant', 1, 3, '2023-01-01'),
-- ── Trace Esports ──────────────────────────────────────────────────────
(66, NULL, 'Zhao Fan', 'Twolazy', 'twolazy@trace.gg', 'China', 'China', NULL, 23, 'Radiant', 1, 3, '2023-01-01'),
(67, NULL, 'Chen Wei', 'dGn', 'dgn@trace.gg', 'China', 'China', NULL, 22, 'Radiant', 1, 3, '2023-01-01'),
(68, NULL, 'Huang Wenlong', 'nGe', 'nge@trace.gg', 'China', 'China', NULL, 24, 'Radiant', 1, 3, '2023-01-01'),
(69, NULL, 'Liu Fang', 'Crush', 'crush@trace.gg', 'China', 'China', NULL, 21, 'Radiant', 1, 3, '2023-01-01'),
(70, NULL, 'Wang Dong', 'Phenom', 'phenom@trace.gg', 'China', 'China', NULL, 22, 'Radiant', 1, 3, '2023-01-01'),
-- ── FunPlus Phoenix ────────────────────────────────────────────────────
(71, NULL, 'Pontus Ekelof', 'Zyppan', 'zyppan@fpx.gg', 'Sweden', 'EMEA', 'https://owcdn.net/img/69a8bfacbffc8.png', 23, 'Radiant', 1, 3, '2023-01-01'),
(72, NULL, 'Andrej Francisty', 'ANGE1', 'ange1@fpx.gg', 'Slovakia', 'EMEA', 'https://owcdn.net/img/6792500c3f0df.png', 31, 'Radiant', 1, 3, '2023-01-01'),
(73, NULL, 'Ayaz Akhmetshin', 'Shao', 'shao@fpx.gg', 'Russia', 'EMEA', 'https://owcdn.net/img/6792501581f4f.png', 23, 'Radiant', 1, 3, '2023-01-01'),
(74, NULL, 'Dmitry Vinogradov', 'SUYGETSU', 'suygetsu@fpx.gg', 'Russia', 'EMEA', 'https://owcdn.net/img/642eabfbd9478.png', 23, 'Radiant', 1, 3, '2023-01-01'),
(75, NULL, 'Ardis Svarenieks', 'ardiis', 'ardiis@fpx.gg', 'Latvia', 'EMEA', 'https://owcdn.net/img/6416904081146.png', 24, 'Radiant', 1, 3, '2023-01-01');
-- =============================================
-- BGMI PLAYERS  (player_id 76 – 102)
-- =============================================
INSERT INTO Player
  (player_id, user_id, name, username, email, country, region, age, rank, status_id, role_id, created_at)
VALUES
-- ── Team XSpark ────────────────────────────────────────────────────────
(76, NULL,'Sachin Singh',     'NinjaJOD',  'ninjajod@xspark.in',        'India','South Asia',22,'Conqueror',1,3,'2022-05-01'),
(77, NULL,'Yash Sharma',      'SPRAYGOD',  'spraygod@xspark.in',        'India','South Asia',21,'Conqueror',1,3,'2022-05-01'),
(78, NULL,'Siddharth Pal',    'Sarang',    'sarang@xspark.in',          'India','South Asia',20,'Conqueror',1,3,'2022-07-01'),
(79, NULL,'Saksham Gupta',    'Shadow7',   'shadow7@xspark.in',         'India','South Asia',21,'Conqueror',1,3,'2022-06-01'),
-- ── Global Esports ─────────────────────────────────────────────────────
(80, NULL,'Abijeet Sarkar',   'Beast',     'beast@globalesports.in',    'India','South Asia',23,'Conqueror',1,3,'2021-09-01'),
(81, NULL,'Maneesh Singh',    'Mavi',      'mavi@globalesports.in',     'India','South Asia',22,'Conqueror',1,3,'2022-01-01'),
(82, NULL,'Nikhil Kumawat',   'NinjaBoi',  'ninjaboi@globalesports.in', 'India','South Asia',20,'Conqueror',1,3,'2023-01-01'),
(83, NULL,'Ankit Panwar',     'Slug',      'slug@globalesports.in',     'India','South Asia',21,'Conqueror',1,3,'2022-01-01'),
-- ── Reckoning Esports ──────────────────────────────────────────────────
(84, NULL,'Rahul Singh',      'GravityJOD','gravity@reckoning.gg',      'India','South Asia',22,'Conqueror',1,3,'2022-03-01'),
(85, NULL,'Aman Sharma',      'HunterZ',   'hunterz@reckoning.gg',      'India','South Asia',23,'Conqueror',1,3,'2022-03-01'),
(86, NULL,'Prashant Kumar',   'IMMORTAL',  'immortal@reckoning.gg',     'India','South Asia',21,'Conqueror',1,3,'2022-03-01'),
(87, NULL,'Kunal Sethi',      'ShikariJOD','shikari@reckoning.gg',      'India','South Asia',22,'Conqueror',1,3,'2022-03-01'),
(88, NULL,'Mayank Arora',     'ViPER',     'viper@reckoning.gg',        'India','South Asia',20,'Conqueror',1,3,'2023-01-01'),
-- ── Team SouL ──────────────────────────────────────────────────────────
(89, NULL,'Harpreet Janjuha', 'Jokerr',    'jokerr@teamsoul.in',        'India','South Asia',24,'Conqueror',1,3,'2020-06-01'),
(90, NULL,'Pavan Sharma',     'Manya',     'manya@teamsoul.in',         'India','South Asia',22,'Conqueror',1,3,'2021-01-01'),
(91, NULL,'Nakul Sharma',     'NakuL',     'nakul@teamsoul.in',         'India','South Asia',23,'Conqueror',1,3,'2020-06-01'),
(92, NULL,'Ronak Anand',      'Rony',      'rony@teamsoul.in',          'India','South Asia',22,'Conqueror',1,3,'2021-01-01'),
(93, NULL,'Navdeep Singh',    'Spower',    'spower@teamsoul.in',        'India','South Asia',24,'Conqueror',1,3,'2022-01-01'),
-- ── GodLike Esports ────────────────────────────────────────────────────
(94, NULL,'Yash Gill',        'Punk',      'punk@godlike.gg',           'India','South Asia',23,'Conqueror',1,3,'2022-01-01'),
(95, NULL,'Animesh Agarwal',  'Neyoo',     'neyoo@godlike.gg',          'India','South Asia',22,'Conqueror',1,3,'2021-01-01'),
(96, NULL,'Rupesh Rathore',   'Destro',    'destro@godlike.gg',         'India','South Asia',21,'Conqueror',1,3,'2022-01-01'),
(97, NULL,'Virender Singh',   'Viru',      'viru@godlike.gg',           'India','South Asia',22,'Conqueror',1,3,'2023-01-01'),
(98, NULL,'Ankush Farswan',   'Clutchgod', 'clutchgod@godlike.gg',      'India','South Asia',23,'Conqueror',1,3,'2022-01-01'),
-- ── Numen Esports ──────────────────────────────────────────────────────
(99,  NULL,'Ashish Shukla',   'Ash',       'ash@numenesports.in',       'India','South Asia',25,'Conqueror',1,3,'2021-01-01'),
(100, NULL,'Mohammad Owais',  'Owais',     'owais@numenesports.in',     'India','South Asia',26,'Conqueror',1,3,'2021-01-01'),
(101, NULL,'Yash Patel',      'Intense',   'intense@numenesports.in',   'India','South Asia',22,'Conqueror',1,3,'2022-01-01'),
(102, NULL,'Pratik Sable',    'Goblin',    'goblin@numenesports.in',    'India','South Asia',22,'Conqueror',1,3,'2022-01-01');

-- =============================================
-- CS2 PLAYERS  (player_id 103 – 142)
-- =============================================
INSERT INTO Player
  (player_id, user_id, name, username, email, country, region, age, rank, status_id, role_id, created_at)
VALUES
-- ── Natus Vincere ──────────────────────────────────────────────────────
(103, NULL,'Justinas Lekavicius', 'jL',       'jl@navi.gg',            'Lithuania',   'EMEA',25,'Global Elite',1,3,'2023-06-30'),
(104, NULL,'Aleksi Virolainen',   'Aleksib',  'aleksib@navi.gg',       'Finland',     'EMEA',28,'Global Elite',1,3,'2023-06-30'),
(105, NULL,'Mihai Ivan',           'iM',       'im@navi.gg',            'Romania',     'EMEA',25,'Global Elite',1,3,'2023-06-30'),
(106, NULL,'Valerii Vakhovskyi',   'b1t',      'b1t@navi.gg',           'Ukraine',     'EMEA',21,'Global Elite',1,3,'2020-12-20'),
(107, NULL,'Ihor Zhdanov',         'w0nderful','wonderful@navi.gg',     'Ukraine',     'EMEA',20,'Global Elite',1,3,'2023-10-31'),
-- ── FaZe Clan ──────────────────────────────────────────────────────────
(108, NULL,'Finn Johansson',      'karrigan', 'karrigan@fazeclan.com', 'Denmark',     'EMEA',34,'Global Elite',1,3,'2022-01-01'),
(109, NULL,'Nikola Kovac',        'NiKo',     'niko@fazeclan.com',     'Bosnia',      'EMEA',26,'Global Elite',1,3,'2024-01-01'),
(110, NULL,'Guillaume Lefebvre', 'm0NESY',    'monesy@fazeclan.com',   'France',      'EMEA',19,'Global Elite',1,3,'2022-08-01'),
(111, NULL,'Robin Kool',          'ropz',     'ropz@fazeclan.com',     'Estonia',     'EMEA',24,'Global Elite',1,3,'2022-02-01'),
(112, NULL,'Havard Nygaard',      'rain',     'rain@fazeclan.com',     'Norway',      'EMEA',30,'Global Elite',1,3,'2021-01-01'),
-- ── Team Spirit ────────────────────────────────────────────────────────
(113, NULL,'Danil Kryshkovets',   'donk',     'donk@teamspirit.gg',    'Russia',      'EMEA',17,'Global Elite',1,3,'2023-01-01'),
(114, NULL,'Boris Vorobyev',      'magixx',   'magixx@teamspirit.gg',  'Russia',      'EMEA',23,'Global Elite',1,3,'2023-01-01'),
(115, NULL,'Dmitriy Sokolov',     'sh1ro',    'sh1ro@teamspirit.gg',   'Russia',      'EMEA',23,'Global Elite',1,3,'2022-01-01'),
(116, NULL,'Leonid Vishnyakov',   'chopper',  'chopper@teamspirit.gg', 'Russia',      'EMEA',25,'Global Elite',1,3,'2022-01-01'),
(117, NULL,'Dmitriy Zharkov',     'zont1x',   'zont1x@teamspirit.gg',  'Russia',      'EMEA',20,'Global Elite',1,3,'2022-01-01'),
-- ── MOUZ ───────────────────────────────────────────────────────────────
(118, NULL,'David Cermak',        'frozen',   'frozen@mouz.gg',        'Slovakia',    'EMEA',23,'Global Elite',1,3,'2021-01-01'),
(119, NULL,'Rasmus Gjeding',      'siuhy',    'siuhy@mouz.gg',         'Denmark',     'EMEA',22,'Global Elite',1,3,'2022-01-01'),
(120, NULL,'Aurimas Pipiras',     'jimpphat', 'jimpphat@mouz.gg',      'Lithuania',   'EMEA',18,'Global Elite',1,3,'2023-01-01'),
(121, NULL,'Tobias Jurica',       'torzsi',   'torzsi@mouz.gg',        'Germany',     'EMEA',22,'Global Elite',1,3,'2022-01-01'),
(122, NULL,'Rasmus Pedersen',     'brollan',  'brollan@mouz.gg',       'Sweden',      'EMEA',23,'Global Elite',1,3,'2024-01-01'),
-- ── Team Vitality ──────────────────────────────────────────────────────
(123, NULL,'Mathieu Herbaut',     'ZywOo',    'zywoo@vitality.gg',     'France',      'EMEA',24,'Global Elite',1,3,'2022-01-01'),
(124, NULL,'Dan Madesclaire',     'apEX',     'apex@vitality.gg',      'France',      'EMEA',31,'Global Elite',1,3,'2022-01-01'),
(125, NULL,'Lotan Giladi',        'Spinx',    'spinx@vitality.gg',     'Israel',      'EMEA',23,'Global Elite',1,3,'2022-01-01'),
(126, NULL,'Shahar Shushan',      'flameZ',   'flamez@vitality.gg',    'Israel',      'EMEA',23,'Global Elite',1,3,'2023-01-01'),
(127, NULL,'Emil Hansen',         'Magisk',   'magisk@vitality.gg',    'Denmark',     'EMEA',26,'Global Elite',1,3,'2022-01-01'),
-- ── The MongolZ ────────────────────────────────────────────────────────
(128, NULL,'Enkhbaatar Ganzul',   'Senzu',    'senzu@mongolz.gg',      'Mongolia',    'Asia', 22,'Global Elite',1,3,'2022-01-01'),
(129, NULL,'Munkhtulga Batsuuri', 'mzinho',   'mzinho@mongolz.gg',     'Mongolia',    'Asia', 21,'Global Elite',1,3,'2022-01-01'),
(130, NULL,'Bold-Ochir Myangad',  'bLitz',    'blitz@mongolz.gg',      'Mongolia',    'Asia', 22,'Global Elite',1,3,'2022-01-01'),
(131, NULL,'Bat-Enkh Gantulga',   'Techno',   'techno@mongolz.gg',     'Mongolia',    'Asia', 23,'Global Elite',1,3,'2022-01-01'),
(132, NULL,'Aaron Dornan',        'Vexite',   'vexite@mongolz.gg',     'Australia',   'Asia', 23,'Global Elite',1,3,'2023-01-01'),
-- ── Team Liquid ────────────────────────────────────────────────────────
(133, NULL,'Keith Markovic',      'NAF',      'naf@teamliquid.com',    'Canada',      'Americas',27,'Global Elite',1,3,'2021-01-01'),
(134, NULL,'Jonathan Jablonowski','EliGE',    'elige@teamliquid.com',  'United States','Americas',26,'Global Elite',1,3,'2020-01-01'),
(135, NULL,'Mareks Galinskis',    'YEKINDAR', 'yekindar@teamliquid.com','Latvia',     'EMEA',   24,'Global Elite',1,3,'2023-01-01'),
(136, NULL,'Nicholas Cannella',   'nitr0',    'nitro@teamliquid.com',  'United States','Americas',29,'Global Elite',1,3,'2020-01-01'),
(137, NULL,'Russel Van Dulken',   'Twistzz',  'twistzz@teamliquid.com','Canada',      'Americas',25,'Global Elite',1,3,'2022-01-01'),
-- ── HEROIC ─────────────────────────────────────────────────────────────
(138, NULL,'Casper Moller',       'cadiaN',   'cadian@heroic.gg',      'Denmark',     'EMEA',29,'Global Elite',1,3,'2021-01-01'),
(139, NULL,'Jonas Svensson',      'stavn',    'stavn@heroic.gg',       'Denmark',     'EMEA',22,'Global Elite',1,3,'2021-01-01'),
(140, NULL,'Thomas Toft',         'TeSeS',    'teses@heroic.gg',       'Denmark',     'EMEA',24,'Global Elite',1,3,'2021-01-01'),
(141, NULL,'Rasmus Beck',         'sjuush',   'sjuush@heroic.gg',      'Denmark',     'EMEA',23,'Global Elite',1,3,'2021-01-01'),
(142, NULL,'Marco Nygaard',       'NertZ',    'nertz@heroic.gg',       'Denmark',     'EMEA',22,'Global Elite',1,3,'2023-01-01');

-- ── SCHEMA V3 APPROVAL BACKFILL ─────────────────────────────────────────
UPDATE Player SET approval_status = 'approved', approved_by = 2, approved_at = '2023-01-01 10:00:00';

-- =============================================
-- PLAYER_GAME (New in v3)
-- =============================================
INSERT INTO Player_Game (player_id, game_id, approval_status, approved_by, approved_at, registered_at)
SELECT player_id, 1, 'approved', 2, '2023-01-01 10:00:00', '2023-01-01 10:00:00' FROM Player WHERE player_id BETWEEN 1 AND 75;

INSERT INTO Player_Game (player_id, game_id, approval_status, approved_by, approved_at, registered_at)
SELECT player_id, 2, 'approved', 3, '2023-01-01 10:00:00', '2023-01-01 10:00:00' FROM Player WHERE player_id BETWEEN 76 AND 102;

INSERT INTO Player_Game (player_id, game_id, approval_status, approved_by, approved_at, registered_at)
SELECT player_id, 3, 'approved', 4, '2023-01-01 10:00:00', '2023-01-01 10:00:00' FROM Player WHERE player_id BETWEEN 103 AND 142;

-- =============================================
-- TEAMS  (org_id = NULL — Organization removed)
-- Valorant: 1–15 | BGMI: 16–21 | CS2: 22–29
-- =============================================
INSERT INTO Team(team_id, name, org_id, logo, founded_date, coach_id, region, status_id, created_at)
VALUES

-- ── VALORANT ─────────────────────────────────────────────
(1,  'Sentinels', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/sentinels/sentinels-logo.png',
'2018-01-31', 1, 'Americas',1,'2021-01-01'),

(2,  '100 Thieves', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/100-thieves/100-thieves-logo.png',
'2021-02-01', 2, 'Americas',1,'2021-02-01'),

(3,  'G2 Esports', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/g2-esports/g2-esports-logo.png',
'2023-11-20', 3, 'Americas',1,'2023-11-20'),

(4,  'LEVIATAN', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/leviatan/leviatan-logo.png',
'2021-06-01', NULL,'Americas',1,'2021-06-01'),

(5,  'Paper Rex', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/paper-rex/paper-rex-logo.png',
'2021-01-01', 4, 'Pacific',1,'2021-01-01'),

(6,  'DRX', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/drx/drx-logo.png',
'2021-12-01', 5, 'Pacific',1,'2021-12-01'),

(7,  'Gen.G Esports', NULL,
'https://prosettings.net/cdn-cgi/image/dpr=1%2Cf=auto%2Cfit=pad%2Cheight=675%2Cq=85%2Csharpen=2%2Cwidth=1200/wp-content/uploads/gen.g.png',
'2022-01-01', 6, 'Pacific',1,'2022-01-01'),

(8,  'EDward Gaming', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/edward-gaming/edward-gaming-logo.png',
'2023-01-01', 7, 'China',1,'2023-01-01'),

(9,  'Team Heretics', NULL,
'https://owcdn.net/img/5f7b679b343bd.png',
'2023-01-01', 8, 'EMEA',1,'2023-01-01'),

(10, 'FNATIC', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/fnatic/fnatic-logo.png',
'2021-03-01', 9, 'EMEA',1,'2021-03-01'),

(11, 'FUT Esports', NULL,
'https://old.runitback.gg/wp-content/uploads/2022/11/Adsiz_tasarim_15.webp',
'2023-01-01', NULL,'EMEA',1,'2023-01-01'),

(12, 'FunPlus Phoenix', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/valorant/funplus-phoenix/funplus-phoenix-logo.png',
'2023-01-01', NULL,'EMEA',1,'2023-01-01'),

(13, 'Bilibili Gaming', NULL,
'https://freepnglogo.com/images/all_img/bilibili-logo-dfc4.png',
'2023-01-01', NULL,'China',1,'2023-01-01'),

(14, 'Trace Esports', NULL,
'https://owcdn.net/img/6433a2cc3ae72.png',
'2023-01-01', NULL,'China',1,'2023-01-01'),

(15, 'KRU Esports', NULL,
'https://liquipedia.net/commons/images/b/bf/KRU_Esports_allmode.png',
'2021-01-01', NULL,'Americas',1,'2021-01-01'),

-- ── BGMI ─────────────────────────────────────────────────
(16, 'Team XSpark', NULL, 
'https://owcdn.net/img/6780c7e474266.png',
'2022-05-01', NULL,'South Asia',1,'2022-05-01'),

(17, 'Global Esports', NULL, 
'https://liquipedia.net/commons/images/2/23/Global_Esports_2020_allmode.png',
'2021-09-01', NULL,'South Asia',1,'2021-09-01'),

(18, 'Reckoning Esports', NULL, 
'https://owcdn.net/img/5f7b4a299fe14.png',
'2022-03-01', NULL,'South Asia',1,'2022-03-01'),

(19, 'Team SouL', NULL, 
'https://image.pngaaa.com/302/687302-middle.png',
'2020-06-01',15,'South Asia',1,'2020-06-01'),

(20, 'GodLike Esports', NULL, NULL,'2021-01-01',17,'South Asia',1,'2021-01-01'),
(21, 'Numen Esports', NULL, NULL,'2021-06-01',16,'South Asia',1,'2021-01-01'),

-- ── CS2 ──────────────────────────────────────────────────
(22, 'Natus Vincere', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/csgo/natus-vincere/natus-vincere-logo.png',
'2009-10-01',10,'EMEA',1,'2020-01-01'),

(23, 'FaZe Clan', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/csgo/faze-clan/faze-clan-logo.png',
'2016-01-01',11,'EMEA',1,'2020-01-01'),

(24, 'Team Spirit', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/csgo/team-spirit/team-spirit-logo.png',
'2021-01-01',12,'EMEA',1,'2021-01-01'),

(25, 'MOUZ', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/csgo/mouz/mouz-logo.png',
'2020-01-01',13,'EMEA',1,'2020-01-01'),

(26, 'Team Vitality', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/csgo/team-vitality/team-vitality-logo.png',
'2021-01-01',14,'EMEA',1,'2021-01-01'),

(27, 'The MongolZ', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/csgo/the-mongolz/the-mongolz-logo.png',
'2022-01-01',NULL,'Asia',1,'2022-01-01'),

(28, 'Team Liquid', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/csgo/team-liquid/team-liquid-logo.png',
'2020-01-01',NULL,'Americas',1,'2020-01-01'),

(29, 'HEROIC', NULL,
'https://raw.githubusercontent.com/lootmarket/esport-team-logos/master/csgo/heroic/heroic-logo.png',
'2020-01-01',NULL,'EMEA',1,'2020-01-01');
-- =============================================
-- TEAM_PLAYER
-- =============================================
INSERT INTO Team_Player (team_id, player_id, join_date, leave_date) VALUES
(1,1,'2022-11-01',NULL),(1,2,'2021-03-05',NULL),(1,3,'2023-01-15',NULL),(1,4,'2023-01-20',NULL),(1,5,'2023-01-20',NULL),
(2,6,'2021-01-01',NULL),(2,7,'2022-07-01',NULL),(2,8,'2022-07-01',NULL),(2,9,'2023-10-01',NULL),(2,10,'2022-01-01',NULL),
(3,11,'2023-11-20',NULL),(3,12,'2023-11-20',NULL),(3,13,'2023-11-20',NULL),(3,14,'2023-11-20',NULL),(3,15,'2023-11-20',NULL),
(4,16,'2021-06-01',NULL),(4,17,'2022-01-01',NULL),(4,18,'2023-12-01',NULL),(4,19,'2023-12-01',NULL),(4,20,'2023-12-01',NULL),
(5,21,'2021-06-01',NULL),(5,22,'2021-06-01',NULL),(5,23,'2021-09-01',NULL),(5,24,'2022-01-01',NULL),(5,25,'2022-05-01',NULL),
(6,26,'2021-12-01',NULL),(6,27,'2022-01-01',NULL),(6,28,'2022-01-01',NULL),(6,29,'2023-01-01',NULL),(6,30,'2023-11-01',NULL),
(7,31,'2022-01-01',NULL),(7,32,'2023-01-01',NULL),(7,33,'2023-01-01',NULL),(7,34,'2023-01-01',NULL),(7,35,'2024-01-01',NULL),
(8,36,'2023-01-01',NULL),(8,37,'2023-01-01',NULL),(8,38,'2023-01-01',NULL),(8,39,'2023-05-01',NULL),(8,40,'2023-01-01',NULL),
(9,41,'2023-01-01',NULL),(9,42,'2023-11-01',NULL),(9,43,'2023-01-01',NULL),(9,44,'2022-01-01',NULL),(9,45,'2023-11-01',NULL),
(10,46,'2021-04-01',NULL),(10,47,'2021-04-01',NULL),(10,48,'2022-11-01',NULL),(10,49,'2021-04-01',NULL),(10,50,'2022-11-01',NULL),
(11,51,'2023-01-01',NULL),(11,52,'2023-01-01',NULL),(11,53,'2023-01-01',NULL),(11,54,'2023-01-01',NULL),(11,55,'2023-01-01',NULL),
(12,71,'2023-01-01',NULL),(12,72,'2023-01-01',NULL),(12,73,'2023-01-01',NULL),(12,74,'2023-01-01',NULL),(12,75,'2023-01-01',NULL),
(13,61,'2023-01-01',NULL),(13,62,'2023-01-01',NULL),(13,63,'2023-01-01',NULL),(13,64,'2023-01-01',NULL),(13,65,'2023-01-01',NULL),
(14,66,'2023-01-01',NULL),(14,67,'2023-01-01',NULL),(14,68,'2023-01-01',NULL),(14,69,'2023-01-01',NULL),(14,70,'2023-01-01',NULL),
(15,56,'2022-01-01',NULL),(15,57,'2022-01-01',NULL),(15,58,'2021-01-01',NULL),(15,59,'2023-01-01',NULL),(15,60,'2023-01-01',NULL),
(16,76,'2022-05-01',NULL),(16,77,'2022-05-01',NULL),(16,78,'2022-07-01',NULL),(16,79,'2022-06-01',NULL),
(17,80,'2021-09-01',NULL),(17,81,'2022-01-01',NULL),(17,82,'2023-01-01',NULL),(17,83,'2022-01-01',NULL),
(18,84,'2022-03-01',NULL),(18,85,'2022-03-01',NULL),(18,86,'2022-03-01',NULL),(18,87,'2022-03-01',NULL),(18,88,'2023-01-01',NULL),
(19,89,'2020-06-01',NULL),(19,90,'2021-01-01',NULL),(19,91,'2020-06-01',NULL),(19,92,'2021-01-01',NULL),(19,93,'2022-01-01',NULL),
(20,94,'2022-01-01',NULL),(20,95,'2021-01-01',NULL),(20,96,'2022-01-01',NULL),(20,97,'2023-01-01',NULL),(20,98,'2022-01-01',NULL),
(21,99,'2021-01-01',NULL),(21,100,'2021-01-01',NULL),(21,101,'2022-01-01',NULL),(21,102,'2022-01-01',NULL),
(22,103,'2023-06-30',NULL),(22,104,'2023-06-30',NULL),(22,105,'2023-06-30',NULL),(22,106,'2020-12-20',NULL),(22,107,'2023-10-31',NULL),
(23,108,'2022-01-01',NULL),(23,109,'2024-01-01',NULL),(23,110,'2022-08-01',NULL),(23,111,'2022-02-01',NULL),(23,112,'2021-01-01',NULL),
(24,113,'2023-01-01',NULL),(24,114,'2023-01-01',NULL),(24,115,'2022-01-01',NULL),(24,116,'2022-01-01',NULL),(24,117,'2022-01-01',NULL),
(25,118,'2021-01-01',NULL),(25,119,'2022-01-01',NULL),(25,120,'2023-01-01',NULL),(25,121,'2022-01-01',NULL),(25,122,'2024-01-01',NULL),
(26,123,'2022-01-01',NULL),(26,124,'2022-01-01',NULL),(26,125,'2022-01-01',NULL),(26,126,'2023-01-01',NULL),(26,127,'2022-01-01',NULL),
(27,128,'2022-01-01',NULL),(27,129,'2022-01-01',NULL),(27,130,'2022-01-01',NULL),(27,131,'2022-01-01',NULL),(27,132,'2023-01-01',NULL),
(28,133,'2021-01-01',NULL),(28,134,'2020-01-01',NULL),(28,135,'2023-01-01',NULL),(28,136,'2020-01-01',NULL),(28,137,'2022-01-01',NULL),
(29,138,'2021-01-01',NULL),(29,139,'2021-01-01',NULL),(29,140,'2021-01-01',NULL),(29,141,'2021-01-01',NULL),(29,142,'2023-01-01',NULL);

-- =============================================
-- PLAYER HISTORY (Transfers) (New in v3)
-- =============================================
INSERT INTO Player_History (player_id, team_id, role, join_date, leave_date, transfer_fee, notes) VALUES
(4, NULL, 'Initiator', '2022-01-01', '2022-12-31', 0, 'Played for LOUD previously'),
(5, NULL, 'Controller', '2022-01-01', '2022-12-31', 0, 'Played for LOUD previously'),
(18, NULL, 'Duelist', '2022-01-01', '2023-11-01', 0, 'Played for LOUD before joining Leviatan'),
(109, 23, 'Rifler', '2020-10-28', '2024-01-01', 500000.00, 'G2 to FaZe transition period recorded'),
(135, NULL, 'Entry Fragger', '2020-05-23', '2022-10-18', 0, 'Played for Virtus.pro / Outsiders before Team Liquid');

-- =============================================
-- TOURNAMENTS
-- VALORANT: 1–10 | BGMI: 11–15 | CS2: 16–20
-- status: 3=completed, 4=upcoming, 5=ongoing
-- =============================================
INSERT INTO Tournament
  (tournament_id, name, game_id, start_date, end_date, type, format, prize_pool,
   location, organizer, number_of_teams, status_id)
VALUES
-- ── VALORANT ───────────────────────────────────────────────────────────
(1,  'VCT 2024: Americas Stage 1',     1,'2024-01-18','2024-03-10','League',        'Round Robin + Playoffs',250000.00, 'Online / USA',           'Riot Games',10,3),
(2,  'VCT 2024: EMEA Stage 1',         1,'2024-01-12','2024-03-17','League',        'Round Robin + Playoffs',250000.00, 'Online / Europe',         'Riot Games',10,3),
(3,  'VCT 2024: Pacific Stage 1',      1,'2024-01-11','2024-03-17','League',        'Round Robin + Playoffs',250000.00, 'Online / Seoul',           'Riot Games',10,3),
(4,  'VCT 2024: China Stage 1',        1,'2024-01-06','2024-03-10','League',        'Round Robin + Playoffs',NULL,      'Online / China',           'Riot Games', 8,3),
(5,  'VCT 2024: Masters Madrid',       1,'2024-03-14','2024-03-31','International', 'Swiss + Single-Elim',   500000.00, 'Madrid, Spain',            'Riot Games',12,3),
(6,  'VCT 2024: Americas Stage 2',     1,'2024-05-30','2024-07-21','League',        'Round Robin + Playoffs',250000.00, 'Online / USA',             'Riot Games',10,3),
(7,  'VCT 2024: EMEA Stage 2',         1,'2024-05-27','2024-07-19','League',        'Round Robin + Playoffs',250000.00, 'Online / Europe',           'Riot Games',10,3),
(8,  'VCT 2024: Pacific Stage 2',      1,'2024-05-26','2024-07-21','League',        'Round Robin + Playoffs',250000.00, 'Online / Seoul',             'Riot Games',10,3),
(9,  'VCT 2024: Masters Shanghai',     1,'2024-05-23','2024-06-09','International', 'Swiss + Single-Elim',  1000000.00, 'Shanghai, China',           'Riot Games',12,3),
(10, 'Valorant Champions 2024',        1,'2024-08-01','2024-08-25','International', 'Swiss + Single-Elim',  2250000.00, 'INSPIRE Arena, Incheon',   'Riot Games',16,3),
-- ── BGMI ───────────────────────────────────────────────────────────────
(11, 'BGMI India Rising 2024',         2,'2024-03-05','2024-03-28','Open',          'League + Grand Final',   150000.00,'Online / India',           'Upthrust Esports',32,3),
(12, 'BGIS 2024',                      2,'2024-06-28','2024-06-30','Open',          'LAN Grand Final',        239911.00,'Hitex Centre, Hyderabad',  'KRAFTON India',16,3),
(13, 'BGMI Masters Series Season 3',   2,'2024-07-19','2024-08-11','Invitational',  'League + Playoffs',      119760.00,'NODWIN Arena, Delhi',      'NODWIN Gaming',24,3),
(14, 'BGMI Pro Series 2024',           2,'2024-08-20','2024-09-29','Invitational',  'League + LAN Final',     239911.00,'Adlux Centre, Kochi',      'KRAFTON India',16,3),
(15, 'BGMI Titans Rising 2024',        2,'2024-10-10','2024-10-27','Open',          'Qualifiers + Grand Final', 26330.00,'Online / India',           'Gujarat Titans & Revenant',32,3),
-- ── CS2 ────────────────────────────────────────────────────────────────
(16, 'IEM Katowice 2024',              3,'2024-01-31','2024-02-18','Invitational',  'Swiss + Playoffs',      1000000.00,'Spodek, Katowice',         'ESL/FACEIT',16,3),
(17, 'PGL Major Copenhagen 2024',      3,'2024-03-17','2024-03-31','Major',         'Swiss x2 + Playoffs',   1250000.00,'Royal Arena, Copenhagen',  'PGL',24,3),
(18, 'ESL Pro League Season 19',       3,'2024-03-20','2024-04-14','League',        'Group Stage + Playoffs',  850000.00,'Malta',                   'ESL/FACEIT',32,3),
(19, 'ESL Pro League Season 20',       3,'2024-09-05','2024-09-29','League',        'Group Stage + Playoffs',  850000.00,'Malta',                   'ESL/FACEIT',32,3),
(20, 'Perfect World Shanghai Major 2024',3,'2024-12-01','2024-12-15','Major',       'Swiss x2 + Playoffs',   1250000.00,'Oriental Sports Ctr, Shanghai','Perfect World',24,3),
-- ── UPCOMING TOURNAMENTS (status_id=4) ─────────────────────────────────
(21, 'VCT 2025: Masters Bangkok',      1,'2025-02-05','2025-02-23','International', 'Swiss + Single-Elim',   500000.00,'Bangkok, Thailand',         'Riot Games',12,3),
(22, 'VCT 2025: Americas Stage 1',     1,'2025-01-09','2025-03-16','League',        'Round Robin + Playoffs',250000.00,'Online / USA',              'Riot Games',10,3),
(23, 'BGIS 2025',                      2,'2025-06-01','2025-06-30','Open',          'LAN Grand Final',        300000.00,'TBD, India',               'KRAFTON India',16,4),
(24, 'IEM Cologne 2025',               3,'2025-07-15','2025-07-27','Invitational',  'Swiss + Playoffs',      1000000.00,'Lanxess Arena, Cologne',   'ESL/FACEIT',16,4),
(25, 'BLAST.tv Austin Major 2025',     3,'2025-06-01','2025-06-22','Major',         'Swiss x2 + Playoffs',   1250000.00,'Moody Center, Austin',     'BLAST',24,4);

-- =============================================
-- TOURNAMENT_TEAM
-- =============================================
INSERT INTO Tournament_Team (tournament_id, team_id) VALUES
-- VCT Americas S1 (t1)
(1,1),(1,2),(1,3),(1,4),(1,15),
-- VCT EMEA S1 (t2)
(2,9),(2,10),(2,11),(2,12),
-- VCT Pacific S1 (t3)
(3,5),(3,6),(3,7),
-- VCT China S1 (t4)
(4,8),(4,13),(4,14),
-- Masters Madrid (t5)
(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8),(5,9),(5,10),(5,11),(5,12),
-- VCT Americas S2 (t6)
(6,1),(6,2),(6,3),(6,4),(6,15),
-- VCT EMEA S2 (t7)
(7,9),(7,10),(7,11),(7,12),
-- VCT Pacific S2 (t8)
(8,5),(8,6),(8,7),
-- Masters Shanghai (t9)
(9,2),(9,3),(9,4),(9,5),(9,6),(9,7),(9,8),(9,9),(9,10),(9,11),(9,12),(9,1),
-- Champions 2024 (t10)
(10,1),(10,2),(10,3),(10,4),(10,5),(10,6),(10,7),(10,8),(10,9),(10,10),(10,12),(10,13),(10,14),(10,15),
-- BGMI (t11–t15)
(11,16),(11,17),(11,18),(11,19),(11,20),(11,21),
(12,16),(12,17),(12,18),(12,19),(12,20),(12,21),
(13,16),(13,17),(13,18),(13,19),(13,20),(13,21),
(14,16),(14,17),(14,18),(14,19),(14,20),(14,21),
(15,16),(15,17),(15,19),(15,20),
-- CS2 (t16–t20)
(16,22),(16,23),(16,24),(16,25),(16,26),(16,27),(16,28),(16,29),
(17,22),(17,23),(17,24),(17,25),(17,26),(17,27),(17,28),(17,29),
(18,22),(18,23),(18,24),(18,25),(18,26),(18,27),(18,28),(18,29),
(19,22),(19,23),(19,24),(19,25),(19,26),(19,27),(19,28),(19,29),
(20,22),(20,23),(20,24),(20,25),(20,26),(20,27),(20,28),(20,29),
-- VCT 2025 Masters Bangkok (t21)
(21,1),(21,5),(21,7),(21,8),(21,9),(21,10),(21,2),(21,3),(21,4),(21,6),
-- VCT 2025 Americas S1 (t22)
(22,1),(22,2),(22,3),(22,4),(22,15),
-- BGIS 2025 (t23)
(23,16),(23,17),(23,18),(23,19),(23,20),(23,21),
-- IEM Cologne 2025 (t24)
(24,22),(24,23),(24,24),(24,25),(24,26),(24,27),(24,28),(24,29),
-- BLAST Austin Major 2025 (t25)
(25,22),(25,23),(25,24),(25,25),(25,26),(25,27),(25,28),(25,29);

-- =============================================
-- MATCHES
-- =============================================
INSERT INTO Matches
  (match_id, tournament_id, game_id, team1_id, team2_id, winner_team_id,
   score_team1, score_team2, round, best_of, map_name, match_type,
   status_id, date, start_time, duration)
VALUES
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] VCT 2024 MASTERS SHANGHAI  (t9, game 1)
-- ══════════════════════════════════════════════════════════════════════
(1,  9,1,  2, 5,  2, 2,1,'Swiss Stage',   3,NULL,      'lan',3,'2024-05-23','04:00:00',75),
(2,  9,1,  9,11,  9, 2,0,'Swiss Stage',   3,NULL,      'lan',3,'2024-05-23','06:45:00',55),
(3,  9,1,  7, 3,  7, 2,1,'Swiss Stage',   3,NULL,      'lan',3,'2024-05-28','04:00:00',80),
(4,  9,1,  5,10,  5, 2,1,'Swiss Stage',   3,NULL,      'lan',3,'2024-05-28','07:00:00',70),
(5,  9,1,  2, 5,  5, 0,2,'Lower QF',      3,NULL,      'lan',3,'2024-06-03','04:00:00',60),
(6,  9,1,  7,12,  7, 2,0,'Upper QF',      3,NULL,      'lan',3,'2024-06-03','06:30:00',55),
(7,  9,1,  9,11,  9, 2,0,'Lower QF',      3,NULL,      'lan',3,'2024-06-03','07:00:00',52),
(8,  9,1,  3, 2,  2, 0,2,'Lower SF',      3,'Icebox',  'lan',3,'2024-06-07','06:00:00',68),
(9,  9,1,  7, 3,  7, 2,1,'Upper Final',   3,'Split',   'lan',3,'2024-06-07','03:00:00',85),
(10, 9,1,  9, 2,  9, 2,0,'Lower Final',   3,'Ascent',  'lan',3,'2024-06-08','07:00:00',62),
(11, 9,1,  3, 9,  9, 0,3,'Lower Final',   5,'Sunset',  'lan',3,'2024-06-08','03:00:00',95),
(12, 9,1,  7, 9,  7, 3,2,'Grand Final',   5,'Lotus',   'lan',3,'2024-06-09','04:10:00',130),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] VCT 2024 MASTERS MADRID  (t5, game 1)
-- ══════════════════════════════════════════════════════════════════════
(13, 5,1,  7, 5,  5, 1,2,'Upper QF',      3,NULL,      'lan',3,'2024-03-25','03:00:00',70),
(14, 5,1,  9,10,  9, 2,1,'Upper QF',      3,NULL,      'lan',3,'2024-03-25','06:00:00',82),
(15, 5,1,  7, 9,  9, 1,2,'Upper SF',      3,'Bind',    'lan',3,'2024-03-28','04:00:00',88),
(16, 5,1,  5, 3,  5, 2,0,'Lower SF',      3,NULL,      'lan',3,'2024-03-28','07:00:00',60),
(17, 5,1,  5, 7,  7, 1,2,'Lower Final',   3,'Lotus',   'lan',3,'2024-03-30','04:00:00',90),
(18, 5,1,  9, 7,  9, 3,1,'Grand Final',   5,'Ascent',  'lan',3,'2024-03-31','04:00:00',120),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] VALORANT CHAMPIONS 2024  (t10, game 1)
-- ══════════════════════════════════════════════════════════════════════
(19,10,1,  7, 1,  7, 2,0,'Opening Group', 3,NULL,      'lan',3,'2024-08-01','04:00:00',55),
(20,10,1, 12, 9,  9, 1,2,'Opening Group', 3,NULL,      'lan',3,'2024-08-01','06:25:00',72),
(21,10,1,  6,15,  6, 2,1,'Opening Group', 3,NULL,      'lan',3,'2024-08-02','04:00:00',78),
(22,10,1, 10,13, 10, 2,0,'Opening Group', 3,NULL,      'lan',3,'2024-08-02','07:00:00',54),
(23,10,1,  2, 4,  4, 1,2,'Opening Group', 3,NULL,      'lan',3,'2024-08-03','04:00:00',80),
(24,10,1,  5,14,  5, 2,0,'Opening Group', 3,NULL,      'lan',3,'2024-08-04','04:00:00',58),
(25,10,1,  8, 3,  8, 2,1,'Elimination',   3,NULL,      'lan',3,'2024-08-06','04:00:00',82),
(26,10,1,  9,10,  9, 2,1,'Elimination',   3,NULL,      'lan',3,'2024-08-07','04:00:00',88),
(27,10,1,  4, 7,  4, 2,1,'Elimination',   3,NULL,      'lan',3,'2024-08-08','04:00:00',75),
(28,10,1,  6, 1,  1, 0,2,'Upper QF',      3,'Bind',    'lan',3,'2024-08-14','04:00:00',62),
(29,10,1, 14, 8,  8, 0,2,'Upper QF',      3,'Ascent',  'lan',3,'2024-08-14','06:25:00',55),
(30,10,1,  3, 4,  4, 0,2,'Upper QF',      3,'Sunset',  'lan',3,'2024-08-15','04:00:00',65),
(31,10,1,  5, 9,  9, 1,2,'Upper QF',      3,'Icebox',  'lan',3,'2024-08-15','06:30:00',82),
(32,10,1,  4, 8,  8, 1,2,'Upper SF',      3,'Haven',   'lan',3,'2024-08-18','04:00:00',90),
(33,10,1,  1, 9,  9, 1,2,'Upper SF',      3,'Pearl',   'lan',3,'2024-08-19','04:00:00',85),
(34,10,1,  1, 4,  4, 1,2,'Lower SF',      3,'Split',   'lan',3,'2024-08-21','04:00:00',88),
(35,10,1,  8, 9,  8, 2,1,'Upper Final',   3,'Lotus',   'lan',3,'2024-08-22','04:00:00',95),
(36,10,1,  4, 9,  9, 1,2,'Lower Final',   5,'Sunset',  'lan',3,'2024-08-23','04:00:00',105),
(37,10,1,  8, 9,  8, 3,2,'Grand Final',   5,'Ascent',  'lan',3,'2024-08-25','04:00:00',140),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] BGIS 2024  (t12, game 2, Hyderabad LAN)
-- ══════════════════════════════════════════════════════════════════════
(38,12,2, 16,17, 16, 45,32,'Grand Final Day 1',6,NULL,'lan',3,'2024-06-28','10:00:00',180),
(39,12,2, 16,18, 16, 52,41,'Grand Final Day 2',6,NULL,'lan',3,'2024-06-29','10:00:00',180),
(40,12,2, 16,19, 16, 45,30,'Grand Final Day 3',6,NULL,'lan',3,'2024-06-30','10:00:00',180),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] BGMI PRO SERIES 2024  (t14, Kochi LAN)
-- ══════════════════════════════════════════════════════════════════════
(41,14,2, 16,21, 16, 65,52,'Grand Final Day 1',6,NULL,'lan',3,'2024-09-27','10:00:00',180),
(42,14,2, 20,21, 21, 44,55,'Grand Final Day 2',6,NULL,'lan',3,'2024-09-28','10:00:00',180),
(43,14,2, 16,20, 16, 48,44,'Grand Final Day 3',6,NULL,'lan',3,'2024-09-29','10:00:00',180),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] BGMI MASTERS SERIES S3  (t13, NODWIN Arena Delhi)
-- ══════════════════════════════════════════════════════════════════════
(44,13,2, 19,20, 19, 55,48,'Grand Final Day 1',6,NULL,'lan',3,'2024-08-09','10:00:00',180),
(45,13,2, 19,18, 19, 62,45,'Grand Final Day 2',6,NULL,'lan',3,'2024-08-10','10:00:00',180),
(46,13,2, 19,21, 19, 50,38,'Grand Final Day 3',6,NULL,'lan',3,'2024-08-11','10:00:00',180),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] IEM KATOWICE 2024  (t16, game 3)
-- ══════════════════════════════════════════════════════════════════════
(47,16,3, 24,22, 24, 2,0,'Quarterfinal', 3,'Mirage',  'lan',3,'2024-02-13','11:00:00',62),
(48,16,3, 24,26, 24, 2,1,'Semifinal',    3,'Nuke',    'lan',3,'2024-02-16','14:00:00',85),
(49,16,3, 23,27, 23, 2,0,'Semifinal',    3,'Ancient', 'lan',3,'2024-02-16','17:30:00',68),
(50,16,3, 24,23, 24, 2,0,'Final',        3,'Inferno', 'lan',3,'2024-02-18','16:00:00',70),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] PGL MAJOR COPENHAGEN 2024  (t17, game 3)
-- ══════════════════════════════════════════════════════════════════════
(51,17,3, 22,27, 22, 2,1,'Quarterfinal', 3,'Dust2',   'lan',3,'2024-03-28','09:00:00',80),
(52,17,3, 23,24, 23, 2,1,'Quarterfinal', 3,'Mirage',  'lan',3,'2024-03-28','12:00:00',85),
(53,17,3, 25,26, 25, 2,1,'Quarterfinal', 3,'Nuke',    'lan',3,'2024-03-29','09:00:00',90),
(54,17,3, 29,28, 29, 2,0,'Quarterfinal', 3,'Ancient', 'lan',3,'2024-03-29','12:00:00',62),
(55,17,3, 22,25, 22, 2,1,'Semifinal',    3,'Inferno', 'lan',3,'2024-03-30','09:00:00',88),
(56,17,3, 23,29, 23, 2,1,'Semifinal',    3,'Anubis',  'lan',3,'2024-03-30','13:00:00',82),
(57,17,3, 22,23, 22, 2,1,'Grand Final',  3,'Dust2',   'lan',3,'2024-03-31','14:00:00',95),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] ESL PRO LEAGUE SEASON 20  (t19, game 3)
-- ══════════════════════════════════════════════════════════════════════
(58,19,3, 24,25, 24, 2,0,'Semifinal',    3,'Mirage',  'lan',3,'2024-09-27','13:00:00',60),
(59,19,3, 22,23, 22, 2,1,'Semifinal',    3,'Nuke',    'lan',3,'2024-09-27','16:00:00',88),
(60,19,3, 22,24, 22, 3,2,'Grand Final',  5,'Anubis',  'lan',3,'2024-09-29','15:00:00',130),
-- ══════════════════════════════════════════════════════════════════════
-- [COMPLETED] PERFECT WORLD SHANGHAI MAJOR 2024  (t20, game 3)
-- ══════════════════════════════════════════════════════════════════════
(61,20,3, 27,22, 27, 2,1,'Elimination Stage',3,NULL,    'lan',3,'2024-12-08','09:00:00',82),
(62,20,3, 24,28, 24, 2,0,'Quarterfinal',     3,'Nuke',  'lan',3,'2024-12-12','09:00:00',62),
(63,20,3, 23,26, 23, 2,1,'Quarterfinal',     3,'Ancient','lan',3,'2024-12-12','12:30:00',88),
(64,20,3, 25,29, 25, 2,1,'Quarterfinal',     3,'Mirage','lan',3,'2024-12-13','09:00:00',85),
(65,20,3, 24,25, 24, 2,1,'Semifinal',        3,'Inferno','lan',3,'2024-12-14','09:00:00',90),
(66,20,3, 23,28, 23, 2,1,'Semifinal',        3,'Dust2', 'lan',3,'2024-12-14','13:00:00',82),
(67,20,3, 24,23, 24, 2,1,'Grand Final',      3,'Dust2', 'lan',3,'2024-12-15','09:28:00',110),
-- ══════════════════════════════════════════════════════════════════════
-- [LIVE / ONGOING]  status_id = 5
-- ══════════════════════════════════════════════════════════════════════
(68,21,1,  8,10, NULL, 1,0,'Swiss Stage',  3,'Ascent',  'lan',5,'2025-02-07','06:00:00',NULL),
(69,21,1,  9, 7, NULL, 0,0,'Swiss Stage',  3,'Bind',    'lan',5,'2025-02-07','09:00:00',NULL),
(70,23,2, 16,20, NULL, 38,31,'Qualifier Day 1',6,NULL,'online',5,'2025-06-05','14:00:00',NULL),
(71,25,3, 22,29, NULL, 1,0,'Opening Stage', 1,'Nuke',  'lan',5,'2025-06-03','15:00:00',NULL),
(72,25,3, 23,27, NULL, 0,0,'Opening Stage', 1,'Mirage','lan',5,'2025-06-03','18:00:00',NULL),
-- ══════════════════════════════════════════════════════════════════════
-- [UPCOMING]  status_id = 4
-- ══════════════════════════════════════════════════════════════════════
(73,21,1,  1, 9, NULL, 0,0,'Swiss Stage',  3,NULL,'lan',4,'2025-02-08','04:00:00',NULL),
(74,21,1,  5, 8, NULL, 0,0,'Swiss Stage',  3,NULL,'lan',4,'2025-02-08','07:00:00',NULL),
(75,21,1,  2, 4, NULL, 0,0,'Swiss Stage',  3,NULL,'lan',4,'2025-02-09','04:00:00',NULL),
(76,21,1,  3,10, NULL, 0,0,'Swiss Stage',  3,NULL,'lan',4,'2025-02-09','07:00:00',NULL),
(77,21,1,  7, 6, NULL, 0,0,'Swiss Stage',  3,NULL,'lan',4,'2025-02-10','04:00:00',NULL),
(78,21,1,  NULL,NULL,NULL,0,0,'Upper QF',  3,NULL,'lan',4,'2025-02-19','04:00:00',NULL),
(79,21,1,  NULL,NULL,NULL,0,0,'Upper SF',  3,NULL,'lan',4,'2025-02-21','04:00:00',NULL),
(80,21,1,  NULL,NULL,NULL,0,0,'Grand Final',5,NULL,'lan',4,'2025-02-23','04:00:00',NULL),
(81,22,1,  1, 3, NULL, 0,0,'Week 1',3,NULL,'online',4,'2025-01-10','22:00:00',NULL),
(82,22,1,  2, 4, NULL, 0,0,'Week 1',3,NULL,'online',4,'2025-01-11','00:00:00',NULL),
(83,22,1,  3,15, NULL, 0,0,'Week 2',3,NULL,'online',4,'2025-01-17','22:00:00',NULL),
(84,22,1,  1, 2, NULL, 0,0,'Week 2',3,NULL,'online',4,'2025-01-18','22:00:00',NULL),
(85,23,2, 16,19, NULL, 0,0,'Round 4 Qualifier',6,NULL,'online',4,'2025-06-10','14:00:00',NULL),
(86,23,2, 17,20, NULL, 0,0,'Round 4 Qualifier',6,NULL,'online',4,'2025-06-10','17:00:00',NULL),
(87,23,2, 18,21, NULL, 0,0,'Round 4 Qualifier',6,NULL,'online',4,'2025-06-11','14:00:00',NULL),
(88,23,2, 16,18, NULL, 0,0,'Grand Final Day 1',6,NULL,'lan',   4,'2025-06-28','10:00:00',NULL),
(89,23,2, 19,20, NULL, 0,0,'Grand Final Day 2',6,NULL,'lan',   4,'2025-06-29','10:00:00',NULL),
(90,23,2, 16,17, NULL, 0,0,'Grand Final Day 3',6,NULL,'lan',   4,'2025-06-30','10:00:00',NULL),
(91,24,3, 22,26, NULL, 0,0,'Quarterfinal',3,'Dust2',  'lan',4,'2025-07-22','10:00:00',NULL),
(92,24,3, 23,25, NULL, 0,0,'Quarterfinal',3,'Nuke',   'lan',4,'2025-07-22','13:00:00',NULL),
(93,24,3, 24,29, NULL, 0,0,'Quarterfinal',3,'Mirage', 'lan',4,'2025-07-23','10:00:00',NULL),
(94,24,3, 27,28, NULL, 0,0,'Quarterfinal',3,'Ancient','lan',4,'2025-07-23','13:00:00',NULL),
(95,24,3, NULL,NULL,NULL,  0,0,'Semifinal',3,NULL,    'lan',4,'2025-07-25','13:00:00',NULL),
(96,24,3, NULL,NULL,NULL,  0,0,'Semifinal',3,NULL,    'lan',4,'2025-07-25','16:00:00',NULL),
(97,24,3, NULL,NULL,NULL,  0,0,'Final',    5,NULL,    'lan',4,'2025-07-27','15:00:00',NULL),
(98, 25,3, 22,26, NULL, 0,0,'Opening Stage',1,NULL,'lan',4,'2025-06-06','09:00:00',NULL),
(99, 25,3, 24,28, NULL, 0,0,'Opening Stage',1,NULL,'lan',4,'2025-06-06','12:00:00',NULL),
(100,25,3, 25,27, NULL, 0,0,'Opening Stage',1,NULL,'lan',4,'2025-06-07','09:00:00',NULL),
(101,25,3, NULL,NULL,NULL,0,0,'Quarterfinal',3,NULL,'lan',4,'2025-06-17','13:00:00',NULL),
(102,25,3, NULL,NULL,NULL,0,0,'Semifinal',   3,NULL,'lan',4,'2025-06-19','13:00:00',NULL),
(103,25,3, NULL,NULL,NULL,0,0,'Grand Final', 5,NULL,'lan',4,'2025-06-22','15:00:00',NULL);

-- =============================================
-- MATCH_MAP (New in v3) - Individual match breakdown
-- =============================================
INSERT INTO Match_Map (match_id, map_number, map_name, score_team1, score_team2, winner_team_id, duration_mins) VALUES
-- Match 12: Gen.G (7) vs Heretics (9), Winner Gen.G (3-2)
(12, 1, 'Breeze', 13, 11, 7, 45),
(12, 2, 'Icebox',  9, 13, 9, 40),
(12, 3, 'Ascent', 13,  9, 7, 42),
(12, 4, 'Lotus',   4, 13, 9, 35),
(12, 5, 'Split',  13,  9, 7, 48),
-- Match 37: EDG (8) vs Heretics (9), Winner EDG (3-2)
(37, 1, 'Haven',   6, 13, 9, 38),
(37, 2, 'Sunset', 13,  4, 8, 35),
(37, 3, 'Lotus',  13,  9, 8, 42),
(37, 4, 'Bind',   11, 13, 9, 45),
(37, 5, 'Abyss',  13,  9, 8, 47),
-- Match 57: PGL Major Copenhagen GF: NAVI (22) vs FaZe (23), Winner NAVI (2-1)
(57, 1, 'Ancient', 13,  9, 22, 50),
(57, 2, 'Mirage',   2, 13, 23, 35),
(57, 3, 'Inferno', 13,  3, 22, 40);

-- =============================================
-- PLAYER_MATCHES 
-- =============================================
INSERT INTO Player_Matches (player_id, match_id) VALUES
(31,12),(32,12),(33,12),(34,12),(35,12),
(41,12),(42,12),(43,12),(44,12),(45,12),
(36,37),(37,37),(38,37),(39,37),(40,37),
(41,37),(42,37),(43,37),(44,37),(45,37),
(41,18),(42,18),(43,18),(44,18),(45,18),
(31,18),(32,18),(33,18),(34,18),(35,18),
(103,57),(104,57),(105,57),(106,57),(107,57),
(108,57),(109,57),(110,57),(111,57),(112,57),
(113,67),(114,67),(115,67),(116,67),(117,67),
(108,67),(109,67),(110,67),(111,67),(112,67),
(113,50),(114,50),(115,50),(116,50),(117,50),
(108,50),(109,50),(110,50),(111,50),(112,50),
(76,40),(77,40),(78,40),(79,40),
(89,40),(90,40),(91,40),(92,40),(93,40),
(36,68),(37,68),(38,68),(39,68),(40,68),
(46,68),(47,68),(48,68),(49,68),(50,68),
(41,69),(42,69),(43,69),(44,69),(45,69),
(31,69),(32,69),(33,69),(34,69),(35,69),
(103,71),(104,71),(105,71),(106,71),(107,71),
(138,71),(139,71),(140,71),(141,71),(142,71),
(108,72),(109,72),(110,72),(111,72),(112,72),
(128,72),(129,72),(130,72),(131,72),(132,72);

-- =============================================
-- PLATFORM_STREAMING
-- =============================================
INSERT INTO Platform_Streaming
  (match_id, platform_id, link, viewer_count, quality, language)
VALUES
(37,2,'https://youtube.com/watch?v=Champions2024GF', 850000,'1080p60','English'),
(37,1,'https://twitch.tv/valorant',                  620000,'1080p60','English'),
(12,2,'https://youtube.com/watch?v=MastersShanghai2024GF',420000,'1080p60','English'),
(12,5,'https://afreecatv.com/valorant',               180000,'1080p',  'Korean'),
(18,2,'https://youtube.com/watch?v=MastersMadrid2024GF', 390000,'1080p60','English'),
(18,1,'https://twitch.tv/valorant',                      290000,'1080p60','English'),
(57,2,'https://youtube.com/watch?v=PGLCopenhagen2024GF',1100000,'1080p60','English'),
(57,1,'https://twitch.tv/pgl',                           820000,'1080p60','English'),
(57,6,'https://steamcommunity.com/broadcast/watch/cs2',  350000,'1080p60','English'),
(67,2,'https://youtube.com/watch?v=ShanghaiMajor2024GF', 950000,'1080p60','English'),
(67,6,'https://steamcommunity.com/broadcast/watch/cs2',  420000,'1080p60','English'),
(40,3,'https://youtube.com/kraftonindia/bgis2024',        380000,'1080p60','Hindi'),
(40,4,'https://loco.gg/krafton',                          120000,'720p',  'Hindi'),
(68,2,'https://youtube.com/watch?v=MastersBangkok2025Live',85000,'1080p60','English'),
(68,1,'https://twitch.tv/valorant',                        60000,'1080p60','English'),
(69,2,'https://youtube.com/watch?v=MastersBangkok2025Live',72000,'1080p60','English'),
(71,1,'https://twitch.tv/blasttv',                         92000,'1080p60','English'),
(71,6,'https://steamcommunity.com/broadcast/watch/cs2',    45000,'1080p60','English'),
(72,1,'https://twitch.tv/blasttv',                        110000,'1080p60','English'),
(72,6,'https://steamcommunity.com/broadcast/watch/cs2',    52000,'1080p60','English');

-- =============================================
-- SOCIAL LINKS (New in v3)
-- =============================================
INSERT INTO Social_Link (entity_type, entity_id, platform, url, display_name, is_verified) VALUES
('team', 1, 'twitter', 'https://twitter.com/Sentinels', '@Sentinels', TRUE),
('team', 22, 'twitter', 'https://twitter.com/natusvincere', '@natusvincere', TRUE),
('player', 1, 'twitter', 'https://twitter.com/zekkenVAL', '@zekkenVAL', TRUE),
('player', 103, 'twitter', 'https://twitter.com/jLcsgo', '@jLcsgo', TRUE),
('player', 113, 'twitter', 'https://twitter.com/donkcs', '@donkcs', TRUE),
('sponsor', 1, 'website', 'https://redbull.com/esports', 'Red Bull Esports', TRUE);

-- =============================================
-- PRIZE DISTRIBUTIONS
-- =============================================
INSERT INTO Prize (prize_id, tournament_id, position, amount, currency) VALUES
(1, 5,1,250000.00,'USD'),(2, 5,2,100000.00,'USD'),(3, 5,3, 62500.00,'USD'),(4, 5,4, 37500.00,'USD'),
(5, 9,1,275000.00,'USD'),(6, 9,2,150000.00,'USD'),(7, 9,3, 85000.00,'USD'),(8, 9,4, 85000.00,'USD'),
(9, 9,5, 50000.00,'USD'),(10,9,6, 50000.00,'USD'),
(11,10,1,1000000.00,'USD'),(12,10,2,400000.00,'USD'),(13,10,3, 250000.00,'USD'),(14,10,4,130000.00,'USD'),
(15,10,5,  85000.00,'USD'),(16,10,6, 85000.00,'USD'),(17,10,7,  50000.00,'USD'),(18,10,8, 50000.00,'USD'),
(19,12,1,71973.00,'USD'),(20,12,2,35987.00,'USD'),(21,12,3,23991.00,'USD'),(22,12,4,17993.00,'USD'),(23,12,5,14994.00,'USD'),
(24,14,1,89966.00,'USD'),(25,14,2,35987.00,'USD'),(26,14,3,23991.00,'USD'),(27,14,4,14994.00,'USD'),
(28,13,1,65934.00,'USD'),(29,13,2,17982.00,'USD'),(30,13,3, 7194.00,'USD'),
(31,16,1,500000.00,'USD'),(32,16,2,180000.00,'USD'),(33,16,3,100000.00,'USD'),(34,16,4,100000.00,'USD'),
(35,17,1,500000.00,'USD'),(36,17,2,150000.00,'USD'),(37,17,3, 75000.00,'USD'),(38,17,4, 75000.00,'USD'),
(39,17,5, 35000.00,'USD'),(40,17,6, 35000.00,'USD'),(41,17,7, 35000.00,'USD'),(42,17,8, 35000.00,'USD'),
(43,19,1,300000.00,'USD'),(44,19,2,150000.00,'USD'),(45,19,3, 75000.00,'USD'),(46,19,4, 75000.00,'USD'),
(47,20,1,500000.00,'USD'),(48,20,2,170000.00,'USD'),(49,20,3, 80000.00,'USD'),(50,20,4, 80000.00,'USD'),
(51,20,5, 45000.00,'USD'),(52,20,6, 45000.00,'USD'),(53,20,7, 45000.00,'USD'),(54,20,8, 45000.00,'USD'),
(55,21,1,250000.00,'USD'),(56,21,2,100000.00,'USD'),(57,21,3, 62500.00,'USD'),(58,21,4, 37500.00,'USD'),
(59,25,1,500000.00,'USD'),(60,25,2,150000.00,'USD'),(61,25,3, 75000.00,'USD'),(62,25,4, 75000.00,'USD');

-- =============================================
-- SPONSORS
-- =============================================
INSERT INTO Sponsor (sponsor_id, name, industry, contact_email, logo, total_investment) VALUES
(1, 'Red Bull', 'Energy Drinks', 'esports@redbull.com','https://icon2.cleanpng.com/lnd/20241224/ie/58742a5b4663708192ffa8881c26a1.webp', 1400000.00),
(2, 'HyperX', 'Peripherals', 'esports@hyperx.com', 'https://yt3.googleusercontent.com/8LVflUuD2Wza5daIV0d-GzHTOl9kH9QxP9IVddBc3fz8OdSVewuGZIg8X-iAQ4V3IXw7aUbC8ks=s900-c-k-c0x00ffffff-no-rj', 500000.00),
(3, 'Mastercard', 'Finance', 'sponsorships@mastercard.com','https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/330px-Mastercard-logo.svg.png', 400000.00),
(4, 'KRAFTON', 'Gaming', 'esports@krafton.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7k-mpKqZBmI8QWGREk3dAQSCWgi7YpWT3Lg&s', 1000000.00),
(5, 'Secretlab', 'Gaming Furniture', 'esports@secretlab.co', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8j8N4_beCPuGV9t_BRoJPDD7gu5mnVDihIg&s', 200000.00),
(6, 'Verizon', 'Telecom', 'esports@verizon.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWiY7UnkHwpB05f3w0tfgaKUW4_Bc1Bgwg_A&s', 400000.00),
(7, 'Aim Labs', 'Training Software', 'partnerships@aimlabs.com', 'https://yt3.googleusercontent.com/KztD9ihG38vGEZ1Eun7pgIkWM2oYTppwLeE6GMw9Xv3X7Nci7mjPWPIGQQ5_uW4sl99V3FT4tmM=s900-c-k-c0x00ffffff-no-rj', 150000.00),
(8, 'BookMyShow', 'Ticketing', 'sponsorships@bookmyshow.in', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4afxnYwEp5_e73hCZ_VA3-swMGIXl52rwLQ&s', 80000.00);

INSERT INTO Sponsorable (sponsor_id, entity_type, entity_id, contract_start, contract_end, amount) VALUES
(1,'team',      22,'2024-01-01','2025-12-31', 800000.00),
(1,'team',      24,'2024-01-01','2025-12-31', 600000.00),
(2,'tournament',10,'2024-08-01','2024-08-25', 500000.00),
(3,'tournament', 9,'2024-05-23','2024-06-09', 400000.00),
(4,'tournament',12,'2024-06-28','2024-06-30', 500000.00),
(4,'tournament',14,'2024-08-20','2024-09-29', 500000.00),
(5,'team',      10,'2024-01-01','2025-12-31', 200000.00),
(6,'tournament',17,'2024-03-17','2024-03-31', 400000.00),
(7,'tournament', 9,'2024-05-23','2024-06-09', 150000.00),
(8,'tournament',14,'2024-08-20','2024-09-29',  80000.00);

-- =============================================
-- GAME ACCOUNTS
-- =============================================
INSERT INTO Game_Account
  (game_id, player_id, username, tag, rank, level, date_created, last_active, is_primary)
VALUES
(1,37,'ZmjjKK','EDG','Radiant',500,'2020-06-02','2024-08-25', TRUE),
(1,31,'Lakia', 'GNG','Radiant',480,'2020-06-02','2024-08-25', TRUE),
(1,41,'paTiTek','HRT','Radiant',490,'2020-06-02','2024-08-25', TRUE),
(1,46,'Boaster','FNC','Radiant',475,'2020-06-02','2024-08-25', TRUE),
(1,21,'Jinggg','PRX','Radiant',495,'2020-06-02','2024-06-09', TRUE),
(3,113,'donk',   NULL,'Global Elite',2800,'2023-09-27','2024-12-15', TRUE),
(3,103,'jL',     NULL,'Global Elite',2750,'2023-09-27','2024-12-15', TRUE),
(3,123,'ZywOo',  NULL,'Global Elite',3000,'2023-09-27','2024-12-15', TRUE),
(3,108,'karrigan',NULL,'Global Elite',2900,'2023-09-27','2024-12-15', TRUE),
(3,110,'m0NESY', NULL,'Global Elite',2950,'2023-09-27','2024-12-15', TRUE),
(2,76,'NinjaJOD','IN','Conqueror',80,'2021-07-01','2024-06-30', TRUE),
(2,77,'SPRAYGOD','IN','Conqueror',75,'2021-07-01','2024-09-29', TRUE),
(2,99,'Ash',     'IN','Conqueror',72,'2021-07-01','2024-09-29', TRUE);

-- =============================================
-- STATISTICS
-- =============================================
-- INSERT INTO Stat
--   (stat_id, owner_type, owner_id, context_type, context_id,
--    visibility, source, confidence, stat_name, value, unit, recorded_at)
-- VALUES
-- (1,'player',37, 'tournament',10,'public','vlr.gg',    0.95,'ACS',       280.4,'points', '2024-08-25'),
-- (2,'player',113,'tournament',20,'public','hltv.org',  0.97,'Rating 2.0',1.41, '',        '2024-12-15'),
-- (3,'player',113,'tournament',16,'public','hltv.org',  0.95,'Rating 2.0',1.38, '',        '2024-02-18'),
-- (4,'player',103,'tournament',17,'public','hltv.org',  0.97,'Rating 2.0',1.29, '',        '2024-03-31'),
-- (5,'team',  7,  'tournament', 9,'public','vlr.gg',    0.90,'Win Rate',  83.3, '%',        '2024-06-09'),
-- (6,'team',  8,  'tournament',10,'public','vlr.gg',    0.90,'Win Rate',  80.0, '%',        '2024-08-25'),
-- (7,'team',  16, 'tournament',12,'public','liquipedia.net',0.99,'Total Points',142,'pts','2024-06-30'),
-- (8,'team',  24, 'tournament',16,'public','hltv.org',  0.95,'Maps Won',  6,    'maps',    '2024-02-18');
USE vlr_clone;

INSERT INTO Stat
  (stat_id, owner_type, owner_id, context_type, context_id,
   visibility, source, confidence, stat_name, value, unit, recorded_at)
VALUES
(915, 'player',132,NULL,NULL,'public','manual',1.0,'rating',1.05,'rating','2024-12-01'),
(916, 'player',132,NULL,NULL,'public','manual',1.0,'acs',220.5,'points','2024-12-01'),
(917, 'player',132,NULL,NULL,'public','manual',1.0,'kd',1.12,'ratio','2024-12-01'),
(918, 'player',132,NULL,NULL,'public','manual',1.0,'kast',72.3,'%','2024-12-01'),
(919, 'player',132,NULL,NULL,'public','manual',1.0,'adr',145.8,'dmg/r','2024-12-01');

INSERT INTO Stat
  (stat_id, owner_type, owner_id, context_type, context_id,
   visibility, source, confidence, stat_name, value, unit, recorded_at)
VALUES

-- ══════════════════════════════════════════════════════════════════════
--  VALORANT — VCT 2024: MASTERS MadrID  (tournament_id = 5)
--  Team Heretics win 3-1 Gen.G in Grand Final
-- ══════════════════════════════════════════════════════════════════════

-- ─── Team Heretics players ─────────────────────────────────────────────
-- paTiTek (41)
(9,   'player',41,'tournament',5,'public','vlr.gg',0.94,'acs',           248.2,'points','2024-03-31'),
(10,  'player',41,'tournament',5,'public','vlr.gg',0.94,'kd',        1.22,'ratio', '2024-03-31'),
(11,  'player',41,'tournament',5,'public','vlr.gg',0.94,'kast',       72.4,'%',     '2024-03-31'),
(12,  'player',41,'tournament',5,'public','vlr.gg',0.94,'adr',           152.1,'dmg/r', '2024-03-31'),
(13,  'player',41,'tournament',5,'public','vlr.gg',0.94,'HS_Pct',         23.8,'%',     '2024-03-31'),
(14,  'player',41,'tournament',5,'public','vlr.gg',0.94,'FK_Per_Round',    0.18,'rate',  '2024-03-31'),
(15,  'player',41,'tournament',5,'public','vlr.gg',0.94,'Maps_Played',    14.0,'maps',  '2024-03-31'),
-- benjyfishy (45)
(16,  'player',45,'tournament',5,'public','vlr.gg',0.93,'acs',           218.6,'points','2024-03-31'),
(17,  'player',45,'tournament',5,'public','vlr.gg',0.93,'kd',        1.08,'ratio', '2024-03-31'),
(18,  'player',45,'tournament',5,'public','vlr.gg',0.93,'kast',       70.8,'%',     '2024-03-31'),
(19,  'player',45,'tournament',5,'public','vlr.gg',0.93,'adr',           138.2,'dmg/r', '2024-03-31'),
(20,  'player',45,'tournament',5,'public','vlr.gg',0.93,'HS_Pct',         25.2,'%',     '2024-03-31'),
(21,  'player',45,'tournament',5,'public','vlr.gg',0.93,'FK_Per_Round',    0.14,'rate',  '2024-03-31'),
-- Boo (42)
(22,  'player',42,'tournament',5,'public','vlr.gg',0.93,'acs',           222.4,'points','2024-03-31'),
(23,  'player',42,'tournament',5,'public','vlr.gg',0.93,'kd',        1.10,'ratio', '2024-03-31'),
(24,  'player',42,'tournament',5,'public','vlr.gg',0.93,'kast',       70.2,'%',     '2024-03-31'),
(25,  'player',42,'tournament',5,'public','vlr.gg',0.93,'adr',           141.8,'dmg/r', '2024-03-31'),
(26,  'player',42,'tournament',5,'public','vlr.gg',0.93,'HS_Pct',         28.1,'%',     '2024-03-31'),
-- RieNs (43)
(27,  'player',43,'tournament',5,'public','vlr.gg',0.92,'acs',           196.4,'points','2024-03-31'),
(28,  'player',43,'tournament',5,'public','vlr.gg',0.92,'kd',        0.98,'ratio', '2024-03-31'),
(29,  'player',43,'tournament',5,'public','vlr.gg',0.92,'kast',       68.4,'%',     '2024-03-31'),
(30,  'player',43,'tournament',5,'public','vlr.gg',0.92,'adr',           128.6,'dmg/r', '2024-03-31'),
-- Wo0t (44)
(31,  'player',44,'tournament',5,'public','vlr.gg',0.92,'acs',           186.2,'points','2024-03-31'),
(32,  'player',44,'tournament',5,'public','vlr.gg',0.92,'kd',        0.93,'ratio', '2024-03-31'),
(33,  'player',44,'tournament',5,'public','vlr.gg',0.92,'kast',       71.0,'%',     '2024-03-31'),
(34,  'player',44,'tournament',5,'public','vlr.gg',0.92,'adr',           122.4,'dmg/r', '2024-03-31'),

-- ─── Gen.G players (runner-up) ─────────────────────────────────────────
-- Lakia (31)
(35,  'player',31,'tournament',5,'public','vlr.gg',0.93,'acs',           242.8,'points','2024-03-31'),
(36,  'player',31,'tournament',5,'public','vlr.gg',0.93,'kd',        1.19,'ratio', '2024-03-31'),
(37,  'player',31,'tournament',5,'public','vlr.gg',0.93,'kast',       71.6,'%',     '2024-03-31'),
(38,  'player',31,'tournament',5,'public','vlr.gg',0.93,'adr',           149.2,'dmg/r', '2024-03-31'),
(39,  'player',31,'tournament',5,'public','vlr.gg',0.93,'HS_Pct',         22.6,'%',     '2024-03-31'),
-- Meteor (34)
(40,  'player',34,'tournament',5,'public','vlr.gg',0.92,'acs',           222.6,'points','2024-03-31'),
(41,  'player',34,'tournament',5,'public','vlr.gg',0.92,'kd',        1.11,'ratio', '2024-03-31'),
(42,  'player',34,'tournament',5,'public','vlr.gg',0.92,'kast',       72.2,'%',     '2024-03-31'),
(43,  'player',34,'tournament',5,'public','vlr.gg',0.92,'adr',           141.4,'dmg/r', '2024-03-31'),
-- Munchkin (32)
(44,  'player',32,'tournament',5,'public','vlr.gg',0.92,'acs',           208.4,'points','2024-03-31'),
(45,  'player',32,'tournament',5,'public','vlr.gg',0.92,'kd',        1.03,'ratio', '2024-03-31'),
(46,  'player',32,'tournament',5,'public','vlr.gg',0.92,'kast',       69.8,'%',     '2024-03-31'),
(47,  'player',32,'tournament',5,'public','vlr.gg',0.92,'adr',           134.2,'dmg/r', '2024-03-31'),
-- t3xture (33)
(48,  'player',33,'tournament',5,'public','vlr.gg',0.91,'acs',           186.8,'points','2024-03-31'),
(49,  'player',33,'tournament',5,'public','vlr.gg',0.91,'kd',        0.95,'ratio', '2024-03-31'),
(50,  'player',33,'tournament',5,'public','vlr.gg',0.91,'kast',       70.4,'%',     '2024-03-31'),
(51,  'player',33,'tournament',5,'public','vlr.gg',0.91,'adr',           120.6,'dmg/r', '2024-03-31'),

-- ─── FNATIC players ────────────────────────────────────────────────────
-- Derke (49)
(52,  'player',49,'tournament',5,'public','vlr.gg',0.92,'acs',           240.2,'points','2024-03-31'),
(53,  'player',49,'tournament',5,'public','vlr.gg',0.92,'kd',        1.21,'ratio', '2024-03-31'),
(54,  'player',49,'tournament',5,'public','vlr.gg',0.92,'adr',           151.8,'dmg/r', '2024-03-31'),
(55,  'player',49,'tournament',5,'public','vlr.gg',0.92,'HS_Pct',         29.4,'%',     '2024-03-31'),
-- Boaster (46)
(56,  'player',46,'tournament',5,'public','vlr.gg',0.91,'acs',           184.6,'points','2024-03-31'),
(57,  'player',46,'tournament',5,'public','vlr.gg',0.91,'kd',        0.91,'ratio', '2024-03-31'),
(58,  'player',46,'tournament',5,'public','vlr.gg',0.91,'kast',       74.2,'%',     '2024-03-31'),
(59,  'player',46,'tournament',5,'public','vlr.gg',0.91,'adr',           116.4,'dmg/r', '2024-03-31'),

-- ══════════════════════════════════════════════════════════════════════
--  VALORANT — VCT 2024: MASTERS SHANGHAI  (tournament_id = 9)
--  Gen.G win 3-2 Team Heretics in Grand Final
-- ══════════════════════════════════════════════════════════════════════

-- ─── Gen.G players (champions) ─────────────────────────────────────────
-- Lakia (31)
(60,  'player',31,'tournament',9,'public','vlr.gg',0.95,'acs',           258.4,'points','2024-06-09'),
(61,  'player',31,'tournament',9,'public','vlr.gg',0.95,'kd',        1.28,'ratio', '2024-06-09'),
(62,  'player',31,'tournament',9,'public','vlr.gg',0.95,'kast',       74.2,'%',     '2024-06-09'),
(63,  'player',31,'tournament',9,'public','vlr.gg',0.95,'adr',           158.6,'dmg/r', '2024-06-09'),
(64,  'player',31,'tournament',9,'public','vlr.gg',0.95,'HS_Pct',         22.4,'%',     '2024-06-09'),
(65,  'player',31,'tournament',9,'public','vlr.gg',0.95,'FK_Per_Round',    0.20,'rate',  '2024-06-09'),
(66,  'player',31,'tournament',9,'public','vlr.gg',0.95,'Maps_Played',    12.0,'maps',  '2024-06-09'),
-- Meteor (34)
(67,  'player',34,'tournament',9,'public','vlr.gg',0.94,'acs',           228.8,'points','2024-06-09'),
(68,  'player',34,'tournament',9,'public','vlr.gg',0.94,'kd',        1.14,'ratio', '2024-06-09'),
(69,  'player',34,'tournament',9,'public','vlr.gg',0.94,'kast',       73.4,'%',     '2024-06-09'),
(70,  'player',34,'tournament',9,'public','vlr.gg',0.94,'adr',           145.2,'dmg/r', '2024-06-09'),
(71,  'player',34,'tournament',9,'public','vlr.gg',0.94,'HS_Pct',         26.8,'%',     '2024-06-09'),
-- Munchkin (32)
(72,  'player',32,'tournament',9,'public','vlr.gg',0.94,'acs',           218.2,'points','2024-06-09'),
(73,  'player',32,'tournament',9,'public','vlr.gg',0.94,'kd',        1.09,'ratio', '2024-06-09'),
(74,  'player',32,'tournament',9,'public','vlr.gg',0.94,'kast',       71.6,'%',     '2024-06-09'),
(75,  'player',32,'tournament',9,'public','vlr.gg',0.94,'adr',           138.8,'dmg/r', '2024-06-09'),
-- t3xture (33)
(76,  'player',33,'tournament',9,'public','vlr.gg',0.93,'acs',           192.6,'points','2024-06-09'),
(77,  'player',33,'tournament',9,'public','vlr.gg',0.93,'kd',        0.97,'ratio', '2024-06-09'),
(78,  'player',33,'tournament',9,'public','vlr.gg',0.93,'kast',       72.0,'%',     '2024-06-09'),
(79,  'player',33,'tournament',9,'public','vlr.gg',0.93,'adr',           123.4,'dmg/r', '2024-06-09'),
-- Karon (35)
(80,  'player',35,'tournament',9,'public','vlr.gg',0.92,'acs',           182.4,'points','2024-06-09'),
(81,  'player',35,'tournament',9,'public','vlr.gg',0.92,'kd',        0.92,'ratio', '2024-06-09'),
(82,  'player',35,'tournament',9,'public','vlr.gg',0.92,'kast',       70.2,'%',     '2024-06-09'),
(83,  'player',35,'tournament',9,'public','vlr.gg',0.92,'adr',           116.6,'dmg/r', '2024-06-09'),

-- ─── Team Heretics players (runner-up) ─────────────────────────────────
-- paTiTek (41)
(84,  'player',41,'tournament',9,'public','vlr.gg',0.95,'acs',           252.4,'points','2024-06-09'),
(85,  'player',41,'tournament',9,'public','vlr.gg',0.95,'kd',        1.24,'ratio', '2024-06-09'),
(86,  'player',41,'tournament',9,'public','vlr.gg',0.95,'kast',       73.2,'%',     '2024-06-09'),
(87,  'player',41,'tournament',9,'public','vlr.gg',0.95,'adr',           154.8,'dmg/r', '2024-06-09'),
(88,  'player',41,'tournament',9,'public','vlr.gg',0.95,'HS_Pct',         23.6,'%',     '2024-06-09'),
-- Boo (42)
(89,  'player',42,'tournament',9,'public','vlr.gg',0.94,'acs',           230.6,'points','2024-06-09'),
(90,  'player',42,'tournament',9,'public','vlr.gg',0.94,'kd',        1.13,'ratio', '2024-06-09'),
(91,  'player',42,'tournament',9,'public','vlr.gg',0.94,'kast',       71.4,'%',     '2024-06-09'),
(92,  'player',42,'tournament',9,'public','vlr.gg',0.94,'adr',           146.4,'dmg/r', '2024-06-09'),
-- RieNs (43)
(93,  'player',43,'tournament',9,'public','vlr.gg',0.93,'acs',           198.8,'points','2024-06-09'),
(94,  'player',43,'tournament',9,'public','vlr.gg',0.93,'kd',        0.99,'ratio', '2024-06-09'),
(95,  'player',43,'tournament',9,'public','vlr.gg',0.93,'kast',       69.2,'%',     '2024-06-09'),
(96,  'player',43,'tournament',9,'public','vlr.gg',0.93,'adr',           129.6,'dmg/r', '2024-06-09'),
-- benjyfishy (45)
(97,  'player',45,'tournament',9,'public','vlr.gg',0.93,'acs',           219.2,'points','2024-06-09'),
(98,  'player',45,'tournament',9,'public','vlr.gg',0.93,'kd',        1.09,'ratio', '2024-06-09'),
(99,  'player',45,'tournament',9,'public','vlr.gg',0.93,'adr',           139.4,'dmg/r', '2024-06-09'),

-- ─── Paper Rex players ─────────────────────────────────────────────────
-- Jinggg (21)
(100, 'player',21,'tournament',9,'public','vlr.gg',0.93,'acs',           248.6,'points','2024-06-09'),
(101, 'player',21,'tournament',9,'public','vlr.gg',0.93,'kd',        1.23,'ratio', '2024-06-09'),
(102, 'player',21,'tournament',9,'public','vlr.gg',0.93,'kast',       73.6,'%',     '2024-06-09'),
(103, 'player',21,'tournament',9,'public','vlr.gg',0.93,'adr',           153.4,'dmg/r', '2024-06-09'),
(104, 'player',21,'tournament',9,'public','vlr.gg',0.93,'HS_Pct',         30.2,'%',     '2024-06-09'),
-- f0rsakeN (22)
(105, 'player',22,'tournament',9,'public','vlr.gg',0.93,'acs',           236.4,'points','2024-06-09'),
(106, 'player',22,'tournament',9,'public','vlr.gg',0.93,'kd',        1.18,'ratio', '2024-06-09'),
(107, 'player',22,'tournament',9,'public','vlr.gg',0.93,'kast',       71.2,'%',     '2024-06-09'),
(108, 'player',22,'tournament',9,'public','vlr.gg',0.93,'adr',           148.2,'dmg/r', '2024-06-09'),

-- ─── 100 Thieves players ───────────────────────────────────────────────
-- Asuna (6)
(109, 'player', 6,'tournament',9,'public','vlr.gg',0.92,'acs',           238.2,'points','2024-06-09'),
(110, 'player', 6,'tournament',9,'public','vlr.gg',0.92,'kd',        1.17,'ratio', '2024-06-09'),
(111, 'player', 6,'tournament',9,'public','vlr.gg',0.92,'kast',       72.8,'%',     '2024-06-09'),
(112, 'player', 6,'tournament',9,'public','vlr.gg',0.92,'adr',           150.4,'dmg/r', '2024-06-09'),
-- Boostio (7)
(113, 'player', 7,'tournament',9,'public','vlr.gg',0.92,'acs',           246.4,'points','2024-06-09'),
(114, 'player', 7,'tournament',9,'public','vlr.gg',0.92,'kd',        1.22,'ratio', '2024-06-09'),
(115, 'player', 7,'tournament',9,'public','vlr.gg',0.92,'kast',       74.2,'%',     '2024-06-09'),
(116, 'player', 7,'tournament',9,'public','vlr.gg',0.92,'adr',           154.2,'dmg/r', '2024-06-09'),

-- ─── EDward Gaming players ─────────────────────────────────────────────
-- ZmjjKK (37) — strong Swiss Stage
(117, 'player',37,'tournament',9,'public','vlr.gg',0.93,'acs',           266.8,'points','2024-06-09'),
(118, 'player',37,'tournament',9,'public','vlr.gg',0.93,'kd',        1.30,'ratio', '2024-06-09'),
(119, 'player',37,'tournament',9,'public','vlr.gg',0.93,'kast',       73.4,'%',     '2024-06-09'),
(120, 'player',37,'tournament',9,'public','vlr.gg',0.93,'adr',           163.2,'dmg/r', '2024-06-09'),

-- ══════════════════════════════════════════════════════════════════════
--  VALORANT — VALORANT CHAMPIONS 2024  (tournament_id = 10)
--  EDward Gaming win 3-2 Team Heretics in Grand Final
--  ZmjjKK named MVP
-- ══════════════════════════════════════════════════════════════════════

-- ─── EDward Gaming players (champions) ────────────────────────────────
-- ZmjjKK (37) — acs already stat_id 1; add remaining stats
(121, 'player',37,'tournament',10,'public','vlr.gg',0.97,'kd',       1.31,'ratio', '2024-08-25'),
(122, 'player',37,'tournament',10,'public','vlr.gg',0.97,'kast',      72.4,'%',     '2024-08-25'),
(123, 'player',37,'tournament',10,'public','vlr.gg',0.97,'adr',           162.4,'dmg/r', '2024-08-25'),
(124, 'player',37,'tournament',10,'public','vlr.gg',0.97,'HS_Pct',         27.2,'%',     '2024-08-25'),
(125, 'player',37,'tournament',10,'public','vlr.gg',0.97,'FK_Per_Round',    0.20,'rate',  '2024-08-25'),
(126, 'player',37,'tournament',10,'public','vlr.gg',0.97,'Kills',         242.0,'kills', '2024-08-25'),
(127, 'player',37,'tournament',10,'public','vlr.gg',0.97,'Deaths',        185.0,'deaths','2024-08-25'),
(128, 'player',37,'tournament',10,'public','vlr.gg',0.97,'Assists',        68.0,'assists','2024-08-25'),
(129, 'player',37,'tournament',10,'public','vlr.gg',0.97,'Maps_Played',    16.0,'maps',  '2024-08-25'),
-- nobody (36)
(130, 'player',36,'tournament',10,'public','vlr.gg',0.94,'acs',           198.4,'points','2024-08-25'),
(131, 'player',36,'tournament',10,'public','vlr.gg',0.94,'kd',        1.00,'ratio', '2024-08-25'),
(132, 'player',36,'tournament',10,'public','vlr.gg',0.94,'kast',      70.2,'%',     '2024-08-25'),
(133, 'player',36,'tournament',10,'public','vlr.gg',0.94,'adr',           127.6,'dmg/r', '2024-08-25'),
(134, 'player',36,'tournament',10,'public','vlr.gg',0.94,'HS_Pct',         22.4,'%',     '2024-08-25'),
-- Haodong (38)
(135, 'player',38,'tournament',10,'public','vlr.gg',0.93,'acs',           188.8,'points','2024-08-25'),
(136, 'player',38,'tournament',10,'public','vlr.gg',0.93,'kd',        0.95,'ratio', '2024-08-25'),
(137, 'player',38,'tournament',10,'public','vlr.gg',0.93,'kast',      69.8,'%',     '2024-08-25'),
(138, 'player',38,'tournament',10,'public','vlr.gg',0.93,'adr',           121.4,'dmg/r', '2024-08-25'),
-- Smoggy (39)
(139, 'player',39,'tournament',10,'public','vlr.gg',0.93,'acs',           212.6,'points','2024-08-25'),
(140, 'player',39,'tournament',10,'public','vlr.gg',0.93,'kd',        1.06,'ratio', '2024-08-25'),
(141, 'player',39,'tournament',10,'public','vlr.gg',0.93,'kast',      71.4,'%',     '2024-08-25'),
(142, 'player',39,'tournament',10,'public','vlr.gg',0.93,'adr',           135.8,'dmg/r', '2024-08-25'),
-- CHICHOO (40)
(143, 'player',40,'tournament',10,'public','vlr.gg',0.92,'acs',           174.2,'points','2024-08-25'),
(144, 'player',40,'tournament',10,'public','vlr.gg',0.92,'kd',        0.88,'ratio', '2024-08-25'),
(145, 'player',40,'tournament',10,'public','vlr.gg',0.92,'kast',      68.4,'%',     '2024-08-25'),
(146, 'player',40,'tournament',10,'public','vlr.gg',0.92,'adr',           111.6,'dmg/r', '2024-08-25'),

-- ─── Team Heretics players (runner-up) ─────────────────────────────────
-- paTiTek (41)
(147, 'player',41,'tournament',10,'public','vlr.gg',0.96,'acs',           258.2,'points','2024-08-25'),
(148, 'player',41,'tournament',10,'public','vlr.gg',0.96,'kd',        1.26,'ratio', '2024-08-25'),
(149, 'player',41,'tournament',10,'public','vlr.gg',0.96,'kast',      74.0,'%',     '2024-08-25'),
(150, 'player',41,'tournament',10,'public','vlr.gg',0.96,'adr',           156.4,'dmg/r', '2024-08-25'),
(151, 'player',41,'tournament',10,'public','vlr.gg',0.96,'HS_Pct',         24.2,'%',     '2024-08-25'),
(152, 'player',41,'tournament',10,'public','vlr.gg',0.96,'FK_Per_Round',    0.19,'rate',  '2024-08-25'),
(153, 'player',41,'tournament',10,'public','vlr.gg',0.96,'Kills',         228.0,'kills', '2024-08-25'),
(154, 'player',41,'tournament',10,'public','vlr.gg',0.96,'Deaths',        181.0,'deaths','2024-08-25'),
-- Boo (42)
(155, 'player',42,'tournament',10,'public','vlr.gg',0.95,'acs',           235.8,'points','2024-08-25'),
(156, 'player',42,'tournament',10,'public','vlr.gg',0.95,'kd',        1.16,'ratio', '2024-08-25'),
(157, 'player',42,'tournament',10,'public','vlr.gg',0.95,'kast',      72.4,'%',     '2024-08-25'),
(158, 'player',42,'tournament',10,'public','vlr.gg',0.95,'adr',           149.2,'dmg/r', '2024-08-25'),
-- benjyfishy (45)
(159, 'player',45,'tournament',10,'public','vlr.gg',0.94,'acs',           222.4,'points','2024-08-25'),
(160, 'player',45,'tournament',10,'public','vlr.gg',0.94,'kd',        1.10,'ratio', '2024-08-25'),
(161, 'player',45,'tournament',10,'public','vlr.gg',0.94,'kast',      71.6,'%',     '2024-08-25'),
(162, 'player',45,'tournament',10,'public','vlr.gg',0.94,'adr',           141.4,'dmg/r', '2024-08-25'),

-- ─── LEVIATAN players (3rd place) ──────────────────────────────────────
-- aspas (18)
(163, 'player',18,'tournament',10,'public','vlr.gg',0.95,'acs',           272.4,'points','2024-08-25'),
(164, 'player',18,'tournament',10,'public','vlr.gg',0.95,'kd',        1.29,'ratio', '2024-08-25'),
(165, 'player',18,'tournament',10,'public','vlr.gg',0.95,'kast',      74.4,'%',     '2024-08-25'),
(166, 'player',18,'tournament',10,'public','vlr.gg',0.95,'adr',           168.6,'dmg/r', '2024-08-25'),
(167, 'player',18,'tournament',10,'public','vlr.gg',0.95,'HS_Pct',         31.8,'%',     '2024-08-25'),
(168, 'player',18,'tournament',10,'public','vlr.gg',0.95,'FK_Per_Round',    0.22,'rate',  '2024-08-25'),
-- kiNgg (16)
(169, 'player',16,'tournament',10,'public','vlr.gg',0.93,'acs',           202.8,'points','2024-08-25'),
(170, 'player',16,'tournament',10,'public','vlr.gg',0.93,'kd',        1.02,'ratio', '2024-08-25'),
(171, 'player',16,'tournament',10,'public','vlr.gg',0.93,'kast',      72.4,'%',     '2024-08-25'),
(172, 'player',16,'tournament',10,'public','vlr.gg',0.93,'adr',           131.4,'dmg/r', '2024-08-25'),
-- Mazino (17)
(173, 'player',17,'tournament',10,'public','vlr.gg',0.92,'acs',           186.4,'points','2024-08-25'),
(174, 'player',17,'tournament',10,'public','vlr.gg',0.92,'kd',        0.94,'ratio', '2024-08-25'),
(175, 'player',17,'tournament',10,'public','vlr.gg',0.92,'kast',      70.8,'%',     '2024-08-25'),
(176, 'player',17,'tournament',10,'public','vlr.gg',0.92,'adr',           119.8,'dmg/r', '2024-08-25'),

-- ─── Sentinels players (4th place) ─────────────────────────────────────
-- Zekken (1)
(177, 'player', 1,'tournament',10,'public','vlr.gg',0.94,'acs',           262.4,'points','2024-08-25'),
(178, 'player', 1,'tournament',10,'public','vlr.gg',0.94,'kd',        1.25,'ratio', '2024-08-25'),
(179, 'player', 1,'tournament',10,'public','vlr.gg',0.94,'kast',      73.8,'%',     '2024-08-25'),
(180, 'player', 1,'tournament',10,'public','vlr.gg',0.94,'adr',           160.4,'dmg/r', '2024-08-25'),
(181, 'player', 1,'tournament',10,'public','vlr.gg',0.94,'HS_Pct',         28.6,'%',     '2024-08-25'),
-- Sacy (4)
(182, 'player', 4,'tournament',10,'public','vlr.gg',0.93,'acs',           216.4,'points','2024-08-25'),
(183, 'player', 4,'tournament',10,'public','vlr.gg',0.93,'kd',        1.08,'ratio', '2024-08-25'),
(184, 'player', 4,'tournament',10,'public','vlr.gg',0.93,'kast',      71.4,'%',     '2024-08-25'),
(185, 'player', 4,'tournament',10,'public','vlr.gg',0.93,'adr',           138.2,'dmg/r', '2024-08-25'),

-- ─── DRX players (5th-6th) ─────────────────────────────────────────────
-- stax (26)
(186, 'player',26,'tournament',10,'public','vlr.gg',0.91,'acs',           195.8,'points','2024-08-25'),
(187, 'player',26,'tournament',10,'public','vlr.gg',0.91,'kd',        0.98,'ratio', '2024-08-25'),
(188, 'player',26,'tournament',10,'public','vlr.gg',0.91,'kast',      71.0,'%',     '2024-08-25'),
(189, 'player',26,'tournament',10,'public','vlr.gg',0.91,'adr',           126.2,'dmg/r', '2024-08-25'),
-- BuZz (28)
(190, 'player',28,'tournament',10,'public','vlr.gg',0.91,'acs',           225.4,'points','2024-08-25'),
(191, 'player',28,'tournament',10,'public','vlr.gg',0.91,'kd',        1.12,'ratio', '2024-08-25'),
(192, 'player',28,'tournament',10,'public','vlr.gg',0.91,'kast',      70.6,'%',     '2024-08-25'),
(193, 'player',28,'tournament',10,'public','vlr.gg',0.91,'adr',           142.8,'dmg/r', '2024-08-25'),

-- ══════════════════════════════════════════════════════════════════════
--  CS2 — IEM KATOWICE 2024  (tournament_id = 16)
--  Team Spirit win; donk MVP
-- ══════════════════════════════════════════════════════════════════════

-- ─── Team Spirit players (champions) ───────────────────────────────────
-- donk (113) — rating already stat_id 3
(194, 'player',113,'tournament',16,'public','hltv.org',0.97,'kast',        74.2,'%',      '2024-02-18'),
(195, 'player',113,'tournament',16,'public','hltv.org',0.97,'adr',              88.4,'dmg/r',  '2024-02-18'),
(196, 'player',113,'tournament',16,'public','hltv.org',0.97,'HS_Pct',           51.8,'%',      '2024-02-18'),
(197, 'player',113,'tournament',16,'public','hltv.org',0.97,'Kills_Per_Round',   0.89,'kpr',   '2024-02-18'),
(198, 'player',113,'tournament',16,'public','hltv.org',0.97,'Deaths_Per_Round',  0.63,'dpr',   '2024-02-18'),
(199, 'player',113,'tournament',16,'public','hltv.org',0.97,'Opening_Win_Pct',  58.4,'%',      '2024-02-18'),
(200, 'player',113,'tournament',16,'public','hltv.org',0.97,'Impact_Rating',     1.82,'rating','2024-02-18'),
-- magixx (114)
(201, 'player',114,'tournament',16,'public','hltv.org',0.95,'rating',        1.18,'rating','2024-02-18'),
(202, 'player',114,'tournament',16,'public','hltv.org',0.95,'kast',         72.4,'%',      '2024-02-18'),
(203, 'player',114,'tournament',16,'public','hltv.org',0.95,'adr',              78.4,'dmg/r',  '2024-02-18'),
(204, 'player',114,'tournament',16,'public','hltv.org',0.95,'HS_Pct',           48.2,'%',      '2024-02-18'),
(205, 'player',114,'tournament',16,'public','hltv.org',0.95,'Kills_Per_Round',   0.79,'kpr',   '2024-02-18'),
-- sh1ro (115)
(206, 'player',115,'tournament',16,'public','hltv.org',0.95,'rating',        1.22,'rating','2024-02-18'),
(207, 'player',115,'tournament',16,'public','hltv.org',0.95,'kast',         73.4,'%',      '2024-02-18'),
(208, 'player',115,'tournament',16,'public','hltv.org',0.95,'adr',              80.2,'dmg/r',  '2024-02-18'),
(209, 'player',115,'tournament',16,'public','hltv.org',0.95,'HS_Pct',           44.6,'%',      '2024-02-18'),
(210, 'player',115,'tournament',16,'public','hltv.org',0.95,'Kills_Per_Round',   0.81,'kpr',   '2024-02-18'),
-- chopper (116)
(211, 'player',116,'tournament',16,'public','hltv.org',0.93,'rating',        0.95,'rating','2024-02-18'),
(212, 'player',116,'tournament',16,'public','hltv.org',0.93,'kast',         74.6,'%',      '2024-02-18'),
(213, 'player',116,'tournament',16,'public','hltv.org',0.93,'adr',              68.4,'dmg/r',  '2024-02-18'),
(214, 'player',116,'tournament',16,'public','hltv.org',0.93,'HS_Pct',           38.4,'%',      '2024-02-18'),

-- ─── FaZe Clan players (runner-up) ─────────────────────────────────────
-- karrigan (108)
(215, 'player',108,'tournament',16,'public','hltv.org',0.93,'rating',        0.92,'rating','2024-02-18'),
(216, 'player',108,'tournament',16,'public','hltv.org',0.93,'kast',         72.4,'%',      '2024-02-18'),
(217, 'player',108,'tournament',16,'public','hltv.org',0.93,'adr',              62.8,'dmg/r',  '2024-02-18'),
(218, 'player',108,'tournament',16,'public','hltv.org',0.93,'Opening_Win_Pct',  54.8,'%',      '2024-02-18'),
-- NiKo (109)
(219, 'player',109,'tournament',16,'public','hltv.org',0.94,'rating',        1.15,'rating','2024-02-18'),
(220, 'player',109,'tournament',16,'public','hltv.org',0.94,'kast',         71.4,'%',      '2024-02-18'),
(221, 'player',109,'tournament',16,'public','hltv.org',0.94,'adr',              76.4,'dmg/r',  '2024-02-18'),
(222, 'player',109,'tournament',16,'public','hltv.org',0.94,'HS_Pct',           46.2,'%',      '2024-02-18'),

-- ─── Team Vitality players ─────────────────────────────────────────────
-- ZywOo (123)
(223, 'player',123,'tournament',16,'public','hltv.org',0.94,'rating',        1.20,'rating','2024-02-18'),
(224, 'player',123,'tournament',16,'public','hltv.org',0.94,'kast',         73.2,'%',      '2024-02-18'),
(225, 'player',123,'tournament',16,'public','hltv.org',0.94,'adr',              82.4,'dmg/r',  '2024-02-18'),
(226, 'player',123,'tournament',16,'public','hltv.org',0.94,'HS_Pct',           48.4,'%',      '2024-02-18'),

-- ══════════════════════════════════════════════════════════════════════
--  CS2 — PGL MAJOR COPENHAGEN 2024  (tournament_id = 17)
--  Natus Vincere win 2-1 FaZe Clan; jL named MVP
-- ══════════════════════════════════════════════════════════════════════

-- ─── Natus Vincere players (champions) ─────────────────────────────────
-- jL (103) — rating already stat_id 4
(227, 'player',103,'tournament',17,'public','hltv.org',0.97,'kast',         75.4,'%',      '2024-03-31'),
(228, 'player',103,'tournament',17,'public','hltv.org',0.97,'adr',              82.4,'dmg/r',  '2024-03-31'),
(229, 'player',103,'tournament',17,'public','hltv.org',0.97,'HS_Pct',           45.2,'%',      '2024-03-31'),
(230, 'player',103,'tournament',17,'public','hltv.org',0.97,'Kills_Per_Round',   0.83,'kpr',   '2024-03-31'),
(231, 'player',103,'tournament',17,'public','hltv.org',0.97,'Deaths_Per_Round',  0.62,'dpr',   '2024-03-31'),
(232, 'player',103,'tournament',17,'public','hltv.org',0.97,'Opening_Win_Pct',  60.2,'%',      '2024-03-31'),
(233, 'player',103,'tournament',17,'public','hltv.org',0.97,'Clutch_Pct',        42.4,'%',     '2024-03-31'),
(234, 'player',103,'tournament',17,'public','hltv.org',0.97,'Impact_Rating',     1.74,'rating','2024-03-31'),
-- b1t (106)
(235, 'player',106,'tournament',17,'public','hltv.org',0.95,'rating',        1.15,'rating','2024-03-31'),
(236, 'player',106,'tournament',17,'public','hltv.org',0.95,'kast',         74.2,'%',      '2024-03-31'),
(237, 'player',106,'tournament',17,'public','hltv.org',0.95,'adr',              76.4,'dmg/r',  '2024-03-31'),
(238, 'player',106,'tournament',17,'public','hltv.org',0.95,'HS_Pct',           50.4,'%',      '2024-03-31'),
(239, 'player',106,'tournament',17,'public','hltv.org',0.95,'Kills_Per_Round',   0.79,'kpr',   '2024-03-31'),
(240, 'player',106,'tournament',17,'public','hltv.org',0.95,'Deaths_Per_Round',  0.64,'dpr',   '2024-03-31'),
-- w0nderful (107)
(241, 'player',107,'tournament',17,'public','hltv.org',0.94,'rating',        1.10,'rating','2024-03-31'),
(242, 'player',107,'tournament',17,'public','hltv.org',0.94,'kast',         72.4,'%',      '2024-03-31'),
(243, 'player',107,'tournament',17,'public','hltv.org',0.94,'adr',              72.8,'dmg/r',  '2024-03-31'),
(244, 'player',107,'tournament',17,'public','hltv.org',0.94,'HS_Pct',           38.4,'%',      '2024-03-31'),
(245, 'player',107,'tournament',17,'public','hltv.org',0.94,'Kills_Per_Round',   0.74,'kpr',   '2024-03-31'),
-- iM (105)
(246, 'player',105,'tournament',17,'public','hltv.org',0.94,'rating',        1.08,'rating','2024-03-31'),
(247, 'player',105,'tournament',17,'public','hltv.org',0.94,'kast',         71.4,'%',      '2024-03-31'),
(248, 'player',105,'tournament',17,'public','hltv.org',0.94,'adr',              70.4,'dmg/r',  '2024-03-31'),
(249, 'player',105,'tournament',17,'public','hltv.org',0.94,'HS_Pct',           52.4,'%',      '2024-03-31'),
-- Aleksib (104)
(250, 'player',104,'tournament',17,'public','hltv.org',0.93,'rating',        0.88,'rating','2024-03-31'),
(251, 'player',104,'tournament',17,'public','hltv.org',0.93,'kast',         73.4,'%',      '2024-03-31'),
(252, 'player',104,'tournament',17,'public','hltv.org',0.93,'adr',              58.4,'dmg/r',  '2024-03-31'),
(253, 'player',104,'tournament',17,'public','hltv.org',0.93,'Kills_Per_Round',   0.60,'kpr',   '2024-03-31'),

-- ─── FaZe Clan players (runner-up) ─────────────────────────────────────
-- karrigan (108)
(254, 'player',108,'tournament',17,'public','hltv.org',0.94,'rating',        0.94,'rating','2024-03-31'),
(255, 'player',108,'tournament',17,'public','hltv.org',0.94,'kast',         72.2,'%',      '2024-03-31'),
(256, 'player',108,'tournament',17,'public','hltv.org',0.94,'adr',              63.4,'dmg/r',  '2024-03-31'),
(257, 'player',108,'tournament',17,'public','hltv.org',0.94,'Opening_Win_Pct',  52.4,'%',      '2024-03-31'),
-- m0NESY (110)
(258, 'player',110,'tournament',17,'public','hltv.org',0.95,'rating',        1.12,'rating','2024-03-31'),
(259, 'player',110,'tournament',17,'public','hltv.org',0.95,'kast',         71.4,'%',      '2024-03-31'),
(260, 'player',110,'tournament',17,'public','hltv.org',0.95,'adr',              75.4,'dmg/r',  '2024-03-31'),
(261, 'player',110,'tournament',17,'public','hltv.org',0.95,'HS_Pct',           35.2,'%',      '2024-03-31'),
-- ropz (111)
(262, 'player',111,'tournament',17,'public','hltv.org',0.94,'rating',        1.10,'rating','2024-03-31'),
(263, 'player',111,'tournament',17,'public','hltv.org',0.94,'kast',         73.2,'%',      '2024-03-31'),
(264, 'player',111,'tournament',17,'public','hltv.org',0.94,'adr',              72.4,'dmg/r',  '2024-03-31'),
(265, 'player',111,'tournament',17,'public','hltv.org',0.94,'HS_Pct',           48.4,'%',      '2024-03-31'),
-- rain (112)
(266, 'player',112,'tournament',17,'public','hltv.org',0.94,'rating',        1.08,'rating','2024-03-31'),
(267, 'player',112,'tournament',17,'public','hltv.org',0.94,'kast',         72.4,'%',      '2024-03-31'),
(268, 'player',112,'tournament',17,'public','hltv.org',0.94,'adr',              70.4,'dmg/r',  '2024-03-31'),

-- ─── MOUZ players (3rd–4th) ────────────────────────────────────────────
-- frozen (118)
(269, 'player',118,'tournament',17,'public','hltv.org',0.94,'rating',        1.18,'rating','2024-03-31'),
(270, 'player',118,'tournament',17,'public','hltv.org',0.94,'kast',         72.4,'%',      '2024-03-31'),
(271, 'player',118,'tournament',17,'public','hltv.org',0.94,'adr',              79.4,'dmg/r',  '2024-03-31'),
(272, 'player',118,'tournament',17,'public','hltv.org',0.94,'HS_Pct',           46.4,'%',      '2024-03-31'),
-- siuhy (119)
(273, 'player',119,'tournament',17,'public','hltv.org',0.93,'rating',        1.05,'rating','2024-03-31'),
(274, 'player',119,'tournament',17,'public','hltv.org',0.93,'kast',         70.4,'%',      '2024-03-31'),
(275, 'player',119,'tournament',17,'public','hltv.org',0.93,'adr',              68.4,'dmg/r',  '2024-03-31'),
-- jimpphat (120)
(276, 'player',120,'tournament',17,'public','hltv.org',0.93,'rating',        1.08,'rating','2024-03-31'),
(277, 'player',120,'tournament',17,'public','hltv.org',0.93,'kast',         70.8,'%',      '2024-03-31'),
(278, 'player',120,'tournament',17,'public','hltv.org',0.93,'adr',              70.4,'dmg/r',  '2024-03-31'),

-- ── HEROIC players (3rd–4th) ───────────────────────────────────────────
-- cadiaN (138)
(279, 'player',138,'tournament',17,'public','hltv.org',0.92,'rating',        1.02,'rating','2024-03-31'),
(280, 'player',138,'tournament',17,'public','hltv.org',0.92,'kast',         71.4,'%',      '2024-03-31'),
(281, 'player',138,'tournament',17,'public','hltv.org',0.92,'adr',              66.4,'dmg/r',  '2024-03-31'),
-- stavn (139)
(282, 'player',139,'tournament',17,'public','hltv.org',0.93,'rating',        1.12,'rating','2024-03-31'),
(283, 'player',139,'tournament',17,'public','hltv.org',0.93,'kast',         72.2,'%',      '2024-03-31'),
(284, 'player',139,'tournament',17,'public','hltv.org',0.93,'adr',              73.4,'dmg/r',  '2024-03-31'),
(285, 'player',139,'tournament',17,'public','hltv.org',0.93,'HS_Pct',           46.4,'%',      '2024-03-31'),

-- ══════════════════════════════════════════════════════════════════════
--  CS2 — ESL PRO LEAGUE SEASON 20  (tournament_id = 19)
--  Natus Vincere win 3-2 Team Spirit in Grand Final
-- ══════════════════════════════════════════════════════════════════════
-- jL (103)
(286, 'player',103,'tournament',19,'public','hltv.org',0.94,'rating',        1.20,'rating','2024-09-29'),
(287, 'player',103,'tournament',19,'public','hltv.org',0.94,'kast',         73.4,'%',      '2024-09-29'),
(288, 'player',103,'tournament',19,'public','hltv.org',0.94,'adr',              78.4,'dmg/r',  '2024-09-29'),
(289, 'player',103,'tournament',19,'public','hltv.org',0.94,'HS_Pct',           43.4,'%',      '2024-09-29'),
(290, 'player',103,'tournament',19,'public','hltv.org',0.94,'Kills_Per_Round',   0.79,'kpr',   '2024-09-29'),
-- b1t (106)
(291, 'player',106,'tournament',19,'public','hltv.org',0.93,'rating',        1.12,'rating','2024-09-29'),
(292, 'player',106,'tournament',19,'public','hltv.org',0.93,'kast',         72.2,'%',      '2024-09-29'),
(293, 'player',106,'tournament',19,'public','hltv.org',0.93,'adr',              74.4,'dmg/r',  '2024-09-29'),
-- donk (113)
(294, 'player',113,'tournament',19,'public','hltv.org',0.95,'rating',        1.25,'rating','2024-09-29'),
(295, 'player',113,'tournament',19,'public','hltv.org',0.95,'kast',         74.4,'%',      '2024-09-29'),
(296, 'player',113,'tournament',19,'public','hltv.org',0.95,'adr',              82.4,'dmg/r',  '2024-09-29'),
(297, 'player',113,'tournament',19,'public','hltv.org',0.95,'HS_Pct',           50.4,'%',      '2024-09-29'),
-- ZywOo (123)
(298, 'player',123,'tournament',19,'public','hltv.org',0.93,'rating',        1.18,'rating','2024-09-29'),
(299, 'player',123,'tournament',19,'public','hltv.org',0.93,'kast',         72.4,'%',      '2024-09-29'),
(300, 'player',123,'tournament',19,'public','hltv.org',0.93,'adr',              79.4,'dmg/r',  '2024-09-29'),
-- NiKo (109)
(301, 'player',109,'tournament',19,'public','hltv.org',0.93,'rating',        1.08,'rating','2024-09-29'),
(302, 'player',109,'tournament',19,'public','hltv.org',0.93,'kast',         70.4,'%',      '2024-09-29'),
(303, 'player',109,'tournament',19,'public','hltv.org',0.93,'adr',              72.4,'dmg/r',  '2024-09-29'),

-- ══════════════════════════════════════════════════════════════════════
--  CS2 — PERFECT WORLD SHANGHAI MAJOR 2024  (tournament_id = 20)
--  Team Spirit win 2-1 FaZe Clan; donk named MVP
-- ══════════════════════════════════════════════════════════════════════

-- ─── Team Spirit players (champions) ───────────────────────────────────
-- donk (113) — rating already stat_id 2
(304, 'player',113,'tournament',20,'public','hltv.org',0.97,'kast',         74.4,'%',      '2024-12-15'),
(305, 'player',113,'tournament',20,'public','hltv.org',0.97,'adr',              88.8,'dmg/r',  '2024-12-15'),
(306, 'player',113,'tournament',20,'public','hltv.org',0.97,'HS_Pct',           50.2,'%',      '2024-12-15'),
(307, 'player',113,'tournament',20,'public','hltv.org',0.97,'Kills_Per_Round',   0.92,'kpr',   '2024-12-15'),
(308, 'player',113,'tournament',20,'public','hltv.org',0.97,'Deaths_Per_Round',  0.62,'dpr',   '2024-12-15'),
(309, 'player',113,'tournament',20,'public','hltv.org',0.97,'Opening_Win_Pct',  62.4,'%',      '2024-12-15'),
(310, 'player',113,'tournament',20,'public','hltv.org',0.97,'Clutch_Pct',        48.4,'%',     '2024-12-15'),
(311, 'player',113,'tournament',20,'public','hltv.org',0.97,'Impact_Rating',     1.92,'rating','2024-12-15'),
-- magixx (114)
(312, 'player',114,'tournament',20,'public','hltv.org',0.95,'rating',        1.20,'rating','2024-12-15'),
(313, 'player',114,'tournament',20,'public','hltv.org',0.95,'kast',         72.4,'%',      '2024-12-15'),
(314, 'player',114,'tournament',20,'public','hltv.org',0.95,'adr',              78.4,'dmg/r',  '2024-12-15'),
(315, 'player',114,'tournament',20,'public','hltv.org',0.95,'HS_Pct',           46.4,'%',      '2024-12-15'),
(316, 'player',114,'tournament',20,'public','hltv.org',0.95,'Kills_Per_Round',   0.79,'kpr',   '2024-12-15'),
-- sh1ro (115)
(317, 'player',115,'tournament',20,'public','hltv.org',0.95,'rating',        1.18,'rating','2024-12-15'),
(318, 'player',115,'tournament',20,'public','hltv.org',0.95,'kast',         73.4,'%',      '2024-12-15'),
(319, 'player',115,'tournament',20,'public','hltv.org',0.95,'adr',              76.4,'dmg/r',  '2024-12-15'),
(320, 'player',115,'tournament',20,'public','hltv.org',0.95,'HS_Pct',           40.4,'%',      '2024-12-15'),
(321, 'player',115,'tournament',20,'public','hltv.org',0.95,'Kills_Per_Round',   0.76,'kpr',   '2024-12-15'),
-- chopper (116)
(322, 'player',116,'tournament',20,'public','hltv.org',0.93,'rating',        0.98,'rating','2024-12-15'),
(323, 'player',116,'tournament',20,'public','hltv.org',0.93,'kast',         74.4,'%',      '2024-12-15'),
(324, 'player',116,'tournament',20,'public','hltv.org',0.93,'adr',              70.4,'dmg/r',  '2024-12-15'),
(325, 'player',116,'tournament',20,'public','hltv.org',0.93,'Opening_Win_Pct',  48.4,'%',      '2024-12-15'),
-- zont1x (117)
(326, 'player',117,'tournament',20,'public','hltv.org',0.93,'rating',        1.05,'rating','2024-12-15'),
(327, 'player',117,'tournament',20,'public','hltv.org',0.93,'kast',         71.4,'%',      '2024-12-15'),
(328, 'player',117,'tournament',20,'public','hltv.org',0.93,'adr',              72.4,'dmg/r',  '2024-12-15'),
(329, 'player',117,'tournament',20,'public','hltv.org',0.93,'HS_Pct',           52.4,'%',      '2024-12-15'),

-- ─── FaZe Clan players (runner-up) ─────────────────────────────────────
-- karrigan (108)
(330, 'player',108,'tournament',20,'public','hltv.org',0.94,'rating',        0.96,'rating','2024-12-15'),
(331, 'player',108,'tournament',20,'public','hltv.org',0.94,'kast',         72.4,'%',      '2024-12-15'),
(332, 'player',108,'tournament',20,'public','hltv.org',0.94,'adr',              65.4,'dmg/r',  '2024-12-15'),
(333, 'player',108,'tournament',20,'public','hltv.org',0.94,'Opening_Win_Pct',  54.4,'%',      '2024-12-15'),
-- NiKo (109)
(334, 'player',109,'tournament',20,'public','hltv.org',0.95,'rating',        1.20,'rating','2024-12-15'),
(335, 'player',109,'tournament',20,'public','hltv.org',0.95,'kast',         72.4,'%',      '2024-12-15'),
(336, 'player',109,'tournament',20,'public','hltv.org',0.95,'adr',              78.4,'dmg/r',  '2024-12-15'),
(337, 'player',109,'tournament',20,'public','hltv.org',0.95,'HS_Pct',           44.4,'%',      '2024-12-15'),
-- m0NESY (110)
(338, 'player',110,'tournament',20,'public','hltv.org',0.95,'rating',        1.22,'rating','2024-12-15'),
(339, 'player',110,'tournament',20,'public','hltv.org',0.95,'kast',         72.4,'%',      '2024-12-15'),
(340, 'player',110,'tournament',20,'public','hltv.org',0.95,'adr',              80.4,'dmg/r',  '2024-12-15'),
(341, 'player',110,'tournament',20,'public','hltv.org',0.95,'HS_Pct',           36.4,'%',      '2024-12-15'),
-- ropz (111)
(342, 'player',111,'tournament',20,'public','hltv.org',0.94,'rating',        1.08,'rating','2024-12-15'),
(343, 'player',111,'tournament',20,'public','hltv.org',0.94,'kast',         72.4,'%',      '2024-12-15'),
(344, 'player',111,'tournament',20,'public','hltv.org',0.94,'adr',              70.4,'dmg/r',  '2024-12-15'),
-- rain (112)
(345, 'player',112,'tournament',20,'public','hltv.org',0.94,'rating',        1.05,'rating','2024-12-15'),
(346, 'player',112,'tournament',20,'public','hltv.org',0.94,'kast',         71.4,'%',      '2024-12-15'),
(347, 'player',112,'tournament',20,'public','hltv.org',0.94,'adr',              68.4,'dmg/r',  '2024-12-15'),

-- ─── Other top performers (5th-8th) ────────────────────────────────────
-- ZywOo (123) - Vitality
(348, 'player',123,'tournament',20,'public','hltv.org',0.93,'rating',        1.15,'rating','2024-12-15'),
(349, 'player',123,'tournament',20,'public','hltv.org',0.93,'kast',         71.4,'%',      '2024-12-15'),
(350, 'player',123,'tournament',20,'public','hltv.org',0.93,'adr',              76.4,'dmg/r',  '2024-12-15'),
-- cadiaN (138) - HEROIC
(351, 'player',138,'tournament',20,'public','hltv.org',0.92,'rating',        1.04,'rating','2024-12-15'),
(352, 'player',138,'tournament',20,'public','hltv.org',0.92,'kast',         71.4,'%',      '2024-12-15'),
(353, 'player',138,'tournament',20,'public','hltv.org',0.92,'adr',              67.4,'dmg/r',  '2024-12-15'),
-- NertZ (142) - HEROIC
(354, 'player',142,'tournament',20,'public','hltv.org',0.92,'rating',        1.10,'rating','2024-12-15'),
(355, 'player',142,'tournament',20,'public','hltv.org',0.92,'kast',         71.8,'%',      '2024-12-15'),
(356, 'player',142,'tournament',20,'public','hltv.org',0.92,'adr',              71.4,'dmg/r',  '2024-12-15'),
-- Senzu (128) - The MongolZ
(357, 'player',128,'tournament',20,'public','hltv.org',0.91,'rating',        1.06,'rating','2024-12-15'),
(358, 'player',128,'tournament',20,'public','hltv.org',0.91,'kast',         70.4,'%',      '2024-12-15'),
(359, 'player',128,'tournament',20,'public','hltv.org',0.91,'adr',              68.4,'dmg/r',  '2024-12-15'),

-- ══════════════════════════════════════════════════════════════════════
--  BGMI — BGIS 2024  (tournament_id = 12, Hyderabad LAN)
--  Team XSpark win; SPRAYGOD MVP; Sarang FMVP
-- ══════════════════════════════════════════════════════════════════════

-- ─── Team XSpark players (champions) ───────────────────────────────────
-- NinjaJOD (76)
(360, 'player',76,'tournament',12,'public','liquipedia.net',0.98,'Total_Points',       45.0,'pts',  '2024-06-30'),
(361, 'player',76,'tournament',12,'public','liquipedia.net',0.98,'Kill_Points',         28.0,'pts',  '2024-06-30'),
(362, 'player',76,'tournament',12,'public','liquipedia.net',0.98,'Placement_Points',    17.0,'pts',  '2024-06-30'),
(363, 'player',76,'tournament',12,'public','liquipedia.net',0.98,'Chicken_Dinners',      2.0,'wins', '2024-06-30'),
(364, 'player',76,'tournament',12,'public','liquipedia.net',0.98,'Avg_Damage_Per_Match',468.4,'dmg', '2024-06-30'),
(365, 'player',76,'tournament',12,'public','liquipedia.net',0.98,'Avg_Survival_Mins',   19.2,'mins', '2024-06-30'),
(366, 'player',76,'tournament',12,'public','liquipedia.net',0.98,'Total_Kills',          38.0,'kills','2024-06-30'),
-- SPRAYGOD (77) — MVP
(367, 'player',77,'tournament',12,'public','liquipedia.net',0.98,'Total_Points',        42.0,'pts',  '2024-06-30'),
(368, 'player',77,'tournament',12,'public','liquipedia.net',0.98,'Kill_Points',          30.0,'pts',  '2024-06-30'),
(369, 'player',77,'tournament',12,'public','liquipedia.net',0.98,'Placement_Points',     12.0,'pts',  '2024-06-30'),
(370, 'player',77,'tournament',12,'public','liquipedia.net',0.98,'Chicken_Dinners',       2.0,'wins', '2024-06-30'),
(371, 'player',77,'tournament',12,'public','liquipedia.net',0.98,'Avg_Damage_Per_Match', 510.2,'dmg', '2024-06-30'),
(372, 'player',77,'tournament',12,'public','liquipedia.net',0.98,'Total_Kills',           41.0,'kills','2024-06-30'),
(373, 'player',77,'tournament',12,'public','liquipedia.net',0.98,'Avg_Survival_Mins',    17.8,'mins', '2024-06-30'),
-- Sarang (78) — FMVP
(374, 'player',78,'tournament',12,'public','liquipedia.net',0.97,'Total_Points',         38.0,'pts',  '2024-06-30'),
(375, 'player',78,'tournament',12,'public','liquipedia.net',0.97,'Kill_Points',           25.0,'pts',  '2024-06-30'),
(376, 'player',78,'tournament',12,'public','liquipedia.net',0.97,'Avg_Damage_Per_Match', 422.8,'dmg', '2024-06-30'),
(377, 'player',78,'tournament',12,'public','liquipedia.net',0.97,'Avg_Survival_Mins',    18.6,'mins', '2024-06-30'),
(378, 'player',78,'tournament',12,'public','liquipedia.net',0.97,'Total_Kills',           34.0,'kills','2024-06-30'),
-- Shadow7 (79)
(379, 'player',79,'tournament',12,'public','liquipedia.net',0.96,'Total_Points',         35.0,'pts',  '2024-06-30'),
(380, 'player',79,'tournament',12,'public','liquipedia.net',0.96,'Kill_Points',           22.0,'pts',  '2024-06-30'),
(381, 'player',79,'tournament',12,'public','liquipedia.net',0.96,'Avg_Damage_Per_Match', 389.4,'dmg', '2024-06-30'),
(382, 'player',79,'tournament',12,'public','liquipedia.net',0.96,'Avg_Survival_Mins',    20.2,'mins', '2024-06-30'),
(383, 'player',79,'tournament',12,'public','liquipedia.net',0.96,'Total_Kills',           30.0,'kills','2024-06-30'),

-- ─── Global Esports players (2nd place) ────────────────────────────────
-- Beast (80)
(384, 'player',80,'tournament',12,'public','liquipedia.net',0.95,'Total_Points',         38.0,'pts',  '2024-06-30'),
(385, 'player',80,'tournament',12,'public','liquipedia.net',0.95,'Kill_Points',           24.0,'pts',  '2024-06-30'),
(386, 'player',80,'tournament',12,'public','liquipedia.net',0.95,'Avg_Damage_Per_Match', 402.6,'dmg', '2024-06-30'),
(387, 'player',80,'tournament',12,'public','liquipedia.net',0.95,'Avg_Survival_Mins',    18.8,'mins', '2024-06-30'),
(388, 'player',80,'tournament',12,'public','liquipedia.net',0.95,'Total_Kills',           33.0,'kills','2024-06-30'),
-- Mavi (81)
(389, 'player',81,'tournament',12,'public','liquipedia.net',0.95,'Total_Points',         32.0,'pts',  '2024-06-30'),
(390, 'player',81,'tournament',12,'public','liquipedia.net',0.95,'Kill_Points',           20.0,'pts',  '2024-06-30'),
(391, 'player',81,'tournament',12,'public','liquipedia.net',0.95,'Avg_Damage_Per_Match', 356.2,'dmg', '2024-06-30'),
(392, 'player',81,'tournament',12,'public','liquipedia.net',0.95,'Total_Kills',           28.0,'kills','2024-06-30'),

-- ─── Team SouL players (4th place) ─────────────────────────────────────
-- Jokerr (89)
(393, 'player',89,'tournament',12,'public','liquipedia.net',0.94,'Total_Points',         28.0,'pts',  '2024-06-30'),
(394, 'player',89,'tournament',12,'public','liquipedia.net',0.94,'Kill_Points',           18.0,'pts',  '2024-06-30'),
(395, 'player',89,'tournament',12,'public','liquipedia.net',0.94,'Avg_Damage_Per_Match', 342.4,'dmg', '2024-06-30'),
(396, 'player',89,'tournament',12,'public','liquipedia.net',0.94,'Avg_Survival_Mins',    16.8,'mins', '2024-06-30'),
-- NakuL (91)
(397, 'player',91,'tournament',12,'public','liquipedia.net',0.94,'Total_Points',         25.0,'pts',  '2024-06-30'),
(398, 'player',91,'tournament',12,'public','liquipedia.net',0.94,'Kill_Points',           15.0,'pts',  '2024-06-30'),
(399, 'player',91,'tournament',12,'public','liquipedia.net',0.94,'Avg_Damage_Per_Match', 314.8,'dmg', '2024-06-30'),
(400, 'player',91,'tournament',12,'public','liquipedia.net',0.94,'Total_Kills',           21.0,'kills','2024-06-30'),

-- ══════════════════════════════════════════════════════════════════════
--  BGMI — BGMI MASTERS SERIES SEASON 3  (tournament_id = 13, Delhi)
--  Team SouL win; Jokerr named MVP
-- ══════════════════════════════════════════════════════════════════════

-- ─── Team SouL players (champions) ─────────────────────────────────────
-- Jokerr (89) — MVP
(401, 'player',89,'tournament',13,'public','sportskeeda.com',0.96,'Total_Points',        58.0,'pts',  '2024-08-11'),
(402, 'player',89,'tournament',13,'public','sportskeeda.com',0.96,'Kill_Points',          38.0,'pts',  '2024-08-11'),
(403, 'player',89,'tournament',13,'public','sportskeeda.com',0.96,'Chicken_Dinners',       3.0,'wins', '2024-08-11'),
(404, 'player',89,'tournament',13,'public','sportskeeda.com',0.96,'Avg_Damage_Per_Match', 492.4,'dmg', '2024-08-11'),
(405, 'player',89,'tournament',13,'public','sportskeeda.com',0.96,'Avg_Survival_Mins',    20.4,'mins', '2024-08-11'),
(406, 'player',89,'tournament',13,'public','sportskeeda.com',0.96,'Total_Kills',           52.0,'kills','2024-08-11'),
-- NakuL (91)
(407, 'player',91,'tournament',13,'public','sportskeeda.com',0.95,'Total_Points',         55.0,'pts',  '2024-08-11'),
(408, 'player',91,'tournament',13,'public','sportskeeda.com',0.95,'Kill_Points',           35.0,'pts',  '2024-08-11'),
(409, 'player',91,'tournament',13,'public','sportskeeda.com',0.95,'Avg_Damage_Per_Match', 465.8,'dmg', '2024-08-11'),
(410, 'player',91,'tournament',13,'public','sportskeeda.com',0.95,'Total_Kills',           48.0,'kills','2024-08-11'),
(411, 'player',91,'tournament',13,'public','sportskeeda.com',0.95,'Avg_Survival_Mins',    19.6,'mins', '2024-08-11'),
-- Manya (90)
(412, 'player',90,'tournament',13,'public','sportskeeda.com',0.95,'Total_Points',         48.0,'pts',  '2024-08-11'),
(413, 'player',90,'tournament',13,'public','sportskeeda.com',0.95,'Kill_Points',           30.0,'pts',  '2024-08-11'),
(414, 'player',90,'tournament',13,'public','sportskeeda.com',0.95,'Avg_Damage_Per_Match', 424.2,'dmg', '2024-08-11'),
(415, 'player',90,'tournament',13,'public','sportskeeda.com',0.95,'Chicken_Dinners',       2.0,'wins', '2024-08-11'),

-- ─── GodLike Esports players (2nd place) ───────────────────────────────
-- Punk (94) — Best IGL Award
(416, 'player',94,'tournament',13,'public','sportskeeda.com',0.95,'Total_Points',         52.0,'pts',  '2024-08-11'),
(417, 'player',94,'tournament',13,'public','sportskeeda.com',0.95,'Kill_Points',           34.0,'pts',  '2024-08-11'),
(418, 'player',94,'tournament',13,'public','sportskeeda.com',0.95,'Chicken_Dinners',       2.0,'wins', '2024-08-11'),
(419, 'player',94,'tournament',13,'public','sportskeeda.com',0.95,'Avg_Damage_Per_Match', 478.6,'dmg', '2024-08-11'),
(420, 'player',94,'tournament',13,'public','sportskeeda.com',0.95,'Avg_Survival_Mins',    20.8,'mins', '2024-08-11'),
-- Neyoo (95)
(421, 'player',95,'tournament',13,'public','sportskeeda.com',0.94,'Total_Points',         49.0,'pts',  '2024-08-11'),
(422, 'player',95,'tournament',13,'public','sportskeeda.com',0.94,'Kill_Points',           32.0,'pts',  '2024-08-11'),
(423, 'player',95,'tournament',13,'public','sportskeeda.com',0.94,'Avg_Damage_Per_Match', 456.4,'dmg', '2024-08-11'),
(424, 'player',95,'tournament',13,'public','sportskeeda.com',0.94,'Total_Kills',           44.0,'kills','2024-08-11'),

-- ─── Numen Esports players (5th-6th) ───────────────────────────────────
-- Ash (99)
(425, 'player',99,'tournament',13,'public','sportskeeda.com',0.93,'Total_Points',         44.0,'pts',  '2024-08-11'),
(426, 'player',99,'tournament',13,'public','sportskeeda.com',0.93,'Kill_Points',           28.0,'pts',  '2024-08-11'),
(427, 'player',99,'tournament',13,'public','sportskeeda.com',0.93,'Avg_Damage_Per_Match', 411.8,'dmg', '2024-08-11'),
(428, 'player',99,'tournament',13,'public','sportskeeda.com',0.93,'Total_Kills',           38.0,'kills','2024-08-11'),

-- ══════════════════════════════════════════════════════════════════════
--  BGMI — BGMI PRO SERIES 2024  (tournament_id = 14, Kochi LAN)
--  Team XSpark win (158 pts); SPRAYGOD MVP; Sarang FMVP
-- ══════════════════════════════════════════════════════════════════════

-- ─── Team XSpark players (champions) ───────────────────────────────────
-- NinjaJOD (76)
(429, 'player',76,'tournament',14,'public','liquipedia.net',0.98,'Total_Points',          158.0,'pts',  '2024-09-29'),
(430, 'player',76,'tournament',14,'public','liquipedia.net',0.98,'Kill_Points',             98.0,'pts',  '2024-09-29'),
(431, 'player',76,'tournament',14,'public','liquipedia.net',0.98,'Placement_Points',        60.0,'pts',  '2024-09-29'),
(432, 'player',76,'tournament',14,'public','liquipedia.net',0.98,'Chicken_Dinners',          4.0,'wins', '2024-09-29'),
(433, 'player',76,'tournament',14,'public','liquipedia.net',0.98,'Avg_Damage_Per_Match',   502.8,'dmg', '2024-09-29'),
(434, 'player',76,'tournament',14,'public','liquipedia.net',0.98,'Avg_Survival_Mins',       20.8,'mins', '2024-09-29'),
(435, 'player',76,'tournament',14,'public','liquipedia.net',0.98,'Total_Kills',              68.0,'kills','2024-09-29'),
-- SPRAYGOD (77) — MVP
(436, 'player',77,'tournament',14,'public','liquipedia.net',0.98,'Avg_Damage_Per_Match',   528.4,'dmg', '2024-09-29'),
(437, 'player',77,'tournament',14,'public','liquipedia.net',0.98,'Total_Kills',              72.0,'kills','2024-09-29'),
(438, 'player',77,'tournament',14,'public','liquipedia.net',0.98,'Chicken_Dinners',          4.0,'wins', '2024-09-29'),
(439, 'player',77,'tournament',14,'public','liquipedia.net',0.98,'Kill_Points',             105.0,'pts', '2024-09-29'),
(440, 'player',77,'tournament',14,'public','liquipedia.net',0.98,'Avg_Survival_Mins',       18.4,'mins', '2024-09-29'),

-- ─── Numen Esports players (2nd place, 144 pts) ─────────────────────────
-- Ash (99)
(441, 'player',99,'tournament',14,'public','liquipedia.net',0.96,'Total_Points',           144.0,'pts',  '2024-09-29'),
(442, 'player',99,'tournament',14,'public','liquipedia.net',0.96,'Kill_Points',              85.0,'pts',  '2024-09-29'),
(443, 'player',99,'tournament',14,'public','liquipedia.net',0.96,'Chicken_Dinners',           3.0,'wins', '2024-09-29'),
(444, 'player',99,'tournament',14,'public','liquipedia.net',0.96,'Avg_Damage_Per_Match',    478.4,'dmg', '2024-09-29'),
(445, 'player',99,'tournament',14,'public','liquipedia.net',0.96,'Total_Kills',              58.0,'kills','2024-09-29'),
-- Owais (100)
(446, 'player',100,'tournament',14,'public','liquipedia.net',0.95,'Total_Points',          138.0,'pts',  '2024-09-29'),
(447, 'player',100,'tournament',14,'public','liquipedia.net',0.95,'Kill_Points',             78.0,'pts',  '2024-09-29'),
(448, 'player',100,'tournament',14,'public','liquipedia.net',0.95,'Avg_Damage_Per_Match',   450.8,'dmg', '2024-09-29'),
(449, 'player',100,'tournament',14,'public','liquipedia.net',0.95,'Total_Kills',             52.0,'kills','2024-09-29'),

-- ─── GodLike Esports players (3rd place, 144 pts) ──────────────────────
-- Punk (94) — Best IGL
(450, 'player',94,'tournament',14,'public','liquipedia.net',0.96,'Total_Points',           144.0,'pts',  '2024-09-29'),
(451, 'player',94,'tournament',14,'public','liquipedia.net',0.96,'Kill_Points',              90.0,'pts',  '2024-09-29'),
(452, 'player',94,'tournament',14,'public','liquipedia.net',0.96,'Chicken_Dinners',           2.0,'wins', '2024-09-29'),
(453, 'player',94,'tournament',14,'public','liquipedia.net',0.96,'Avg_Damage_Per_Match',    490.2,'dmg', '2024-09-29'),
(454, 'player',94,'tournament',14,'public','liquipedia.net',0.96,'Avg_Survival_Mins',        21.4,'mins', '2024-09-29'),
-- Neyoo (95)
(455, 'player',95,'tournament',14,'public','liquipedia.net',0.95,'Total_Points',           130.0,'pts',  '2024-09-29'),
(456, 'player',95,'tournament',14,'public','liquipedia.net',0.95,'Kill_Points',              80.0,'pts',  '2024-09-29'),
(457, 'player',95,'tournament',14,'public','liquipedia.net',0.95,'Avg_Damage_Per_Match',    462.4,'dmg', '2024-09-29'),

-- ── GravityJOD (84) — Reckoning Esports (5th) ─────────────────────────
(458, 'player',84,'tournament',14,'public','liquipedia.net',0.93,'Total_Points',           112.0,'pts',  '2024-09-29'),
(459, 'player',84,'tournament',14,'public','liquipedia.net',0.93,'Kill_Points',              68.0,'pts',  '2024-09-29'),
(460, 'player',84,'tournament',14,'public','liquipedia.net',0.93,'Avg_Damage_Per_Match',    388.4,'dmg', '2024-09-29'),

-- ══════════════════════════════════════════════════════════════════════
--  TEAM-LEVEL STATISTICS
-- ══════════════════════════════════════════════════════════════════════

-- ─── VALORANT TEAM STATS ───────────────────────────────────────────────

-- EDward Gaming (team 8) at Champions 2024 (t10)
(461, 'team', 8,'tournament',10,'public','vlr.gg',0.96,'Win_Rate',         80.0,'%',    '2024-08-25'),
(462, 'team', 8,'tournament',10,'public','vlr.gg',0.96,'Maps_Won',          12.0,'maps','2024-08-25'),
(463, 'team', 8,'tournament',10,'public','vlr.gg',0.96,'Maps_Lost',          3.0,'maps','2024-08-25'),
(464, 'team', 8,'tournament',10,'public','vlr.gg',0.96,'Maps_Played',        15.0,'maps','2024-08-25'),
(465, 'team', 8,'tournament',10,'public','vlr.gg',0.96,'Rounds_Won_Pct',   55.2,'%',    '2024-08-25'),
(466, 'team', 8,'tournament',10,'public','vlr.gg',0.96,'Team_acs_Avg',     210.6,'pts', '2024-08-25'),
(467, 'team', 8,'tournament',10,'public','vlr.gg',0.96,'Team_KD_Avg',        1.14,'ratio','2024-08-25'),

-- Team Heretics (team 9) at Champions 2024 (t10)
(468, 'team', 9,'tournament',10,'public','vlr.gg',0.95,'Win_Rate',         73.3,'%',    '2024-08-25'),
(469, 'team', 9,'tournament',10,'public','vlr.gg',0.95,'Maps_Won',          11.0,'maps','2024-08-25'),
(470, 'team', 9,'tournament',10,'public','vlr.gg',0.95,'Maps_Lost',          4.0,'maps','2024-08-25'),
(471, 'team', 9,'tournament',10,'public','vlr.gg',0.95,'Maps_Played',        15.0,'maps','2024-08-25'),
(472, 'team', 9,'tournament',10,'public','vlr.gg',0.95,'Rounds_Won_Pct',   53.8,'%',    '2024-08-25'),

-- LEVIATAN (team 4) at Champions 2024 (t10)
(473, 'team', 4,'tournament',10,'public','vlr.gg',0.93,'Win_Rate',         60.0,'%',    '2024-08-25'),
(474, 'team', 4,'tournament',10,'public','vlr.gg',0.93,'Maps_Won',           9.0,'maps','2024-08-25'),
(475, 'team', 4,'tournament',10,'public','vlr.gg',0.93,'Maps_Lost',          6.0,'maps','2024-08-25'),
(476, 'team', 4,'tournament',10,'public','vlr.gg',0.93,'Maps_Played',        15.0,'maps','2024-08-25'),

-- Sentinels (team 1) at Champions 2024 (t10)
(477, 'team', 1,'tournament',10,'public','vlr.gg',0.93,'Win_Rate',         56.3,'%',    '2024-08-25'),
(478, 'team', 1,'tournament',10,'public','vlr.gg',0.93,'Maps_Won',           9.0,'maps','2024-08-25'),
(479, 'team', 1,'tournament',10,'public','vlr.gg',0.93,'Maps_Lost',          7.0,'maps','2024-08-25'),
(480, 'team', 1,'tournament',10,'public','vlr.gg',0.93,'Maps_Played',        16.0,'maps','2024-08-25'),

-- Gen.G (team 7) at Masters Shanghai (t9) — stat_id 5 already has Win_Rate
(481, 'team', 7,'tournament', 9,'public','vlr.gg',0.95,'Maps_Won',          10.0,'maps','2024-06-09'),
(482, 'team', 7,'tournament', 9,'public','vlr.gg',0.95,'Maps_Lost',           2.0,'maps','2024-06-09'),
(483, 'team', 7,'tournament', 9,'public','vlr.gg',0.95,'Maps_Played',         12.0,'maps','2024-06-09'),
(484, 'team', 7,'tournament', 9,'public','vlr.gg',0.95,'Rounds_Won_Pct',    56.4,'%',    '2024-06-09'),
(485, 'team', 7,'tournament', 9,'public','vlr.gg',0.95,'Team_acs_Avg',      212.8,'pts', '2024-06-09'),

-- Team Heretics (team 9) at Masters Shanghai (t9)
(486, 'team', 9,'tournament', 9,'public','vlr.gg',0.94,'Win_Rate',          75.0,'%',    '2024-06-09'),
(487, 'team', 9,'tournament', 9,'public','vlr.gg',0.94,'Maps_Won',            9.0,'maps','2024-06-09'),
(488, 'team', 9,'tournament', 9,'public','vlr.gg',0.94,'Maps_Lost',           3.0,'maps','2024-06-09'),
(489, 'team', 9,'tournament', 9,'public','vlr.gg',0.94,'Maps_Played',         12.0,'maps','2024-06-09'),

-- Team Heretics (team 9) at Masters Madrid (t5) — winners
(490, 'team', 9,'tournament', 5,'public','vlr.gg',0.95,'Win_Rate',          78.6,'%',    '2024-03-31'),
(491, 'team', 9,'tournament', 5,'public','vlr.gg',0.95,'Maps_Won',           11.0,'maps','2024-03-31'),
(492, 'team', 9,'tournament', 5,'public','vlr.gg',0.95,'Maps_Lost',           3.0,'maps','2024-03-31'),
(493, 'team', 9,'tournament', 5,'public','vlr.gg',0.95,'Maps_Played',         14.0,'maps','2024-03-31'),
(494, 'team', 9,'tournament', 5,'public','vlr.gg',0.95,'Rounds_Won_Pct',    54.8,'%',    '2024-03-31'),

-- Gen.G (team 7) at Masters Madrid (t5) — runners-up
(495, 'team', 7,'tournament', 5,'public','vlr.gg',0.93,'Win_Rate',          64.3,'%',    '2024-03-31'),
(496, 'team', 7,'tournament', 5,'public','vlr.gg',0.93,'Maps_Won',            9.0,'maps','2024-03-31'),
(497, 'team', 7,'tournament', 5,'public','vlr.gg',0.93,'Maps_Lost',           5.0,'maps','2024-03-31'),
(498, 'team', 7,'tournament', 5,'public','vlr.gg',0.93,'Maps_Played',         14.0,'maps','2024-03-31'),

-- FNATIC (team 10) at Masters Madrid (t5)
(499, 'team',10,'tournament', 5,'public','vlr.gg',0.91,'Win_Rate',          50.0,'%',    '2024-03-31'),
(500, 'team',10,'tournament', 5,'public','vlr.gg',0.91,'Maps_Won',            6.0,'maps','2024-03-31'),
(501, 'team',10,'tournament', 5,'public','vlr.gg',0.91,'Maps_Lost',           6.0,'maps','2024-03-31'),

-- ─── CS2 TEAM STATS ────────────────────────────────────────────────────

-- Natus Vincere (team 22) at PGL Major Copenhagen (t17) — champions
(502, 'team',22,'tournament',17,'public','hltv.org',0.97,'Win_Rate',          75.0,'%',     '2024-03-31'),
(503, 'team',22,'tournament',17,'public','hltv.org',0.97,'Maps_Won',            9.0,'maps', '2024-03-31'),
(504, 'team',22,'tournament',17,'public','hltv.org',0.97,'Maps_Lost',           3.0,'maps', '2024-03-31'),
(505, 'team',22,'tournament',17,'public','hltv.org',0.97,'Maps_Played',         12.0,'maps', '2024-03-31'),
(506, 'team',22,'tournament',17,'public','hltv.org',0.97,'Rounds_Won_Pct',    54.8,'%',     '2024-03-31'),
(507, 'team',22,'tournament',17,'public','hltv.org',0.97,'Team_Rating_Avg',    1.10,'rating','2024-03-31'),

-- FaZe Clan (team 23) at PGL Major Copenhagen (t17) — runners-up
(508, 'team',23,'tournament',17,'public','hltv.org',0.95,'Win_Rate',          66.7,'%',     '2024-03-31'),
(509, 'team',23,'tournament',17,'public','hltv.org',0.95,'Maps_Won',            8.0,'maps', '2024-03-31'),
(510, 'team',23,'tournament',17,'public','hltv.org',0.95,'Maps_Lost',           4.0,'maps', '2024-03-31'),
(511, 'team',23,'tournament',17,'public','hltv.org',0.95,'Maps_Played',         12.0,'maps', '2024-03-31'),
(512, 'team',23,'tournament',17,'public','hltv.org',0.95,'Rounds_Won_Pct',    52.4,'%',     '2024-03-31'),

-- MOUZ (team 25) at PGL Major Copenhagen (t17) — 3rd-4th
(513, 'team',25,'tournament',17,'public','hltv.org',0.93,'Win_Rate',          58.3,'%',     '2024-03-31'),
(514, 'team',25,'tournament',17,'public','hltv.org',0.93,'Maps_Won',            7.0,'maps', '2024-03-31'),
(515, 'team',25,'tournament',17,'public','hltv.org',0.93,'Maps_Lost',           5.0,'maps', '2024-03-31'),

-- HEROIC (team 29) at PGL Major Copenhagen (t17) — 3rd-4th
(516, 'team',29,'tournament',17,'public','hltv.org',0.93,'Win_Rate',          58.3,'%',     '2024-03-31'),
(517, 'team',29,'tournament',17,'public','hltv.org',0.93,'Maps_Won',            7.0,'maps', '2024-03-31'),
(518, 'team',29,'tournament',17,'public','hltv.org',0.93,'Maps_Lost',           5.0,'maps', '2024-03-31'),

-- Team Spirit (team 24) at Shanghai Major (t20) — champions
(519, 'team',24,'tournament',20,'public','hltv.org',0.97,'Win_Rate',          70.0,'%',     '2024-12-15'),
(520, 'team',24,'tournament',20,'public','hltv.org',0.97,'Maps_Won',            7.0,'maps', '2024-12-15'),
(521, 'team',24,'tournament',20,'public','hltv.org',0.97,'Maps_Lost',           3.0,'maps', '2024-12-15'),
(522, 'team',24,'tournament',20,'public','hltv.org',0.97,'Maps_Played',         10.0,'maps', '2024-12-15'),
(523, 'team',24,'tournament',20,'public','hltv.org',0.97,'Rounds_Won_Pct',    55.4,'%',     '2024-12-15'),
(524, 'team',24,'tournament',20,'public','hltv.org',0.97,'Team_Rating_Avg',    1.12,'rating','2024-12-15'),

-- FaZe Clan (team 23) at Shanghai Major (t20) — runners-up
(525, 'team',23,'tournament',20,'public','hltv.org',0.95,'Win_Rate',          65.0,'%',     '2024-12-15'),
(526, 'team',23,'tournament',20,'public','hltv.org',0.95,'Maps_Won',           13.0,'maps', '2024-12-15'),
(527, 'team',23,'tournament',20,'public','hltv.org',0.95,'Maps_Lost',           7.0,'maps', '2024-12-15'),
(528, 'team',23,'tournament',20,'public','hltv.org',0.95,'Rounds_Won_Pct',    52.8,'%',     '2024-12-15'),

-- MOUZ (team 25) at Shanghai Major (t20) — 3rd-4th
(529, 'team',25,'tournament',20,'public','hltv.org',0.93,'Win_Rate',          60.0,'%',     '2024-12-15'),
(530, 'team',25,'tournament',20,'public','hltv.org',0.93,'Maps_Won',            6.0,'maps', '2024-12-15'),
(531, 'team',25,'tournament',20,'public','hltv.org',0.93,'Maps_Lost',           4.0,'maps', '2024-12-15'),

-- G2 Esports (CS2 team 3 is G2 VAL; no separate CS2 G2 team in DB — skip)
-- The MongolZ (team 27) at Shanghai Major (t20) — 5th-8th
(532, 'team',27,'tournament',20,'public','hltv.org',0.91,'Win_Rate',          50.0,'%',     '2024-12-15'),
(533, 'team',27,'tournament',20,'public','hltv.org',0.91,'Maps_Won',            5.0,'maps', '2024-12-15'),
(534, 'team',27,'tournament',20,'public','hltv.org',0.91,'Maps_Lost',           5.0,'maps', '2024-12-15'),

-- Team Spirit (team 24) at IEM Katowice 2024 (t16) — champions
-- Win_Rate for team 24 at t16 already has stat_id 8 (Maps Won 6)
(535, 'team',24,'tournament',16,'public','hltv.org',0.96,'Win_Rate',          85.7,'%',     '2024-02-18'),
(536, 'team',24,'tournament',16,'public','hltv.org',0.96,'Maps_Lost',           1.0,'maps', '2024-02-18'),
(537, 'team',24,'tournament',16,'public','hltv.org',0.96,'Maps_Played',          7.0,'maps', '2024-02-18'),
(538, 'team',24,'tournament',16,'public','hltv.org',0.96,'Rounds_Won_Pct',    57.2,'%',     '2024-02-18'),
(539, 'team',24,'tournament',16,'public','hltv.org',0.96,'Team_Rating_Avg',    1.14,'rating','2024-02-18'),

-- FaZe Clan (team 23) at IEM Katowice (t16) — runners-up
(540, 'team',23,'tournament',16,'public','hltv.org',0.94,'Win_Rate',          71.4,'%',     '2024-02-18'),
(541, 'team',23,'tournament',16,'public','hltv.org',0.94,'Maps_Won',            5.0,'maps', '2024-02-18'),
(542, 'team',23,'tournament',16,'public','hltv.org',0.94,'Maps_Lost',           2.0,'maps', '2024-02-18'),
(543, 'team',23,'tournament',16,'public','hltv.org',0.94,'Maps_Played',          7.0,'maps', '2024-02-18'),

-- Natus Vincere (team 22) at ESL Pro League S20 (t19) — champions
(544, 'team',22,'tournament',19,'public','hltv.org',0.96,'Win_Rate',          77.8,'%',     '2024-09-29'),
(545, 'team',22,'tournament',19,'public','hltv.org',0.96,'Maps_Won',            7.0,'maps', '2024-09-29'),
(546, 'team',22,'tournament',19,'public','hltv.org',0.96,'Maps_Lost',           2.0,'maps', '2024-09-29'),
(547, 'team',22,'tournament',19,'public','hltv.org',0.96,'Maps_Played',          9.0,'maps', '2024-09-29'),
(548, 'team',22,'tournament',19,'public','hltv.org',0.96,'Rounds_Won_Pct',    55.6,'%',     '2024-09-29'),

-- Team Spirit (team 24) at ESL Pro League S20 (t19) — runners-up
(549, 'team',24,'tournament',19,'public','hltv.org',0.94,'Win_Rate',          66.7,'%',     '2024-09-29'),
(550, 'team',24,'tournament',19,'public','hltv.org',0.94,'Maps_Won',            6.0,'maps', '2024-09-29'),
(551, 'team',24,'tournament',19,'public','hltv.org',0.94,'Maps_Lost',           3.0,'maps', '2024-09-29'),

-- ─── BGMI TEAM STATS ───────────────────────────────────────────────────

-- Team XSpark (team 16) at BGIS 2024 (t12) — stat_id 7 has Total Points
(552, 'team',16,'tournament',12,'public','liquipedia.net',0.99,'Chicken_Dinners',     5.0,'wins',  '2024-06-30'),
(553, 'team',16,'tournament',12,'public','liquipedia.net',0.99,'Kill_Points',          88.0,'pts',  '2024-06-30'),
(554, 'team',16,'tournament',12,'public','liquipedia.net',0.99,'Placement_Points',     54.0,'pts',  '2024-06-30'),
(555, 'team',16,'tournament',12,'public','liquipedia.net',0.99,'Placement_Avg',          2.8,'pos', '2024-06-30'),
(556, 'team',16,'tournament',12,'public','liquipedia.net',0.99,'Team_Kill_Avg',         7.6,'kills','2024-06-30'),

-- Global Esports (team 17) at BGIS 2024 (t12) — 2nd place
(557, 'team',17,'tournament',12,'public','liquipedia.net',0.96,'Total_Points',        110.0,'pts',  '2024-06-30'),
(558, 'team',17,'tournament',12,'public','liquipedia.net',0.96,'Chicken_Dinners',       2.0,'wins', '2024-06-30'),
(559, 'team',17,'tournament',12,'public','liquipedia.net',0.96,'Kill_Points',           66.0,'pts',  '2024-06-30'),
(560, 'team',17,'tournament',12,'public','liquipedia.net',0.96,'Placement_Points',      44.0,'pts',  '2024-06-30'),

-- Reckoning Esports (team 18) at BGIS 2024 (t12) — 3rd place
(561, 'team',18,'tournament',12,'public','liquipedia.net',0.95,'Total_Points',          95.0,'pts',  '2024-06-30'),
(562, 'team',18,'tournament',12,'public','liquipedia.net',0.95,'Chicken_Dinners',        2.0,'wins', '2024-06-30'),
(563, 'team',18,'tournament',12,'public','liquipedia.net',0.95,'Kill_Points',            56.0,'pts',  '2024-06-30'),

-- Team XSpark (team 16) at BMPS 2024 (t14) — champions
(564, 'team',16,'tournament',14,'public','liquipedia.net',0.99,'Total_Points',          158.0,'pts',  '2024-09-29'),
(565, 'team',16,'tournament',14,'public','liquipedia.net',0.99,'Chicken_Dinners',          4.0,'wins', '2024-09-29'),
(566, 'team',16,'tournament',14,'public','liquipedia.net',0.99,'Kill_Points',              98.0,'pts',  '2024-09-29'),
(567, 'team',16,'tournament',14,'public','liquipedia.net',0.99,'Placement_Points',         60.0,'pts',  '2024-09-29'),
(568, 'team',16,'tournament',14,'public','liquipedia.net',0.99,'Team_Kill_Avg',             8.4,'kills','2024-09-29'),

-- Numen Esports (team 21) at BMPS 2024 (t14) — 2nd place
(569, 'team',21,'tournament',14,'public','liquipedia.net',0.96,'Total_Points',          144.0,'pts',  '2024-09-29'),
(570, 'team',21,'tournament',14,'public','liquipedia.net',0.96,'Chicken_Dinners',          3.0,'wins', '2024-09-29'),
(571, 'team',21,'tournament',14,'public','liquipedia.net',0.96,'Kill_Points',               85.0,'pts', '2024-09-29'),
(572, 'team',21,'tournament',14,'public','liquipedia.net',0.96,'Placement_Points',          59.0,'pts', '2024-09-29'),

-- GodLike Esports (team 20) at BMPS 2024 (t14) — 3rd place
(573, 'team',20,'tournament',14,'public','liquipedia.net',0.95,'Total_Points',          144.0,'pts',  '2024-09-29'),
(574, 'team',20,'tournament',14,'public','liquipedia.net',0.95,'Chicken_Dinners',          2.0,'wins', '2024-09-29'),
(575, 'team',20,'tournament',14,'public','liquipedia.net',0.95,'Kill_Points',              90.0,'pts',  '2024-09-29'),

-- Team SouL (team 19) at BGMS Season 3 (t13) — champions
(576, 'team',19,'tournament',13,'public','sportskeeda.com',0.97,'Total_Points',         167.0,'pts',  '2024-08-11'),
(577, 'team',19,'tournament',13,'public','sportskeeda.com',0.97,'Chicken_Dinners',         3.0,'wins', '2024-08-11'),
(578, 'team',19,'tournament',13,'public','sportskeeda.com',0.97,'Kill_Points',             103.0,'pts','2024-08-11'),
(579, 'team',19,'tournament',13,'public','sportskeeda.com',0.97,'Placement_Points',         64.0,'pts','2024-08-11'),
(580, 'team',19,'tournament',13,'public','sportskeeda.com',0.97,'Team_Kill_Avg',             8.8,'kills','2024-08-11'),

-- GodLike Esports (team 20) at BGMS Season 3 (t13) — 2nd place
(581, 'team',20,'tournament',13,'public','sportskeeda.com',0.95,'Total_Points',         148.0,'pts',  '2024-08-11'),
(582, 'team',20,'tournament',13,'public','sportskeeda.com',0.95,'Chicken_Dinners',         2.0,'wins', '2024-08-11'),
(583, 'team',20,'tournament',13,'public','sportskeeda.com',0.95,'Kill_Points',              90.0,'pts', '2024-08-11'),

-- Reckoning Esports (team 18) at BGMS Season 3 (t13) — 3rd place
(584, 'team',18,'tournament',13,'public','sportskeeda.com',0.93,'Total_Points',         122.0,'pts',  '2024-08-11'),
(585, 'team',18,'tournament',13,'public','sportskeeda.com',0.93,'Chicken_Dinners',         2.0,'wins', '2024-08-11'),
(586, 'team',18,'tournament',13,'public','sportskeeda.com',0.93,'Kill_Points',              72.0,'pts', '2024-08-11');

-- =============================================
-- END OF STATS SEED
-- Total new rows: 578  (stat_id 9 – 586)
--
-- Stat names reference guide for frontend:
--  VALORANT  : acs | kd | kast | adr | HS_Pct |
--              FK_Per_Round | Kills | Deaths | Assists | Maps_Played
--  CS2       : rating | kast | adr | HS_Pct |
--              Kills_Per_Round | Deaths_Per_Round |
--              Opening_Win_Pct | Clutch_Pct | Impact_Rating
--  BGMI      : Total_Points | Kill_Points | Placement_Points |
--              Chicken_Dinners | Avg_Damage_Per_Match |
--              Avg_Survival_Mins | Total_Kills
--  Teams     : Win_Rate | Maps_Won | Maps_Lost | Maps_Played |
--              Rounds_Won_Pct | Team_acs_Avg | Team_KD_Avg |
--              Team_Rating_Avg | Team_Kill_Avg | Placement_Avg
-- =============================================

-- =============================================
-- CONTENTIONS, BANS, & APPEALS (New in v3)
-- =============================================
-- INSERT INTO Contention (contention_id, status_id, filer_type, raised_by, reason, description, created_at, resolved_at, game_id) VALUES
-- (1, 8, 'player', 10, 'Toxicity / Unsportsmanlike Conduct', 'Player exhibited severe toxic behavior in public match', '2024-01-15', '2024-01-20', 1),
-- (2, 8, 'coach', 1, 'Competitive Ruling Violation', 'Team used an unauthorized bug boost during a VCT match', '2024-03-01', '2024-03-05', 1);
INSERT INTO Contention (
    contention_id, status_id, filer_type, raised_by, 
    target_player_id, target_team_id, 
    reason, description, created_at, resolved_at, game_id
) VALUES
(1, 8, 'player', 10, 11, NULL, 
 'Toxicity / Unsportsmanlike Conduct', 'Player exhibited severe toxic behavior in public match', 
 '2024-01-15', '2024-01-20', 1),

(2, 8, 'coach', 1, NULL, 5, 
 'Competitive Ruling Violation', 'Team used an unauthorized bug boost during a VCT match', 
 '2024-03-01', '2024-03-05', 1);
 
INSERT INTO Contention_History (contention_id, status_id, changed_by, note, changed_at) VALUES
(1, 7, 2, 'Reviewing VODs', '2024-01-16'),
(1, 8, 2, 'Ban issued', '2024-01-20'),
(2, 8, 2, 'Team penalized and match overturned', '2024-03-05');

INSERT INTO Ban (ban_id, contention_id, ban_type, duration, start_date, end_date, description, evidence, issued_by) VALUES
(1, 1, 'warning', 30, '2024-01-20', '2024-02-19', '30 day warning for toxicity', 'VOD clip #402', 2),
(2, 2, 'team_ban', 14, '2024-03-05', '2024-03-19', '14 day tournament suspension for bug abuse', 'Match 14 VOD', 2);

INSERT INTO Ban_Target (ban_id, player_id, team_id, game_id) VALUES
(1, 10, NULL, 1),
(2, NULL, 3, 1);

INSERT INTO Team_Ban (ban_id, team_id, affects_roster, ban_scope) VALUES
(2, 3, TRUE, 'tournament');

INSERT INTO Customer_Support (support_id, player_id, admin_id, type, category, subject, description, status_id, priority, created_at, resolved_at) VALUES
(1, 10, 2, 'Appeal', 'Ban Appeal', 'Appeal for Toxicity Warning', 'I apologize for my behavior and have muted chat.', 8, 'high', '2024-01-21', '2024-01-22');

INSERT INTO Appeal_Contention (support_id, contention_id) VALUES
(1, 1);

-- =============================================
-- NOTIFICATIONS
-- =============================================
INSERT INTO Notification (player_id, message, is_read, created_at) VALUES
(37, 'Congratulations ZmjjKK! You have been named MVP of Valorant Champions 2024.',        FALSE,'2024-08-25 18:00:00'),
(103,'Congratulations jL! You have been named MVP of PGL Major Copenhagen 2024.',          FALSE,'2024-03-31 20:00:00'),
(113,'Congratulations donk! You have been named MVP of Perfect World Shanghai Major 2024.',FALSE,'2024-12-15 15:00:00'),
(76, 'Congratulations NinjaJOD! Team XSpark has won BGIS 2024.',                           FALSE,'2024-06-30 18:00:00'),
(77, 'Congratulations SPRAYGOD! You have been named MVP of BGIS 2024.',                    FALSE,'2024-06-30 18:30:00'),
(37, 'VCT 2025 Masters Bangkok is now LIVE! EDward Gaming vs FNATIC is in progress.',      FALSE,'2025-02-07 06:00:00'),
(113,'BLAST Austin Major 2025 is LIVE! Your match vs HEROIC starts in 15 minutes.',        FALSE,'2025-06-03 14:45:00'),
(108,'BLAST Austin Major 2025: Your match vs The MongolZ starts in 15 minutes.',           FALSE,'2025-06-03 17:45:00');

-- =============================================
-- AUDIT LOG
-- =============================================
INSERT INTO Audit_Log
  (entity_type, entity_id, action, performed_by, timestamp, ip_address, details)
VALUES
('tournament',10,'created',   2,'2024-07-01 09:00:00','10.0.0.1','Created Valorant Champions 2024 record'),
('tournament',17,'created',   4,'2024-02-01 10:00:00','10.0.0.2','Created PGL Major Copenhagen 2024 record'),
('tournament',12,'created',   3,'2024-06-01 09:00:00','10.0.0.3','Created BGIS 2024 record'),
('match',     37,'updated',   2,'2024-08-25 20:00:00','10.0.0.1','Result: EDG 3-2 Heretics — Champions 2024'),
('match',     57,'updated',   4,'2024-03-31 22:00:00','10.0.0.2','Result: NAVI 2-1 FaZe — PGL Major Copenhagen'),
('match',     67,'updated',   4,'2024-12-15 18:00:00','10.0.0.2','Result: Spirit 2-1 FaZe — Shanghai Major'),
('match',     40,'updated',   3,'2024-06-30 18:00:00','10.0.0.3','Result: XSpark wins BGIS 2024 Day 3'),
('match',     68,'created',   2,'2025-02-07 05:50:00','10.0.0.1','LIVE: Masters Bangkok — EDG vs FNATIC started'),
('match',     71,'created',   4,'2025-06-03 14:50:00','10.0.0.2','LIVE: BLAST Austin — NAVI vs HEROIC started'),
('match',     72,'created',   4,'2025-06-03 17:50:00','10.0.0.2','LIVE: BLAST Austin — FaZe vs MongolZ started'),
('player',    37,'stat_added',2,'2024-08-26 09:00:00','10.0.0.1','Added Champions 2024 ACS stat for ZmjjKK');