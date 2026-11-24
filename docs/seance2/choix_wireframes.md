# Wireframes : parcours et choix de la variante

Auteur : Jude

Les wireframes sont disponibles dans le fichier `wireframes_campusflow.html`.

## Le parcours d'ensemble

L'application comporte sept écrans : Connexion, Inscription, Échéances, Détail, Nouvelle tâche, Cours et Profil.

1. **Connexion** : point d'entrée pour les utilisateurs qui possèdent déjà un compte. Le bouton « Se connecter » mène à Échéances. Le lien « Créer un compte » mène à Inscription. On revient à Connexion depuis Profil (Se déconnecter) ou quand le serveur refuse le jeton.
2. **Inscription** : permet à un nouvel utilisateur de créer son compte. Il renseigne son nom complet, son adresse e-mail, son établissement, sa formation et son mot de passe, qu'il confirme. Après la création du compte, il accède à Échéances. Le lien « Déjà inscrit(e) ? Se connecter » ramène à Connexion.
3. **Échéances** : écran d'accueil. Un appui sur une tâche mène à Détail, le bouton + mène à Nouvelle tâche, la barre du bas mène à Cours et Profil.
4. **Détail** : vient de Échéances. Marquer comme fait, Supprimer ou la flèche retour ramènent à Échéances.
5. **Nouvelle tâche** : vient de Échéances. Enregistrer ou la flèche retour ramènent à Échéances. Si le titre est vide, un message d'erreur s'affiche et on reste sur l'écran.
6. **Cours** : vient de la barre du bas. C'est un écran de consultation.
7. **Profil** : vient de la barre du bas. Il affiche le nom, l'établissement et la formation renseignés lors de l'inscription. Se déconnecter mène à Connexion.

## Règles de navigation

- La barre du bas (Échéances, Cours, Profil) est visible sur les trois écrans principaux. Elle est masquée sur Détail, Nouvelle tâche, Connexion et Inscription, qui sont des écrans secondaires.
- Depuis Connexion, l'utilisateur peut se connecter ou accéder à Inscription s'il ne possède pas encore de compte.
- Après la création du compte, l'utilisateur accède à Échéances. Depuis Inscription, le lien « Déjà inscrit(e) ? Se connecter » ramène à Connexion.
- Détail et Nouvelle tâche s'ouvrent depuis la liste et y reviennent à la fin de l'action ou avec la flèche retour.
- Les informations académiques (établissement et formation) sont saisies à l'inscription et réutilisées dans l'écran Profil. L'utilisateur n'a donc pas à les saisir une deuxième fois.
- « À faire » regroupe toutes les tâches non terminées (retards compris) et « En retard » en est un sous-ensemble.

## Trois variantes de l'écran Échéances

- **Variante A, liste** : une liste simple avec une case à cocher, quatre filtres en haut et un bouton flottant pour ajouter.
- **Variante B, cartes par période** : des cartes regroupées sous En retard, Aujourd'hui, Cette semaine et Plus tard.
- **Variante C, semaine** : une bande des sept jours de la semaine, avec la liste des tâches du jour sélectionné.

## Évaluation avec la grille du cours

### Variante A

- **Besoin** : répond directement à la job story 2, car le filtre « En retard » est disponible dès l'ouverture.
- **Parcours** : cocher une tâche se fait depuis la liste, sans ouvrir l'écran de détail.
- **Accessibilité** : zones de toucher des composants Material, texte secondaire à 14 px avec un fort contraste. Le filtre « En retard » identifie la catégorie par son libellé ; la date dans la ligne reste un texte secondaire ordinaire.
- **Faisabilité** : c'est la plus simple à réaliser, avec une ListView et des ListTile, et elle fonctionne bien à côté d'un panneau de détail sur tablette.

### Variante B

- **Besoin** : le regroupement par période aide à planifier, mais il affiche moins de tâches à l'écran.
- **Parcours** : il faut plus de défilement pour atteindre les tâches du bas.
- **Accessibilité** : correcte, mais les cartes prennent plus de hauteur sur un petit écran.
- **Faisabilité** : moyenne, car il faut calculer les groupes de dates.

### Variante C

- **Besoin** : utile pour planifier la semaine, mais les retards d'une semaine précédente n'apparaissent pas.
- **Parcours** : il faut changer de jour pour tout voir.
- **Accessibilité** : sept boutons étroits sur un écran de 360 dp, ce qui est limite.
- **Faisabilité** : la plus coûteuse, avec un composant de semaine à construire.

## Choix : variante A

La variante A couvre le besoin principal (voir d'un coup ce qui est urgent), reste la plus lisible sur un petit écran et se construit avec les widgets étudiés en séance 5. C'est l'écran 3 du parcours présenté dans ce document (Échéances, après Connexion et Inscription). Les idées de B (regrouper par période) et de C (vue semaine) pourront être ajoutées plus tard sous forme de filtres.