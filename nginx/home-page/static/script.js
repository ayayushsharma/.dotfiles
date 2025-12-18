const apps = [
    { name: "Excalidraw", url: "http://draw.localhost" },
    { name: "Swagger Editor (Next Gen)", url: "http://swagger.localhost" },
    { name: "Swagger Editor (Legacy)", url: "http://legacy.swagger.localhost" },
    { name: "DrawSQL", url: "http://sqldraw.localhost" },
];

function fuzzyMatch(str, pattern) {
    pattern = pattern.split('').reduce((a, b) => a + '.*' + b);
    return new RegExp(pattern, 'i').test(str);
}

const searchBar = document.getElementById('searchBar');
const appList = document.getElementById('appList');
let filteredApps = apps;
let selectedIndex = 0;

function renderApps() {
    appList.innerHTML = '';
    filteredApps.forEach((app, idx) => {
        const li = document.createElement('li');
        if (idx === selectedIndex) li.classList.add('selected');
        const a = document.createElement('a');
        a.href = app.url;
        a.textContent = app.name;
        li.appendChild(a);
        appList.appendChild(li);
    });
}

function filterApps() {
    const query = searchBar.value.trim();
    if (!query) {
        filteredApps = apps;
    } else {
        filteredApps = apps.filter(app => fuzzyMatch(app.name, query));
    }
    selectedIndex = 0;
    renderApps();
}

searchBar.addEventListener('input', filterApps);

searchBar.addEventListener('keydown', function(e) {
    if (filteredApps.length === 0) return;
    if (e.key === 'ArrowDown') {
        selectedIndex = (selectedIndex + 1) % filteredApps.length;
        renderApps();
        e.preventDefault();
    } else if (e.key === 'ArrowUp') {
        selectedIndex = (selectedIndex - 1 + filteredApps.length) % filteredApps.length;
        renderApps();
        e.preventDefault();
    } else if (e.key === 'Enter') {
        window.location.href = filteredApps[selectedIndex].url;
    }
});

// Initial render
renderApps();

// Focus the search bar on page load
window.onload = function() {
    searchBar.focus();
};

// Dark Mode
const darkModeToggle = document.getElementById('darkModeToggle');
let darkMode = false;

if (localStorage.getItem('darkMode') === 'true') {
    document.body.classList.add('dark-mode');
    darkMode = true;
    darkModeToggle.textContent = '☀️';
}

darkModeToggle.addEventListener('click', function() {
    darkMode = !darkMode;
    if (darkMode) {
        document.body.classList.add('dark-mode');
        darkModeToggle.textContent = '☀️';
    } else {
        document.body.classList.remove('dark-mode');
        darkModeToggle.textContent = '🌙';
    }
    localStorage.setItem('darkMode', darkMode);
});
