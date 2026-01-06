/* ========================================
   cIAra Mobility - Database Visualizer
   Enhanced Interactive JavaScript Application
   ======================================== */

// ========== Global State ==========
let vehiclesData = [];
let filteredData = [];
let currentPage = 1;
const itemsPerPage = 15;
let currentSort = { field: 'id', direction: 'asc' };
let charts = {};

// City coordinates for France hexagon map (flat-top orientation)
const cityCoordinates = {
    'Paris': { x: 320, y: 200, color: '#00d4ff' },
    'Lyon': { x: 400, y: 320, color: '#a855f7' },
    'Marseille': { x: 380, y: 430, color: '#ec4899' },
    'Bordeaux': { x: 160, y: 360, color: '#22c55e' },
    'Lille': { x: 350, y: 130, color: '#f97316' },
    'Nantes': { x: 140, y: 260, color: '#eab308' },
    'Toulouse': { x: 250, y: 420, color: '#06b6d4' },
    'Nice': { x: 480, y: 380, color: '#8b5cf6' },
    'Strasbourg': { x: 480, y: 180, color: '#14b8a6' },
    'Montpellier': { x: 320, y: 400, color: '#f43f5e' }
};

// ========== Initialize Application ==========
document.addEventListener('DOMContentLoaded', async () => {
    // Initialize Mermaid
    mermaid.initialize({
        startOnLoad: false,
        theme: 'dark',
        themeVariables: {
            primaryColor: '#1a1a3e',
            primaryTextColor: '#ffffff',
            primaryBorderColor: '#00d4ff',
            lineColor: '#a855f7',
            secondaryColor: '#12122a',
            tertiaryColor: '#0a0a1a'
        }
    });

    // Create background particles
    createParticles();

    // Set current date
    setCurrentDate();

    // Initialize theme
    initTheme();

    // Initialize mobile menu
    initMobileMenu();

    // Initialize keyboard shortcuts
    initKeyboardShortcuts();

    // Load CSV data
    await loadVehiclesData();

    // Initialize navigation
    initNavigation();

    // Initialize charts
    initCharts();

    // Initialize filters
    initFilters();

    // Initialize table sorting
    initTableSorting();

    // Initialize view toggle
    initViewToggle();

    // Initialize France map
    initFranceMap();

    // Hide loading screen
    hideLoadingScreen();

    // Animate KPI counters
    animateCounters();

    // Hide skeleton loaders
    hideSkeletons();

    // Show welcome toast
    showToast('Dashboard chargé avec succès!', 'success');
});

// ========== Loading Screen ==========
function hideLoadingScreen() {
    const loadingScreen = document.getElementById('loadingScreen');
    if (loadingScreen) {
        setTimeout(() => {
            loadingScreen.classList.add('hidden');
        }, 800);
    }
}

// ========== Skeleton Loaders ==========
function hideSkeletons() {
    setTimeout(() => {
        document.querySelectorAll('.skeleton-loader').forEach(skeleton => {
            skeleton.classList.add('hidden');
        });
        document.querySelectorAll('.skeleton-row').forEach(row => {
            row.remove();
        });
    }, 1000);
}

// ========== Toast Notifications ==========
function showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const icons = {
        success: 'fa-check-circle',
        info: 'fa-info-circle',
        warning: 'fa-exclamation-triangle',
        error: 'fa-times-circle'
    };

    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `
        <i class="fas ${icons[type]}"></i>
        <span class="toast-message">${message}</span>
    `;

    container.appendChild(toast);

    // Remove after animation
    setTimeout(() => {
        toast.remove();
    }, 3000);
}

// ========== Theme Toggle ==========
function initTheme() {
    const themeToggle = document.getElementById('themeToggle');
    const savedTheme = localStorage.getItem('ciara-theme') || 'dark';

    document.documentElement.setAttribute('data-theme', savedTheme);

    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';

            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('ciara-theme', newTheme);

            // Update charts for new theme
            updateChartsTheme(newTheme);

            showToast(`Thème ${newTheme === 'dark' ? 'sombre' : 'clair'} activé`, 'info');
        });
    }
}

function updateChartsTheme(theme) {
    const textColor = theme === 'dark' ? 'rgba(255, 255, 255, 0.7)' : 'rgba(26, 26, 46, 0.7)';
    const gridColor = theme === 'dark' ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.05)';

    Chart.defaults.color = textColor;
    Chart.defaults.borderColor = gridColor;

    // Update existing charts
    Object.values(charts).forEach(chart => {
        if (chart.options.scales) {
            if (chart.options.scales.x) {
                chart.options.scales.x.grid = { color: gridColor };
                chart.options.scales.x.ticks = { color: textColor };
            }
            if (chart.options.scales.y) {
                chart.options.scales.y.grid = { color: gridColor };
                chart.options.scales.y.ticks = { color: textColor };
            }
        }
        if (chart.options.plugins && chart.options.plugins.legend) {
            chart.options.plugins.legend.labels = { color: textColor };
        }
        chart.update();
    });
}

// ========== Mobile Menu ==========
function initMobileMenu() {
    const toggle = document.getElementById('mobileMenuToggle');
    const navLinks = document.getElementById('navLinks');

    if (toggle && navLinks) {
        toggle.addEventListener('click', () => {
            toggle.classList.toggle('active');
            navLinks.classList.toggle('active');
        });

        // Close menu when clicking a link
        navLinks.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                toggle.classList.remove('active');
                navLinks.classList.remove('active');
            });
        });
    }
}

// ========== Keyboard Shortcuts ==========
function initKeyboardShortcuts() {
    const modal = document.getElementById('shortcutsModal');
    const closeBtn = document.getElementById('closeShortcuts');

    document.addEventListener('keydown', (e) => {
        // Ignore if typing in input
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.tagName === 'SELECT') {
            // Allow Escape to close modal
            if (e.key === 'Escape') {
                modal?.classList.remove('active');
                e.target.blur();
            }
            return;
        }

        switch (e.key) {
            case '1':
                showSection('dashboard');
                updateActiveNavLink('dashboard');
                showToast('Dashboard', 'info');
                break;
            case '2':
                showSection('map');
                updateActiveNavLink('map');
                showToast('Carte de France', 'info');
                break;
            case '3':
                showSection('fleet');
                updateActiveNavLink('fleet');
                showToast('Explorateur de Flotte', 'info');
                break;
            case '4':
                showSection('schema');
                updateActiveNavLink('schema');
                showToast('Schéma DB', 'info');
                break;
            case 't':
            case 'T':
                document.getElementById('themeToggle')?.click();
                break;
            case '/':
                e.preventDefault();
                document.getElementById('searchInput')?.focus();
                showSection('fleet');
                updateActiveNavLink('fleet');
                break;
            case '?':
                modal?.classList.add('active');
                break;
            case 'Escape':
                modal?.classList.remove('active');
                break;
        }
    });

    // Close modal on button click
    closeBtn?.addEventListener('click', () => {
        modal?.classList.remove('active');
    });

    // Close modal on backdrop click
    modal?.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.classList.remove('active');
        }
    });
}

function updateActiveNavLink(sectionId) {
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
        if (link.dataset.section === sectionId) {
            link.classList.add('active');
        }
    });
}

// ========== Background Particles ==========
function createParticles() {
    const container = document.getElementById('particles');
    if (!container) return;

    for (let i = 0; i < 30; i++) {
        const particle = document.createElement('div');
        particle.className = 'particle';
        particle.style.left = Math.random() * 100 + '%';
        particle.style.top = Math.random() * 100 + '%';
        particle.style.animationDelay = Math.random() * 15 + 's';
        particle.style.animationDuration = (10 + Math.random() * 10) + 's';
        container.appendChild(particle);
    }
}

// ========== Date Display ==========
function setCurrentDate() {
    const dateEl = document.getElementById('currentDate');
    if (dateEl) {
        const now = new Date();
        dateEl.textContent = now.toLocaleDateString('fr-FR', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }
}

// ========== Load CSV Data ==========
async function loadVehiclesData() {
    try {
        const response = await fetch('../data/vehicules_cIara_2025.csv');
        const csvText = await response.text();
        vehiclesData = parseCSV(csvText);
        filteredData = [...vehiclesData];

        // Update KPI counts
        updateKPICounts();

        // Populate filters
        populateFilters();

        // Render initial table
        renderTable();

    } catch (error) {
        console.error('Error loading CSV:', error);
        showToast('Erreur de chargement des données', 'error');
        generateSampleData();
    }
}

function parseCSV(csvText) {
    const lines = csvText.trim().split('\n');
    const headers = lines[0].split(',').map(h => h.trim().replace(/\r/g, ''));

    return lines.slice(1).map(line => {
        const values = line.split(',').map(v => v.trim().replace(/\r/g, ''));
        const obj = {};
        headers.forEach((header, index) => {
            obj[header] = values[index] || '';
        });
        return obj;
    });
}

function generateSampleData() {
    const brands = ['Tesla', 'Renault', 'Peugeot', 'Mercedes', 'BMW', 'Volkswagen', 'Kia', 'Hyundai'];
    const models = ['Model 3', 'Zoe', 'e-208', 'EQA', 'iX1', 'ID.4', 'EV6', 'Ioniq 5'];
    const cities = Object.keys(cityCoordinates);
    const states = ['Disponible', 'En service', 'En maintenance', 'Hors service'];

    vehiclesData = Array.from({ length: 200 }, (_, i) => ({
        id: String(i + 1),
        marque: brands[Math.floor(Math.random() * brands.length)],
        modele: models[Math.floor(Math.random() * models.length)],
        annee: String(2021 + Math.floor(Math.random() * 4)),
        energie: 'Electrique',
        autonomie_km: String(250 + Math.floor(Math.random() * 350)),
        immatriculation: generatePlate(),
        etat: states[Math.floor(Math.random() * states.length)],
        localisation: cities[Math.floor(Math.random() * cities.length)]
    }));

    filteredData = [...vehiclesData];
    updateKPICounts();
    populateFilters();
    renderTable();
}

function generatePlate() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetter = () => letters[Math.floor(Math.random() * letters.length)];
    const randomNum = () => Math.floor(Math.random() * 10);
    return `${randomLetter()}${randomLetter()}-${randomNum()}${randomNum()}${randomNum()}-${randomLetter()}${randomLetter()}`;
}

// ========== Update KPI Counts ==========
function updateKPICounts() {
    const available = vehiclesData.filter(v => v.etat === 'Disponible').length;
    const maintenance = vehiclesData.filter(v => v.etat === 'En maintenance').length;

    const availableEl = document.getElementById('available-count');
    const maintenanceEl = document.getElementById('maintenance-count');

    if (availableEl) availableEl.dataset.count = available;
    if (maintenanceEl) maintenanceEl.dataset.count = maintenance;
}

// ========== Animate Counters ==========
function animateCounters() {
    const counters = document.querySelectorAll('.kpi-value[data-count]');

    counters.forEach(counter => {
        const target = parseInt(counter.dataset.count);
        const duration = 2000;
        const step = target / (duration / 16);
        let current = 0;

        const updateCounter = () => {
            current += step;
            if (current < target) {
                counter.textContent = Math.floor(current);
                requestAnimationFrame(updateCounter);
            } else {
                counter.textContent = target;
            }
        };

        setTimeout(updateCounter, 500);
    });
}

// ========== Navigation ==========
function initNavigation() {
    const navLinks = document.querySelectorAll('.nav-link');

    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();

            navLinks.forEach(l => l.classList.remove('active'));
            link.classList.add('active');

            const sectionId = link.dataset.section;
            showSection(sectionId);
        });
    });
}

function showSection(sectionId) {
    const sections = document.querySelectorAll('.section');
    sections.forEach(section => {
        section.classList.remove('active');
    });

    const targetSection = document.getElementById(sectionId);
    if (targetSection) {
        targetSection.classList.add('active');

        if (sectionId === 'schema') {
            renderMermaid();
        }
        if (sectionId === 'map') {
            initFranceMap();
        }
    }
}

// ========== France Map ==========
function initFranceMap() {
    const markersContainer = document.getElementById('cityMarkers');
    const legendContainer = document.getElementById('mapLegend');

    if (!markersContainer || !legendContainer) return;

    // Clear existing markers
    markersContainer.innerHTML = '';
    legendContainer.innerHTML = '<h4 style="margin-bottom: 0.5rem; font-size: 0.9rem;">Légende</h4>';

    // Count vehicles by city
    const cityCounts = {};
    vehiclesData.forEach(v => {
        cityCounts[v.localisation] = (cityCounts[v.localisation] || 0) + 1;
    });

    // Create markers for each city
    Object.entries(cityCoordinates).forEach(([city, coords]) => {
        const count = cityCounts[city] || 0;
        const radius = Math.max(15, Math.min(35, 10 + count / 3));

        const marker = document.createElementNS('http://www.w3.org/2000/svg', 'g');
        marker.setAttribute('class', 'city-marker');
        marker.setAttribute('data-city', city);
        marker.innerHTML = `
            <circle cx="${coords.x}" cy="${coords.y}" r="${radius}" fill="${coords.color}" opacity="0.8"/>
            <circle cx="${coords.x}" cy="${coords.y}" r="${radius + 5}" fill="${coords.color}" opacity="0.2"/>
            <text x="${coords.x}" y="${coords.y - radius - 8}" text-anchor="middle" fill="currentColor" style="font-size: 11px; font-weight: 600;">${city}</text>
            <text x="${coords.x}" y="${coords.y + 4}" class="vehicle-count">${count}</text>
        `;

        marker.addEventListener('click', () => selectCity(city));
        marker.addEventListener('mouseenter', () => {
            marker.style.transform = `translate(${coords.x}px, ${coords.y}px) scale(1.1) translate(-${coords.x}px, -${coords.y}px)`;
        });
        marker.addEventListener('mouseleave', () => {
            marker.style.transform = '';
        });

        markersContainer.appendChild(marker);

        // Add to legend
        const legendItem = document.createElement('div');
        legendItem.className = 'legend-item';
        legendItem.innerHTML = `
            <span class="legend-dot" style="background: ${coords.color}"></span>
            <span>${city}: ${count}</span>
        `;
        legendItem.style.cursor = 'pointer';
        legendItem.addEventListener('click', () => selectCity(city));
        legendContainer.appendChild(legendItem);
    });
}

function selectCity(cityName) {
    const panel = document.getElementById('cityDetailsPanel');
    const titleEl = document.getElementById('selectedCityName');
    const statsEl = document.getElementById('cityStats');

    if (!panel || !titleEl || !statsEl) return;

    titleEl.textContent = cityName;

    // Get vehicles for this city
    const cityVehicles = vehiclesData.filter(v => v.localisation === cityName);
    const available = cityVehicles.filter(v => v.etat === 'Disponible').length;
    const inService = cityVehicles.filter(v => v.etat === 'En service').length;
    const maintenance = cityVehicles.filter(v => v.etat === 'En maintenance').length;
    const outOfService = cityVehicles.filter(v => v.etat === 'Hors service').length;

    // Get top brands
    const brandCounts = {};
    cityVehicles.forEach(v => {
        brandCounts[v.marque] = (brandCounts[v.marque] || 0) + 1;
    });
    const topBrands = Object.entries(brandCounts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 3)
        .map(([brand, count]) => `${brand} (${count})`)
        .join(', ');

    // Average autonomy
    const avgAutonomy = Math.round(
        cityVehicles.reduce((sum, v) => sum + parseInt(v.autonomie_km), 0) / cityVehicles.length
    );

    statsEl.innerHTML = `
        <div class="stat-item">
            <span class="stat-label"><i class="fas fa-car"></i> Total</span>
            <span class="stat-value">${cityVehicles.length}</span>
        </div>
        <div class="stat-item">
            <span class="stat-label"><i class="fas fa-check-circle"></i> Disponibles</span>
            <span class="stat-value green">${available}</span>
        </div>
        <div class="stat-item">
            <span class="stat-label"><i class="fas fa-road"></i> En service</span>
            <span class="stat-value cyan">${inService}</span>
        </div>
        <div class="stat-item">
            <span class="stat-label"><i class="fas fa-wrench"></i> Maintenance</span>
            <span class="stat-value yellow">${maintenance}</span>
        </div>
        <div class="stat-item">
            <span class="stat-label"><i class="fas fa-times-circle"></i> Hors service</span>
            <span class="stat-value pink">${outOfService}</span>
        </div>
        <div class="stat-item">
            <span class="stat-label"><i class="fas fa-battery-three-quarters"></i> Autonomie moy.</span>
            <span class="stat-value">${avgAutonomy} km</span>
        </div>
        <div class="stat-item" style="flex-direction: column; align-items: flex-start;">
            <span class="stat-label"><i class="fas fa-industry"></i> Top marques</span>
            <span style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 0.25rem;">${topBrands || 'N/A'}</span>
        </div>
    `;

    showToast(`${cityName}: ${cityVehicles.length} véhicules`, 'info');
}

// ========== Mermaid Diagram ==========
let mermaidRendered = false;

async function renderMermaid() {
    if (mermaidRendered) return;

    const mermaidEl = document.getElementById('erDiagram');
    if (!mermaidEl) return;

    try {
        await mermaid.run({ nodes: [mermaidEl] });
        mermaidRendered = true;
    } catch (error) {
        console.error('Mermaid render error:', error);
    }
}

// ========== Charts ==========
function initCharts() {
    const theme = document.documentElement.getAttribute('data-theme') || 'dark';
    const textColor = theme === 'dark' ? 'rgba(255, 255, 255, 0.7)' : 'rgba(26, 26, 46, 0.7)';

    Chart.defaults.color = textColor;
    Chart.defaults.borderColor = 'rgba(255, 255, 255, 0.1)';
    Chart.defaults.font.family = "'Inter', sans-serif";

    createCityChart();
    createStatusChart();
    createBrandChart();
    createAutonomyChart();
}

function createCityChart() {
    const ctx = document.getElementById('cityChart');
    if (!ctx) return;

    const cityCounts = {};
    vehiclesData.forEach(v => {
        cityCounts[v.localisation] = (cityCounts[v.localisation] || 0) + 1;
    });

    const sortedCities = Object.entries(cityCounts).sort((a, b) => b[1] - a[1]);

    charts.city = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: sortedCities.map(c => c[0]),
            datasets: [{
                label: 'Véhicules',
                data: sortedCities.map(c => c[1]),
                backgroundColor: sortedCities.map((_, i) => {
                    const colors = ['#00d4ff', '#a855f7', '#ec4899', '#22c55e', '#f97316', '#eab308', '#06b6d4', '#8b5cf6', '#14b8a6', '#f43f5e'];
                    return colors[i % colors.length] + 'cc';
                }),
                borderRadius: 8,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(10, 10, 26, 0.9)',
                    borderColor: 'rgba(0, 212, 255, 0.3)',
                    borderWidth: 1,
                    padding: 12,
                    callbacks: {
                        label: (ctx) => `${ctx.parsed.y} véhicules`
                    }
                }
            },
            scales: {
                x: { grid: { display: false }, ticks: { font: { size: 11 } } },
                y: { beginAtZero: true, grid: { color: 'rgba(255, 255, 255, 0.05)' }, ticks: { precision: 0 } }
            },
            animation: { duration: 1500, easing: 'easeOutQuart' }
        }
    });
}

function createStatusChart() {
    const ctx = document.getElementById('statusChart');
    if (!ctx) return;

    const statusCounts = { 'Disponible': 0, 'En service': 0, 'En maintenance': 0, 'Hors service': 0 };
    vehiclesData.forEach(v => {
        if (statusCounts.hasOwnProperty(v.etat)) statusCounts[v.etat]++;
    });

    charts.status = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(statusCounts),
            datasets: [{
                data: Object.values(statusCounts),
                backgroundColor: ['#22c55ecc', '#00d4ffcc', '#eab308cc', '#ec4899cc'],
                borderWidth: 0,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '65%',
            plugins: {
                legend: { position: 'bottom', labels: { padding: 15, usePointStyle: true, pointStyle: 'circle', font: { size: 11 } } },
                tooltip: {
                    backgroundColor: 'rgba(10, 10, 26, 0.9)',
                    borderColor: 'rgba(0, 212, 255, 0.3)',
                    borderWidth: 1,
                    padding: 12,
                    callbacks: {
                        label: (ctx) => {
                            const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
                            const percent = ((ctx.parsed / total) * 100).toFixed(1);
                            return ` ${ctx.parsed} véhicules (${percent}%)`;
                        }
                    }
                }
            },
            animation: { animateRotate: true, animateScale: true, duration: 1500, easing: 'easeOutQuart' }
        }
    });
}

function createBrandChart() {
    const ctx = document.getElementById('brandChart');
    if (!ctx) return;

    const brandCounts = {};
    vehiclesData.forEach(v => { brandCounts[v.marque] = (brandCounts[v.marque] || 0) + 1; });

    const sortedBrands = Object.entries(brandCounts).sort((a, b) => b[1] - a[1]).slice(0, 10);

    charts.brand = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: sortedBrands.map(b => b[0]),
            datasets: [{
                label: 'Véhicules',
                data: sortedBrands.map(b => b[1]),
                backgroundColor: 'rgba(168, 85, 247, 0.7)',
                borderColor: 'rgba(168, 85, 247, 1)',
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { beginAtZero: true, grid: { color: 'rgba(255, 255, 255, 0.05)' }, ticks: { precision: 0 } },
                y: { grid: { display: false }, ticks: { font: { size: 11 } } }
            },
            animation: { duration: 1500, easing: 'easeOutQuart' }
        }
    });
}

function createAutonomyChart() {
    const ctx = document.getElementById('autonomyChart');
    if (!ctx) return;

    const ranges = { '250-350 km': 0, '350-450 km': 0, '450-550 km': 0, '550+ km': 0 };
    vehiclesData.forEach(v => {
        const autonomy = parseInt(v.autonomie_km);
        if (autonomy < 350) ranges['250-350 km']++;
        else if (autonomy < 450) ranges['350-450 km']++;
        else if (autonomy < 550) ranges['450-550 km']++;
        else ranges['550+ km']++;
    });

    charts.autonomy = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: Object.keys(ranges),
            datasets: [{
                label: 'Véhicules',
                data: Object.values(ranges),
                backgroundColor: ['#f97316cc', '#eab308cc', '#22c55ecc', '#00d4ffcc'],
                borderRadius: 8,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false }, ticks: { font: { weight: '500' } } },
                y: { beginAtZero: true, grid: { color: 'rgba(255, 255, 255, 0.05)' }, ticks: { precision: 0 } }
            },
            animation: { duration: 1500, easing: 'easeOutQuart' }
        }
    });
}

// ========== Filters ==========
function initFilters() {
    const searchInput = document.getElementById('searchInput');
    const statusFilter = document.getElementById('filterStatus');
    const cityFilter = document.getElementById('filterCity');
    const brandFilter = document.getElementById('filterBrand');
    const resetBtn = document.getElementById('resetFilters');

    if (searchInput) searchInput.addEventListener('input', debounce(applyFilters, 300));
    if (statusFilter) statusFilter.addEventListener('change', applyFilters);
    if (cityFilter) cityFilter.addEventListener('change', applyFilters);
    if (brandFilter) brandFilter.addEventListener('change', applyFilters);
    if (resetBtn) resetBtn.addEventListener('click', resetFilters);
}

function populateFilters() {
    const cityFilter = document.getElementById('filterCity');
    const brandFilter = document.getElementById('filterBrand');

    const cities = [...new Set(vehiclesData.map(v => v.localisation))].sort();
    if (cityFilter) {
        cities.forEach(city => {
            const option = document.createElement('option');
            option.value = city;
            option.textContent = city;
            cityFilter.appendChild(option);
        });
    }

    const brands = [...new Set(vehiclesData.map(v => v.marque))].sort();
    if (brandFilter) {
        brands.forEach(brand => {
            const option = document.createElement('option');
            option.value = brand;
            option.textContent = brand;
            brandFilter.appendChild(option);
        });
    }
}

function applyFilters() {
    const searchTerm = document.getElementById('searchInput')?.value.toLowerCase() || '';
    const statusValue = document.getElementById('filterStatus')?.value || '';
    const cityValue = document.getElementById('filterCity')?.value || '';
    const brandValue = document.getElementById('filterBrand')?.value || '';

    filteredData = vehiclesData.filter(vehicle => {
        const matchesSearch = !searchTerm ||
            vehicle.marque.toLowerCase().includes(searchTerm) ||
            vehicle.modele.toLowerCase().includes(searchTerm) ||
            vehicle.immatriculation.toLowerCase().includes(searchTerm) ||
            vehicle.localisation.toLowerCase().includes(searchTerm);

        const matchesStatus = !statusValue || vehicle.etat === statusValue;
        const matchesCity = !cityValue || vehicle.localisation === cityValue;
        const matchesBrand = !brandValue || vehicle.marque === brandValue;

        return matchesSearch && matchesStatus && matchesCity && matchesBrand;
    });

    currentPage = 1;
    renderTable();
    renderCards();
    updateResultsCount();

    if (filteredData.length !== vehiclesData.length) {
        showToast(`${filteredData.length} résultats trouvés`, 'info');
    }
}

function resetFilters() {
    document.getElementById('searchInput').value = '';
    document.getElementById('filterStatus').value = '';
    document.getElementById('filterCity').value = '';
    document.getElementById('filterBrand').value = '';

    filteredData = [...vehiclesData];
    currentPage = 1;
    renderTable();
    renderCards();
    updateResultsCount();
    showToast('Filtres réinitialisés', 'success');
}

function updateResultsCount() {
    const countEl = document.getElementById('resultsCount');
    if (countEl) {
        countEl.textContent = `${filteredData.length} véhicule${filteredData.length !== 1 ? 's' : ''}`;
    }
}

// ========== Table Rendering ==========
function renderTable() {
    const tbody = document.getElementById('vehicleTableBody');
    if (!tbody) return;

    const sortedData = sortData([...filteredData], currentSort.field, currentSort.direction);
    const startIndex = (currentPage - 1) * itemsPerPage;
    const paginatedData = sortedData.slice(startIndex, startIndex + itemsPerPage);

    tbody.innerHTML = paginatedData.map(vehicle => `
        <tr>
            <td>${vehicle.id}</td>
            <td class="brand-cell">${getBrandLogo(vehicle.marque)}<span class="brand-name">${vehicle.marque}</span></td>
            <td class="model-cell">${vehicle.modele}</td>
            <td>${vehicle.annee}</td>
            <td>${vehicle.autonomie_km} km</td>
            <td>${vehicle.immatriculation}</td>
            <td>${getStatusBadge(vehicle.etat)}</td>
            <td>${vehicle.localisation}</td>
        </tr>
    `).join('');

    renderPagination();
    updateResultsCount();
}

function getStatusBadge(status) {
    const statusClasses = {
        'Disponible': 'disponible',
        'En service': 'en-service',
        'En maintenance': 'en-maintenance',
        'Hors service': 'hors-service'
    };
    const statusIcons = {
        'Disponible': '✓',
        'En service': '🚗',
        'En maintenance': '🔧',
        'Hors service': '✕'
    };
    return `<span class="status-badge ${statusClasses[status] || ''}">${statusIcons[status] || ''} ${status}</span>`;
}

function sortData(data, field, direction) {
    return data.sort((a, b) => {
        let valA = a[field];
        let valB = b[field];

        if (field === 'id' || field === 'annee' || field === 'autonomie_km') {
            valA = parseInt(valA) || 0;
            valB = parseInt(valB) || 0;
        } else {
            valA = valA?.toString().toLowerCase() || '';
            valB = valB?.toString().toLowerCase() || '';
        }

        if (valA < valB) return direction === 'asc' ? -1 : 1;
        if (valA > valB) return direction === 'asc' ? 1 : -1;
        return 0;
    });
}

function initTableSorting() {
    const headers = document.querySelectorAll('.data-table th[data-sort]');
    headers.forEach(header => {
        header.addEventListener('click', () => {
            const field = header.dataset.sort;
            if (currentSort.field === field) {
                currentSort.direction = currentSort.direction === 'asc' ? 'desc' : 'asc';
            } else {
                currentSort.field = field;
                currentSort.direction = 'asc';
            }

            headers.forEach(h => { h.querySelector('i').className = 'fas fa-sort'; });
            header.querySelector('i').className = `fas fa-sort-${currentSort.direction === 'asc' ? 'up' : 'down'}`;

            renderTable();
        });
    });
}

// ========== Cards View ==========
function initViewToggle() {
    const toggleBtns = document.querySelectorAll('.toggle-btn');
    toggleBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            toggleBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const view = btn.dataset.view;
            const tableView = document.getElementById('tableView');
            const cardsView = document.getElementById('cardsView');

            if (view === 'table') {
                tableView.style.display = 'block';
                cardsView.style.display = 'none';
            } else {
                tableView.style.display = 'none';
                cardsView.style.display = 'grid';
                renderCards();
            }
        });
    });
}

function renderCards() {
    const container = document.getElementById('cardsView');
    if (!container) return;

    const sortedData = sortData([...filteredData], currentSort.field, currentSort.direction);
    const startIndex = (currentPage - 1) * itemsPerPage;
    const paginatedData = sortedData.slice(startIndex, startIndex + itemsPerPage);

    container.innerHTML = paginatedData.map(vehicle => `
        <div class="vehicle-card">
            <div class="vehicle-card-header">
                <div class="vehicle-card-title">
                    <span class="vehicle-card-brand">${vehicle.marque}</span>
                    <span class="vehicle-card-model">${vehicle.modele}</span>
                </div>
                <span class="vehicle-card-id">#${vehicle.id}</span>
            </div>
            <div class="vehicle-card-details">
                <div class="detail-item"><span class="detail-label">Année</span><span class="detail-value">${vehicle.annee}</span></div>
                <div class="detail-item"><span class="detail-label">Autonomie</span><span class="detail-value">${vehicle.autonomie_km} km</span></div>
                <div class="detail-item"><span class="detail-label">Immatriculation</span><span class="detail-value">${vehicle.immatriculation}</span></div>
                <div class="detail-item"><span class="detail-label">Ville</span><span class="detail-value">${vehicle.localisation}</span></div>
            </div>
            <div class="vehicle-card-footer">
                ${getStatusBadge(vehicle.etat)}
                <span style="color: var(--text-muted); font-size: 0.8rem;">${vehicle.energie}</span>
            </div>
        </div>
    `).join('');
}

// ========== Pagination ==========
function renderPagination() {
    const container = document.getElementById('pagination');
    if (!container) return;

    const totalPages = Math.ceil(filteredData.length / itemsPerPage);
    let html = '';

    html += `<button ${currentPage === 1 ? 'disabled' : ''} onclick="goToPage(${currentPage - 1})"><i class="fas fa-chevron-left"></i></button>`;

    const maxVisiblePages = 5;
    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
    let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

    if (endPage - startPage < maxVisiblePages - 1) {
        startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }

    if (startPage > 1) {
        html += `<button onclick="goToPage(1)">1</button>`;
        if (startPage > 2) html += `<button disabled>...</button>`;
    }

    for (let i = startPage; i <= endPage; i++) {
        html += `<button class="${i === currentPage ? 'active' : ''}" onclick="goToPage(${i})">${i}</button>`;
    }

    if (endPage < totalPages) {
        if (endPage < totalPages - 1) html += `<button disabled>...</button>`;
        html += `<button onclick="goToPage(${totalPages})">${totalPages}</button>`;
    }

    html += `<button ${currentPage === totalPages ? 'disabled' : ''} onclick="goToPage(${currentPage + 1})"><i class="fas fa-chevron-right"></i></button>`;

    container.innerHTML = html;
}

function goToPage(page) {
    const totalPages = Math.ceil(filteredData.length / itemsPerPage);
    if (page < 1 || page > totalPages) return;

    currentPage = page;
    renderTable();
    renderCards();
    document.getElementById('fleet')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

window.goToPage = goToPage;

// ========== Utility Functions ==========
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// ========== Color Theme Picker ==========
function initColorPicker() {
    const btn = document.getElementById('colorPickerBtn');
    const dropdown = document.getElementById('colorPickerDropdown');
    const options = document.querySelectorAll('.color-option');

    // Load saved accent color
    const savedAccent = localStorage.getItem('ciara-accent') || 'cyan';
    document.documentElement.setAttribute('data-accent', savedAccent);
    options.forEach(opt => {
        opt.classList.toggle('active', opt.dataset.color === savedAccent);
    });

    // Toggle dropdown
    btn?.addEventListener('click', (e) => {
        e.stopPropagation();
        dropdown?.classList.toggle('active');
    });

    // Close dropdown on outside click
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.color-picker-wrapper')) {
            dropdown?.classList.remove('active');
        }
    });

    // Color option click
    options.forEach(option => {
        option.addEventListener('click', () => {
            const color = option.dataset.color;

            // Update active state
            options.forEach(opt => opt.classList.remove('active'));
            option.classList.add('active');

            // Apply accent color
            document.documentElement.setAttribute('data-accent', color);
            localStorage.setItem('ciara-accent', color);

            // Close dropdown
            dropdown?.classList.remove('active');

            showToast(`Thème ${option.title} appliqué`, 'success');
        });
    });
}

// ========== Advanced Search ==========
let advancedSearchState = {
    text: '',
    statuses: ['Disponible', 'En service', 'En maintenance', 'Hors service'],
    cities: [],
    brands: [],
    yearMin: null,
    yearMax: null,
    autonomyMin: null,
    autonomyMax: null
};

function initAdvancedSearch() {
    const btn = document.getElementById('advancedSearchBtn');
    const modal = document.getElementById('advancedSearchModal');
    const closeBtn = document.getElementById('closeAdvancedSearch');
    const form = document.getElementById('advancedSearchForm');
    const clearBtn = document.getElementById('clearAdvancedSearch');

    // Open modal
    btn?.addEventListener('click', () => {
        modal?.classList.add('active');
        populateAdvancedSearchDropdowns();
    });

    // Close modal
    closeBtn?.addEventListener('click', () => {
        modal?.classList.remove('active');
    });

    modal?.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.classList.remove('active');
        }
    });

    // Form submit
    form?.addEventListener('submit', (e) => {
        e.preventDefault();
        applyAdvancedSearch();
        modal?.classList.remove('active');
    });

    // Clear button
    clearBtn?.addEventListener('click', clearAdvancedSearch);

    // Range slider sync
    initRangeSliders();

    // Multi-select dropdowns
    initMultiSelects();
}

function populateAdvancedSearchDropdowns() {
    const cityDropdown = document.getElementById('cityDropdown');
    const brandDropdown = document.getElementById('brandDropdown');

    const cities = [...new Set(vehiclesData.map(v => v.localisation))].sort();
    const brands = [...new Set(vehiclesData.map(v => v.marque))].sort();

    if (cityDropdown) {
        cityDropdown.innerHTML = cities.map(city => `
            <div class="dropdown-item ${advancedSearchState.cities.includes(city) ? 'selected' : ''}" 
                 data-value="${city}">${city}</div>
        `).join('');
    }

    if (brandDropdown) {
        brandDropdown.innerHTML = brands.map(brand => `
            <div class="dropdown-item ${advancedSearchState.brands.includes(brand) ? 'selected' : ''}" 
                 data-value="${brand}">${brand}</div>
        `).join('');
    }
}

function initMultiSelects() {
    // City multi-select
    const cityTags = document.getElementById('cityTags');
    const cityDropdown = document.getElementById('cityDropdown');

    cityTags?.addEventListener('click', () => {
        cityDropdown?.classList.toggle('active');
        brandDropdown?.classList.remove('active');
    });

    // Brand multi-select
    const brandTags = document.getElementById('brandTags');
    const brandDropdown = document.getElementById('brandDropdown');

    brandTags?.addEventListener('click', () => {
        brandDropdown?.classList.toggle('active');
        cityDropdown?.classList.remove('active');
    });

    // Dropdown item selection
    document.addEventListener('click', (e) => {
        const item = e.target.closest('.dropdown-item');
        if (!item) return;

        const value = item.dataset.value;
        const parentDropdown = item.closest('.multi-select-dropdown');

        if (parentDropdown?.id === 'cityDropdown') {
            toggleSelection('cities', value, item, 'cityTags');
        } else if (parentDropdown?.id === 'brandDropdown') {
            toggleSelection('brands', value, item, 'brandTags');
        }
    });

    // Close dropdowns on outside click
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.multi-select-wrapper')) {
            cityDropdown?.classList.remove('active');
            brandDropdown?.classList.remove('active');
        }
    });
}

function toggleSelection(stateKey, value, item, tagsContainerId) {
    const arr = advancedSearchState[stateKey];
    const index = arr.indexOf(value);

    if (index > -1) {
        arr.splice(index, 1);
        item.classList.remove('selected');
    } else {
        arr.push(value);
        item.classList.add('selected');
    }

    updateTags(stateKey, tagsContainerId);
}

function updateTags(stateKey, containerId) {
    const container = document.getElementById(containerId);
    if (!container) return;

    const values = advancedSearchState[stateKey];

    if (values.length === 0) {
        container.innerHTML = `<span class="tag-placeholder">${stateKey === 'cities' ? 'Toutes les villes' : 'Toutes les marques'}</span>`;
    } else {
        container.innerHTML = values.map(val => `
            <span class="tag">${val}<span class="tag-remove" data-key="${stateKey}" data-value="${val}">×</span></span>
        `).join('');

        // Tag removal
        container.querySelectorAll('.tag-remove').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const key = btn.dataset.key;
                const val = btn.dataset.value;
                const arr = advancedSearchState[key];
                const idx = arr.indexOf(val);
                if (idx > -1) arr.splice(idx, 1);
                updateTags(key, containerId);

                // Update dropdown
                const dropdownId = key === 'cities' ? 'cityDropdown' : 'brandDropdown';
                const dropdown = document.getElementById(dropdownId);
                dropdown?.querySelectorAll('.dropdown-item').forEach(item => {
                    if (item.dataset.value === val) {
                        item.classList.remove('selected');
                    }
                });
            });
        });
    }
}

function initRangeSliders() {
    // Year range
    const yearMin = document.getElementById('yearMin');
    const yearMax = document.getElementById('yearMax');
    const yearRangeMin = document.getElementById('yearRangeMin');
    const yearRangeMax = document.getElementById('yearRangeMax');

    yearRangeMin?.addEventListener('input', () => {
        yearMin.value = yearRangeMin.value;
    });

    yearRangeMax?.addEventListener('input', () => {
        yearMax.value = yearRangeMax.value;
    });

    yearMin?.addEventListener('input', () => {
        yearRangeMin.value = yearMin.value;
    });

    yearMax?.addEventListener('input', () => {
        yearRangeMax.value = yearMax.value;
    });

    // Autonomy range
    const autonomyMin = document.getElementById('autonomyMin');
    const autonomyMax = document.getElementById('autonomyMax');
    const autonomyRangeMin = document.getElementById('autonomyRangeMin');
    const autonomyRangeMax = document.getElementById('autonomyRangeMax');

    autonomyRangeMin?.addEventListener('input', () => {
        autonomyMin.value = autonomyRangeMin.value;
    });

    autonomyRangeMax?.addEventListener('input', () => {
        autonomyMax.value = autonomyRangeMax.value;
    });

    autonomyMin?.addEventListener('input', () => {
        autonomyRangeMin.value = autonomyMin.value;
    });

    autonomyMax?.addEventListener('input', () => {
        autonomyRangeMax.value = autonomyMax.value;
    });
}

function applyAdvancedSearch() {
    // Gather form values
    advancedSearchState.text = document.getElementById('advSearchText')?.value || '';

    // Get checked statuses
    advancedSearchState.statuses = [];
    document.querySelectorAll('input[name="status"]:checked').forEach(cb => {
        advancedSearchState.statuses.push(cb.value);
    });

    // Get ranges
    advancedSearchState.yearMin = parseInt(document.getElementById('yearMin')?.value) || null;
    advancedSearchState.yearMax = parseInt(document.getElementById('yearMax')?.value) || null;
    advancedSearchState.autonomyMin = parseInt(document.getElementById('autonomyMin')?.value) || null;
    advancedSearchState.autonomyMax = parseInt(document.getElementById('autonomyMax')?.value) || null;

    // Apply filters
    filteredData = vehiclesData.filter(vehicle => {
        // Text search
        if (advancedSearchState.text) {
            const searchTerm = advancedSearchState.text.toLowerCase();
            const matchesText =
                vehicle.marque.toLowerCase().includes(searchTerm) ||
                vehicle.modele.toLowerCase().includes(searchTerm) ||
                vehicle.immatriculation.toLowerCase().includes(searchTerm) ||
                vehicle.localisation.toLowerCase().includes(searchTerm);
            if (!matchesText) return false;
        }

        // Status filter
        if (advancedSearchState.statuses.length > 0 && !advancedSearchState.statuses.includes(vehicle.etat)) {
            return false;
        }

        // Cities filter
        if (advancedSearchState.cities.length > 0 && !advancedSearchState.cities.includes(vehicle.localisation)) {
            return false;
        }

        // Brands filter
        if (advancedSearchState.brands.length > 0 && !advancedSearchState.brands.includes(vehicle.marque)) {
            return false;
        }

        // Year range
        const year = parseInt(vehicle.annee);
        if (advancedSearchState.yearMin && year < advancedSearchState.yearMin) return false;
        if (advancedSearchState.yearMax && year > advancedSearchState.yearMax) return false;

        // Autonomy range
        const autonomy = parseInt(vehicle.autonomie_km);
        if (advancedSearchState.autonomyMin && autonomy < advancedSearchState.autonomyMin) return false;
        if (advancedSearchState.autonomyMax && autonomy > advancedSearchState.autonomyMax) return false;

        return true;
    });

    currentPage = 1;
    renderTable();
    renderCards();
    updateResultsCount();
    updateActiveFiltersDisplay();

    showToast(`${filteredData.length} résultats avec recherche avancée`, 'success');

    // Trigger confetti for precise results
    checkForCelebration(filteredData.length);

    // Navigate to fleet section
    showSection('fleet');
    updateActiveNavLink('fleet');
}

function clearAdvancedSearch() {
    // Reset form
    document.getElementById('advSearchText').value = '';
    document.querySelectorAll('input[name="status"]').forEach(cb => cb.checked = true);
    document.getElementById('yearMin').value = '';
    document.getElementById('yearMax').value = '';
    document.getElementById('autonomyMin').value = '';
    document.getElementById('autonomyMax').value = '';
    document.getElementById('yearRangeMin').value = 2020;
    document.getElementById('yearRangeMax').value = 2026;
    document.getElementById('autonomyRangeMin').value = 200;
    document.getElementById('autonomyRangeMax').value = 700;

    // Reset state
    advancedSearchState = {
        text: '',
        statuses: ['Disponible', 'En service', 'En maintenance', 'Hors service'],
        cities: [],
        brands: [],
        yearMin: null,
        yearMax: null,
        autonomyMin: null,
        autonomyMax: null
    };

    // Reset tags
    updateTags('cities', 'cityTags');
    updateTags('brands', 'brandTags');

    // Repopulate dropdowns
    populateAdvancedSearchDropdowns();

    // Hide active filters
    document.getElementById('activeFilters').style.display = 'none';

    showToast('Filtres avancés effacés', 'info');
}

function updateActiveFiltersDisplay() {
    const container = document.getElementById('activeFilters');
    const tagsContainer = document.getElementById('filterTags');

    if (!container || !tagsContainer) return;

    const tags = [];

    if (advancedSearchState.text) {
        tags.push(`Texte: "${advancedSearchState.text}"`);
    }

    if (advancedSearchState.statuses.length < 4 && advancedSearchState.statuses.length > 0) {
        tags.push(`États: ${advancedSearchState.statuses.length}`);
    }

    if (advancedSearchState.cities.length > 0) {
        tags.push(`Villes: ${advancedSearchState.cities.length}`);
    }

    if (advancedSearchState.brands.length > 0) {
        tags.push(`Marques: ${advancedSearchState.brands.length}`);
    }

    if (advancedSearchState.yearMin || advancedSearchState.yearMax) {
        tags.push(`Années: ${advancedSearchState.yearMin || '?'}-${advancedSearchState.yearMax || '?'}`);
    }

    if (advancedSearchState.autonomyMin || advancedSearchState.autonomyMax) {
        tags.push(`Autonomie: ${advancedSearchState.autonomyMin || '?'}-${advancedSearchState.autonomyMax || '?'} km`);
    }

    if (tags.length > 0) {
        container.style.display = 'block';
        tagsContainer.innerHTML = tags.map(tag => `<span class="filter-tag">${tag}</span>`).join('');
    } else {
        container.style.display = 'none';
    }
}

// ========== Brand Logos ==========
function getBrandLogo(brand) {
    const brandKey = brand.toLowerCase().replace(/\s+/g, '');
    const shortNames = {
        'tesla': 'T',
        'renault': 'R',
        'peugeot': 'P',
        'mercedes': 'MB',
        'bmw': 'BMW',
        'volkswagen': 'VW',
        'kia': 'K',
        'hyundai': 'H',
        'audi': 'A',
        'nissan': 'N',
        'citroën': 'C',
        'citroen': 'C',
        'ford': 'F',
        'opel': 'O',
        'fiat': 'Fi',
        'skoda': 'S',
        'seat': 'SE',
        'porsche': 'P',
        'jaguar': 'J',
        'volvo': 'V'
    };

    const shortName = shortNames[brandKey] || brand.substring(0, 2).toUpperCase();
    const cssClass = shortNames[brandKey] ? brandKey : 'default';

    return `<span class="brand-logo ${cssClass}">${shortName}</span>`;
}

// ========== Confetti Celebration ==========
function triggerConfetti(count = 50) {
    const container = document.createElement('div');
    container.className = 'confetti-container';
    document.body.appendChild(container);

    const colors = ['#00d4ff', '#a855f7', '#ec4899', '#22c55e', '#f97316', '#eab308'];
    const shapes = ['circle', 'square', 'triangle'];

    for (let i = 0; i < count; i++) {
        const confetti = document.createElement('div');
        const shape = shapes[Math.floor(Math.random() * shapes.length)];
        const color = colors[Math.floor(Math.random() * colors.length)];

        confetti.className = `confetti ${shape}`;
        confetti.style.left = Math.random() * 100 + '%';
        confetti.style.backgroundColor = shape !== 'triangle' ? color : 'transparent';
        confetti.style.color = color;
        confetti.style.animationDelay = Math.random() * 0.5 + 's';
        confetti.style.animationDuration = (2 + Math.random() * 2) + 's';

        container.appendChild(confetti);
    }

    // Remove container after animation
    setTimeout(() => {
        container.remove();
    }, 4000);
}

// Trigger confetti on great filter results
function checkForCelebration(resultCount) {
    // Celebrate if filter returns exactly what user might want
    if (resultCount > 0 && resultCount <= 10) {
        triggerConfetti(30);
        showToast('🎉 Résultats précis trouvés!', 'success');
    } else if (resultCount === filteredData.length && resultCount > 100) {
        // All available - small celebration
        triggerConfetti(15);
    }
}

// ========== Mouse Tracking for Gradient ==========
function initMouseTracking() {
    document.addEventListener('mousemove', (e) => {
        const x = (e.clientX / window.innerWidth) * 100;
        const y = (e.clientY / window.innerHeight) * 100;
        document.documentElement.style.setProperty('--mouse-x', x + '%');
        document.documentElement.style.setProperty('--mouse-y', y + '%');
    });
}

// Initialize color picker, advanced search, and mouse tracking on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    initColorPicker();
    initAdvancedSearch();
    initMouseTracking();
});
