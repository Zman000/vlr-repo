  // ─── API Utilities ────────────────────────────────
  const API = {
    base: '/api',

    getToken() { return localStorage.getItem('vlr_token'); },
    getUser()  { return JSON.parse(localStorage.getItem('vlr_user') || 'null'); },  
    isLoggedIn(){ return !!this.getToken(); },

    headers() {
      const h = { 'Content-Type': 'application/json' };
      const token = this.getToken();
      if (token) h['Authorization'] = `Bearer ${token}`;
      return h;
    },

    async get(path) {
      const res = await fetch(this.base + path, { headers: this.headers() });
      if (!res.ok) throw await res.json();
      return res.json();
    },

    async post(path, body) {
      const res = await fetch(this.base + path, {
        method: 'POST', headers: this.headers(), body: JSON.stringify(body)
      });
      const data = await res.json();
      if (!res.ok) throw data;
      return data;
    },

    async put(path, body) {
      const res = await fetch(this.base + path, {
        method: 'PUT', headers: this.headers(), body: JSON.stringify(body)
      });
      const data = await res.json();
      if (!res.ok) throw data;
      return data;
    },

    login(token, user) {
      localStorage.setItem('vlr_token', token);
      localStorage.setItem('vlr_user', JSON.stringify(user));
    },
    logout() {
      localStorage.removeItem('vlr_token');
      localStorage.removeItem('vlr_user');
      window.location.href = '/login.html';
    }
  };

  // ─── Shared Components ────────────────────────────
  window.Components = {

    navbar(activePage = '') {
      const user = API.getUser();
      const links = [
        { href: '/index.html',   label: 'Home' },
        { href: '/matches.html', label: 'Matches' },
        { href: '/tournaments.html',  label: 'Tournaments' },
        { href: '/teams.html',   label: 'Teams' },
        { href: '/players.html', label: 'Players' },
        { href: '/rankings.html',label: 'Rankings' },
        { href: '/stats.html',   label: 'Stats' },
        { href: '/sponsors.html',label: 'Sponsors' },
      ];

      const navLinks = links.map(l => {
        const active = activePage === l.label ? 'active' : '';
        return `<a href="${l.href}" class="${active}">${l.label}</a>`;
      }).join('');

      const authSection = user
        // ? `<div class="dropdown">
        //     <div class="nav-avatar" onclick="toggleDropdown()">${user.username[0].toUpperCase()}</div>
        //     <div class="dropdown-menu" id="userDropdown">
        //       <span class="dropdown-item nav-user-name">${user.username} <small style="color:var(--text-3)">(${user.role})</small></span>
        //       <div class="divider" style="margin:4px 0"></div>
        //       ${user.role === 'Admin' ? `<a class="dropdown-item" href="/admin.html" style="color:var(--accent);display:flex;align-items:center;gap:7px;font-weight:600"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>Admin Panel</a><div class="divider" style="margin:4px 0"></div>` : ''}
        //       <a class="dropdown-item" href="/profile.html" style="display:flex;align-items:center;gap:7px"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>My Account</a>
        //       ${user.role === 'Player' ? `<a class="dropdown-item" href="/contentions.html" style="display:flex;align-items:center;gap:7px"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>My Contentions</a>` : ''}
        //       <div class="divider" style="margin:4px 0"></div>
        //       <a class="dropdown-item dropdown-item danger" onclick="API.logout()">Logout</a>
        //     </div>
        //   </div>`
            ? `<div class="dropdown">
          <div class="nav-avatar" onclick="toggleDropdown()">${user.username[0].toUpperCase()}</div>
          <div class="dropdown-menu" id="userDropdown">
            <span class="dropdown-item nav-user-name">${user.username} <small style="color:var(--text-3)">(${user.role})</small></span>
            <div class="divider" style="margin:4px 0"></div>
            
            ${user.role === 'Admin' ? `<a class="dropdown-item" href="/admin.html" style="color:var(--accent);display:flex;align-items:center;gap:7px;font-weight:600"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>Admin Panel</a><div class="divider" style="margin:4px 0"></div>` : ''}
            
            ${user.role !== 'Admin' ? `<a class="dropdown-item" href="/profile.html" style="display:flex;align-items:center;gap:7px"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>My Account</a>` : ''}
            
            ${user.role === 'Player' ? `<a class="dropdown-item" href="/contentions.html" style="display:flex;align-items:center;gap:7px"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>My Contentions</a>` : ''}
            
            <div class="divider" style="margin:4px 0"></div>
            <a class="dropdown-item dropdown-item danger" onclick="API.logout()">Logout</a>
          </div>
        </div>`
        : `<a href="/login.html" class="btn btn-ghost btn-sm">Login</a>
          <a href="/register.html" class="btn btn-primary btn-sm">Register</a>`;

      return `
      <nav class="navbar">
        <div class="container">
          <a href="/index.html" class="nav-logo">
            <div class="nav-logo-icon"></div>
            Esports<span style="color:var(--accent)">Hub</span>
          </a>
          <div class="nav-links">${navLinks}</div>
          <div class="nav-right">
            <div class="nav-search">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
              </svg>
              <input type="text" id="globalSearch" placeholder="Search teams, players..." onkeydown="handleSearch(event)">
            </div>
            <div class="nav-right">${authSection}</div>
          </div>
        </div>
      </nav>`;
    },
    
    footer() {
      return `
      <footer class="footer">
        <div class="container">
          <div class="footer-inner">
            <span class="footer-logo">Esports<span style="color:var(--accent)">Hub</span> <small style="font-size:11px;font-weight:400;color:var(--text-3)">— Multi-Game Esports Tracker</small></span>
            <span>Data for educational purposes only · Not affiliated with Riot Games</span>
            
        </div>
      </div>
    </footer>`;
  },

  matchCard(m) {
    const isCompleted = m.status === 'Completed';
    const t1win = m.w_id === m.t1_id;
    const t2win = m.w_id === m.t2_id;

    const statusBadge = m.status === 'Live'
      ? `<span class="badge badge-live">Live</span>`
      : m.status === 'Upcoming'
      ? `<span class="badge badge-upcoming">${Components.formatDate(m.date)} ${m.start_time?.slice(0,5)}</span>`
      : `<span class="badge badge-done">${Components.formatDate(m.date)}</span>`;

    return `
    <div class="match-card" onclick="location.href='/match-detail.html?id=${m.match_id}'">
      <div class="match-card-header">
        <span class="match-event">${m.tournament_name}</span>
        ${statusBadge}
      </div>
      <div class="match-body">
        <div class="match-teams">
          <div class="match-team">
            ${m.t1_logo ? `<img class="team-logo" src="${m.t1_logo}" alt="${m.t1_name}" onerror="this.style.display='none'">` : `<div class="team-logo-placeholder">${(m.t1_name||'?')[0]}</div>`}
            <span class="team-name ${isCompleted ? (t1win?'winner':'loser') : ''}">${m.t1_name}</span>
          </div>
          <div class="match-score">
            ${isCompleted
              ? `<span class="score-num ${t1win?'win':'lose'}">${m.score_team1}</span>
                 <span class="score-vs">:</span>
                 <span class="score-num ${t2win?'win':'lose'}">${m.score_team2}</span>`
              : `<span class="score-vs" style="font-size:20px">vs</span>`}
          </div>
          <div class="match-team right">
            <span class="team-name ${isCompleted ? (t2win?'winner':'loser') : ''}">${m.t2_name}</span>
            ${m.t2_logo ? `<img class="team-logo" src="${m.t2_logo}" alt="${m.t2_name}" onerror="this.style.display='none'">` : `<div class="team-logo-placeholder">${(m.t2_name||'?')[0]}</div>`}
          </div>
        </div>
        <div class="match-meta">
          ${m.round ? `<span class="match-meta-item">📍 ${m.round}</span>` : ''}
          ${m.best_of ? `<span class="match-meta-item">BO${m.best_of}</span>` : ''}
          ${m.map_name ? `<span class="match-meta-item">🗺 ${m.map_name}</span>` : ''}
          ${m.t1_region ? `<span class="match-meta-item region-badge region-${(m.t1_region||'').toLowerCase()}">${m.t1_region}</span>` : ''}
        </div>
      </div>
    </div>`;
  },

  teamLogo(team) {
    if (team.logo) return `<img class="team-logo" src="${team.logo}" alt="${team.name}" onerror="this.outerHTML='<div class=team-logo-placeholder>${team.name[0]}</div>'">`;
    return `<div class="team-logo-placeholder">${team.name[0]}</div>`;
  },

  regionBadge(region) {
    if (!region) return '';
    return `<span class="region-badge region-${region.toLowerCase()}">${region}</span>`;
  },

  formatDate(dateStr) {
    if (!dateStr) return '';
    const d = new Date(dateStr);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  },

  formatPrize(amount) {
    if (!amount) return '$0';
    if (amount >= 1000000) return `$${(amount/1000000).toFixed(1)}M`;
    if (amount >= 1000) return `$${(amount/1000).toFixed(0)}K`;
    return `$${amount}`;
  },

  loading() {
    return `<div class="loading"><div class="spinner"></div><span>Loading...</span></div>`;
  },

  empty(msg = 'No data found') {
    return `<div class="empty"><div class="empty-icon">🎮</div><p>${msg}</p></div>`;
  }
};

// ─── Globals ──────────────────────────────────────
function toggleDropdown() {
  document.getElementById('userDropdown')?.classList.toggle('open');
}
document.addEventListener('click', e => {
  if (!e.target.closest('.dropdown')) {
    document.getElementById('userDropdown')?.classList.remove('open');
  }
});

function handleSearch(e) {
  if (e.key === 'Enter') {
    const q = e.target.value.trim();
    if (q) window.location.href = `/players.html?q=${encodeURIComponent(q)}`;
  }
}

function showToast(msg, type = 'success') {
  const t = document.createElement('div');
  t.className = `toast ${type}`;
  t.textContent = msg;
  document.body.appendChild(t);
  setTimeout(() => t.classList.add('show'), 10);
  setTimeout(() => { t.classList.remove('show'); setTimeout(() => t.remove(), 300); }, 3000);
}

// Inject nav + footer on DOMContentLoaded if not on auth pages
document.addEventListener('DOMContentLoaded', () => {
  const navMount = document.getElementById('navbar-mount');
  const footerMount = document.getElementById('footer-mount');
  const page = document.body.dataset.page || '';
  if (navMount)    navMount.innerHTML   = Components.navbar(page);
  if (footerMount) footerMount.innerHTML = Components.footer();
});
