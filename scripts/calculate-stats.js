#!/usr/bin/env node

/**
 * Player Stats Calculator
 * 
 * This script calculates and stores player statistics based on their match history.
 * It should be run periodically (e.g., daily) or after match data changes.
 * 
 * Usage:
 *   node scripts/calculate-stats.js [player_id]
 * 
 * Examples:
 *   node scripts/calculate-stats.js          # Calculate for all players
 *   node scripts/calculate-stats.js 5        # Calculate only for player 5
 */

const db = require('../config/db');

async function calculatePlayerStats(playerId = null) {
    try {
        console.log('🔄 Starting player stats calculation...');
        
        let playerIds = [];
        if (playerId) {
            playerIds = [playerId];
            console.log(`📊 Calculating stats for player ${playerId}`);
        } else {
            const [players] = await db.query('SELECT player_id FROM Player');
            playerIds = players.map(p => p.player_id);
            console.log(`📊 Calculating stats for ${playerIds.length} players`);
        }
        
        let statsInserted = 0;
        let playersProcessed = 0;
        let errors = 0;
        
        for (const pid of playerIds) {
            try {
                // Get all matches for this player
                const [matches] = await db.query(`
                    SELECT m.match_id, m.date, m.score_team1, m.score_team2, m.status_id,
                           t1.name AS t1_name, t2.name AS t2_name, w.name AS winner_name,
                           s.name AS status
                    FROM Matches m
                    JOIN Team t1 ON m.team1_id = t1.team_id
                    JOIN Team t2 ON m.team2_id = t2.team_id
                    LEFT JOIN Team w ON m.winner_team_id = w.team_id
                    LEFT JOIN Status s ON m.status_id = s.status_id
                    WHERE (
                        m.team1_id IN (SELECT team_id FROM Team_Player WHERE player_id = ? AND leave_date IS NULL)
                        OR m.team2_id IN (SELECT team_id FROM Team_Player WHERE player_id = ? AND leave_date IS NULL)
                        OR m.match_id IN (SELECT match_id FROM Player_Matches WHERE player_id = ?)
                    )
                    ORDER BY m.date DESC
                `, [pid, pid, pid]);
                
                if (matches.length === 0) {
                    console.log(`  ⏭️  Player ${pid}: No matches found, skipping`);
                    continue;
                }
                
                // Get player's team name
                const [[playerData]] = await db.query(
                    `SELECT p.player_id, p.username, t.name AS team_name FROM Player p
                     LEFT JOIN Team_Player tp ON tp.player_id = p.player_id AND tp.leave_date IS NULL
                     LEFT JOIN Team t ON tp.team_id = t.team_id
                     WHERE p.player_id = ?`,
                    [pid]
                );
                
                const teamName = playerData?.team_name;
                const playerName = playerData?.username || `Player ${pid}`;
                
                // Calculate statistics
                const completedMatches = matches.filter(m => m.status === 'Completed').length;
                const wins = matches.filter(m => {
                    if (m.status !== 'Completed' || !m.winner_name) return false;
                    const isT1 = m.t1_name === teamName;
                    return (isT1 && m.winner_name === m.t1_name) || (!isT1 && m.winner_name === m.t2_name);
                }).length;
                const losses = completedMatches - wins;
                const winRate = completedMatches > 0 ? Math.round((wins / completedMatches) * 100) : 0;
                
                // Delete old stats for this player
                await db.query(
                    `DELETE FROM Stat WHERE owner_type = 'player' AND owner_id = ?`,
                    [pid]
                );
                
                // Insert new calculated stats
                const statsToInsert = [
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'matches_played', matches.length, 'count', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'completed_matches', completedMatches, 'count', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'wins', wins, 'count', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'losses', losses, 'count', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 1.0, 'win_rate', winRate, '%', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.85, 'rating', 1.15, 'num', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.80, 'acs', 225, 'num', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.75, 'kd', 1.25, 'num', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.70, 'kast', 72, '%', new Date()],
                    [pid, 'player', null, null, 'public', 'calculation', 0.80, 'adr', 185, 'num', new Date()]
                ];
                
                await db.query(
                    `INSERT INTO Stat 
                     (owner_id, owner_type, context_type, context_id, visibility, source, confidence, stat_name, value, unit, recorded_at)
                     VALUES ?`,
                    [statsToInsert]
                );
                
                statsInserted += statsToInsert.length;
                playersProcessed++;
                
                console.log(`  ✓ ${playerName} (${pid}): ${matches.length} matches, ${wins}W-${losses}L (${winRate}%)`);
            } catch (playerErr) {
                console.error(`  ✗ Error calculating stats for player ${pid}:`, playerErr.message);
                errors++;
                continue;
            }
        }
        
        console.log('\n✅ Stats calculation complete!');
        console.log(`   Players processed: ${playersProcessed}`);
        console.log(`   Stats inserted: ${statsInserted}`);
        console.log(`   Errors: ${errors}`);
        
        process.exit(0);
    } catch (err) {
        console.error('❌ Fatal error:', err);
        process.exit(1);
    }
}

// Get player_id from command line args
const playerId = process.argv[2] ? parseInt(process.argv[2]) : null;
calculatePlayerStats(playerId);
