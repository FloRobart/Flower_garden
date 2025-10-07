#!/bin/bash

echo "[❕] Initialisation des variables d'environnement"

if [ ! -f ".env" ]; then
    cp .env.example .env
fi

# Enable nullglob so the loop is skipped when there are no matches
shopt -s nullglob

for f in ./config/.env.example.*; do
    # basename like: .env.example.econoris_server or .env.example.ln.econoris_app
    base=$(basename "$f")

    if [[ "$base" == *.ln.* ]]; then
        # Link case: create a link without the ".ln" token to uniformize env filenames
        # extract app name after the ".ln." token
        app_name="${base##*.ln.}"
        link_name="./config/.env.${app_name}"
        link_target="../${app_name}/.env"

        if [ -e "$link_name" ]; then
            if [ -L "$link_name" ]; then
                # already a symlink: check target
                existing_target=$(readlink "$link_name")
                if [ "$existing_target" = "$link_target" ]; then
                    echo "[ℹ️] Lien déjà présent $link_name -> $link_target"
                else
                    echo "[⚠️] Un lien existe déjà en $link_name mais pointe vers $existing_target (attendu: $link_target)."
                fi
            else
                echo "[⚠️] Un fichier existe déjà en $link_name et n'est pas un lien. Aucun changement effectué."
            fi
        else
            ln -s "$link_target" "$link_name"
            echo "[✅] Lien créé : $link_name -> $link_target"
        fi
    else
        target="./config/.env.${f##*.}"
        if [ ! -f "$target" ]; then
            cp "$f" "$target"
            echo "[✅] Copie : $f -> $target"
        else
            echo "[ℹ️] Déjà présent : $target"
        fi
    fi
done

# restore shell option to default (optional)
shopt -u nullglob

echo "[✅] Variables d'environnement initialisées."