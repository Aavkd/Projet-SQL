# Dictionnaire de Données
## cIAra Mobility

---

## Table : TYPES_VEHICULES

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_type | SERIAL | PK, NOT NULL | Identifiant unique du type |
| libelle | VARCHAR(50) | NOT NULL, UNIQUE | Nom du type (Voiture, Scooter, Trottinette, Vélo) |
| tarif_minute | DECIMAL(5,2) | NOT NULL, CHECK > 0 | Tarif par minute en euros |
| tarif_km | DECIMAL(5,2) | NOT NULL, CHECK > 0 | Tarif par kilomètre en euros |

---

## Table : STATIONS

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_station | SERIAL | PK, NOT NULL | Identifiant unique de la station |
| nom | VARCHAR(100) | NOT NULL | Nom de la station |
| adresse | VARCHAR(255) | NOT NULL | Adresse complète |
| ville | VARCHAR(100) | NOT NULL | Ville |
| code_postal | VARCHAR(10) | NOT NULL | Code postal |
| latitude | DECIMAL(10,8) | | Coordonnée GPS latitude |
| longitude | DECIMAL(11,8) | | Coordonnée GPS longitude |
| capacite | INTEGER | NOT NULL, CHECK > 0 | Nombre de places disponibles |

---

## Table : VEHICULES

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_vehicule | SERIAL | PK, NOT NULL | Identifiant unique du véhicule |
| id_type | INTEGER | FK, NOT NULL | Référence vers TYPES_VEHICULES |
| id_station | INTEGER | FK | Station actuelle (NULL si en location) |
| marque | VARCHAR(50) | NOT NULL | Marque du véhicule |
| modele | VARCHAR(50) | NOT NULL | Modèle du véhicule |
| annee | INTEGER | NOT NULL, CHECK 2015-2030 | Année de fabrication |
| energie | VARCHAR(20) | NOT NULL | Type d'énergie |
| autonomie_km | INTEGER | NOT NULL, CHECK > 0 | Autonomie en km |
| immatriculation | VARCHAR(15) | NOT NULL, UNIQUE | Plaque d'immatriculation |
| etat | VARCHAR(20) | NOT NULL, CHECK | État du véhicule |
| date_ajout | DATE | DEFAULT CURRENT_DATE | Date d'ajout à la flotte |

**Valeurs possibles pour `etat`** : Disponible, En service, En maintenance, Hors service

---

## Table : BORNES

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_borne | SERIAL | PK, NOT NULL | Identifiant unique de la borne |
| id_station | INTEGER | FK, NOT NULL | Référence vers STATIONS |
| numero | VARCHAR(20) | NOT NULL | Numéro de la borne dans la station |
| type_connecteur | VARCHAR(50) | NOT NULL | Type de connecteur (Type 2, CCS, CHAdeMO) |
| puissance_kw | DECIMAL(5,2) | NOT NULL, CHECK > 0 | Puissance en kW |
| statut | VARCHAR(20) | NOT NULL, CHECK | État de la borne |

**Valeurs possibles pour `statut`** : Disponible, Occupee, Hors service

---

## Table : CLIENTS

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_client | SERIAL | PK, NOT NULL | Identifiant unique du client |
| nom | VARCHAR(50) | NOT NULL | Nom de famille |
| prenom | VARCHAR(50) | NOT NULL | Prénom |
| email | VARCHAR(100) | NOT NULL, UNIQUE | Adresse email |
| telephone | VARCHAR(20) | | Numéro de téléphone |
| date_naissance | DATE | NOT NULL | Date de naissance |
| permis_numero | VARCHAR(20) | UNIQUE | Numéro de permis de conduire |
| date_inscription | TIMESTAMP | DEFAULT NOW() | Date d'inscription |
| actif | BOOLEAN | DEFAULT TRUE | Compte actif ou non |

---

## Table : TECHNICIENS

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_technicien | SERIAL | PK, NOT NULL | Identifiant unique du technicien |
| nom | VARCHAR(50) | NOT NULL | Nom de famille |
| prenom | VARCHAR(50) | NOT NULL | Prénom |
| email | VARCHAR(100) | NOT NULL, UNIQUE | Adresse email professionnelle |
| telephone | VARCHAR(20) | NOT NULL | Numéro de téléphone |
| specialite | VARCHAR(50) | NOT NULL | Spécialité technique |
| date_embauche | DATE | NOT NULL | Date d'embauche |

---

## Table : LOCATIONS

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_location | SERIAL | PK, NOT NULL | Identifiant unique de la location |
| id_client | INTEGER | FK, NOT NULL | Référence vers CLIENTS |
| id_vehicule | INTEGER | FK, NOT NULL | Référence vers VEHICULES |
| id_station_depart | INTEGER | FK, NOT NULL | Station de départ |
| id_station_arrivee | INTEGER | FK | Station d'arrivée (NULL si en cours) |
| date_debut | TIMESTAMP | NOT NULL | Date et heure de début |
| date_fin | TIMESTAMP | | Date et heure de fin |
| distance_km | DECIMAL(8,2) | CHECK >= 0 | Distance parcourue |
| statut | VARCHAR(20) | NOT NULL, CHECK | État de la location |

**Valeurs possibles pour `statut`** : En cours, Terminee, Annulee

---

## Table : PAIEMENTS

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_paiement | SERIAL | PK, NOT NULL | Identifiant unique du paiement |
| id_location | INTEGER | FK, NOT NULL, UNIQUE | Référence vers LOCATIONS |
| montant | DECIMAL(10,2) | NOT NULL, CHECK >= 0 | Montant en euros |
| methode | VARCHAR(30) | NOT NULL | Méthode de paiement |
| statut | VARCHAR(20) | NOT NULL, CHECK | État du paiement |
| date_paiement | TIMESTAMP | | Date du paiement effectué |

**Valeurs possibles pour `methode`** : Carte bancaire, PayPal, Apple Pay, Google Pay
**Valeurs possibles pour `statut`** : En attente, Valide, Rembourse, Echoue

---

## Table : INTERVENTIONS

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_intervention | SERIAL | PK, NOT NULL | Identifiant unique |
| id_vehicule | INTEGER | FK, NOT NULL | Référence vers VEHICULES |
| id_technicien | INTEGER | FK, NOT NULL | Référence vers TECHNICIENS |
| type_intervention | VARCHAR(50) | NOT NULL | Type d'intervention |
| description | TEXT | | Description détaillée |
| date_debut | TIMESTAMP | NOT NULL | Date de début |
| date_fin | TIMESTAMP | | Date de fin |
| cout | DECIMAL(10,2) | CHECK >= 0 | Coût de l'intervention |
| statut | VARCHAR(20) | NOT NULL, CHECK | État de l'intervention |

**Valeurs possibles pour `type_intervention`** : Maintenance preventive, Reparation, Controle technique, Nettoyage
**Valeurs possibles pour `statut`** : Planifiee, En cours, Terminee, Annulee

---

## Table : SESSIONS_RECHARGE

| Attribut | Type | Contraintes | Description |
|----------|------|-------------|-------------|
| id_session | SERIAL | PK, NOT NULL | Identifiant unique |
| id_vehicule | INTEGER | FK, NOT NULL | Référence vers VEHICULES |
| id_borne | INTEGER | FK, NOT NULL | Référence vers BORNES |
| date_debut | TIMESTAMP | NOT NULL | Début de la recharge |
| date_fin | TIMESTAMP | | Fin de la recharge |
| energie_kwh | DECIMAL(6,2) | CHECK >= 0 | Énergie consommée en kWh |
| cout | DECIMAL(8,2) | CHECK >= 0 | Coût de la recharge |
