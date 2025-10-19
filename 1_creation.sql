create database miniProjet;
use miniProjet;

CREATE TABLE MISSIONS(
   id_mis INT,
   date_depart DATETIME NOT NULL,
   date_arriv DATETIME NOT NULL,
   statut_mis VARCHAR(50) NOT NULL,
   lieu_dep_mis VARCHAR(40) NOT NULL,
   destination_mis VARCHAR(40) NOT NULL,
   distance INT NOT NULL,
   PRIMARY KEY(id_mis)
);

CREATE TABLE VEHICULES(
   id_veh INT,
   immatriculation VARCHAR(15) NOT NULL,
   type_veh VARCHAR(40) NOT NULL,
   capacite_veh INT NOT NULL,
   PRIMARY KEY(id_veh)
);

CREATE TABLE CONDUCTEURS(
   num_permis INT,
   nom_cond VARCHAR(50) NOT NULL,
   prenom_cond VARCHAR(50) NOT NULL,
   date_nai_cond DATE NOT NULL,
   date_embauche DATE NOT NULL,
   type_permis VARCHAR(10) NOT NULL,
   num_permis_formé INT,
   PRIMARY KEY(num_permis),
   FOREIGN KEY(num_permis_formé) REFERENCES CONDUCTEURS(num_permis)
);

CREATE TABLE CLIENTS(
   id_cl INT,
   nom_cl VARCHAR(50) NOT NULL,
   num_telephone_cl INT NOT NULL,
   num_rue_cl INT,
   nom_rue_cI VARCHAR(60),
   ville_cl VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_cl),
   UNIQUE(num_telephone_cl)
);

CREATE TABLE FACTURES(
   id_fact INT,
   montant_fact DECIMAL(25,2) NOT NULL,
   date_emis DATE NOT NULL,
   statut_paiem VARCHAR(20) NOT NULL,
   montant_paye INT NOT NULL,
   id_cl INT NOT NULL,
   id_mis INT NOT NULL,
   PRIMARY KEY(id_fact),
   FOREIGN KEY(id_cl) REFERENCES CLIENTS(id_cl),
   FOREIGN KEY(id_mis) REFERENCES MISSIONS(id_mis)
);

CREATE TABLE EQUIPEMENT(
   id_equip INT,
   poid_equi DECIMAL(25,2) NOT NULL,
   volume_equip DECIMAL(15,2) NOT NULL,
   valeur_equip DECIMAL(15,2) NOT NULL,
   id_mis INT NOT NULL,
   PRIMARY KEY(id_equip),
   FOREIGN KEY(id_mis) REFERENCES MISSIONS(id_mis)
);

CREATE TABLE AFFECTER(
   id_mis INT,
   id_veh INT,
   num_permis INT,
   date_affect DATE NOT NULL,
   PRIMARY KEY(id_mis, id_veh, num_permis),
   FOREIGN KEY(id_mis) REFERENCES MISSIONS(id_mis),
   FOREIGN KEY(id_veh) REFERENCES VEHICULES(id_veh),
   FOREIGN KEY(num_permis) REFERENCES CONDUCTEURS(num_permis)
);

CREATE TABLE COMMANDE(
   id_mis INT,
   id_cl INT,
   date_com DATETIME NOT NULL,
   statut_com VARCHAR(20) NOT NULL,
   PRIMARY KEY(id_mis, id_cl),
   FOREIGN KEY(id_mis) REFERENCES MISSIONS(id_mis),
   FOREIGN KEY(id_cl) REFERENCES CLIENTS(id_cl)
);
