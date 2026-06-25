import { h, render, Fragment } from 'preact';
import { useState, useEffect, useRef, useCallback, useMemo } from 'preact/hooks';

var decoder = decodeURIComponent || unescape;

const state = {
  statusTabParts: [['spinner']],
  statsTabParts: [],
  mcTabParts: [],
  currentTab: null,
  hrefToken: null,
  verbTabs: [],
  verbs: [['', '']],
  verbSearch: '',
  lastVerbCat: '',
  tickets: [],
  sdql2: [],
  permanentTabs: [],
  splitAdminTabs: false,
};

const listeners = new Set();
let notifyPending = false;

function notify() {
  if (notifyPending) return;
  notifyPending = true;
  Promise.resolve().then(() => {
    notifyPending = false;
    listeners.forEach((l) => l());
  });
}

function setState(patch) {
  Object.assign(state, patch);
  notify();
}

function useStatState() {
  const [, setTick] = useState(0);
  useEffect(() => {
    const fn = () => setTick((t) => t + 1);
    listeners.add(fn);
    return () => listeners.delete(fn);
  }, []);
  return state;
}

const defaultTab = 'Round Info';
const imageRetryDelay = 500;
const imageRetryLimit = 50;

function runAfterFocus(callback) {
  setTimeout(callback, 0);
}

function BrailleSpinner() {
  const frames = ['⣾','⣽','⣻','⢿','⡿','⣟','⣯','⣷'];
  const [frame, setFrame] = useState(0);
  useEffect(() => {
    const id = setInterval(() => setFrame(f => (f + 1) % frames.length), 100);
    return () => clearInterval(id);
  }, []);
  return (
    <div style={{ textAlign: 'center', padding: '1em' }}>
      {frames[frame]} Awaiting round data...
	  <div>
	  <br/>
		<img src="https://twilight-fortress-axis.ru/tgc_medieval_07.gif"
			width="96"
			height="96"
			style="image-rendering: pixelated;"
		></img>
		<img src="https://twilight-fortress-axis.ru/tgc_medieval_09.gif"
			width="96"
			height="96"
			style="image-rendering: pixelated;"
		></img>	
	  </div>
    </div>
  );
}

function splitCategory(name, splitAdminTabs) {
  if (name.indexOf('.') === -1) return name;
  const parts = name.split('.');
  if (splitAdminTabs && parts[0] === 'Admin') return parts[1];
  return parts[0];
}

function sortVerbs(verbs) {
  return [...verbs].sort((a, b) => {
    var selector = a[0] == b[0] ? 1 : 0;
    if (a[selector].toUpperCase() < b[selector].toUpperCase()) return 1;
    if (a[selector].toUpperCase() > b[selector].toUpperCase()) return -1;
    return 0;
  });
}

function findVerbIndex(name, verblist) {
  for (var i = 0; i < verblist.length; i++) {
    if (verblist[i][1] == name) return i;
  }
  return undefined;
}

function removeVerb(v, verbs) {
  return verbs.filter((part) => part[1] != v[1]);
}

const byondTabs = new Set();

function sendTabToByond(tab) {
  if (byondTabs.has(tab)) return;
  byondTabs.add(tab);
  Byond.sendMessage('Send-Tabs', { tab });
}
function takeTabFromByond(tab) {
  if (!byondTabs.has(tab)) return;
  byondTabs.delete(tab);
  Byond.sendMessage('Remove-Tabs', { tab });
}
function sendTabsToByond() {
  const all = [...state.permanentTabs, ...state.verbTabs];
  all.forEach(sendTabToByond);
}
function setByondTab(tab) {
  Byond.sendMessage('Set-Tab', { tab });
}

function addPermanentTab(name) {
  if (state.permanentTabs.includes(name)) return;
  setState({ permanentTabs: [...state.permanentTabs, name] });
  sendTabToByond(name);
}

function removePermanentTab(name) {
  if (!state.permanentTabs.includes(name)) return;
  state.permanentTabs = state.permanentTabs.filter((t) => t !== name);
  notify();
  takeTabFromByond(name); 
}

function removeStatusTab(name) {
  if (state.permanentTabs.includes(name)) return;
  if (!state.verbTabs.includes(name)) return;
  state.verbTabs = state.verbTabs.filter((t) => t !== name);
  notify();
  takeTabFromByond(name);
}

function wipeVerbs() {
  setState({ verbs: [['', '']], verbTabs: [] });
}

function updateVerbs() {
  wipeVerbs();
  Byond.sendMessage('Update-Verbs');
}

function tabChange(tab) {
  if (tab === state.currentTab) return;
  setByondTab(tab);
  setState({ currentTab: tab });
  Byond.winset(Byond.windowId, { 'is-visible': true });
}

function verbsCatCheck(cat) {
  const tabCat = splitCategory(cat, state.splitAdminTabs);
  if (!state.verbTabs.includes(tabCat)) {
    removeStatusTab(tabCat);
    return;
  }
  const hasVerb = state.verbs.some((part) => {
    const verbcat = splitCategory(part[0], state.splitAdminTabs);
    return verbcat === tabCat && verbcat.trim() !== '';
  });
  if (!hasVerb) {
    removeStatusTab(tabCat);
    if (state.currentTab === tabCat) tabChange(defaultTab);
  }
}

function checkVerbs() {
  state.verbTabs.forEach((cat) => verbsCatCheck(cat));
}

function addVerbList(payload) {
  const toAdd = [...payload].sort();
  let verbs = [...state.verbs];
  let verbTabs = [...state.verbTabs];
  let changed = false;

  for (const part of toAdd) {
    if (!part[0]) continue;
    const category = splitCategory(part[0], state.splitAdminTabs);
    if (findVerbIndex(part[1], verbs) !== undefined) continue;
    changed = true;
    if (verbTabs.includes(category)) {
      verbs.push(part);
    } else if (category) {
      verbTabs.push(category);
      verbs.push(part);
    }
  }

  if (changed) setState({ verbs, verbTabs });
}

function StatusRow({ part }) {
  if (!Array.isArray(part)) {
    if (typeof part === 'string' && part.trim() === '') return <br />;
    return <div>{part}</div>;
  }

  if (part?.[0] === 'spinner') return <BrailleSpinner />;

  switch (part[0]) {
    case 'tod': {
      const todWord = part[1].charAt(0).toUpperCase() + part[1].slice(1);
      const todText = part[2];
      const idx = todText.indexOf(todWord);
      if (idx === -1) return <div>{todText}</div>;
      return (
        <div>
          {todText.slice(0, idx)}
          <span className={'tod-' + part[1]}>{todWord}</span>
          {todText.slice(idx + todWord.length)}
        </div>
      );
    }
    case 'load': {
      if (part[3] !== undefined) {
        return (
          <div>
            {part[2]}
            <span className={'load-' + part[1]}>{part[3]}</span>
          </div>
        );
      }
      return <div className={'load-' + part[1]}>{part[2]}</div>;
    }
    case 'same_line':
      return <div><a href={'byond://?' + part[2]}>{part[1]}</a></div>;
    default: {
      if (part[0].trim() === '') return <br />;
      if (part[2]) {
        return (
          <div>
            {part[0]}
            <a href={'byond://?' + part[2]}>{part[1]}</a>
          </div>
        );
      }
      return <div>{part}</div>;
    }
  }
}

function RoundInfoPanel() {
  const s = useStatState();

  const sentFixRef = useRef(false);
  useEffect(() => {
    if (s.verbTabs.length === 0) {
      if (!sentFixRef.current) {
        sentFixRef.current = true;
        Byond.command('Fix-Stat-Panel');
      }
    } else {
      sentFixRef.current = false;
    }
  }, [s.verbTabs.length]);

  return (
    <table>
      {s.statusTabParts.map((part, i) => (
        <StatusRow key={i} part={part} />
      ))}
    </table>
  );
}

function StatsPanel() {
  const s = useStatState();
  return (
    <table>
      {s.statsTabParts.map((text, i) => {
        const idx = text.indexOf(':');
        if (idx === -1) return <div key={i}>{text}</div>;
        const label = text.substring(0, idx);
        return (
          <div key={i}>
            <span className={'stat-label stat-label-' + label.trim().toLowerCase()}>
              {label}:
            </span>
            {text.substring(idx + 1)}
          </div>
        );
      })}
    </table>
  );
}

function MCPanel() {
  const s = useStatState();
  const rows = useMemo(() => [...s.mcTabParts], [s.mcTabParts]);
  return (
    <table>
      {rows.map((part, i) => (
        <tr key={i}>
          <td className="monospace">{part[0]}</td>
          <td>{part[1]}</td>
          <td>
            {part[3]
              ? <a href={'byond://?_src_=vars;admin_token=' + s.hrefToken + ';Vars=' + part[3]}>{part[2]}</a>
              : part[2]}
          </td>
        </tr>
      ))}
    </table>
  );
}

function TicketsPanel() {
  const s = useStatState();
  return (
    <table>
      {s.tickets.map((part, i) => {
        let link;
        if (part[2]) {
          link = <a href={'byond://?_src_=holder;admin_token=' + s.hrefToken + ';ahelp=' + part[2] + ';ahelp_action=ticket;statpanel_item_click=left;action=ticket'}>{part[1]}</a>;
        } else if (part[3]) {
          link = <a href={'byond://?src=' + part[3] + ';statpanel_item_click=left'}>{part[1]}</a>;
        } else {
          link = part[1];
        }
        return (
          <tr key={i}>
            <td>{part[0]}</td>
            <td>{link}</td>
          </tr>
        );
      })}
    </table>
  );
}

function SDQL2Panel() {
  const s = useStatState();
  return (
    <table>
      {s.sdql2.map((part, i) => (
        <tr key={i}>
          <td>{part[0]}</td>
          <td>
            {part[2]
              ? <a href={'byond://?src=' + part[2] + ';statpanel_item_click=left'}>{part[1]}</a>
              : part[1]}
          </td>
        </tr>
      ))}
    </table>
  );
}

function VerbsPanel({ cat }) {
  const s = useStatState();
  const [search, setSearch] = useState(s.verbSearch);

  useEffect(() => {
    if (cat !== s.lastVerbCat) {
      setSearch('');
      setState({ verbSearch: '', lastVerbCat: cat });
    }
  }, [cat]);

  const onInput = (e) => {
    setSearch(e.target.value);
    setState({ verbSearch: e.target.value });
  };

  const effectiveCat = useMemo(() => {
    if (s.splitAdminTabs && cat.lastIndexOf('.') !== -1) {
      const split = cat.split('.');
      if (split[0] === 'Admin') return split[1];
    }
    return cat;
  }, [cat, s.splitAdminTabs]);

  const { main, additions } = useMemo(() => {
    const verbsReversed = sortVerbs(s.verbs).reverse();
    const main = [];
    const additions = {};
    for (const part of verbsReversed) {
      let name = part[0];
      const command = part[1];
      if (s.splitAdminTabs && name.lastIndexOf('.') !== -1) {
        const split = name.split('.');
        if (split[0] === 'Admin') name = split[1];
      }
      if (
        command &&
        name.lastIndexOf(effectiveCat, 0) !== -1 &&
        (name.length === effectiveCat.length || name.charAt(effectiveCat.length) === '.')
      ) {
        const subCat = name.lastIndexOf('.') !== -1 ? name.split('.')[1] : null;
        if (subCat) {
          if (!additions[subCat]) additions[subCat] = [];
          additions[subCat].push(command);
        } else {
          main.push(command);
        }
      }
    }
    return { main, additions };
  }, [s.verbs, effectiveCat, s.splitAdminTabs]);

  const q = (search || '').toLowerCase();
  const matches = (command) => !q || command.toLowerCase().indexOf(q) !== -1;
  const onVerbClick = (command) => (e) => {
    e.preventDefault();
    runAfterFocus(() => Byond.command(command.replace(/\s/g, '-')));
  };

  return (
    <Fragment>
      <input
        type="text"
        className="verb-search"
        placeholder="Search verbs..."
        value={search}
        onInput={onInput}
      />
      <div className="grid-container">
        {main.map((command, i) => (
          <a key={i} href="#" className="grid-item" data-label={command}
            style={{ display: matches(command) ? '' : 'none' }}
            onClick={onVerbClick(command)}>
            <span className="grid-item-text">{command}</span>
          </a>
        ))}
      </div>
      {Object.keys(additions).map((subCat) => (
        <Fragment key={subCat}>
          <h3>{subCat}</h3>
          <div className="grid-container">
            {additions[subCat].map((command, i) => (
              <a key={i} href="#" className="grid-item" data-label={command}
                style={{ display: matches(command) ? '' : 'none' }}
                onClick={onVerbClick(command)}>
                <span className="grid-item-text">{command}</span>
              </a>
            ))}
          </div>
        </Fragment>
      ))}
    </Fragment>
  );
}

function DebugPanel() {
  const s = useStatState();
  const visibleVerbTabs = s.verbTabs.filter((vt) => {
    if (vt.lastIndexOf('.') === -1) return true;
    const split = vt.split('.');
    return s.splitAdminTabs && split[0] === 'Admin';
  });
  const displayName = (vt) => {
    if (vt.lastIndexOf('.') === -1) return vt;
    const split = vt.split('.');
    return s.splitAdminTabs && split[0] === 'Admin' ? split[1] : vt;
  };
  return (
    <Fragment>
      <div><a onClick={wipeVerbs}>Wipe All Verbs</a></div>
      <div><a onClick={updateVerbs}>Wipe and Update All Verbs</a></div>
      <div>Verb Tabs:</div>
      <table>
        {visibleVerbTabs.map((vt, i) => (
          <tr key={i}>
            <td>
              {displayName(vt)}
              <a onClick={() => removeStatusTab(displayName(vt))}> Delete Tab {displayName(vt)}</a>
            </td>
          </tr>
        ))}
      </table>
      <div>Verbs:</div>
      <table>
        {s.verbs.map((part, i) => (
          <tr key={i}><td>{part[0]}</td><td>{part[1]}</td></tr>
        ))}
      </table>
      <div>Permanent Tabs:</div>
      <table>
        {s.permanentTabs.map((pt, i) => (
          <tr key={i}><td>{pt}</td></tr>
        ))}
      </table>
    </Fragment>
  );
}

const TAB_ORDER = { 'Round Info': 1, Stats: 2, MC: 3 };

function tabDisplayName(name, splitAdminTabs) {
  if (name.indexOf('.') === -1) return name;
  const split = name.split('.');
  if (splitAdminTabs && split[0] === 'Admin') return split[1];
  return split[0];
}

function TabBar() {
  const s = useStatState();
  const allTabs = useMemo(() => {
    const seen = new Set();
    const result = [];
    for (const t of [...s.permanentTabs, ...s.verbTabs]) {
      const display = tabDisplayName(t, s.splitAdminTabs);
      if (display.trim() === '' || seen.has(display)) continue;
      if (
        !s.permanentTabs.includes(t) &&
        t.lastIndexOf('.') !== -1 &&
        !(s.splitAdminTabs && t.split('.')[0] === 'Admin')
      ) continue;
      seen.add(display);
      result.push(display);
    }
    result.sort((a, b) => {
      const oa = TAB_ORDER[a] ?? a.charCodeAt(0);
      const ob = TAB_ORDER[b] ?? b.charCodeAt(0);
      return oa - ob;
    });
    return result;
  }, [s.permanentTabs, s.verbTabs, s.splitAdminTabs]);

  const onTabClick = (name) => (e) => {
    if (name === state.currentTab) {
      e.preventDefault();
      return;
    }
    tabChange(name);
    e.currentTarget.blur();
    document.getElementById('statcontent')?.focus();
  };

  return (
    <div id="menu" className="menu-wrap">
      {allTabs.map((name) => (
        <div
          key={name}
          id={name}
          className={'button' + (s.currentTab === name ? ' active' : '')}
          style={{ order: TAB_ORDER[name] || name.charCodeAt(0) }}
          onClick={onTabClick(name)}
        >
          {name}
        </div>
      ))}
    </div>
  );
}

function StatContent() {
  const s = useStatState();
  let className = 'statcontent';
  let body;

  if (s.currentTab === 'Round Info') {
    body = <RoundInfoPanel />;
  } else if (s.currentTab === 'Stats') {
    body = <StatsPanel />;
  } else if (s.currentTab === 'MC') {
    className = 'mcstatcontent';
    body = <MCPanel />;
  } else if (s.currentTab === 'Debug Stat Panel') {
    body = <DebugPanel />;
  } else if (s.currentTab === 'Tickets') {
    body = <TicketsPanel />;
  } else if (s.currentTab === 'SDQL2') {
    body = <SDQL2Panel />;
  } else if (s.verbTabs.includes(s.currentTab)) {
    body = <VerbsPanel cat={s.currentTab} />;
  } else {
    body = <BrailleSpinner />;
  }

  return (
    <div id="statcontent" className={className} tabIndex={-1}>
      {body}
    </div>
  );
}

function App() {
  return (
    <div className="stat-container">
      <TabBar />
      <StatContent />
    </div>
  );
}

function set_theme(which) {
  if (which == 'light') {
    document.body.className = '';
    document.documentElement.className = 'light';
  } else if (which == 'dark') {
    document.body.className = 'dark';
    document.documentElement.className = 'dark';
  }
}
function set_font_size(size) {
  document.body.style.setProperty('font-size', size);
}
function set_tabs_style(style) {
  const menu = document.getElementById('menu');
  if (!menu) return;
  if (style == 'default') {
    menu.classList.add('menu-wrap');
    menu.classList.remove('tabs-classic');
  } else if (style == 'classic') {
    menu.classList.add('menu-wrap');
    menu.classList.add('tabs-classic');
  } else if (style == 'scrollable') {
    menu.classList.remove('menu-wrap');
    menu.classList.remove('tabs-classic');
  }
}
function restoreFocus() {
  if (document.activeElement && document.activeElement.tagName === 'INPUT') return;
  runAfterFocus(() => Byond.winset('map', { focus: true }));
}
function getCookie(cname) {
  var name = cname + '=';
  var ca = document.cookie.split(';');
  for (var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') c = c.substring(1);
    if (c.indexOf(name) === 0) return decoder(c.substring(name.length, c.length));
  }
  return '';
}

document.addEventListener('mouseup', restoreFocus);
document.addEventListener('keyup', restoreFocus);
document.addEventListener('wheel', (e) => { if (e.ctrlKey) e.preventDefault(); }, { passive: false });

if (!state.currentTab) {
  state.permanentTabs = [defaultTab];
  state.currentTab = defaultTab;
}

window.onload = () => {
  Byond.sendMessage('Update-Verbs');
};

Byond.subscribeTo('remove_verb_list', (toRemove) => {
  let verbs = state.verbs;
  toRemove.forEach((v) => { verbs = removeVerb(v, verbs); });
  setState({ verbs });
  checkVerbs();
  setState({ verbs: sortVerbs(state.verbs) });
});

Byond.subscribeTo('init_verbs', (payload) => {
  wipeVerbs();
  let verbTabs = [...payload.panel_tabs].sort();
  setState({ verbTabs });
  if (payload.verblist) {
    addVerbList(payload.verblist);
    setState({ verbs: sortVerbs(state.verbs) });
  }
  sendTabsToByond();
});

Byond.subscribeTo('update_stat', (payload) => {
  const parts = [];
  for (const p of payload.global_data) if (p != null) parts.push(p);
  if (payload.ping_str) parts.push(payload.ping_str);
  for (const p of payload.other_str) if (p != null) parts.push(p);
  setState({ statusTabParts: parts });
});

Byond.subscribeTo('update_stats', (payload) => setState({ statsTabParts: payload }));

Byond.subscribeTo('add_stats_tab', () => addPermanentTab('Stats'));

Byond.subscribeTo('remove_stats_tab', () => {
  removePermanentTab('Stats');
  if (state.currentTab === 'Stats') tabChange(defaultTab);
});

Byond.subscribeTo('update_mc', (payload) => {
  const mcTabParts = [['', 'Location:', payload.coord_entry], ...payload.mc_data];
  let verbTabs = state.verbTabs;
  if (!verbTabs.includes('MC')) verbTabs = [...verbTabs, 'MC'];
  setState({ mcTabParts, verbTabs });
});

Byond.subscribeTo('create_debug', () => {
  if (!state.permanentTabs.includes('Debug Stat Panel')) {
    addPermanentTab('Debug Stat Panel');
  } else {
    removePermanentTab('Debug Stat Panel');
  }
});

Byond.subscribeTo('remove_admin_tabs', () => {
  setState({ hrefToken: null });
  removePermanentTab('MC');
  if (state.currentTab === 'MC') tabChange(defaultTab);
  removePermanentTab('Tickets');
  setState({ tickets: [] });
  if (state.currentTab === 'Tickets') tabChange(defaultTab);
  removePermanentTab('SDQL2');
  setState({ sdql2: [] });
  if (state.currentTab === 'SDQL2') tabChange(defaultTab);
});

Byond.subscribeTo('update_split_admin_tabs', (status) => {
  status = status === true;
  if (state.splitAdminTabs !== status) {
    if (state.splitAdminTabs === true) {
      removeStatusTab('Events');
      removeStatusTab('Fun');
      removeStatusTab('Game');
    }
    updateVerbs();
  }
  setState({ splitAdminTabs: status });
});

Byond.subscribeTo('set_theme', (payload) => set_theme(payload));

set_theme('dark');

Byond.subscribeTo('add_admin_tabs', (ht) => {
  setState({ hrefToken: ht });
  addPermanentTab('MC');
  addPermanentTab('Tickets');
});

Byond.subscribeTo('update_sdql2', (S) => {
  let verbTabs = state.verbTabs;
  let permanentTabs = state.permanentTabs;
  if (S.length > 0 && !verbTabs.includes('SDQL2')) {
    verbTabs = [...verbTabs, 'SDQL2'];
    if (!permanentTabs.includes('SDQL2')) permanentTabs = [...permanentTabs, 'SDQL2'];
  }
  setState({ sdql2: S, verbTabs, permanentTabs });
});

Byond.subscribeTo('update_tickets', (T) => {
  let verbTabs = state.verbTabs;
  let permanentTabs = state.permanentTabs;
  if (!verbTabs.includes('Tickets')) {
    verbTabs = [...verbTabs, 'Tickets'];
    if (!permanentTabs.includes('Tickets')) permanentTabs = [...permanentTabs, 'Tickets'];
  }
  setState({ tickets: T, verbTabs, permanentTabs });
});

Byond.subscribeTo('remove_sdql2', () => {
  setState({ sdql2: [] });
  removePermanentTab('SDQL2');
  if (state.currentTab === 'SDQL2') tabChange(defaultTab);
});

Byond.subscribeTo('remove_mc', () => {
  removePermanentTab('MC');
  if (state.currentTab === 'MC') tabChange(defaultTab);
});

Byond.subscribeTo('add_verb_list', (v) => addVerbList(v));

render(<App />, document.getElementById('app'));

window.set_theme = set_theme;
window.set_font_size = set_font_size;
window.set_tabs_style = set_tabs_style;
window.getCookie = getCookie;
