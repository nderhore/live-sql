# création de la table Utilisateur

CREATE TABLE utilisateur(
    utilisateur_id INT AUTO_INCREMENT PRIMARY KEY,
    GSM varchar(10) NOT NULL,
    mail varchar(50) NOT NULL,
    nom varchar(50) NOT NULL,
    prenom varchar(50) NOT NULL,
    adresse varchar(50) NOT NULL
);

# création de la table article
CREATE TABLE article(
    article_id INT AUTO_INCREMENT PRIMARY KEY,
    nom varchar(50) NOT NULL,
    description varchar(50),
    prix FLOAT NOT NULL
);

CREATE TABLE utilisateur_article(
    article_id INT,
    utilisateur_id INT,
    quantite INT NOT NULL,
    PRIMARY KEY (article_id,utilisateur_id),
    FOREIGN KEY (article_id) REFERENCES article(article_id),
    CONSTRAINT fk_user
        FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id)
);

CREATE TABLE pays(
    pays_id INT AUTO_INCREMENT PRIMARY KEY,
    libelle varchar(50) NOT NULL
);

CREATE TABLE depot(
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


START TRANSACTION;                                                              '5 rue du pont');
SELECT * from utilisateur;
    #operation 1 : inserer l'enregistrement de la commande
    INSERT INTO utilisateur_article (article_id, utilisateur_id, quantite) VALUES
                                                                               (1,1,1);
    # -> retirer un element du stock
    UPDATE article_depot SET quantite = quantite-1 WHERE article_id=1 AND depot_id=4;

    SELECT * from utilisateur_article;
    SELECT * from article_depot;
COMMIT; # push (envoie vers le serveur)






