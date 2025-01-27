# cluedo_db

##  Le script ci‐dessous constitue le MPD

### Création de la Base de données

    ```bash
    -- 1) Création de la base

    CREATE DATABASE IF NOT EXISTS cluedo_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

    USE cluedo_db;

    -- 2) Création des tables

    -- Table Personnage
    CREATE TABLE Personnage (
        id_personnage INT AUTO_INCREMENT PRIMARY KEY,
        nom_personnage VARCHAR(50) NOT NULL
    );

    -- Table Piece
    CREATE TABLE Piece (
        id_piece INT AUTO_INCREMENT PRIMARY KEY,
        nom_piece VARCHAR(50) NOT NULL,
        CONSTRAINT piece_nom_unique UNIQUE (nom_piece)
    );

    -- Table Objet
    CREATE TABLE Objet (
        id_objet INT AUTO_INCREMENT PRIMARY KEY,
        nom_objet VARCHAR(50) NOT NULL,
        id_piece INT NOT NULL,
        CONSTRAINT fk_objet_piece
            FOREIGN KEY (id_piece)
            REFERENCES Piece (id_piece)
            ON UPDATE CASCADE
            ON DELETE CASCADE
    );

    -- Table Joueur
    CREATE TABLE Joueur (
        id_joueur INT AUTO_INCREMENT PRIMARY KEY,
        nom_joueur VARCHAR(50) NOT NULL,
        role ENUM('MaitreDuJeu','Utilisateur','Observateur') NOT NULL,
        id_personnage INT NULL,
        CONSTRAINT fk_joueur_personnage
            FOREIGN KEY (id_personnage)
            REFERENCES Personnage (id_personnage)
            ON UPDATE CASCADE
            ON DELETE SET NULL
    );

    -- Table Deplacement
    CREATE TABLE Deplacement (
        id_deplacement INT AUTO_INCREMENT PRIMARY KEY,
        date_deplacement DATE NOT NULL,
        heure_debut TIME NOT NULL,
        heure_fin TIME NOT NULL,
        id_personnage INT NOT NULL,
        id_piece INT NOT NULL,
        CONSTRAINT fk_deplacement_personnage
            FOREIGN KEY (id_personnage)
            REFERENCES Personnage (id_personnage)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
        CONSTRAINT fk_deplacement_piece
            FOREIGN KEY (id_piece)
            REFERENCES Piece (id_piece)
            ON UPDATE CASCADE
            ON DELETE CASCADE
    );

    -- Trigger pour garantir un seul Maître du jeu
    DELIMITER $$
    CREATE TRIGGER trg_unique_maitre_du_jeu
    BEFORE INSERT ON Joueur
    FOR EACH ROW
    BEGIN
        IF NEW.role = 'MaitreDuJeu' THEN
            IF (SELECT COUNT(*) FROM Joueur WHERE role = 'MaitreDuJeu') >= 1 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Il y a déjà un MaitreDuJeu dans la partie.';
            END IF;
        END IF;
    END;
    $$
    DELIMITER ;
    ```

### Requêtes SQL

- Lister tous les personnages

  ```bash
  SELECT *
  FROM Personnage;
  ```

- Lister chaque joueur et son personnage associé :
  ```bash
  SELECT j.nom_joueur,
  j.role,
  p.nom_personnage
  FROM Joueur j
  LEFT JOIN Personnage p
  ON j.id_personnage = p.id_personnage;
  ```
- Afficher la liste des personnages présents dans la Cuisine entre 08:00 et 09:00 :
  ```bash
  SELECT pers.nom_personnage
  FROM Deplacement d
  JOIN Personnage pers
  ON d.id_personnage = pers.id_personnage
  JOIN Piece pi
  ON d.id_piece = pi.id_piece
  WHERE pi.nom_piece = 'Cuisine'
  AND d.heure_debut <  '09:00:00'
  AND d.heure_fin   >  '08:00:00';
  ```
- Afficher les pièces où aucun personnage n’est allé :
  ```bash
  SELECT pi.nom_piece
  FROM Piece pi
  WHERE pi.id_piece NOT IN (
  SELECT DISTINCT d.id_piece
  FROM Deplacement d
  );
  ```
- Compter le nombre d'objets par pièce :
  ```bash
  SELECT pi.nom_piece,
  COUNT(o.id_objet) AS nb_objets
  FROM Piece pi
  LEFT JOIN Objet o
  ON o.id_piece = pi.id_piece
  GROUP BY pi.id_piece, pi.nom_piece;
  ```
- Ajouter une pièce :
  ```bash
  INSERT INTO Piece (nom_piece)
  VALUES ('Salle secrète');
  ```
- Modifier un objet :
  ```bash
  UPDATE Objet
  SET nom_objet = 'Nouvelle arme secrète'
  WHERE id_objet = 1;
  ```
- Supprimer une pièce :
  ```bash
  DELETE FROM Piece
  WHERE nom_piece = 'Salle secrète';
  ```
