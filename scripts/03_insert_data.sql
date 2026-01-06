-- ============================================
-- cIAra Mobility - Script d'insertion des données
-- ============================================
-- Script 03: Données de test et import CSV
-- PostgreSQL
-- ============================================

-- ============================================
-- TYPES DE VEHICULES
-- ============================================
INSERT INTO types_vehicules (libelle, tarif_minute, tarif_km) VALUES
    ('Voiture', 0.35, 0.25),
    ('Scooter', 0.20, 0.15),
    ('Trottinette', 0.15, 0.10),
    ('Velo', 0.10, 0.05);

-- ============================================
-- STATIONS
-- ============================================
INSERT INTO stations (nom, adresse, ville, code_postal, latitude, longitude, capacite) VALUES
    ('Station Gare Paris Nord', '18 Rue de Dunkerque', 'Paris', '75010', 48.8809, 2.3553, 30),
    ('Station Bellecour', 'Place Bellecour', 'Lyon', '69002', 45.7578, 4.8320, 25),
    ('Station Vieux-Port', 'Quai des Belges', 'Marseille', '13001', 43.2951, 5.3739, 20),
    ('Station Place de la Bourse', 'Place de la Bourse', 'Bordeaux', '33000', 44.8411, -0.5696, 22),
    ('Station Grand Place', 'Grand Place', 'Lille', '59000', 50.6365, 3.0635, 18),
    ('Station Capitole', 'Place du Capitole', 'Toulouse', '31000', 43.6045, 1.4440, 24),
    ('Station Promenade des Anglais', 'Promenade des Anglais', 'Nice', '06000', 43.6957, 7.2657, 20),
    ('Station Place Kléber', 'Place Kléber', 'Strasbourg', '67000', 48.5839, 7.7455, 16),
    ('Station Place de la Comédie', 'Place de la Comédie', 'Montpellier', '34000', 43.6087, 3.8796, 22),
    ('Station Miroir d''eau', 'Place de la Bourse', 'Nantes', '44000', 47.2132, -1.5534, 18);

-- ============================================
-- BORNES DE RECHARGE
-- ============================================
INSERT INTO bornes (id_station, numero, type_connecteur, puissance_kw, statut) VALUES
    -- Paris
    (1, 'B001', 'Type 2', 22.00, 'Disponible'),
    (1, 'B002', 'CCS', 50.00, 'Disponible'),
    (1, 'B003', 'Type 2', 22.00, 'Occupee'),
    (1, 'B004', 'CHAdeMO', 50.00, 'Disponible'),
    -- Lyon
    (2, 'B001', 'Type 2', 22.00, 'Disponible'),
    (2, 'B002', 'CCS', 100.00, 'Disponible'),
    (2, 'B003', 'Type 2', 11.00, 'Hors service'),
    -- Marseille
    (3, 'B001', 'Type 2', 22.00, 'Disponible'),
    (3, 'B002', 'CCS', 50.00, 'Occupee'),
    -- Bordeaux
    (4, 'B001', 'Type 2', 22.00, 'Disponible'),
    (4, 'B002', 'Type 2', 22.00, 'Disponible'),
    (4, 'B003', 'CCS', 150.00, 'Disponible'),
    -- Lille
    (5, 'B001', 'Type 2', 22.00, 'Disponible'),
    (5, 'B002', 'CHAdeMO', 50.00, 'Disponible'),
    -- Toulouse
    (6, 'B001', 'Type 2', 22.00, 'Disponible'),
    (6, 'B002', 'CCS', 50.00, 'Disponible'),
    (6, 'B003', 'Type 2', 11.00, 'Disponible'),
    -- Nice
    (7, 'B001', 'Type 2', 22.00, 'Disponible'),
    (7, 'B002', 'CCS', 100.00, 'Occupee'),
    -- Strasbourg
    (8, 'B001', 'Type 2', 22.00, 'Disponible'),
    (8, 'B002', 'Type 2', 22.00, 'Disponible'),
    -- Montpellier
    (9, 'B001', 'Type 2', 22.00, 'Disponible'),
    (9, 'B002', 'CCS', 50.00, 'Disponible'),
    -- Nantes
    (10, 'B001', 'Type 2', 22.00, 'Disponible'),
    (10, 'B002', 'CHAdeMO', 50.00, 'Hors service');

-- ============================================
-- CLIENTS
-- ============================================
INSERT INTO clients (nom, prenom, email, telephone, date_naissance, permis_numero, actif) VALUES
    ('Dupont', 'Marie', 'marie.dupont@email.fr', '0612345678', '1990-05-15', 'FR123456789', TRUE),
    ('Martin', 'Pierre', 'pierre.martin@email.fr', '0623456789', '1985-08-22', 'FR234567890', TRUE),
    ('Bernard', 'Sophie', 'sophie.bernard@email.fr', '0634567890', '1992-03-10', 'FR345678901', TRUE),
    ('Petit', 'Lucas', 'lucas.petit@email.fr', '0645678901', '1988-11-28', 'FR456789012', TRUE),
    ('Durand', 'Emma', 'emma.durand@email.fr', '0656789012', '1995-07-03', 'FR567890123', TRUE),
    ('Leroy', 'Thomas', 'thomas.leroy@email.fr', '0667890123', '1982-01-19', 'FR678901234', TRUE),
    ('Moreau', 'Julie', 'julie.moreau@email.fr', '0678901234', '1993-09-14', 'FR789012345', TRUE),
    ('Simon', 'Antoine', 'antoine.simon@email.fr', '0689012345', '1987-04-25', 'FR890123456', TRUE),
    ('Laurent', 'Camille', 'camille.laurent@email.fr', '0690123456', '1991-12-08', 'FR901234567', TRUE),
    ('Lefebvre', 'Hugo', 'hugo.lefebvre@email.fr', '0601234567', '1989-06-30', 'FR012345678', TRUE),
    ('Michel', 'Léa', 'lea.michel@email.fr', '0611234567', '1994-02-17', NULL, TRUE),
    ('Garcia', 'Nathan', 'nathan.garcia@email.fr', '0622345678', '1986-10-05', 'FR112233445', TRUE),
    ('Roux', 'Chloé', 'chloe.roux@email.fr', '0633456789', '1997-08-21', NULL, TRUE),
    ('Fournier', 'Maxime', 'maxime.fournier@email.fr', '0644567890', '1983-05-12', 'FR223344556', TRUE),
    ('Girard', 'Clara', 'clara.girard@email.fr', '0655678901', '1996-03-28', 'FR334455667', FALSE);

-- ============================================
-- TECHNICIENS
-- ============================================
INSERT INTO techniciens (nom, prenom, email, telephone, specialite, date_embauche) VALUES
    ('Dubois', 'Jean', 'jean.dubois@ciara.fr', '0712345678', 'Mécanique', '2022-01-15'),
    ('Robert', 'Marc', 'marc.robert@ciara.fr', '0723456789', 'Électronique', '2022-03-20'),
    ('Richard', 'Paul', 'paul.richard@ciara.fr', '0734567890', 'Batterie', '2022-06-01'),
    ('Dumont', 'François', 'francois.dumont@ciara.fr', '0745678901', 'Mécanique', '2023-02-10'),
    ('Mercier', 'Louis', 'louis.mercier@ciara.fr', '0756789012', 'Électronique', '2023-05-15');

-- ============================================
-- IMPORT DES VEHICULES DEPUIS LE CSV
-- ============================================
-- Note: Adapter le chemin selon votre installation
-- Méthode 1: Utiliser COPY (nécessite les droits superuser)
-- COPY vehicules_temp FROM 'chemin/vers/vehicules_cIara_2025.csv' WITH CSV HEADER;

-- Méthode 2: Insertion manuelle des véhicules du CSV
-- Mapping des villes vers les stations:
-- Paris -> 1, Lyon -> 2, Marseille -> 3, Bordeaux -> 4, Lille -> 5
-- Toulouse -> 6, Nice -> 7, Strasbourg -> 8, Montpellier -> 9, Nantes -> 10

-- Pour simplifier, nous insérons les 50 premiers véhicules manuellement
-- Le type "Voiture" = 1 pour tous les véhicules du CSV

INSERT INTO vehicules (id_type, id_station, marque, modele, annee, energie, autonomie_km, immatriculation, etat) VALUES
    (1, 8, 'Kia', 'EV6', 2022, 'Electrique', 320, 'XR-964-LJ', 'En maintenance'),
    (1, 10, 'Kia', 'EV6', 2024, 'Electrique', 270, 'OY-932-RY', 'En maintenance'),
    (1, 3, 'Hyundai', 'Ioniq 5', 2022, 'Electrique', 380, 'BJ-663-FL', 'Hors service'),
    (1, 9, 'Kia', 'EV6', 2024, 'Electrique', 480, 'MW-909-XP', 'Hors service'),
    (1, 2, 'Mercedes', 'EQA', 2021, 'Electrique', 390, 'UN-317-LM', 'En maintenance'),
    (1, 9, 'Hyundai', 'Ioniq 5', 2024, 'Electrique', 330, 'PU-953-NB', 'En maintenance'),
    (1, 6, 'BMW', 'iX1', 2024, 'Electrique', 270, 'YO-412-AH', 'Hors service'),
    (1, 2, 'Nissan', 'Leaf', 2024, 'Electrique', 270, 'SO-650-ZD', 'Disponible'),
    (1, 7, 'Toyota', 'Proace Electric', 2023, 'Electrique', 530, 'YE-805-LI', 'En maintenance'),
    (1, 9, 'Renault', 'Megane E-Tech', 2024, 'Electrique', 550, 'YE-951-QU', 'Disponible'),
    (1, 2, 'Citroen', 'Ami', 2024, 'Electrique', 550, 'WT-751-VN', 'Disponible'),
    (1, 6, 'Mercedes', 'EQB', 2024, 'Electrique', 420, 'OD-742-GO', 'En maintenance'),
    (1, 10, 'Volkswagen', 'ID.5', 2022, 'Electrique', 550, 'KO-197-KW', 'Hors service'),
    (1, 5, 'Mercedes', 'EQA', 2022, 'Electrique', 500, 'KM-850-ZY', 'En maintenance'),
    (1, 10, 'Kia', 'Soul EV', 2024, 'Electrique', 360, 'TR-567-ZM', 'Hors service'),
    (1, 3, 'Renault', 'Megane E-Tech', 2021, 'Electrique', 590, 'JR-526-BM', 'Disponible'),
    (1, 8, 'Citroen', 'Ami', 2023, 'Electrique', 340, 'XF-922-TM', 'Hors service'),
    (1, 7, 'Tesla', 'Model 3', 2022, 'Electrique', 270, 'HU-769-AI', 'En maintenance'),
    (1, 6, 'Kia', 'Soul EV', 2022, 'Electrique', 510, 'IW-415-IT', 'En service'),
    (1, 1, 'Mercedes', 'EQA', 2022, 'Electrique', 500, 'IL-910-WY', 'Disponible'),
    (1, 10, 'Mercedes', 'EQB', 2023, 'Electrique', 330, 'FF-812-UQ', 'En maintenance'),
    (1, 2, 'Toyota', 'Proace Electric', 2024, 'Electrique', 320, 'UD-673-OE', 'En maintenance'),
    (1, 9, 'Mercedes', 'EQA', 2021, 'Electrique', 420, 'AQ-685-JB', 'En service'),
    (1, 3, 'Toyota', 'Proace Electric', 2022, 'Electrique', 290, 'PS-158-WM', 'En maintenance'),
    (1, 4, 'Nissan', 'Ariya', 2021, 'Electrique', 470, 'WN-898-EP', 'En maintenance'),
    (1, 5, 'Volkswagen', 'ID.4', 2023, 'Electrique', 580, 'XU-837-FD', 'Disponible'),
    (1, 3, 'Peugeot', 'e-308', 2023, 'Electrique', 320, 'ON-875-UO', 'Hors service'),
    (1, 10, 'Toyota', 'Proace Electric', 2023, 'Electrique', 430, 'GO-836-IU', 'En maintenance'),
    (1, 2, 'Citroen', 'Ami', 2022, 'Electrique', 480, 'VE-965-UY', 'Disponible'),
    (1, 10, 'Hyundai', 'Ioniq 5', 2024, 'Electrique', 410, 'UE-921-ED', 'En maintenance'),
    (1, 7, 'Mercedes', 'EQA', 2021, 'Electrique', 450, 'YA-188-TY', 'En maintenance'),
    (1, 6, 'Citroen', 'Ami', 2023, 'Electrique', 340, 'HV-248-IT', 'En service'),
    (1, 8, 'Hyundai', 'Ioniq 5', 2022, 'Electrique', 500, 'TZ-433-HF', 'En maintenance'),
    (1, 5, 'Fiat', '500e', 2021, 'Electrique', 320, 'NQ-819-BP', 'Hors service'),
    (1, 1, 'Fiat', 'Panda EV', 2022, 'Electrique', 540, 'DW-525-FC', 'En service'),
    (1, 2, 'Renault', 'Zoe', 2023, 'Electrique', 300, 'QC-782-KP', 'En maintenance'),
    (1, 4, 'BMW', 'iX1', 2022, 'Electrique', 400, 'UG-214-SA', 'En service'),
    (1, 2, 'Mercedes', 'EQB', 2021, 'Electrique', 290, 'IT-929-YS', 'Hors service'),
    (1, 9, 'Nissan', 'Leaf', 2022, 'Electrique', 490, 'TH-749-AC', 'En service'),
    (1, 1, 'Tesla', 'Model 3', 2022, 'Electrique', 390, 'NC-394-CX', 'Disponible'),
    (1, 8, 'Volkswagen', 'ID.4', 2023, 'Electrique', 340, 'HX-598-OS', 'En maintenance'),
    (1, 4, 'Citroen', 'Berlingo EV', 2023, 'Electrique', 450, 'AN-441-ZU', 'Disponible'),
    (1, 7, 'Mercedes', 'EQE', 2022, 'Electrique', 520, 'QN-135-FB', 'En maintenance'),
    (1, 3, 'Fiat', '500e', 2024, 'Electrique', 590, 'ZO-456-RC', 'Hors service'),
    (1, 5, 'Tesla', 'Model Y', 2022, 'Electrique', 450, 'HY-708-CY', 'Hors service'),
    (1, 9, 'Hyundai', 'Kona Electric', 2023, 'Electrique', 560, 'AR-624-YF', 'Hors service'),
    (1, 7, 'Citroen', 'e-C4', 2022, 'Electrique', 420, 'TW-514-GR', 'Disponible'),
    (1, 2, 'Toyota', 'bZ4X', 2021, 'Electrique', 250, 'SI-389-FD', 'Disponible'),
    (1, 10, 'Toyota', 'bZ4X', 2023, 'Electrique', 320, 'QI-180-WY', 'En service'),
    (1, 7, 'Renault', 'Zoe', 2024, 'Electrique', 550, 'SW-740-DO', 'Hors service');

-- Suite des véhicules (51-100)
INSERT INTO vehicules (id_type, id_station, marque, modele, annee, energie, autonomie_km, immatriculation, etat) VALUES
    (1, 5, 'Tesla', 'Model S', 2023, 'Electrique', 340, 'FF-225-KQ', 'Hors service'),
    (1, 4, 'Volkswagen', 'ID.3', 2024, 'Electrique', 480, 'QS-174-ZR', 'Disponible'),
    (1, 7, 'Tesla', 'Model S', 2024, 'Electrique', 260, 'LP-456-BF', 'Disponible'),
    (1, 9, 'Tesla', 'Model Y', 2024, 'Electrique', 410, 'WE-429-FR', 'Hors service'),
    (1, 9, 'Peugeot', 'e-208', 2021, 'Electrique', 390, 'EL-581-UI', 'Hors service'),
    (1, 5, 'Mercedes', 'EQE', 2021, 'Electrique', 250, 'RJ-910-JH', 'En service'),
    (1, 2, 'Mercedes', 'EQB', 2024, 'Electrique', 540, 'MM-708-MP', 'Disponible'),
    (1, 5, 'Toyota', 'bZ4X', 2023, 'Electrique', 410, 'AX-830-FQ', 'En maintenance'),
    (1, 10, 'Renault', 'Megane E-Tech', 2022, 'Electrique', 570, 'TE-356-RM', 'Hors service'),
    (1, 1, 'Nissan', 'Leaf', 2021, 'Electrique', 250, 'EB-604-AD', 'En service'),
    (1, 9, 'Fiat', '500e', 2021, 'Electrique', 430, 'SU-704-FB', 'En service'),
    (1, 4, 'Mercedes', 'EQE', 2022, 'Electrique', 450, 'VA-230-KN', 'Hors service'),
    (1, 3, 'Citroen', 'Berlingo EV', 2023, 'Electrique', 250, 'AN-425-ZW', 'Hors service'),
    (1, 4, 'Renault', 'Twingo E-Tech', 2024, 'Electrique', 350, 'KZ-306-XV', 'Disponible'),
    (1, 9, 'Tesla', 'Model 3', 2021, 'Electrique', 570, 'SD-357-YU', 'Disponible'),
    (1, 5, 'Nissan', 'Ariya', 2023, 'Electrique', 490, 'FO-267-ZD', 'En maintenance'),
    (1, 4, 'Kia', 'EV6', 2022, 'Electrique', 260, 'LS-696-PV', 'Disponible'),
    (1, 6, 'Citroen', 'Ami', 2023, 'Electrique', 310, 'ZV-338-JX', 'Hors service'),
    (1, 7, 'Mercedes', 'EQA', 2024, 'Electrique', 480, 'TC-188-QF', 'Hors service'),
    (1, 1, 'Mercedes', 'EQA', 2023, 'Electrique', 360, 'QD-535-RQ', 'En service'),
    (1, 1, 'Fiat', '500e', 2021, 'Electrique', 260, 'YW-289-PL', 'En maintenance'),
    (1, 4, 'Hyundai', 'Ioniq 6', 2024, 'Electrique', 310, 'CX-634-XG', 'Hors service'),
    (1, 8, 'Peugeot', 'e-2008', 2023, 'Electrique', 550, 'SE-164-IS', 'En maintenance'),
    (1, 8, 'Nissan', 'Ariya', 2023, 'Electrique', 300, 'SW-661-EL', 'Hors service'),
    (1, 3, 'Mercedes', 'EQA', 2021, 'Electrique', 490, 'FV-360-TH', 'En maintenance'),
    (1, 5, 'Renault', 'Zoe', 2021, 'Electrique', 540, 'RW-414-YG', 'Hors service'),
    (1, 8, 'Toyota', 'bZ4X', 2023, 'Electrique', 350, 'KE-749-OR', 'En maintenance'),
    (1, 6, 'Mercedes', 'EQE', 2021, 'Electrique', 570, 'EM-599-QD', 'En service'),
    (1, 6, 'Kia', 'Soul EV', 2023, 'Electrique', 360, 'YL-392-JL', 'Hors service'),
    (1, 5, 'Renault', 'Megane E-Tech', 2023, 'Electrique', 340, 'SW-667-JM', 'Disponible'),
    (1, 5, 'Hyundai', 'Kona Electric', 2022, 'Electrique', 400, 'HO-110-PM', 'En service'),
    (1, 4, 'Hyundai', 'Ioniq 5', 2023, 'Electrique', 280, 'CN-775-SP', 'Hors service'),
    (1, 10, 'Tesla', 'Model 3', 2024, 'Electrique', 490, 'NW-528-XK', 'Hors service'),
    (1, 9, 'Fiat', 'Panda EV', 2021, 'Electrique', 520, 'PV-742-CK', 'Hors service'),
    (1, 1, 'Fiat', '500e', 2021, 'Electrique', 360, 'WZ-347-FT', 'En service'),
    (1, 3, 'Tesla', 'Model Y', 2022, 'Electrique', 330, 'JX-290-MI', 'Disponible'),
    (1, 5, 'Hyundai', 'Ioniq 5', 2023, 'Electrique', 540, 'DP-239-MK', 'Hors service'),
    (1, 10, 'Kia', 'EV6', 2021, 'Electrique', 300, 'BP-212-VV', 'En service'),
    (1, 7, 'Citroen', 'Ami', 2021, 'Electrique', 310, 'WS-948-XM', 'Disponible'),
    (1, 4, 'Toyota', 'Proace Electric', 2024, 'Electrique', 400, 'UO-609-AK', 'Hors service'),
    (1, 7, 'Toyota', 'bZ4X', 2022, 'Electrique', 330, 'DE-120-IL', 'En maintenance'),
    (1, 1, 'Nissan', 'Ariya', 2023, 'Electrique', 360, 'NL-530-PG', 'En maintenance'),
    (1, 6, 'Toyota', 'Proace Electric', 2023, 'Electrique', 300, 'GJ-521-QR', 'Disponible'),
    (1, 5, 'Citroen', 'Berlingo EV', 2024, 'Electrique', 550, 'OE-844-KP', 'En maintenance'),
    (1, 9, 'Hyundai', 'Ioniq 6', 2021, 'Electrique', 470, 'HW-712-EI', 'Hors service'),
    (1, 8, 'Fiat', 'Panda EV', 2021, 'Electrique', 330, 'TF-251-SI', 'Disponible'),
    (1, 4, 'Tesla', 'Model 3', 2023, 'Electrique', 410, 'ZK-632-LE', 'En maintenance'),
    (1, 10, 'Renault', 'Zoe', 2023, 'Electrique', 270, 'OM-169-MV', 'En service'),
    (1, 3, 'BMW', 'i4', 2022, 'Electrique', 590, 'ET-620-CS', 'Hors service'),
    (1, 4, 'Kia', 'Niro EV', 2024, 'Electrique', 570, 'LG-389-OK', 'Hors service');

-- Suite des véhicules (101-150)
INSERT INTO vehicules (id_type, id_station, marque, modele, annee, energie, autonomie_km, immatriculation, etat) VALUES
    (1, 5, 'Peugeot', 'e-2008', 2023, 'Electrique', 490, 'WI-254-SD', 'Disponible'),
    (1, 5, 'Volkswagen', 'ID.5', 2022, 'Electrique', 540, 'WL-753-WR', 'Hors service'),
    (1, 2, 'Kia', 'Soul EV', 2023, 'Electrique', 350, 'IR-711-JA', 'En service'),
    (1, 9, 'Mercedes', 'EQE', 2021, 'Electrique', 470, 'RP-199-AS', 'En maintenance'),
    (1, 9, 'Renault', 'Megane E-Tech', 2021, 'Electrique', 400, 'XT-498-QA', 'En maintenance'),
    (1, 6, 'Volkswagen', 'ID.5', 2021, 'Electrique', 290, 'WG-359-PO', 'Disponible'),
    (1, 2, 'Mercedes', 'EQA', 2022, 'Electrique', 340, 'FX-993-XP', 'Disponible'),
    (1, 5, 'Toyota', 'bZ4X', 2024, 'Electrique', 480, 'MB-368-UO', 'En maintenance'),
    (1, 10, 'BMW', 'iX1', 2024, 'Electrique', 290, 'QL-947-DJ', 'Hors service'),
    (1, 10, 'Citroen', 'Ami', 2023, 'Electrique', 570, 'BZ-366-UO', 'Hors service'),
    (1, 9, 'Citroen', 'e-C4', 2022, 'Electrique', 260, 'WJ-620-FG', 'En maintenance'),
    (1, 6, 'Mercedes', 'EQA', 2023, 'Electrique', 370, 'RZ-370-NL', 'Disponible'),
    (1, 4, 'Nissan', 'Leaf', 2024, 'Electrique', 390, 'BP-234-SK', 'Disponible'),
    (1, 3, 'Fiat', 'Panda EV', 2023, 'Electrique', 350, 'XJ-945-HM', 'En maintenance'),
    (1, 3, 'Mercedes', 'EQB', 2022, 'Electrique', 530, 'DH-852-NY', 'Disponible'),
    (1, 9, 'Mercedes', 'EQA', 2021, 'Electrique', 280, 'NK-133-FM', 'En service'),
    (1, 6, 'BMW', 'iX1', 2024, 'Electrique', 490, 'WD-869-LS', 'En maintenance'),
    (1, 1, 'BMW', 'i4', 2024, 'Electrique', 250, 'ZR-949-AH', 'Disponible'),
    (1, 1, 'Nissan', 'Ariya', 2022, 'Electrique', 510, 'NL-355-NC', 'En maintenance'),
    (1, 8, 'Volkswagen', 'ID.4', 2023, 'Electrique', 260, 'PR-323-VJ', 'Disponible'),
    (1, 8, 'Tesla', 'Model Y', 2023, 'Electrique', 360, 'AE-397-CK', 'Disponible'),
    (1, 6, 'Fiat', 'Panda EV', 2024, 'Electrique', 340, 'FT-670-QN', 'Hors service'),
    (1, 9, 'Peugeot', 'e-2008', 2021, 'Electrique', 480, 'PS-782-EL', 'En maintenance'),
    (1, 4, 'Nissan', 'Ariya', 2023, 'Electrique', 440, 'DK-304-FY', 'Hors service'),
    (1, 8, 'Fiat', 'Panda EV', 2023, 'Electrique', 350, 'FC-495-SL', 'En service'),
    (1, 7, 'Fiat', 'Panda EV', 2024, 'Electrique', 520, 'VK-465-JT', 'En maintenance'),
    (1, 10, 'Mercedes', 'EQB', 2021, 'Electrique', 370, 'QY-837-UB', 'En maintenance'),
    (1, 9, 'Fiat', 'Panda EV', 2023, 'Electrique', 310, 'NH-411-OO', 'Disponible'),
    (1, 5, 'Mercedes', 'EQB', 2022, 'Electrique', 440, 'LJ-641-IZ', 'Hors service'),
    (1, 2, 'Tesla', 'Model S', 2021, 'Electrique', 530, 'UM-650-SA', 'Disponible'),
    (1, 10, 'Kia', 'EV6', 2022, 'Electrique', 590, 'RB-458-VO', 'Hors service'),
    (1, 5, 'Mercedes', 'EQB', 2022, 'Electrique', 510, 'VE-861-VS', 'Hors service'),
    (1, 4, 'Mercedes', 'EQE', 2022, 'Electrique', 300, 'CJ-528-YK', 'En service'),
    (1, 3, 'Tesla', 'Model 3', 2024, 'Electrique', 560, 'SO-450-TY', 'En maintenance'),
    (1, 1, 'Hyundai', 'Kona Electric', 2024, 'Electrique', 250, 'JL-958-MC', 'Disponible'),
    (1, 2, 'Nissan', 'Ariya', 2022, 'Electrique', 450, 'BL-747-IP', 'Disponible'),
    (1, 5, 'Peugeot', 'e-308', 2024, 'Electrique', 560, 'IJ-140-LZ', 'Disponible'),
    (1, 4, 'Nissan', 'Leaf', 2023, 'Electrique', 530, 'ME-146-YS', 'Disponible'),
    (1, 10, 'Nissan', 'Ariya', 2023, 'Electrique', 360, 'WU-151-UG', 'Disponible'),
    (1, 3, 'Volkswagen', 'ID.5', 2024, 'Electrique', 370, 'MN-866-BT', 'En maintenance'),
    (1, 10, 'Tesla', 'Model 3', 2024, 'Electrique', 270, 'KH-489-MM', 'En service'),
    (1, 4, 'Mercedes', 'EQE', 2024, 'Electrique', 590, 'ZF-466-DO', 'En maintenance'),
    (1, 1, 'Fiat', 'Panda EV', 2024, 'Electrique', 270, 'RG-111-UB', 'En maintenance'),
    (1, 3, 'Peugeot', 'e-2008', 2023, 'Electrique', 490, 'TM-569-HA', 'Disponible'),
    (1, 7, 'Toyota', 'bZ4X', 2023, 'Electrique', 440, 'WK-987-YD', 'Disponible'),
    (1, 10, 'Peugeot', 'e-308', 2023, 'Electrique', 490, 'UD-306-PX', 'Hors service'),
    (1, 7, 'Kia', 'EV6', 2021, 'Electrique', 280, 'BU-389-QH', 'En service'),
    (1, 5, 'Renault', 'Twingo E-Tech', 2024, 'Electrique', 260, 'SV-706-SJ', 'En service'),
    (1, 2, 'Volkswagen', 'ID.3', 2022, 'Electrique', 300, 'OI-419-ZT', 'En service'),
    (1, 5, 'Peugeot', 'e-2008', 2024, 'Electrique', 480, 'LN-599-UP', 'En maintenance');

-- Suite des véhicules (151-200)
INSERT INTO vehicules (id_type, id_station, marque, modele, annee, energie, autonomie_km, immatriculation, etat) VALUES
    (1, 6, 'Tesla', 'Model Y', 2024, 'Electrique', 560, 'GD-271-MQ', 'Disponible'),
    (1, 5, 'Fiat', 'Panda EV', 2022, 'Electrique', 500, 'PF-512-MT', 'En service'),
    (1, 6, 'Volkswagen', 'ID.4', 2022, 'Electrique', 350, 'SB-817-VP', 'En service'),
    (1, 3, 'Peugeot', 'e-208', 2021, 'Electrique', 330, 'VY-619-MP', 'En service'),
    (1, 4, 'BMW', 'i4', 2023, 'Electrique', 330, 'DR-314-DR', 'Hors service'),
    (1, 10, 'Fiat', 'Panda EV', 2021, 'Electrique', 270, 'JY-869-HY', 'Disponible'),
    (1, 5, 'Kia', 'Niro EV', 2024, 'Electrique', 340, 'QJ-391-VO', 'En service'),
    (1, 6, 'Renault', 'Twingo E-Tech', 2023, 'Electrique', 340, 'SB-797-MR', 'En maintenance'),
    (1, 8, 'Kia', 'Niro EV', 2023, 'Electrique', 420, 'AX-470-KN', 'En maintenance'),
    (1, 3, 'BMW', 'iX1', 2023, 'Electrique', 420, 'KM-572-NJ', 'En service'),
    (1, 2, 'Renault', 'Megane E-Tech', 2021, 'Electrique', 520, 'PU-577-ZZ', 'En maintenance'),
    (1, 6, 'Hyundai', 'Ioniq 6', 2024, 'Electrique', 250, 'TZ-622-EA', 'En maintenance'),
    (1, 5, 'Toyota', 'Proace Electric', 2022, 'Electrique', 570, 'EH-429-CM', 'Disponible'),
    (1, 6, 'Volkswagen', 'ID.3', 2023, 'Electrique', 410, 'OS-980-AT', 'En maintenance'),
    (1, 2, 'Tesla', 'Model 3', 2022, 'Electrique', 480, 'TI-895-UI', 'En maintenance'),
    (1, 10, 'Tesla', 'Model Y', 2022, 'Electrique', 290, 'NN-119-YJ', 'Disponible'),
    (1, 9, 'Volkswagen', 'ID.3', 2023, 'Electrique', 450, 'RV-850-FT', 'Hors service'),
    (1, 10, 'Peugeot', 'e-2008', 2022, 'Electrique', 310, 'UX-407-TO', 'Disponible'),
    (1, 6, 'Volkswagen', 'ID.3', 2024, 'Electrique', 540, 'FZ-415-DG', 'En service'),
    (1, 3, 'Renault', 'Twingo E-Tech', 2024, 'Electrique', 550, 'BH-615-AM', 'Hors service'),
    (1, 7, 'Volkswagen', 'ID.4', 2024, 'Electrique', 540, 'VP-134-EA', 'Hors service'),
    (1, 10, 'Volkswagen', 'ID.3', 2024, 'Electrique', 550, 'UJ-309-EH', 'En maintenance'),
    (1, 7, 'Fiat', '500e', 2024, 'Electrique', 370, 'KT-363-MD', 'En service'),
    (1, 8, 'Hyundai', 'Ioniq 6', 2021, 'Electrique', 410, 'BK-529-UC', 'Disponible'),
    (1, 8, 'Mercedes', 'EQB', 2023, 'Electrique', 590, 'EJ-848-ZK', 'Hors service'),
    (1, 2, 'BMW', 'iX1', 2021, 'Electrique', 550, 'OS-817-PA', 'En maintenance'),
    (1, 2, 'Renault', 'Zoe', 2021, 'Electrique', 480, 'LO-729-ZR', 'En service'),
    (1, 5, 'Peugeot', 'e-2008', 2021, 'Electrique', 470, 'XD-909-AR', 'En service'),
    (1, 7, 'Citroen', 'e-C4', 2024, 'Electrique', 460, 'HO-747-OR', 'Hors service'),
    (1, 7, 'Citroen', 'e-C4', 2022, 'Electrique', 580, 'XE-564-VB', 'Disponible');

-- ============================================
-- LOCATIONS (Données de test)
-- ============================================
INSERT INTO locations (id_client, id_vehicule, id_station_depart, id_station_arrivee, date_debut, date_fin, distance_km, statut) VALUES
    (1, 8, 2, 2, '2025-12-01 08:30:00', '2025-12-01 09:15:00', 12.5, 'Terminee'),
    (2, 20, 1, 3, '2025-12-01 10:00:00', '2025-12-01 14:30:00', 45.8, 'Terminee'),
    (3, 10, 9, 9, '2025-12-02 07:45:00', '2025-12-02 08:30:00', 8.3, 'Terminee'),
    (4, 26, 5, 5, '2025-12-02 14:00:00', '2025-12-02 16:45:00', 28.7, 'Terminee'),
    (5, 40, 1, 1, '2025-12-03 09:00:00', '2025-12-03 11:30:00', 22.4, 'Terminee'),
    (6, 11, 2, 9, '2025-12-03 15:30:00', '2025-12-03 18:00:00', 38.2, 'Terminee'),
    (7, 47, 7, 7, '2025-12-04 08:00:00', '2025-12-04 10:00:00', 15.6, 'Terminee'),
    (8, 52, 4, 4, '2025-12-04 11:30:00', '2025-12-04 14:00:00', 19.8, 'Terminee'),
    (9, 29, 2, 2, '2025-12-05 07:00:00', '2025-12-05 08:45:00', 14.2, 'Terminee'),
    (10, 16, 3, 3, '2025-12-05 10:30:00', '2025-12-05 13:15:00', 25.9, 'Terminee'),
    (1, 42, 4, 4, '2025-12-06 09:15:00', '2025-12-06 12:00:00', 21.3, 'Terminee'),
    (2, 48, 2, 2, '2025-12-06 14:30:00', '2025-12-06 17:00:00', 18.7, 'Terminee'),
    (3, 57, 2, 2, '2025-12-07 08:45:00', '2025-12-07 11:30:00', 24.5, 'Terminee'),
    (4, 64, 4, 4, '2025-12-07 13:00:00', '2025-12-07 15:45:00', 20.1, 'Terminee'),
    (5, 67, 4, 4, '2025-12-08 07:30:00', '2025-12-08 10:15:00', 26.8, 'Terminee'),
    (1, 8, 2, NULL, '2025-12-28 08:00:00', NULL, NULL, 'En cours'),
    (6, 40, 1, NULL, '2025-12-28 09:30:00', NULL, NULL, 'En cours'),
    (7, 11, 2, NULL, '2025-12-28 10:00:00', NULL, NULL, 'En cours'),
    (11, 52, 4, 10, '2025-12-10 08:00:00', '2025-12-10 12:00:00', 35.6, 'Terminee'),
    (12, 89, 7, 7, '2025-12-11 09:00:00', '2025-12-11 11:30:00', 16.2, 'Terminee'),
    (13, 47, 7, 3, '2025-12-12 10:15:00', '2025-12-12 15:00:00', 52.4, 'Terminee'),
    (14, 96, 8, 8, '2025-12-13 07:45:00', '2025-12-13 09:30:00', 11.8, 'Terminee'),
    (1, 16, 3, 3, '2025-12-14 14:00:00', '2025-12-14 17:30:00', 31.5, 'Terminee'),
    (2, 29, 2, 5, '2025-12-15 08:30:00', '2025-12-15 14:00:00', 68.2, 'Terminee'),
    (3, 42, 4, 4, '2025-12-16 11:00:00', '2025-12-16 13:45:00', 18.9, 'Terminee');

-- ============================================
-- PAIEMENTS (Données de test)
-- ============================================
INSERT INTO paiements (id_location, montant, methode, statut, date_paiement) VALUES
    (1, 15.75, 'Carte bancaire', 'Valide', '2025-12-01 09:16:00'),
    (2, 58.90, 'PayPal', 'Valide', '2025-12-01 14:31:00'),
    (3, 9.45, 'Carte bancaire', 'Valide', '2025-12-02 08:31:00'),
    (4, 34.80, 'Apple Pay', 'Valide', '2025-12-02 16:46:00'),
    (5, 26.50, 'Carte bancaire', 'Valide', '2025-12-03 11:31:00'),
    (6, 45.20, 'Google Pay', 'Valide', '2025-12-03 18:01:00'),
    (7, 18.70, 'Carte bancaire', 'Valide', '2025-12-04 10:01:00'),
    (8, 23.40, 'PayPal', 'Valide', '2025-12-04 14:01:00'),
    (9, 16.25, 'Carte bancaire', 'Valide', '2025-12-05 08:46:00'),
    (10, 30.15, 'Apple Pay', 'Valide', '2025-12-05 13:16:00'),
    (11, 25.30, 'Carte bancaire', 'Valide', '2025-12-06 12:01:00'),
    (12, 22.10, 'PayPal', 'Valide', '2025-12-06 17:01:00'),
    (13, 28.95, 'Carte bancaire', 'Valide', '2025-12-07 11:31:00'),
    (14, 23.80, 'Google Pay', 'Valide', '2025-12-07 15:46:00'),
    (15, 31.60, 'Carte bancaire', 'Valide', '2025-12-08 10:16:00'),
    (16, 0.00, 'Carte bancaire', 'En attente', NULL),
    (17, 0.00, 'Apple Pay', 'En attente', NULL),
    (18, 0.00, 'Carte bancaire', 'En attente', NULL),
    (19, 42.30, 'Carte bancaire', 'Valide', '2025-12-10 12:01:00'),
    (20, 19.45, 'PayPal', 'Valide', '2025-12-11 11:31:00'),
    (21, 62.80, 'Carte bancaire', 'Valide', '2025-12-12 15:01:00'),
    (22, 13.20, 'Apple Pay', 'Valide', '2025-12-13 09:31:00'),
    (23, 37.50, 'Carte bancaire', 'Valide', '2025-12-14 17:31:00'),
    (24, 78.90, 'Google Pay', 'Valide', '2025-12-15 14:01:00'),
    (25, 22.65, 'Carte bancaire', 'Valide', '2025-12-16 13:46:00');

-- ============================================
-- INTERVENTIONS (Données de test)
-- ============================================
INSERT INTO interventions (id_vehicule, id_technicien, type_intervention, description, date_debut, date_fin, cout, statut) VALUES
    (1, 1, 'Maintenance preventive', 'Contrôle des freins et pneus', '2025-12-01 09:00:00', '2025-12-01 12:00:00', 85.00, 'Terminee'),
    (2, 2, 'Reparation', 'Remplacement du chargeur embarqué', '2025-12-02 08:00:00', '2025-12-02 17:00:00', 450.00, 'Terminee'),
    (5, 1, 'Controle technique', 'Contrôle technique annuel', '2025-12-03 10:00:00', '2025-12-03 14:00:00', 120.00, 'Terminee'),
    (6, 3, 'Maintenance preventive', 'Vérification batterie et électronique', '2025-12-04 08:30:00', '2025-12-04 11:30:00', 95.00, 'Terminee'),
    (9, 2, 'Reparation', 'Réparation écran tableau de bord', '2025-12-05 09:00:00', '2025-12-05 16:00:00', 320.00, 'Terminee'),
    (12, 4, 'Nettoyage', 'Nettoyage complet intérieur/extérieur', '2025-12-06 08:00:00', '2025-12-06 10:00:00', 45.00, 'Terminee'),
    (14, 3, 'Maintenance preventive', 'Mise à jour logicielle et diagnostic', '2025-12-07 11:00:00', '2025-12-07 15:00:00', 75.00, 'Terminee'),
    (18, 5, 'Reparation', 'Remplacement pneu avant gauche', '2025-12-08 08:00:00', '2025-12-08 10:30:00', 180.00, 'Terminee'),
    (21, 1, 'Controle technique', 'Contrôle périodique obligatoire', '2025-12-09 14:00:00', '2025-12-09 17:00:00', 110.00, 'Terminee'),
    (22, 4, 'Maintenance preventive', 'Vérification système de freinage', '2025-12-10 09:30:00', '2025-12-10 12:30:00', 90.00, 'Terminee'),
    (24, 2, 'Reparation', 'Réparation système de climatisation', '2025-12-11 08:00:00', NULL, 0.00, 'En cours'),
    (28, 3, 'Maintenance preventive', 'Contrôle complet', '2025-12-12 10:00:00', NULL, 0.00, 'Planifiee'),
    (30, 5, 'Nettoyage', 'Nettoyage après location longue durée', '2025-12-13 08:00:00', NULL, 0.00, 'Planifiee');

-- ============================================
-- SESSIONS DE RECHARGE (Données de test)
-- ============================================
INSERT INTO sessions_recharge (id_vehicule, id_borne, date_debut, date_fin, energie_kwh, cout) VALUES
    (8, 5, '2025-12-01 09:30:00', '2025-12-01 11:00:00', 35.5, 12.40),
    (20, 1, '2025-12-01 15:00:00', '2025-12-01 17:30:00', 42.8, 14.98),
    (10, 22, '2025-12-02 08:45:00', '2025-12-02 10:15:00', 28.3, 9.91),
    (26, 13, '2025-12-02 17:00:00', '2025-12-02 19:30:00', 51.2, 17.92),
    (40, 2, '2025-12-03 12:00:00', '2025-12-03 13:30:00', 38.7, 13.55),
    (11, 6, '2025-12-03 18:30:00', '2025-12-03 21:00:00', 48.5, 16.98),
    (47, 18, '2025-12-04 10:30:00', '2025-12-04 12:00:00', 32.1, 11.24),
    (52, 10, '2025-12-04 14:30:00', '2025-12-04 16:30:00', 44.6, 15.61),
    (29, 5, '2025-12-05 09:00:00', '2025-12-05 10:30:00', 29.8, 10.43),
    (16, 8, '2025-12-05 13:30:00', '2025-12-05 15:30:00', 41.3, 14.46),
    (42, 11, '2025-12-06 08:00:00', '2025-12-06 10:00:00', 36.9, 12.92),
    (48, 6, '2025-12-06 17:30:00', '2025-12-06 19:30:00', 45.2, 15.82),
    (57, 5, '2025-12-07 12:00:00', '2025-12-07 14:00:00', 40.5, 14.18),
    (64, 10, '2025-12-07 16:00:00', '2025-12-07 18:00:00', 37.8, 13.23),
    (67, 12, '2025-12-08 10:30:00', '2025-12-08 12:30:00', 43.2, 15.12);

-- ============================================
-- Vérification finale
-- ============================================
SELECT 'Données insérées avec succès!' AS message;

-- Statistiques
SELECT 'Types de véhicules' AS table_name, COUNT(*) AS nombre FROM types_vehicules
UNION ALL
SELECT 'Stations', COUNT(*) FROM stations
UNION ALL
SELECT 'Bornes', COUNT(*) FROM bornes
UNION ALL
SELECT 'Véhicules', COUNT(*) FROM vehicules
UNION ALL
SELECT 'Clients', COUNT(*) FROM clients
UNION ALL
SELECT 'Techniciens', COUNT(*) FROM techniciens
UNION ALL
SELECT 'Locations', COUNT(*) FROM locations
UNION ALL
SELECT 'Paiements', COUNT(*) FROM paiements
UNION ALL
SELECT 'Interventions', COUNT(*) FROM interventions
UNION ALL
SELECT 'Sessions de recharge', COUNT(*) FROM sessions_recharge;
