-- ============================================
-- cIAra Mobility - Requêtes SQL Avancées
-- ============================================
-- Script 04: Requêtes, Vues, Triggers et Fonctions
-- PostgreSQL
-- ============================================

-- ============================================
-- PARTIE 1 : REQUÊTES DE BASE
-- ============================================

-- --------------------------------------------
-- REQUÊTE 1 : Liste des véhicules disponibles par ville
-- Utilise : SELECT, JOIN, WHERE, ORDER BY
-- --------------------------------------------
SELECT 
    v.id_vehicule,
    v.marque,
    v.modele,
    v.immatriculation,
    v.autonomie_km,
    s.ville,
    s.nom AS station
FROM vehicules v
INNER JOIN stations s ON v.id_station = s.id_station
WHERE v.etat = 'Disponible'
ORDER BY s.ville, v.marque;

-- --------------------------------------------
-- REQUÊTE 2 : Nombre de véhicules par état
-- Utilise : COUNT, GROUP BY
-- --------------------------------------------
SELECT 
    etat,
    COUNT(*) AS nombre_vehicules,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM vehicules), 2) AS pourcentage
FROM vehicules
GROUP BY etat
ORDER BY nombre_vehicules DESC;

-- --------------------------------------------
-- REQUÊTE 3 : Top 5 des clients les plus actifs
-- Utilise : COUNT, JOIN, GROUP BY, ORDER BY, LIMIT
-- --------------------------------------------
SELECT 
    c.id_client,
    c.nom,
    c.prenom,
    c.email,
    COUNT(l.id_location) AS nombre_locations,
    COALESCE(SUM(l.distance_km), 0) AS distance_totale_km
FROM clients c
LEFT JOIN locations l ON c.id_client = l.id_client
GROUP BY c.id_client, c.nom, c.prenom, c.email
ORDER BY nombre_locations DESC
LIMIT 5;

-- --------------------------------------------
-- REQUÊTE 4 : Revenus totaux par type de véhicule
-- Utilise : SUM, JOIN multiple, GROUP BY
-- --------------------------------------------
SELECT 
    tv.libelle AS type_vehicule,
    COUNT(DISTINCT l.id_location) AS nombre_locations,
    COALESCE(SUM(p.montant), 0) AS revenus_totaux,
    ROUND(AVG(p.montant), 2) AS revenu_moyen_par_location
FROM types_vehicules tv
LEFT JOIN vehicules v ON tv.id_type = v.id_type
LEFT JOIN locations l ON v.id_vehicule = l.id_vehicule
LEFT JOIN paiements p ON l.id_location = p.id_location AND p.statut = 'Valide'
GROUP BY tv.id_type, tv.libelle
ORDER BY revenus_totaux DESC;

-- --------------------------------------------
-- REQUÊTE 5 : Véhicules nécessitant une maintenance
-- Utilise : WHERE, IN, sous-requête
-- --------------------------------------------
SELECT 
    v.id_vehicule,
    v.marque,
    v.modele,
    v.immatriculation,
    v.etat,
    s.ville,
    (SELECT MAX(i.date_debut) 
     FROM interventions i 
     WHERE i.id_vehicule = v.id_vehicule) AS derniere_intervention
FROM vehicules v
LEFT JOIN stations s ON v.id_station = s.id_station
WHERE v.etat IN ('En maintenance', 'Hors service')
ORDER BY v.etat, s.ville;

-- ============================================
-- PARTIE 2 : REQUÊTES AVANCÉES
-- ============================================

-- --------------------------------------------
-- REQUÊTE 6 : Taux d'occupation par station
-- Utilise : COUNT, CASE, JOIN, GROUP BY
-- --------------------------------------------
SELECT 
    s.id_station,
    s.nom,
    s.ville,
    s.capacite,
    COUNT(v.id_vehicule) AS vehicules_presents,
    s.capacite - COUNT(v.id_vehicule) AS places_libres,
    ROUND(COUNT(v.id_vehicule) * 100.0 / s.capacite, 2) AS taux_occupation
FROM stations s
LEFT JOIN vehicules v ON s.id_station = v.id_station
GROUP BY s.id_station, s.nom, s.ville, s.capacite
ORDER BY taux_occupation DESC;

-- --------------------------------------------
-- REQUÊTE 7 : Durée moyenne des locations par ville de départ
-- Utilise : AVG, EXTRACT, JOIN, GROUP BY
-- --------------------------------------------
SELECT 
    s.ville AS ville_depart,
    COUNT(l.id_location) AS nombre_locations,
    ROUND(AVG(EXTRACT(EPOCH FROM (l.date_fin - l.date_debut)) / 60), 2) AS duree_moyenne_minutes,
    ROUND(AVG(l.distance_km), 2) AS distance_moyenne_km
FROM locations l
INNER JOIN stations s ON l.id_station_depart = s.id_station
WHERE l.date_fin IS NOT NULL
GROUP BY s.ville
ORDER BY nombre_locations DESC;

-- --------------------------------------------
-- REQUÊTE 8 : Interventions par technicien avec coût total
-- Utilise : COUNT, SUM, JOIN, GROUP BY
-- --------------------------------------------
SELECT 
    t.id_technicien,
    t.nom,
    t.prenom,
    t.specialite,
    COUNT(i.id_intervention) AS nombre_interventions,
    COUNT(CASE WHEN i.statut = 'Terminee' THEN 1 END) AS interventions_terminees,
    COALESCE(SUM(i.cout), 0) AS cout_total
FROM techniciens t
LEFT JOIN interventions i ON t.id_technicien = i.id_technicien
GROUP BY t.id_technicien, t.nom, t.prenom, t.specialite
ORDER BY nombre_interventions DESC;

-- --------------------------------------------
-- REQUÊTE 9 : Véhicules jamais loués
-- Utilise : LEFT JOIN, IS NULL (anti-join)
-- --------------------------------------------
SELECT 
    v.id_vehicule,
    v.marque,
    v.modele,
    v.immatriculation,
    v.etat,
    s.ville,
    v.date_ajout
FROM vehicules v
LEFT JOIN stations s ON v.id_station = s.id_station
LEFT JOIN locations l ON v.id_vehicule = l.id_vehicule
WHERE l.id_location IS NULL
ORDER BY v.date_ajout;

-- --------------------------------------------
-- REQUÊTE 10 : Chiffre d'affaires mensuel
-- Utilise : DATE_TRUNC, SUM, GROUP BY
-- --------------------------------------------
SELECT 
    DATE_TRUNC('month', p.date_paiement) AS mois,
    COUNT(p.id_paiement) AS nombre_paiements,
    SUM(p.montant) AS chiffre_affaires,
    ROUND(AVG(p.montant), 2) AS panier_moyen
FROM paiements p
WHERE p.statut = 'Valide'
GROUP BY DATE_TRUNC('month', p.date_paiement)
ORDER BY mois DESC;

-- --------------------------------------------
-- REQUÊTE 11 : Analyse des marques les plus louées
-- Utilise : COUNT, JOIN, GROUP BY, HAVING
-- --------------------------------------------
SELECT 
    v.marque,
    COUNT(DISTINCT v.id_vehicule) AS nombre_vehicules,
    COUNT(l.id_location) AS nombre_locations,
    ROUND(COUNT(l.id_location)::DECIMAL / COUNT(DISTINCT v.id_vehicule), 2) AS locations_par_vehicule
FROM vehicules v
LEFT JOIN locations l ON v.id_vehicule = l.id_vehicule
GROUP BY v.marque
HAVING COUNT(DISTINCT v.id_vehicule) > 0
ORDER BY nombre_locations DESC;

-- --------------------------------------------
-- REQUÊTE 12 : Bornes les plus utilisées
-- Utilise : COUNT, SUM, JOIN, GROUP BY
-- --------------------------------------------
SELECT 
    b.id_borne,
    b.numero,
    s.nom AS station,
    s.ville,
    b.type_connecteur,
    b.puissance_kw,
    COUNT(sr.id_session) AS nombre_recharges,
    COALESCE(SUM(sr.energie_kwh), 0) AS energie_totale_kwh,
    COALESCE(SUM(sr.cout), 0) AS revenus_recharge
FROM bornes b
INNER JOIN stations s ON b.id_station = s.id_station
LEFT JOIN sessions_recharge sr ON b.id_borne = sr.id_borne
GROUP BY b.id_borne, b.numero, s.nom, s.ville, b.type_connecteur, b.puissance_kw
ORDER BY nombre_recharges DESC;

-- ============================================
-- PARTIE 3 : VUES
-- ============================================

-- --------------------------------------------
-- VUE 1 : Tableau de bord des véhicules
-- Résumé complet de chaque véhicule avec stats
-- --------------------------------------------
CREATE OR REPLACE VIEW vue_tableau_bord_vehicules AS
SELECT 
    v.id_vehicule,
    v.marque,
    v.modele,
    v.immatriculation,
    v.annee,
    v.autonomie_km,
    v.etat,
    tv.libelle AS type_vehicule,
    s.nom AS station,
    s.ville,
    COUNT(DISTINCT l.id_location) AS nombre_locations,
    COALESCE(SUM(l.distance_km), 0) AS distance_totale_km,
    (SELECT COUNT(*) FROM interventions i WHERE i.id_vehicule = v.id_vehicule) AS nombre_interventions
FROM vehicules v
INNER JOIN types_vehicules tv ON v.id_type = tv.id_type
LEFT JOIN stations s ON v.id_station = s.id_station
LEFT JOIN locations l ON v.id_vehicule = l.id_vehicule
GROUP BY v.id_vehicule, v.marque, v.modele, v.immatriculation, v.annee, 
         v.autonomie_km, v.etat, tv.libelle, s.nom, s.ville;

COMMENT ON VIEW vue_tableau_bord_vehicules IS 'Vue complète des véhicules avec statistiques de location et maintenance';

-- --------------------------------------------
-- VUE 2 : Résumé activité clients
-- Statistiques clients pour le service commercial
-- --------------------------------------------
CREATE OR REPLACE VIEW vue_activite_clients AS
SELECT 
    c.id_client,
    c.nom,
    c.prenom,
    c.email,
    c.date_inscription,
    c.actif,
    COUNT(DISTINCT l.id_location) AS nombre_locations,
    COALESCE(SUM(p.montant), 0) AS depenses_totales,
    COALESCE(SUM(l.distance_km), 0) AS distance_totale_km,
    MAX(l.date_debut) AS derniere_location,
    CASE 
        WHEN MAX(l.date_debut) > CURRENT_TIMESTAMP - INTERVAL '30 days' THEN 'Actif'
        WHEN MAX(l.date_debut) > CURRENT_TIMESTAMP - INTERVAL '90 days' THEN 'Occasionnel'
        WHEN MAX(l.date_debut) IS NULL THEN 'Jamais loué'
        ELSE 'Inactif'
    END AS statut_activite
FROM clients c
LEFT JOIN locations l ON c.id_client = l.id_client
LEFT JOIN paiements p ON l.id_location = p.id_location AND p.statut = 'Valide'
GROUP BY c.id_client, c.nom, c.prenom, c.email, c.date_inscription, c.actif;

COMMENT ON VIEW vue_activite_clients IS 'Vue résumant l''activité de chaque client';

-- ============================================
-- PARTIE 4 : TRIGGERS
-- ============================================

-- --------------------------------------------
-- TRIGGER 1 : Mise à jour automatique du statut véhicule
-- Quand une location commence : véhicule -> "En service"
-- Quand une location termine : véhicule -> "Disponible"
-- --------------------------------------------

-- Fonction pour le trigger
CREATE OR REPLACE FUNCTION fn_update_vehicule_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Si nouvelle location (INSERT) ou passage en cours
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.statut = 'En cours') THEN
        UPDATE vehicules 
        SET etat = 'En service'
        WHERE id_vehicule = NEW.id_vehicule;
    END IF;
    
    -- Si location terminée
    IF TG_OP = 'UPDATE' AND NEW.statut = 'Terminee' AND OLD.statut != 'Terminee' THEN
        UPDATE vehicules 
        SET etat = 'Disponible',
            id_station = NEW.id_station_arrivee
        WHERE id_vehicule = NEW.id_vehicule;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Création du trigger
CREATE TRIGGER trg_update_vehicule_status
    AFTER INSERT OR UPDATE ON locations
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_vehicule_status();

COMMENT ON FUNCTION fn_update_vehicule_status() IS 'Met à jour automatiquement le statut du véhicule lors des locations';

-- --------------------------------------------
-- TRIGGER 2 : Mise à jour du statut de la borne
-- Quand une recharge commence : borne -> "Occupee"
-- Quand une recharge termine : borne -> "Disponible"
-- --------------------------------------------

CREATE OR REPLACE FUNCTION fn_update_borne_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Début de recharge
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.date_fin IS NULL) THEN
        UPDATE bornes 
        SET statut = 'Occupee'
        WHERE id_borne = NEW.id_borne;
    END IF;
    
    -- Fin de recharge
    IF TG_OP = 'UPDATE' AND NEW.date_fin IS NOT NULL AND OLD.date_fin IS NULL THEN
        UPDATE bornes 
        SET statut = 'Disponible'
        WHERE id_borne = NEW.id_borne;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_borne_status
    AFTER INSERT OR UPDATE ON sessions_recharge
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_borne_status();

COMMENT ON FUNCTION fn_update_borne_status() IS 'Met à jour automatiquement le statut de la borne lors des recharges';

-- ============================================
-- PARTIE 5 : FONCTIONS
-- ============================================

-- --------------------------------------------
-- FONCTION 1 : Calcul du coût d'une location
-- Paramètres : durée en minutes, distance en km, type de véhicule
-- Retourne : coût total en euros
-- --------------------------------------------
CREATE OR REPLACE FUNCTION fn_calculer_cout_location(
    p_duree_minutes INTEGER,
    p_distance_km DECIMAL,
    p_id_type INTEGER
)
RETURNS DECIMAL AS $$
DECLARE
    v_tarif_minute DECIMAL;
    v_tarif_km DECIMAL;
    v_cout_total DECIMAL;
BEGIN
    -- Récupérer les tarifs du type de véhicule
    SELECT tarif_minute, tarif_km 
    INTO v_tarif_minute, v_tarif_km
    FROM types_vehicules 
    WHERE id_type = p_id_type;
    
    -- Vérifier si le type existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Type de véhicule % non trouvé', p_id_type;
    END IF;
    
    -- Calculer le coût total
    v_cout_total := (p_duree_minutes * v_tarif_minute) + (p_distance_km * v_tarif_km);
    
    RETURN ROUND(v_cout_total, 2);
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_calculer_cout_location(INTEGER, DECIMAL, INTEGER) IS 
'Calcule le coût d''une location basé sur la durée, la distance et le type de véhicule';

-- Exemple d'utilisation :
-- SELECT fn_calculer_cout_location(60, 25.5, 1); -- 60 min, 25.5 km, type voiture

-- --------------------------------------------
-- FONCTION 2 : Obtenir les statistiques d'une station
-- Paramètres : id de la station
-- Retourne : table avec les statistiques
-- --------------------------------------------
CREATE OR REPLACE FUNCTION fn_stats_station(p_id_station INTEGER)
RETURNS TABLE (
    nom_station VARCHAR,
    ville VARCHAR,
    capacite INTEGER,
    vehicules_disponibles BIGINT,
    vehicules_en_service BIGINT,
    vehicules_maintenance BIGINT,
    bornes_disponibles BIGINT,
    taux_occupation DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.nom,
        s.ville,
        s.capacite,
        COUNT(v.id_vehicule) FILTER (WHERE v.etat = 'Disponible'),
        COUNT(v.id_vehicule) FILTER (WHERE v.etat = 'En service'),
        COUNT(v.id_vehicule) FILTER (WHERE v.etat IN ('En maintenance', 'Hors service')),
        (SELECT COUNT(*) FROM bornes b WHERE b.id_station = s.id_station AND b.statut = 'Disponible'),
        ROUND(COUNT(v.id_vehicule) * 100.0 / NULLIF(s.capacite, 0), 2)
    FROM stations s
    LEFT JOIN vehicules v ON s.id_station = v.id_station
    WHERE s.id_station = p_id_station
    GROUP BY s.id_station, s.nom, s.ville, s.capacite;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_stats_station(INTEGER) IS 
'Retourne les statistiques détaillées d''une station';

-- Exemple d'utilisation :
-- SELECT * FROM fn_stats_station(1);

-- --------------------------------------------
-- FONCTION 3 : Vérifier disponibilité véhicule
-- Paramètres : id véhicule, date début, date fin
-- Retourne : booléen
-- --------------------------------------------
CREATE OR REPLACE FUNCTION fn_vehicule_disponible(
    p_id_vehicule INTEGER,
    p_date_debut TIMESTAMP,
    p_date_fin TIMESTAMP
)
RETURNS BOOLEAN AS $$
DECLARE
    v_conflit INTEGER;
    v_etat VARCHAR;
BEGIN
    -- Vérifier l'état actuel du véhicule
    SELECT etat INTO v_etat FROM vehicules WHERE id_vehicule = p_id_vehicule;
    
    IF v_etat IS NULL THEN
        RETURN FALSE; -- Véhicule n'existe pas
    END IF;
    
    IF v_etat IN ('Hors service', 'En maintenance') THEN
        RETURN FALSE; -- Véhicule indisponible
    END IF;
    
    -- Vérifier les conflits de réservation
    SELECT COUNT(*) INTO v_conflit
    FROM locations
    WHERE id_vehicule = p_id_vehicule
      AND statut = 'En cours'
      AND (
          (date_debut <= p_date_fin AND (date_fin IS NULL OR date_fin >= p_date_debut))
      );
    
    RETURN v_conflit = 0;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_vehicule_disponible(INTEGER, TIMESTAMP, TIMESTAMP) IS 
'Vérifie si un véhicule est disponible pour une période donnée';

-- ============================================
-- REQUÊTES SUPPLÉMENTAIRES BONUS
-- ============================================

-- --------------------------------------------
-- REQUÊTE 13 : Analyse géographique - Flux entre stations
-- --------------------------------------------
SELECT 
    sd.ville AS ville_depart,
    sa.ville AS ville_arrivee,
    COUNT(*) AS nombre_trajets,
    ROUND(AVG(l.distance_km), 2) AS distance_moyenne
FROM locations l
INNER JOIN stations sd ON l.id_station_depart = sd.id_station
INNER JOIN stations sa ON l.id_station_arrivee = sa.id_station
WHERE l.statut = 'Terminee'
GROUP BY sd.ville, sa.ville
ORDER BY nombre_trajets DESC
LIMIT 10;

-- --------------------------------------------
-- REQUÊTE 14 : Analyse temporelle - Locations par jour de semaine
-- --------------------------------------------
SELECT 
    TO_CHAR(date_debut, 'Day') AS jour_semaine,
    EXTRACT(DOW FROM date_debut) AS numero_jour,
    COUNT(*) AS nombre_locations,
    ROUND(AVG(EXTRACT(EPOCH FROM (date_fin - date_debut)) / 60), 2) AS duree_moyenne_minutes
FROM locations
WHERE date_fin IS NOT NULL
GROUP BY TO_CHAR(date_debut, 'Day'), EXTRACT(DOW FROM date_debut)
ORDER BY numero_jour;

-- --------------------------------------------
-- REQUÊTE 15 : Véhicules avec autonomie supérieure à la moyenne
-- Utilise : sous-requête dans WHERE
-- --------------------------------------------
SELECT 
    v.marque,
    v.modele,
    v.autonomie_km,
    v.etat,
    s.ville
FROM vehicules v
LEFT JOIN stations s ON v.id_station = s.id_station
WHERE v.autonomie_km > (SELECT AVG(autonomie_km) FROM vehicules)
ORDER BY v.autonomie_km DESC;

-- ============================================
-- Vérification finale
-- ============================================
SELECT 'Requêtes, vues, triggers et fonctions créés avec succès!' AS message;
