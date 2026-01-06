-- ============================================
-- cIAra Mobility - Script de création des tables
-- ============================================
-- Script 02: Création des tables avec contraintes
-- PostgreSQL
-- ============================================

-- ============================================
-- TABLE: types_vehicules
-- Description: Catégories de véhicules disponibles
-- ============================================
CREATE TABLE IF NOT EXISTS types_vehicules (
    id_type SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    tarif_minute DECIMAL(5,2) NOT NULL CHECK (tarif_minute > 0),
    tarif_km DECIMAL(5,2) NOT NULL CHECK (tarif_km > 0)
);

COMMENT ON TABLE types_vehicules IS 'Catégories de véhicules électriques disponibles';
COMMENT ON COLUMN types_vehicules.tarif_minute IS 'Tarif par minute en euros';
COMMENT ON COLUMN types_vehicules.tarif_km IS 'Tarif par kilomètre en euros';

-- ============================================
-- TABLE: stations
-- Description: Points de stationnement et recharge
-- ============================================
CREATE TABLE IF NOT EXISTS stations (
    id_station SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    capacite INTEGER NOT NULL CHECK (capacite > 0)
);

COMMENT ON TABLE stations IS 'Stations de stationnement et recharge';
COMMENT ON COLUMN stations.capacite IS 'Nombre maximum de véhicules';

-- ============================================
-- TABLE: vehicules
-- Description: Flotte de véhicules électriques
-- ============================================
CREATE TABLE IF NOT EXISTS vehicules (
    id_vehicule SERIAL PRIMARY KEY,
    id_type INTEGER NOT NULL,
    id_station INTEGER,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    annee INTEGER NOT NULL CHECK (annee BETWEEN 2015 AND 2030),
    energie VARCHAR(20) NOT NULL DEFAULT 'Electrique',
    autonomie_km INTEGER NOT NULL CHECK (autonomie_km > 0),
    immatriculation VARCHAR(15) NOT NULL UNIQUE,
    etat VARCHAR(20) NOT NULL CHECK (etat IN ('Disponible', 'En service', 'En maintenance', 'Hors service')),
    date_ajout DATE DEFAULT CURRENT_DATE,
    
    CONSTRAINT fk_vehicule_type FOREIGN KEY (id_type) 
        REFERENCES types_vehicules(id_type) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehicule_station FOREIGN KEY (id_station) 
        REFERENCES stations(id_station) ON DELETE SET NULL ON UPDATE CASCADE
);

COMMENT ON TABLE vehicules IS 'Flotte de véhicules électriques de cIAra Mobility';
COMMENT ON COLUMN vehicules.etat IS 'État actuel: Disponible, En service, En maintenance, Hors service';

-- Index pour améliorer les performances
CREATE INDEX idx_vehicules_etat ON vehicules(etat);
CREATE INDEX idx_vehicules_ville ON vehicules(id_station);
CREATE INDEX idx_vehicules_type ON vehicules(id_type);

-- ============================================
-- TABLE: bornes
-- Description: Bornes de recharge individuelles
-- ============================================
CREATE TABLE IF NOT EXISTS bornes (
    id_borne SERIAL PRIMARY KEY,
    id_station INTEGER NOT NULL,
    numero VARCHAR(20) NOT NULL,
    type_connecteur VARCHAR(50) NOT NULL CHECK (type_connecteur IN ('Type 2', 'CCS', 'CHAdeMO', 'Combo')),
    puissance_kw DECIMAL(5,2) NOT NULL CHECK (puissance_kw > 0),
    statut VARCHAR(20) NOT NULL DEFAULT 'Disponible' CHECK (statut IN ('Disponible', 'Occupee', 'Hors service')),
    
    CONSTRAINT fk_borne_station FOREIGN KEY (id_station) 
        REFERENCES stations(id_station) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uk_borne_numero_station UNIQUE (id_station, numero)
);

COMMENT ON TABLE bornes IS 'Bornes de recharge dans les stations';

-- ============================================
-- TABLE: clients
-- Description: Utilisateurs du service
-- ============================================
CREATE TABLE IF NOT EXISTS clients (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telephone VARCHAR(20),
    date_naissance DATE NOT NULL,
    permis_numero VARCHAR(20) UNIQUE,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actif BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE clients IS 'Clients utilisateurs du service cIAra Mobility';

-- Index pour la recherche
CREATE INDEX idx_clients_email ON clients(email);
CREATE INDEX idx_clients_actif ON clients(actif);

-- ============================================
-- TABLE: techniciens
-- Description: Personnel de maintenance
-- ============================================
CREATE TABLE IF NOT EXISTS techniciens (
    id_technicien SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telephone VARCHAR(20) NOT NULL,
    specialite VARCHAR(50) NOT NULL,
    date_embauche DATE NOT NULL
);

COMMENT ON TABLE techniciens IS 'Techniciens de maintenance';

-- ============================================
-- TABLE: locations
-- Description: Réservations et locations de véhicules
-- ============================================
CREATE TABLE IF NOT EXISTS locations (
    id_location SERIAL PRIMARY KEY,
    id_client INTEGER NOT NULL,
    id_vehicule INTEGER NOT NULL,
    id_station_depart INTEGER NOT NULL,
    id_station_arrivee INTEGER,
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP,
    distance_km DECIMAL(8,2) CHECK (distance_km >= 0),
    statut VARCHAR(20) NOT NULL DEFAULT 'En cours' CHECK (statut IN ('En cours', 'Terminee', 'Annulee')),
    
    CONSTRAINT fk_location_client FOREIGN KEY (id_client) 
        REFERENCES clients(id_client) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_location_vehicule FOREIGN KEY (id_vehicule) 
        REFERENCES vehicules(id_vehicule) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_location_station_depart FOREIGN KEY (id_station_depart) 
        REFERENCES stations(id_station) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_location_station_arrivee FOREIGN KEY (id_station_arrivee) 
        REFERENCES stations(id_station) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_dates_location CHECK (date_fin IS NULL OR date_fin >= date_debut)
);

COMMENT ON TABLE locations IS 'Historique des locations de véhicules';

-- Index pour les requêtes fréquentes
CREATE INDEX idx_locations_client ON locations(id_client);
CREATE INDEX idx_locations_vehicule ON locations(id_vehicule);
CREATE INDEX idx_locations_statut ON locations(statut);
CREATE INDEX idx_locations_dates ON locations(date_debut, date_fin);

-- ============================================
-- TABLE: paiements
-- Description: Transactions financières
-- ============================================
CREATE TABLE IF NOT EXISTS paiements (
    id_paiement SERIAL PRIMARY KEY,
    id_location INTEGER NOT NULL UNIQUE,
    montant DECIMAL(10,2) NOT NULL CHECK (montant >= 0),
    methode VARCHAR(30) NOT NULL CHECK (methode IN ('Carte bancaire', 'PayPal', 'Apple Pay', 'Google Pay')),
    statut VARCHAR(20) NOT NULL DEFAULT 'En attente' CHECK (statut IN ('En attente', 'Valide', 'Rembourse', 'Echoue')),
    date_paiement TIMESTAMP,
    
    CONSTRAINT fk_paiement_location FOREIGN KEY (id_location) 
        REFERENCES locations(id_location) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE paiements IS 'Paiements associés aux locations';

-- Index
CREATE INDEX idx_paiements_statut ON paiements(statut);

-- ============================================
-- TABLE: interventions
-- Description: Opérations de maintenance
-- ============================================
CREATE TABLE IF NOT EXISTS interventions (
    id_intervention SERIAL PRIMARY KEY,
    id_vehicule INTEGER NOT NULL,
    id_technicien INTEGER NOT NULL,
    type_intervention VARCHAR(50) NOT NULL CHECK (type_intervention IN ('Maintenance preventive', 'Reparation', 'Controle technique', 'Nettoyage')),
    description TEXT,
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP,
    cout DECIMAL(10,2) CHECK (cout >= 0),
    statut VARCHAR(20) NOT NULL DEFAULT 'Planifiee' CHECK (statut IN ('Planifiee', 'En cours', 'Terminee', 'Annulee')),
    
    CONSTRAINT fk_intervention_vehicule FOREIGN KEY (id_vehicule) 
        REFERENCES vehicules(id_vehicule) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_intervention_technicien FOREIGN KEY (id_technicien) 
        REFERENCES techniciens(id_technicien) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_dates_intervention CHECK (date_fin IS NULL OR date_fin >= date_debut)
);

COMMENT ON TABLE interventions IS 'Interventions de maintenance sur les véhicules';

-- Index
CREATE INDEX idx_interventions_vehicule ON interventions(id_vehicule);
CREATE INDEX idx_interventions_technicien ON interventions(id_technicien);
CREATE INDEX idx_interventions_statut ON interventions(statut);

-- ============================================
-- TABLE: sessions_recharge
-- Description: Sessions de recharge des véhicules
-- ============================================
CREATE TABLE IF NOT EXISTS sessions_recharge (
    id_session SERIAL PRIMARY KEY,
    id_vehicule INTEGER NOT NULL,
    id_borne INTEGER NOT NULL,
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP,
    energie_kwh DECIMAL(6,2) CHECK (energie_kwh >= 0),
    cout DECIMAL(8,2) CHECK (cout >= 0),
    
    CONSTRAINT fk_session_vehicule FOREIGN KEY (id_vehicule) 
        REFERENCES vehicules(id_vehicule) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_session_borne FOREIGN KEY (id_borne) 
        REFERENCES bornes(id_borne) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_dates_session CHECK (date_fin IS NULL OR date_fin >= date_debut)
);

COMMENT ON TABLE sessions_recharge IS 'Sessions de recharge des véhicules';

-- ============================================
-- Vérification finale
-- ============================================
SELECT 'Toutes les tables ont été créées avec succès!' AS message;

-- Afficher la liste des tables créées
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
