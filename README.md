# Flower Garden

## Table des matières

<details>
<summary>Voir la table des matières</summary>

- [Flower Garden](#flower-garden)
  - [Table des matières](#table-des-matières)
  - [Description](#description)
  - [Prérequis](#prérequis)
  - [Installation](#installation)
  - [Mise en production](#mise-en-production)
  - [Liste des projets inclus](#liste-des-projets-inclus)
    - [FlorAccess serveur](#floraccess-serveur)
    - [Econoris serveur](#econoris-serveur)
    - [Econoris app](#econoris-app)
  - [Architecture](#architecture)

</details>

## Description

Ce projet vise à déployer et gérer plusieurs applications web en utilisant Docker et Docker Compose. Il inclut des scripts pour automatiser le processus de clonage des dépôts, l'initialisation des variables d'environnement, et le lancement des services. Il est conçu pour être facile à utiliser et à configurer, ainsi que pour être extensible afin d'ajouter de nouvelles applications à l'avenir, avec n'importe quelle technologie.

## Prérequis

Avant de commencer, assurez-vous d'avoir satisfait aux exigences suivantes :

- Vous avez installé `Docker` et `Docker Compose`.
- Être sur un système Linux (Ubuntu, Debian, etc.) ou macOS possédant bash.

## Installation

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

   - FlorAccess serveur : [http://localhost:8081](http://localhost:8081)
   - Econoris serveur : [http://localhost:8082](http://localhost:8082)
   - Econoris app : [http://localhost:8083](http://localhost:8083)

## Mise en production

- Créer un dossier `Flower_garden` sur votre serveur de production.

  ```bash
  mkdir Flower_garden
  cd Flower_garden
  ```

- Téléchargez la release la plus récente

  ```bash
  curl -L https://github.com/FloRobart/Flower_garden/releases/download/v1.0.0/Flower_garden.tar.gz | tar -xz
  ```

- Créer les fichiers d'environnement

  ```bash
  ./init-env.sh
  ```

- Lancez l'application

  ```bash
  docker-compose -f docker-compose.yml -f docker-compose.proxy.yml up -d
  ```

## Liste des projets inclus

### [FlorAccess serveur](https://github.com/FloRobart/FlorAccess_server)

[FlorAccess](https://github.com/FloRobart/FlorAccess_server) est une API d'authentification.

### [Econoris serveur](https://github.com/FloRobart/Econoris_server)

[Econoris](https://github.com/FloRobart/Econoris_server) serveur est le backend de l'application Econoris.

### [Econoris app](https://github.com/FloRobart/econoris_app)

[Econoris app](https://github.com/FloRobart/econoris_app) est le frontend de l'application Econoris.

## Architecture

<details>
<summary>Voir l'architecture</summary>

- Comming soon...

</details>