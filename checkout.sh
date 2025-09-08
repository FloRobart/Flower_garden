#!/bin/bash

# Vérifier que le fichier projects.list existe
if [ ! -f "./projects.list" ]; then
    echo "Le fichier ./projects.list est introuvable."
    exit 1
fi

# Lire chaque ligne du fichier projects.list (format: folder_name git_link type)
while IFS= read -r line || [ -n "$line" ]; do
    # Nettoyer la ligne (suppression des espaces et retours chariot)
    line="$(echo "$line" | tr -d '\r' | xargs)"

    # Ignorer les lignes vides ou les commentaires
    if [[ -z "$line" || "$line" =~ ^# ]]; then
        continue
    fi

    # Extraire folder et URL (format: folder git_link type)
    folder=$(echo "$line" | awk '{print $1}')
    repo_url=$(echo "$line" | awk '{print $2}')

    if [ -z "$folder" ] || [ -z "$repo_url" ]; then
        echo "Ligne invalide dans projects.list: '$line' (attendu: folder git_link type)"
        continue
    fi

    # Cloner ou mettre à jour le projet dans le dossier parent
    target_dir="../$folder"
    if [ ! -d "$target_dir" ]; then
        echo "Clonage de $repo_url dans $target_dir"
        git clone "$repo_url" "$target_dir"
        if [ $? -eq 0 ]; then
            echo "Le projet $folder a été cloné avec succès dans $target_dir."
        else
            echo "Erreur lors du clonage de $folder." 
            continue
        fi
    elif [ -d "$target_dir/.git" ]; then
        echo "Le projet $folder existe déjà dans $target_dir, mise à jour du projet..."
        git -C "$target_dir" pull || echo "Échec du pull pour $folder"
    else
        echo "Le dossier $target_dir existe déjà mais n'est pas un dépôt git, clonage ignoré."
    fi

    # Créer le lien symbolique dans le dossier courant
    if [ ! -L "$folder" ]; then
        ln -s "$target_dir" "$folder"
        echo "Lien symbolique créé pour $folder -> $target_dir."
    else
        echo "Le lien symbolique $folder existe déjà."
    fi
done < "./projects.list"
