# création de la table Utilisateur

CREATE TABLE IF NOT EXISTS utilisateur(
    utilisateur_id INT AUTO_INCREMENT PRIMARY KEY,
    GSM varchar(10) NOT NULL,
    mail varchar(50) NOT NULL,
    nom varchar(50) NOT NULL,
    prenom varchar(50) NOT NULL,
    adresse varchar(50) NOT NULL
);

# création de la table article
CREATE TABLE IF NOT EXISTS article(
    article_id INT AUTO_INCREMENT PRIMARY KEY,
    nom varchar(50) NOT NULL,
    description varchar(50),
    prix FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS utilisateur_article(
    article_id INT,
    utilisateur_id INT,
    quantite INT NOT NULL,
    PRIMARY KEY (article_id,utilisateur_id),
    FOREIGN KEY (article_id) REFERENCES article(article_id),
    CONSTRAINT fk_user
        FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id)
);

CREATE TABLE IF NOT EXISTS pays(
    pays_id INT AUTO_INCREMENT PRIMARY KEY,
    libelle varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS depot(
    depot_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nom varchar(50) NOT NULL,
    ville varchar(50) NOT NULL,
    pays_id INT,
    CONSTRAINT fk_pays
                  FOREIGN KEY(pays_id) REFERENCES pays(pays_id)
);

CREATE TABLE IF NOT EXISTS article_depot(
    article_id INT,
    depot_id INT,
    quantite INT NOT NULL,
    PRIMARY KEY (article_id,depot_id),
    FOREIGN KEY (article_id) REFERENCES article(article_id),
    CONSTRAINT fk_depot
        FOREIGN KEY (depot_id) REFERENCES depot(depot_id)
);

# alimentation (jeu de données)
INSERT INTO article (nom,description,prix) VALUES ('GSM', 'appel à la belge',15.5);
INSERT INTO article (nom,description,prix) VALUES ('test', 'toto',12);
INSERT INTO article (nom,description,prix) VALUES ('sergio', 'toto',10);
INSERT INTO pays(libelle) VALUES ('France');
INSERT INTO pays(libelle) VALUES ('France');
INSERT INTO depot(nom,ville,pays_id)
    SELECT 'toto','Paris',pays_id
    FROM pays
    WHERE pays.libelle = 'France'
    LIMIT 1;
INSERT INTO utilisateur (GSM, mail, nom, prenom, adresse) VALUES
                                                              ('3630',
                                                               'jose@ose.fr',
                                                               'ose',
                                                               'jose',
                                                               '5 rue du pont');

INSERT INTO article_depot (article_id, depot_id, quantite) VALUES (1,4,2);
INSERT INTO article_depot (article_id, depot_id, quantite) VALUES (2,4,0);
INSERT INTO article_depot (article_id, depot_id, quantite) VALUES (3,4,-1);

# Trigger : permet de mettre en place des verifications sur la valeur des champs
CREATE TRIGGER check_quantite_before_insert
    BEFORE INSERT ON article_depot
        FOR EACH ROW
            BEGIN
                IF NEW.quantite < 0 THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Erreur : la quantité ne peut pas être negative.';
                end if;
            end;

CREATE TRIGGER check_quantite_before_update
    BEFORE UPDATE ON article_depot
        FOR EACH ROW
            BEGIN
                IF NEW.quantite < 0 THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Erreur : la quantité ne peut pas être negative.';
                end if;
            end;


CREATE TABLE IF NOT EXISTS inventaire(
    article_nom VARCHAR(255) NOT NULL,
    quantite INT NOT NULL
);
# une procedure => une fonction
# un event => permet de lancer une fonction à un moment données
# par defaut, les evenements ne sont pas activé , voici comment les activer
SET GLOBAL event_scheduler = ON;
CREATE EVENT update_inventaire
    ON SCHEDULE EVERY 1 YEAR
    STARTS CURRENT_DATE #generalement on prend un format UTC
    DO
    BEGIN
        INSERT INTO inventaire(article_nom,quantite)
            SELECT a.nom, SUM(ad.quantite)
                FROM article a
                JOIN article_depot ad ON ad.article_id = a.article_id
                GROUP BY a.article_id
                HAVING SUM(ad.quantite) > 0;
    end;




START TRANSACTION;
SELECT * from utilisateur;
    #operation 1 : inserer l'enregistrement de la commande
    INSERT INTO utilisateur_article (article_id, utilisateur_id, quantite) VALUES
                                                                               (1,1,1);
    # -> retirer un element du stock
    UPDATE article_depot SET quantite = quantite-1 WHERE article_id=1 AND depot_id=4;

    SELECT * from utilisateur_article;
    SELECT * from article_depot;
ROLLBACK ; # push (envoie vers le serveur)

# Je veux tous les articles présent dans le depot 4
SELECT *
FROM article_depot
WHERE depot_id = 4;

# je veux le nom des articles qui coutent moins de 13 euros
CREATE VIEW article_moins_treize_euros
AS
    SELECT a.nom
    FROM article_depot as ad
    JOIN article as a ON a.article_id = ad.article_id
    WHERE depot_id = 4 and a.prix < 13;
