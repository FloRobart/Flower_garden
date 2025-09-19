#!/bin/bash

echo "[❕] Initialisation des variables d'environnement"

if [ ! -f ".env" ]; then
    cp .env.example .env
fi

for f in ./config/.env.example.*; do
    target="./config/.env.${f##*.}"
    if [ ! -f "$target" ]; then
        cp "$f" "$target"
    fi
done

echo "[✅] Variables d'environnement initialisées."