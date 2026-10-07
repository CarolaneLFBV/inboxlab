# InboxLab

App iOS de boîte de réception, créée pour explorer une architecture modulaire et outils.
Ce projet sert de support d’apprentissage et de préparation à un entretien.

## Fonctionnalités

- Affichage d’une liste de messages.
- Consultation du détail : expéditeur, destinataire, sujet, date et contenu.
- Passage automatique à « lu » à l’ouverture.
- Indicateur visuel des messages non lus.
- Persistance locale des messages et de leur statut entre les lancements.

## Stack

- **Swift et SwiftUI** : logique et interface.
- **Observation** : état observable des ViewModels.
- **AsyncStream** : transmission des changements de messages.
- **Realm Swift** : stockage local et notifications de changements.
- **Tuist** : génération du projet Xcode et configuration des targets.
- **mise** : gestion de la version de Tuist.
- **Swift Testing** : tests automatisés.

## Installation

Prérequis : macOS, Xcode et mise.
La version minimale de l’application est iOS 18.0.

```sh
git clone git@github.com:CarolaneLFBV/inboxlab.git
cd inboxlab

mise install
mise exec -- tuist install
mise exec -- tuist generate
```

Ouvrir le workspace généré, laisser Xcode résoudre le package Realm, puis sélectionner un simulateur et lancer l’application.

Realm est déclaré dans le manifeste Tuist et utilise l’intégration Swift Package Manager native de Xcode.

Les modifications de targets et de réglages doivent être faites dans `Project.swift`, puis appliquées avec `tuist generate`.

## Tests

Les tests du repository en mémoire vérifient :

- La réception de l’état initial et des changements par deux abonnés.
- La réception des changements par l’abonné restant après annulation de l’autre.

Les tests peuvent être lancés depuis Xcode avec ⌘U.

## Prochaines étapes

- [x] Tester le repository Realm avec une base en mémoire.
- [x] Ajouter une source distante avec Alamofire.
- [ ] Gérer la synchronisation et les erreurs réseau.
- [x] Extraire les responsabilités en modules Tuist.
- [ ] Explorer l’intégration d’un composant UIKit.
