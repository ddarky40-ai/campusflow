# Design system v1

Auteur : Jude

## Couleurs

Contraste calculé selon la formule WCAG, le minimum demandé pour le texte est 4,5:1.

- **Primaire** : #1E4FA3 (bleu). Boutons principaux, icône de connexion et élément actif de la navigation. Texte blanc dessus : environ 7,8:1.
- **Alerte** : #B3261E (rouge). Erreurs du formulaire d'inscription. L'écran Connexion utilise le rouge Material par défaut.
- **Texte** : #1B1F27. Sur blanc : environ 16:1.
- **Texte secondaire** : #4A5160. Sur blanc : environ 8:1.
- **Surface** : #F3F5F9 pour les cartes, #FFFFFF pour le fond des écrans et des barres d'application.
- **Bordure des champs** : #6B7385. Sur blanc : environ 4,8:1.

## Typographie

Police : Roboto (police par défaut d'Android, aucun fichier à ajouter).

- Titre de barre d'application : 20 px, medium.
- Titre d'écran : 22 px, medium.
- Corps de texte : 16 px, regular.
- Texte secondaire : 14 px, regular.
- Légende et étiquette de navigation : 12 px, medium.

## Composants

### Bouton principal

Bouton `FilledButton` Material 3, fond primaire et texte blanc. Le bouton secondaire (Supprimer) est un `OutlinedButton` Material 3, sans bordure rouge personnalisée.

### Carte de tâche

Fond surface, coins arrondis à 12 dp, marge de 16 dp. Elle contient le titre (16 px medium), le cours et la date (14 px). Une tâche terminée est indiquée par son titre barré. La date d'une tâche en retard n'a pas de couleur ni de libellé spécifique.

### Champ de saisie

Hauteur minimale de 56 dp, bordure de 1 px, coins arrondis à 8 dp. L'étiquette est affichée dans le champ avec `labelText`.

### Formulaire d'inscription

Le formulaire d'inscription réutilise le composant Champ de saisie. Il comprend les champs suivants :

- Nom complet.
- Adresse e-mail.
- Établissement.
- Formation.
- Mot de passe.
- Confirmation du mot de passe.

Les champs obligatoires sont validés à la soumission. Une erreur de saisie est signalée à proximité du champ concerné.

Le bouton « Créer mon compte » utilise le composant Bouton principal. Un lien secondaire « Déjà inscrit(e) ? Se connecter » permet de revenir à l'écran Connexion.

### Ligne de tâche (liste Échéances)

Case à cocher dans une zone de toucher de 48 dp, puis titre (16 px medium), cours et date (14 px). Le titre d'une tâche terminée est barré. Les tâches en retard peuvent être affichées avec le filtre « En retard » ; leur date n'est pas colorée dans la liste.

### Barre de navigation

Trois onglets : Échéances, Cours, Profil. Hauteur 72 dp, onglet actif en couleur primaire. Elle est masquée sur les écrans secondaires (Détail, Nouvelle tâche, Connexion et Inscription).

## Tailles de fenêtre visées

- **Téléphone, moins de 600 dp** : cible principale, testée à 360 par 800 dp et 390 par 844 dp. Une seule colonne et une barre de navigation en bas.
- **Tablette, 840 dp et plus** : la liste et le détail côte à côte.
- Les zones de toucher utilisent les composants Material de l'application.
