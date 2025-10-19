ALTER TABLE VEHICULES
	  ADD CONSTRAINT chk_capacite_veh
      CHECK(capacite_veh > 0);

ALTER TABLE CONDUCTEURS
     ADD CONSTRAINT chk_type_permis
     CHECK(type_permis IN ('A','B','C','D','E'));
     
ALTER TABLE MISSIONS
   ADD CONSTRAINT chk_statut_mis
   CHECK(statut_mis IN ('planifiée','en_cours','terminée','annulée'));
ALTER TABLE MISSIONS
   ADD CONSTRAINT chk_date_mis
   CHECK(date_depart<date_arriv);
   -- date_depart et date_arriv font reference au debut  et arriver a la destination et non au debut et fin de mission
ALTER TABLE MISSIONS
   ADD CONSTRAINT chk_distance
   CHECK(distance>0);
  
ALTER TABLE CLIENTS
ALTER COLUMN ville_cl SET DEFAULT 'non_renseignée';

-/* vu que le renseignement de la ville actuelle du client est  not null,
cela permet de mettre cette valeur par defaut si ce n'est pas reseigné pour respecter cette contrainte */
  
  
ALTER TABLE FACTURES
   ADD CONSTRAINT chk_statut_paiem
   CHECK(statut_paiem IN ('payée','en_attente','annulée','avance_payée'));
ALTER TABLE FACTURES
   ADD CONSTRAINT chk_montant_paye
   CHECK(montant_paye >= 0);
   
ALTER TABLE EQUIPEMENT
   ADD CONSTRAINT chk_poid_equi
   CHECK(poid_equi > 0),
   ADD CONSTRAINT chk_volum_equip
   CHECK(volume_equip > 0),
   ADD CONSTRAINT chk_val_equip
   CHECK(valeur_equip > 0);
-- valeur correspond ici à une somme d'argent pour un equipement