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

CREATE TABLE article_depot(
    article_id INT,
    depot_id INT,
    quantite INT NOT NULL,
    PRIMARY KEY (article_id,depot_id),
    FOREIGN KEY (article_id) REFERENCES article(article_id),
    CONSTRAINT fk_depot
        FOREIGN KEY (depot_id) REFERENCES depot(depot_id)

);
