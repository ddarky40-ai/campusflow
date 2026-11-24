# Fiche comparative Android / iOS

Cas étudié : une application destinée aux étudiants d'Afrique francophone.
Auteur : Jude

## 1. Philosophie
- **Android** : système ouvert (AOSP), repris par de nombreux constructeurs.
- **iOS** : système fermé, matériel et logiciel contrôlés par Apple.
- **Dans notre contexte** : Android existe à tous les niveaux de prix, ce qui explique sa place chez les étudiants.

## 2. Architecture
- **Android** : noyau Linux, runtime ART, couche d'abstraction matérielle (HAL).
- **iOS** : noyau XNU (Darwin), couche Cocoa Touch.
- **Dans notre contexte** : beaucoup de téléphones Android d'entrée de gamme n'ont que 2 à 3 Go de RAM, l'application doit rester légère.

## 3. Langage
- **Android** : Kotlin, Java.
- **iOS** : Swift, Objective-C.
- **Dans notre contexte** : deux langages imposent deux bases de code. Flutter (Dart) permet d'en écrire une seule.

## 4. Cycle de vie
- **Android** : Activity et Fragment, le système peut tuer un processus en arrière-plan.
- **iOS** : application suspendue rapidement en arrière-plan.
- **Dans notre contexte** : sur des appareils à faible mémoire, il faut sauvegarder l'état pour ne pas perdre une saisie.

## 5. Permissions
- **Android** : demandées à l'exécution depuis Android 6, modèle de plus en plus restrictif.
- **iOS** : demandées à l'exécution, contrôles stricts.
- **Dans notre contexte** : la permission de notification doit être demandée au bon moment, avec une explication claire.

## 6. Stockage
- **Android** : stockage interne, carte SD possible.
- **iOS** : sandbox stricte, pas de carte SD.
- **Dans notre contexte** : peu d'espace libre sur les appareils modestes, donc on limite les données et images stockées.

## 7. Distribution
- **Android** : Google Play, installation d'APK hors store, boutiques alternatives.
- **iOS** : App Store uniquement.
- **Dans notre contexte** : le partage d'APK de téléphone à téléphone est courant, ce qui facilite la diffusion entre étudiants.

## 8. Fragmentation
- **Android** : nombreuses versions, tailles d'écran et surcouches constructeurs.
- **iOS** : peu de modèles, versions récentes très répandues.
- **Dans notre contexte** : on vise une version minimale d'Android basse et on teste sur petit écran.

## 9. Mises à jour
- **Android** : dépendent du constructeur, souvent tardives.
- **iOS** : distribuées directement par Apple, adoption rapide.
- **Dans notre contexte** : beaucoup d'étudiants gardent d'anciennes versions d'Android, donc pas de fonction réservée aux versions récentes.

## 10. Contraintes de développement
- **Android** : tests nécessaires sur de nombreux appareils.
- **iOS** : Mac obligatoire pour compiler, compte développeur à 99 dollars par an.
- **Dans notre contexte** : un Mac et un abonnement annuel dépassent le budget d'un étudiant.

## 11. Outils
- **Android** : Android Studio sur Windows, Linux et macOS.
- **iOS** : Xcode, macOS uniquement.
- **Dans notre contexte** : nous travaillons sous Windows, seul Android est testable directement.

## 12. Paiement
- **Android** : Google Play Billing, mais le Mobile Money est très utilisé.
- **iOS** : achats intégrés via Apple.
- **Dans notre contexte** : le Mobile Money passe avant la carte bancaire. CampusFlow est gratuite et n'a pas besoin d'achat intégré.

## 13. Coût du matériel
- **Android** : large choix, dès quelques dizaines de milliers de FCFA.
- **iOS** : iPhone coûteux par rapport aux revenus locaux.
- **Dans notre contexte** : le public étudiant utilise très majoritairement Android.

## 14. Connectivité et données
- **Android** : Android Go et applications allégées répandues.
- **iOS** : mode données réduites disponible, mais parc d'appareils récents et coûteux.
- **Dans notre contexte** : forfaits de données chers et réseau instable. L'application échange peu de données et doit rester utilisable hors connexion.

## Répartition des systèmes selon les régions

Selon StatCounter, la part d'Android sur mobile en Afrique se situe entre 81 % et 84 % en 2026, contre 16 % à 19 % pour iOS. Aux États-Unis, les deux systèmes se partagent le marché de façon beaucoup plus équilibrée. Un choix de plateforme fait sur des statistiques mondiales ou américaines serait donc mauvais pour notre cible.

Source : StatCounter Global Stats, Mobile Operating System Market Share Africa
https://gs.statcounter.com/os-market-share/mobile/africa