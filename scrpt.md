# Script de Présentation Orale - Projet SQL B2 (clAra Mobility)

**Durée estimée :** 5 minutes  
**Intervenant(s) :** [Vos Noms]

---

## Diapositive 1 : Titre et Introduction

> **Ce que vous dites :**  
> "Bonjour à tous. Nous sommes ravis de vous présenter aujourd'hui le projet de base de données réalisé pour clAra Mobility.
>
> Comme vous le savez, clAra Mobility est une start-up en pleine croissance dans le secteur de la mobilité urbaine durable. Notre mission était de concevoir un système centralisé, robuste et évolutif capable de gérer une flotte hétérogène de véhicules électriques (voitures, scooters, trottinettes), ainsi que tout l'écosystème qui l'entoure : clients, bornes de recharge et maintenance."

---

## Diapositive 2 : Analyse et Modélisation (MCD)

*Afficher le schéma MCD global (ou une version simplifiée).*

> **Ce que vous dites :**  
> "Pour répondre à ce besoin, nous avons commencé par une phase de modélisation stricte selon la méthode Merise. Notre Modèle Conceptuel de Données s'articule autour de 10 entités principales.
>
> Le cœur du système est l'entité `VEHICULES`, qui est liée à son `TYPE` (pour gérer les tarifications différentes entre une voiture et une trottinette) et à sa `STATION` de localisation.
>
> Nous avons accordé une importance particulière à l'intégrité des données :
>
> *   Un véhicule ne peut pas être loué s'il est en maintenance.
> *   Une borne de recharge est physiquement liée à une station.
> *   La gestion des `INTERVENTIONS` techniques et des `SESSIONS_RECHARGE` permet un suivi complet du cycle de vie du matériel."

---

## Diapositive 3 : Architecture Technique

*Afficher les logos PostgreSQL, Docker et peut-être un extrait du docker-compose.*

> **Ce que vous dites :**  
> "Côté technique, nous avons fait le choix de la performance et de la portabilité. La base de données tourne sous **PostgreSQL 16**, conteneurisée via **Docker**. Cela garantit que notre environnement est reproductible instantanément sur n'importe quelle machine de développement ou serveur de production.
>
> Nous avons implémenté des contraintes fortes directement dans le schéma SQL (clés étrangères, contraintes `CHECK` pour les tarifs positifs ou les dates logiques) afin que la base de données soit le dernier garant de la qualité de la donnée, indépendamment de l'application."

---

## Diapositive 4 : Fonctionnalités Avancées (Triggers & Fonctions)

*Afficher un bout de code du trigger ou de la fonction de calcul de coût.*

> **Ce que vous dites :**  
> "Pour aller au-delà du simple stockage, nous avons rendu la base de données 'intelligente' grâce à l'automatisation.
>
> Nous avons développé plusieurs fonctionnalités clés :
>
> *   **L'automatisation des statuts :** Grâce aux Triggers (comme `trg_update_vehicule_status`), le statut d'un véhicule change automatiquement lorsqu'une intervention technique est déclarée. Cela évite les erreurs humaines.
> *   **La logique métier encapsulée :** Nous avons créé des fonctions stockées, notamment `fn_calculer_cout_location`, qui calcule le prix final en fonction de la durée, de la distance et du type de véhicule. Cela centralise la règle de calcul à un seul endroit."

---

## Diapositive 5 : Exploitation de la Donnée (Requêtes & Vues)

*Afficher un graphique ou le résultat de la requête "Top 5 clients" ou le Dashboard.*

> **Ce que vous dites :**  
> "Enfin, une base de données doit servir à la prise de décision. Nous avons mis en place des **Vues** (`Views`) pour simplifier l'accès aux données complexes, comme le tableau de bord des véhicules disponibles.
>
> Nos requêtes analytiques permettent par exemple de suivre :
>
> *   Le Top 5 des clients les plus actifs (pour des programmes de fidélité).
> *   Le taux d'occupation des stations par ville.
> *   La gestion prédictive de la maintenance via l'analyse des autonomies restantes.
>
> Ces outils offrent à l'équipe de clAra Mobility une vision claire et temps réel de l'activité."

---

## Diapositive 6 : Conclusion

> **Ce que vous dites :**  
> "En conclusion, ce projet nous a permis de livrer une solution complète : du modèle conceptuel jusqu'au déploiement Docker, en passant par des scripts d'exploitation avancés.
>
> La base clAra Mobility est aujourd'hui fonctionnelle, documentée et prête à passer à l'échelle. Merci de votre attention, nous sommes maintenant disponibles pour répondre à vos questions."
