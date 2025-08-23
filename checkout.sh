#!/bin/bash

# Vérifier que le fichier projects.list existe
if [ ! -f "./projects.list" ]; then
    echo "Le fichier ./projects.list est introuvable."
    exit 1
fi

# Lire chaque ligne du fichier projects.list
while IFS= read -r repo_url || [ -n "$repo_url" ]; do
    # Nettoyer la ligne (suppression des espaces et retours chariot)
    repo_url="$(echo "$repo_url" | tr -d '\r' | xargs)"

    # Ignorer les lignes vides ou les commentaires
    if [[ -z "$repo_url" || "$repo_url" =~ ^# ]]; then
        continue
    fi

    # Extraire le nom du projet à partir de l'URL
    repo_name=$(basename "$repo_url" .git)

    # Cloner ou mettre à jour le projet dans le dossier parent
    if [ ! -d "../$repo_name" ]; then
        git clone "$repo_url" "../$repo_name"
        if [ $? -eq 0 ]; then
            echo "Le projet $repo_name a été cloné avec succès."
        else
            echo "Erreur lors du clonage de $repo_name."
        fi
    elif [ -d "../$repo_name/.git" ]; then
        echo "Le projet $repo_name existe déjà, mise à jour du projet..."
        git -C "../$repo_name" pull
    else
        echo "Le dossier ../$repo_name existe déjà mais n'est pas un dépôt git, clonage ignoré."
    fi

    # Créer le lien symbolique dans le dossier courant
    if [ ! -L "$repo_name" ]; then
        ln -s "../$repo_name" "$repo_name"
        echo "Lien symbolique créé pour $repo_name."
    else
        echo "Le lien symbolique $repo_name existe déjà."
    fi
done < "./projects.list"
