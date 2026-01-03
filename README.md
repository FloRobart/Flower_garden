# Flower Garden

<img src="./assets/logo/flower_garden_logo_1024.png" alt="Flower Garden Logo" style="display:block; margin:auto;"/>

## Table des matières

<details>
<summary>Voir la table des matières</summary>

- [Flower Garden](#flower-garden)
    - [Table des matières](#table-des-matières)
    - [Description](#description)
    - [Prérequis](#prérequis)
    - [Installation pour le développement](#installation-pour-le-développement)
    - [Mise en production](#mise-en-production)
    - [Liste des projets inclus](#liste-des-projets-inclus)
        - [FlorAccess serveur](#floraccess-serveur)
        - [Econoris serveur](#econoris-serveur)
        - [Econoris app](#econoris-app)
        - [FlollyList serveur](#flollylist-serveur)
        - [FlollyList app](#flollylist-app)
    - [Ajout d'une nouvelle application](#ajout-dune-nouvelle-application)
    - [Licence](#licence)

</details>

## Description

Ce projet vise à déployer et gérer plusieurs applications web en utilisant Docker et Docker Compose. Il inclut des scripts pour automatiser le processus de clonage des dépôts, l'initialisation des variables d'environnement, et le lancement des services. Il est conçu pour être facile à utiliser et à configurer, ainsi que pour être extensible afin d'ajouter de nouvelles applications à l'avenir, avec n'importe quelle technologie.

## Prérequis

Avant de commencer, assurez-vous d'avoir satisfait aux exigences suivantes :

- Vous avez installé `Docker` et `Docker Compose`.
- Être sur un système Linux (Ubuntu, Debian, etc.) ou macOS possédant bash.

## Installation pour le développement

1. Clonez ce dépôt sur votre machine locale :

     ```bash
     git clone https://github.com/FloRobart/Flower_garden.git
     ```

2. Accédez au répertoire cloné :

     ```bash
     cd Flower_garden
     ```

3. Lancez l'application à l'aide du script RUN.sh :

     ```bash
     ./RUN.sh
     ```

     - Le script `RUN.sh` va faire les actions suivantes :
         - Cloner les dépôts présents dans le fichier `projects.list` à l'aide du script `checkout.sh`.
         - Initialiser les variables d'environnement à l'aide du script `init-env.sh`.
         - Lancer la commande `docker-compose up` pour démarrer les services. Cette commande va faire les actions suivantes :
             - Construire les images Docker décrites dans le fichier `docker-compose.yml`.
             - Créer les réseaux et volumes nécessaires.
             - Créer et configurer les conteneurs pour chaque service.
             - Démarrer les conteneurs.

4. Accédez aux applications via votre navigateur web :

     - FlorAccess serveur : [http://localhost:26001](http://localhost:26001)
     - Econoris serveur : [http://localhost:26002](http://localhost:26002)
     - Econoris app : [http://localhost:26003](http://localhost:26003)
     - FlollyList serveur : [http://localhost:26004](http://localhost:26004)
     - FlollyList app : [http://localhost:26005](http://localhost:26005)

## Mise en production

- Cloner le dépôt

    ```bash
    git clone https://github.com/FloRobart/Flower_garden.git
    ```

- Accédez au répertoire cloné

    ```bash
    cd Flower_garden
    ```

- Passer sur la branche de production

    ```bash
    git checkout prod
    ```

- Créer les fichiers d'environnement

    ```bash
    ./init-env.sh
    ```

- Completer les variables d'environnement dans les fichiers `.env` en veillant à ne pas remplir les numéros de ports afin d'utiliser les ports par défaut pour la production (80).
- Lancez l'application

    ```bash
    docker compose -f docker-compose.yml -f docker-compose.proxy.yml up -d
    ```

## Liste des projets inclus

### [FlorAccess serveur](https://github.com/FloRobart/FlorAccess_server)

[FlorAccess](https://github.com/FloRobart/FlorAccess_server) est une API d'authentification.

### [Econoris serveur](https://github.com/FloRobart/Econoris_server)

[Econoris](https://github.com/FloRobart/Econoris_server) serveur est le backend de l'application Econoris.

### [Econoris app](https://github.com/FloRobart/econoris_app)

[Econoris app](https://github.com/FloRobart/econoris_app) est le frontend de l'application Econoris.

### [FlollyList serveur](https://github.com/FloRobart/FlollyList_server)

[FlollyList](https://github.com/FloRobart/FlollyList_server) serveur est le backend de l'application FlollyList.

### [FlollyList app](https://github.com/FloRobart/flollylist_app)

[FlollyList app](https://github.com/FloRobart/flollylist_app) est le frontend de l'application FlollyList.

## Ajout d'une nouvelle application

*Vous devrez suivre les étapes suivantes pour chaque partie d'une nouvelle application à ajouter à Flower Garden, par exemple si vous ajoutez un application avec une base de données, un back-end et un front-end, vous devrez répéter ces étapes trois fois.*

- Ajouter le dépôt git de l'application dans le fichier `/projects.list`
- Ajouter un fichier configuration dans le dossier `/configs/` en suivant les conventions de nommage (copier se qui à déjà été fait pour les autres applications)
- Ajouter les informations nécessaires dans le fichier `/.env.example` en suivant les conventions de nommage (copier se qui à déjà été fait pour les autres applications)
- Ajouter le service dans le fichier `docker-compose.dev.yml` en suivant les conventions de nommage (copier se qui à déjà été fait pour les autres applications)
- Ajouter le service dans le fichier `docker-compose.yml` en suivant les conventions de nommage (copier se qui à déjà été fait pour les autres applications)
- Ajouter le service dans le fichier `docker-compose.proxy.yml` en suivant les conventions de nommage (copier se qui à déjà été fait pour les autres applications)

## Licence

Copyright (C) 2024 Floris Robart

Authors: Floris Robart

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
