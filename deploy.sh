#!/usr/bin/env bash
set -euo pipefail

echo "[deploy] chargement des images Docker depuis le répertoire courant"

for f in *.tar; do
  [ -f "$f" ] || continue
  echo "[deploy] docker load -i $f"
  docker load -i "$f"
done

echo "[deploy] images chargées. Démarrage des services via docker-compose/docker compose"

if command -v docker-compose >/dev/null 2>&1; then
  docker-compose up -d
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  docker compose up -d
else
  echo "[deploy] erreur: ni 'docker-compose' ni 'docker compose' disponible"
  exit 1
fi

echo "[deploy] terminé"
