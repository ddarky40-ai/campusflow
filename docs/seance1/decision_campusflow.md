# Décision pour CampusFlow

Auteur : Jude

**Cible.** CampusFlow s'adresse aux étudiants des universités d'Afrique francophone, comme au Burkina Faso. Ils ont besoin de suivre leurs cours, leurs échéances et leurs tâches, le plus souvent sur un smartphone Android d'entrée de gamme avec une connexion mobile irrégulière.

**Plateformes.** Android en priorité : il représente plus de 80 % des mobiles en Afrique selon StatCounter, il permet de distribuer l'application par APK, et nous pouvons le tester sous Windows sans Mac ni compte développeur payant. iOS viendra dans un second temps, avec la même base de code.

**Approche.** Cross-platform avec Flutter et Dart. Une seule base de code évite de maintenir deux applications, l'interface reste fluide sur des appareils modestes, et l'ajout d'iOS ne demandera pas de tout réécrire. Le développement natif en Kotlin offrirait un contrôle plus fin, mais obligerait à tout refaire pour iOS, ce qui n'est pas justifié pour une application de suivi de tâches.

**Justification.** La fiche comparative montre qu'Android domine la région et que sa fragmentation se gère avec une version minimale basse et une application légère. L'autopsie de Windows Phone rappelle qu'une plateforme disparaît quand elle n'a ni public ni applications : nous choisissons donc la plateforme où sont les utilisateurs, et un outil qui limite l'effort de développement.