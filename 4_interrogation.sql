
-- A. PROJECTIONS & SÉLECTIONS
-- 1) Véhicules de type 'camion' avec capacité > 10 000 (kg)

SELECT id_veh, immatriculation, type_veh, capacite_veh
FROM VEHICULES
WHERE type_veh = 'camion' AND capacite_veh > 10000
ORDER BY capacite_veh DESC;

-- 2) Conducteurs avec permis 'E' embauchés avant 2015
SELECT num_permis, nom_cond, prenom_cond, date_embauche, type_permis
FROM CONDUCTEURS
WHERE type_permis = 'E' AND date_embauche < '2015-01-01'
ORDER BY date_embauche ASC;

-- 3) Missions en cours entre Paris et Marseille (aller OU retour)
SELECT id_mis, date_depart, date_arriv, statut_mis, lieu_dep_mis, destination_mis, distance
FROM MISSIONS
WHERE statut_mis = 'en_cours'
  AND (
       (lieu_dep_mis = 'Paris' AND destination_mis = 'Marseille')
    OR (lieu_dep_mis = 'Marseille' AND destination_mis = 'Paris')
  )
ORDER BY date_depart DESC;

-- 4) Clients dont la ville est Paris ou Lyon
SELECT id_cl, nom_cl, ville_cl
FROM CLIENTS
WHERE ville_cl IN ('Paris','Lyon')
ORDER BY nom_cl;
-- 5) Clients dont la ville n'est pas renseignée
SELECT id_cl, nom_cl, num_telephone_cl, num_rue_cl, nom_rue_cI, ville_cl
FROM clients
WHERE ville_cl = 'non_renseignée'
ORDER BY nom_cl ;

-- 6) Factures entre 1 200€ et 2 000€ en attente 
SELECT id_fact, id_cl, id_mis, montant_fact, statut_paiem, date_emis
FROM FACTURES
WHERE statut_paiem = 'en_attente'
  AND montant_fact BETWEEN 1200 AND 2000
ORDER BY date_emis;

-- 7) Véhicules de type 'fourgon' avec capacité ≤ 3 500 kg
SELECT id_veh, immatriculation, type_veh, capacite_veh
FROM VEHICULES
WHERE type_veh = 'fourgon' AND capacite_veh <= 3500
ORDER BY capacite_veh DESC;

-- 8) Conducteurs dont le nom commence par 'D'
SELECT num_permis, nom_cond, prenom_cond, type_permis
FROM CONDUCTEURS
WHERE nom_cond LIKE 'D%'
ORDER BY nom_cond, prenom_cond;

-- B. AGRÉGATIONS (GROUP BY, HAVING)

-- 9) Nombre de missions par statut
SELECT statut_mis, COUNT(*) AS nb_missions
FROM MISSIONS
GROUP BY statut_mis
ORDER BY nb_missions DESC;

-- 10) Distance moyenne par ville de départ
SELECT lieu_dep_mis, AVG(distance) AS distance_moyenne
FROM MISSIONS
GROUP BY lieu_dep_mis
ORDER BY distance_moyenne DESC;

-- 11) Total des montants des factures par statut de paiement
SELECT statut_paiem, SUM(montant_fact) AS total_facture, SUM(montant_paye) AS total_paye
FROM FACTURES
GROUP BY statut_paiem
ORDER BY total_facture DESC;

-- 12) Nombre de commandes par client et (> 3)
SELECT id_cl, COUNT(*) AS nb_commandes
FROM COMMANDE
GROUP BY id_cl
HAVING COUNT(*) > 3
ORDER BY nb_commandes DESC;

-- 13) Capacité totale des véhicules par type
SELECT type_veh, COUNT(*) AS nb_vehicules, SUM(capacite_veh) AS capacite_totale
FROM VEHICULES
GROUP BY type_veh
ORDER BY capacite_totale DESC;

-- 14) Moyenne des montants payés par client
SELECT c.id_cl, c.nom_cl, AVG(f.montant_paye) AS moyenne_paye
FROM FACTURES f
JOIN CLIENTS c ON c.id_cl = f.id_cl
GROUP BY c.id_cl, c.nom_cl
ORDER BY moyenne_paye DESC;

-- 15) Nombre de missions par destination (> 2)
SELECT destination_mis, COUNT(*) AS nb_missions
FROM MISSIONS
GROUP BY destination_mis
HAVING COUNT(*) > 2
ORDER BY nb_missions DESC, destination_mis;

-- C. JOINTURES (internes, externes, simples, multiples)

-- 16) Missions avec conducteur et véhicule affectés
SELECT m.id_mis, m.date_depart, m.destination_mis, a.date_affect,
       d.num_permis, d.nom_cond, d.prenom_cond, d.type_permis,
       v.id_veh, v.immatriculation, v.type_veh
FROM AFFECTER a
JOIN MISSIONS    m ON m.id_mis   = a.id_mis
JOIN CONDUCTEURS d ON d.num_permis = a.num_permis
JOIN VEHICULES   v ON v.id_veh   = a.id_veh
ORDER BY m.date_depart;

-- 17) Commandes avec nom du client et statut
SELECT cmd.id_mis, cmd.id_cl, c.nom_cl, cmd.date_com, cmd.statut_com
FROM COMMANDE cmd
JOIN CLIENTS  c ON c.id_cl = cmd.id_cl
ORDER BY cmd.date_com;

-- 18) Factures avec client et mission associée
SELECT f.id_fact, f.date_emis, f.statut_paiem, f.montant_fact, f.montant_paye,
       c.id_cl, c.nom_cl,
       m.id_mis, m.destination_mis, m.statut_mis
FROM FACTURES f
JOIN CLIENTS  c ON c.id_cl  = f.id_cl
JOIN MISSIONS m ON m.id_mis = f.id_mis
ORDER BY f.date_emis;

-- 19) Missions avec équipements associés
SELECT m.id_mis, m.date_depart, m.destination_mis,
       e.id_equip, e.poid_equi, e.volume_equip, e.valeur_equip
FROM MISSIONS m
JOIN EQUIPEMENT e ON e.id_mis = m.id_mis
ORDER BY m.id_mis, e.id_equip;

-- 20) Conducteurs sans véhicule/mission affecté (LEFT JOIN → NULL)
SELECT d.num_permis, d.nom_cond, d.prenom_cond, d.type_permis
FROM CONDUCTEURS d
LEFT JOIN AFFECTER a ON a.num_permis = d.num_permis
WHERE a.num_permis IS NULL
ORDER BY d.num_permis;

-- 21) Liste des équipements avec leur mission et distance
SELECT e.id_equip, e.valeur_equip, e.poid_equi,
       m.id_mis, m.destination_mis, m.distance
FROM EQUIPEMENT e
JOIN MISSIONS m ON m.id_mis = e.id_mis
ORDER BY e.id_equip;

-- 22) Factures avec nom du client et statut de paiement
SELECT f.id_fact, f.statut_paiem, f.montant_fact, f.montant_paye,
       c.id_cl, c.nom_cl
FROM FACTURES f
JOIN CLIENTS  c ON c.id_cl = f.id_cl
ORDER BY f.id_fact;

-- D. REQUÊTES IMBRIQUÉES (IN, NOT IN, EXISTS, NOT EXISTS, ANY, ALL)

-- 23) Clients ayant des factures en attente
SELECT c.id_cl, c.nom_cl
FROM CLIENTS c
WHERE EXISTS (
  SELECT 1 FROM FACTURES f
  WHERE f.id_cl = c.id_cl AND f.statut_paiem = 'en_attente'
)
ORDER BY c.id_cl;

-- 24) Missions dont la distance est > à TOUTES les missions annulées
SELECT m.*
FROM MISSIONS m
WHERE m.distance > ALL (
  SELECT distance FROM MISSIONS WHERE statut_mis = 'annulée'
)
ORDER BY m.distance DESC;

-- 25) Conducteurs sans aucune affectation 
SELECT d.num_permis, d.nom_cond, d.prenom_cond
FROM CONDUCTEURS d
WHERE NOT EXISTS (
  SELECT 1 FROM AFFECTER a WHERE a.num_permis = d.num_permis
)
ORDER BY d.num_permis;

-- 26) Véhicules affectés à au moins une mission planifiée
SELECT DISTINCT v.id_veh, v.immatriculation, v.type_veh
FROM VEHICULES v
WHERE EXISTS (
  SELECT 1
  FROM AFFECTER a
  JOIN MISSIONS m ON m.id_mis = a.id_mis
  WHERE a.id_veh = v.id_veh AND m.statut_mis = 'planifiée'
)
ORDER BY v.id_veh;

-- 27) Clients n’ayant pas passé de commande (NOT EXISTS)
SELECT c.id_cl, c.nom_cl
FROM CLIENTS c
WHERE NOT EXISTS (
  SELECT 1 FROM COMMANDE cmd WHERE cmd.id_cl = c.id_cl
)
ORDER BY c.id_cl;

-- 28) Clients ayant au moins une commande confirmée
SELECT DISTINCT c.id_cl, c.nom_cl
FROM CLIENTS c
WHERE EXISTS (
  SELECT 1 FROM COMMANDE cmd WHERE cmd.id_cl = c.id_cl AND cmd.statut_com = 'confirmée'
)
ORDER BY c.id_cl;

-- 29) Véhicules jamais affectés à une mission
SELECT v.id_veh, v.immatriculation, v.type_veh
FROM VEHICULES v
WHERE v.id_veh NOT IN (SELECT a.id_veh FROM AFFECTER a)
ORDER BY v.id_veh;

-- 30) Missions dont la distance est inférieure à la distance moyenne
SELECT id_mis, lieu_dep_mis, destination_mis, distance
FROM MISSIONS
WHERE distance < (SELECT AVG(distance) FROM MISSIONS)
ORDER BY distance ASC;

-- 31) Clients ayant uniquement des factures payées (et au moins 1 facture)
SELECT c.id_cl, c.nom_cl
FROM CLIENTS c
WHERE EXISTS (
  SELECT 1 FROM FACTURES f WHERE f.id_cl = c.id_cl
)
AND NOT EXISTS (
  SELECT 1 FROM FACTURES f WHERE f.id_cl = c.id_cl AND f.statut_paiem <> 'payée'
)
ORDER BY c.id_cl;

-- E. FORMATIONS (via relation réflexive mentor ← formé)

-- 32) Conducteurs ayant suivi une formation (formés) avec leur mentor
SELECT f.num_permis   AS num_permis_forme,
       f.nom_cond     AS nom_forme,
       f.prenom_cond  AS prenom_forme,
       f.type_permis  AS permis_forme,
       m.num_permis   AS num_permis_mentor,
       m.nom_cond     AS nom_mentor,
       m.prenom_cond  AS prenom_mentor
FROM CONDUCTEURS f
JOIN CONDUCTEURS m ON m.num_permis = f.num_permis_formé
ORDER BY m.num_permis, f.num_permis;

-- 33) Conducteurs sans aucune formation (pas de mentor renseigné)
SELECT d.num_permis, d.nom_cond, d.prenom_cond, d.type_permis
FROM CONDUCTEURS d
WHERE d.num_permis_formé IS NULL
ORDER BY d.num_permis;



