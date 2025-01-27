USE cluedo_db;

-- Personnages
INSERT INTO Personnage (nom_personnage) VALUES
('Mademoiselle Rose'),
('Colonel Moutarde'),
('Madame Leblanc'),
('Monsieur Olive'),
('Madame Pervenche'),
('Docteur Orchidée');

-- Pièces
INSERT INTO Piece (nom_piece) VALUES
('Cuisine'),
('Salle à manger'),
('Salon'),
('Salle de bal'),
('Véranda'),
('Bureau'),
('Bibliothèque'),
('Salle de billard'),
('Hall');

-- Objets (6 armes classiques du Cluedo)
INSERT INTO Objet (nom_objet, id_piece) VALUES
('Couteau', (SELECT id_piece FROM Piece WHERE nom_piece='Hall')),
('Chandelier', (SELECT id_piece FROM Piece WHERE nom_piece='Hall')),
('Revolver', (SELECT id_piece FROM Piece WHERE nom_piece='Hall')),
('Corde', (SELECT id_piece FROM Piece WHERE nom_piece='Hall')),
('Barre de fer', (SELECT id_piece FROM Piece WHERE nom_piece='Hall')),
('Clé anglaise', (SELECT id_piece FROM Piece WHERE nom_piece='Hall'));

-- Joueurs
INSERT INTO Joueur (nom_joueur, role, id_personnage)
VALUES
('Alice', 'MaitreDuJeu', NULL),
('Bob', 'Utilisateur', (SELECT id_personnage FROM Personnage WHERE nom_personnage='Colonel Moutarde')),
('Charlie', 'Utilisateur', (SELECT id_personnage FROM Personnage WHERE nom_personnage='Mademoiselle Rose')),
('Diana', 'Observateur', NULL);

-- Déplacements (exemple)
INSERT INTO Deplacement 
  (date_deplacement, heure_debut, heure_fin, id_personnage, id_piece)
VALUES
('2025-01-27','08:00:00','08:30:00',
  (SELECT id_personnage FROM Personnage WHERE nom_personnage='Colonel Moutarde'),
  (SELECT id_piece FROM Piece WHERE nom_piece='Cuisine')),
('2025-01-27','08:45:00','09:00:00',
  (SELECT id_personnage FROM Personnage WHERE nom_personnage='Colonel Moutarde'),
  (SELECT id_piece FROM Piece WHERE nom_piece='Salon')),
('2025-01-27','08:10:00','08:50:00',
  (SELECT id_personnage FROM Personnage WHERE nom_personnage='Mademoiselle Rose'),
  (SELECT id_piece FROM Piece WHERE nom_piece='Cuisine'));