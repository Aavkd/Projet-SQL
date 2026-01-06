-- ============================================
-- cIAra Mobility - Script de création de base
-- ============================================
-- Script 01: Création de la base de données
-- PostgreSQL
-- ============================================

-- Supprimer la base si elle existe (attention en production!)
-- DROP DATABASE IF EXISTS ciara_mobility;

-- Création de la base de données
CREATE DATABASE ciara_mobility
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'fr_FR.UTF-8'
    LC_CTYPE = 'fr_FR.UTF-8'
    TEMPLATE = template0;

-- Connexion à la base
\c ciara_mobility;

-- Message de confirmation
SELECT 'Base de données ciara_mobility créée avec succès!' AS message;
