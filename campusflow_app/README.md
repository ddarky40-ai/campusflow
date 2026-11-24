# CampusFlow

Application Flutter de gestion des échéances universitaires.

## Backend

Depuis le dossier `campusflow_app` :

```powershell
npm install
node server.js
```

L'API écoute sur `http://localhost:3000`.

Compte de démonstration :

- Email : `aminata@campusflow.com`
- Mot de passe : `123456`

## Application

Depuis le dossier `campusflow_app` :

```powershell
flutter pub get
flutter run
```

Sur Android Emulator, l'application utilise automatiquement
`http://10.0.2.2:3000`. Sur Windows et navigateur, elle utilise
`http://localhost:3000`.

## Navigation

La barre du bas donne accès aux écrans Échéances, Cours et Profil.
Les écrans de détail et de création masquent la barre du bas.
Depuis la connexion, le lien « Créer un compte » ouvre l'inscription.
