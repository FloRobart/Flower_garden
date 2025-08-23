# Flower Garden

## Table of Contents

- [Flower Garden](#flower-garden)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)

## Description

This repository contains the Docker setup for two applications: FlorAccess and Econoris. Each application has its own PostgreSQL database and server, all managed through Docker Compose.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have a Docker environment set up and running.
- You have Docker Compose installed.

## Installation

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/FloRobart/Flower_garden.git
   cd Flower_garden
   ```

2. Run the `RUN.sh` script to start the applications:

   ```bash
   ./RUN.sh
   ```

3. Copy the `.env.dev` files to `.env` in both the `FlorAccess` and `Econoris` directories and configure them as needed.
4. Start the Docker containers:

   ```bash
   docker-compose up -d
   ```

5. Access the applications via your web browser:
   - FlorAccess: `http://localhost:8080`
   - Econoris: `http://localhost:8081`
