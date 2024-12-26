-- Créer le schéma colleges
DROP SCHEMA IF EXISTS colleges CASCADE;
CREATE SCHEMA colleges;
SET SCHEMA 'colleges';

-- Créer la table _region
CREATE TABLE _region (
    code_region VARCHAR(3) PRIMARY KEY,
    libelle_region VARCHAR(30) NOT NULL UNIQUE
);

-- Créer la table _type
CREATE TABLE _type (
    code_nature VARCHAR(4) PRIMARY KEY,
    libelle_nature VARCHAR(40) NOT NULL
);

-- Créer la table _academie
CREATE TABLE _academie (
    code_academie INT PRIMARY KEY,
    lib_academie VARCHAR(30) NOT NULL UNIQUE
);

-- Créer la table _annee
CREATE TABLE _annee (
    annee_scolaire VARCHAR(5) PRIMARY KEY
);

-- Créer la table _departement
CREATE TABLE _departement (
    code_du_departement VARCHAR(4) PRIMARY KEY,
    nom_departement VARCHAR(30) NOT NULL UNIQUE,
    code_region VARCHAR(3) NOT NULL,
    
    CONSTRAINT fk_departement_region 
        FOREIGN KEY (code_region) REFERENCES _region(code_region)
);

-- Créer la table _commune
CREATE TABLE _commune (
    code_insee_de_la_commune VARCHAR(6) PRIMARY KEY,
    nom_de_la_commune VARCHAR(30) NOT NULL UNIQUE,
    code_du_departement VARCHAR(4) NOT NULL,
    
    CONSTRAINT fk_commune_departement 
        FOREIGN KEY (code_du_departement) REFERENCES _departement(code_du_departement)
);

-- Créer la table _etablissement
CREATE TABLE _etablissement (
    uai VARCHAR(10) PRIMARY KEY,
    nom_etablissement VARCHAR(100) NOT NULL,
    secteur VARCHAR(20) NOT NULL,
    code_postal VARCHAR(6) NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    code_insee_de_la_commune VARCHAR(6) NOT NULL,
    code_nature VARCHAR(4) NOT NULL,
    code_academie INT NOT NULL,
    
    CONSTRAINT fk_etablissement_commune 
        FOREIGN KEY (code_insee_de_la_commune) REFERENCES _commune(code_insee_de_la_commune),
    CONSTRAINT fk_etablissement_type 
        FOREIGN KEY (code_nature) REFERENCES _type(code_nature),
    CONSTRAINT fk_etablissement_academie 
        FOREIGN KEY (code_academie) REFERENCES _academie(code_academie)
);

-- Créer la table _quartier_prioritaire
CREATE TABLE _quartier_prioritaire (
    code_quartier_prioritaire VARCHAR(10) PRIMARY KEY,
    nom_quartier_prioritaire VARCHAR(100)
);

-- Créer la table _a_proximite_de
CREATE TABLE _a_proximite_de (
    uai VARCHAR(10),
    code_quartier_prioritaire VARCHAR(10),
    
    CONSTRAINT pk_a_proximite_de PRIMARY KEY (uai, code_quartier_prioritaire),
    
    CONSTRAINT fk_a_proximite_de_etablissement 
        FOREIGN KEY (uai) REFERENCES _etablissement(uai),
    CONSTRAINT fk_a_proximite_de_quartier_prioritaire 
        FOREIGN KEY (code_quartier_prioritaire) REFERENCES _quartier_prioritaire(code_quartier_prioritaire)
);

-- Créer la table _caracteristiques_tout_etablissement
CREATE TABLE _caracteristiques_tout_etablissement (
    uai VARCHAR(10),
    annee_scolaire VARCHAR(5),
    effectifs INT NOT NULL,
    ips FLOAT NOT NULL,
    ecart_type_de_l_ips FLOAT NOT NULL,
    ep VARCHAR(8) NOT NULL,
    CONSTRAINT pk_caracteristiques_tout_etablissement PRIMARY KEY (uai, annee_scolaire),
    CONSTRAINT fk_caracteristiques_tout_etablissement_etablissement 
        FOREIGN KEY (uai) REFERENCES _etablissement(uai),
    CONSTRAINT fk_caracteristiques_tout_etablissement_annee_scolaire 
        FOREIGN KEY (annee_scolaire) REFERENCES _annee(annee_scolaire)
);

-- Créer la table _caracteristiques_college
CREATE TABLE _caracteristiques_college (
    uai VARCHAR(10),
    annee_scolaire VARCHAR(5),
    nbre_eleves_hors_segpa_hors_ulis INT NOT NULL,
    nbre_eleves_segpa INT NOT NULL,
    nbre_eleves_ulis INT NOT NULL,
    
    CONSTRAINT pk_caracteristiques_college PRIMARY KEY (uai, annee_scolaire),
    
    CONSTRAINT fk_caracteristiques_college_etablissement 
        FOREIGN KEY (uai) REFERENCES _etablissement(uai),
    CONSTRAINT fk_caracteristiques_college_annee_scolaire 
        FOREIGN KEY (annee_scolaire) REFERENCES _annee(annee_scolaire)
);

-- Créer la table _classe
CREATE TABLE _classe (
    id_classe VARCHAR(20) PRIMARY KEY
);

-- Créer la table _caracteristiques_selon_classe
CREATE TABLE _caracteristiques_selon_classe (
    id_classe VARCHAR(20),
    uai VARCHAR(10),
    annee_scolaire VARCHAR(5),
    nbre_eleves_hors_segpa_hors_ulis_selon_niveau INT NOT NULL,
    nbre_eleves_segpa_selon_niveau INT NOT NULL,
    nbre_eleves_ulis_selon_niveau INT NOT NULL,
    effectif_filles INT NOT NULL,
    effectif_garcons INT NOT NULL,
    
    CONSTRAINT pk_caracteristiques_selon_classe PRIMARY KEY (id_classe, uai, annee_scolaire),
    
    CONSTRAINT fk_caracteristiques_selon_classe_classe 
        FOREIGN KEY (id_classe) REFERENCES _classe(id_classe),
    CONSTRAINT fk_caracteristiques_selon_classe_uai 
        FOREIGN KEY (uai) REFERENCES _etablissement(uai),
    CONSTRAINT fk_caracteristiques_selon_classe_annee 
        FOREIGN KEY (annee_scolaire) REFERENCES _annee(annee_scolaire)
);
