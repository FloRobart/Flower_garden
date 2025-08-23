#!/bin/bash

echo "Recherche des projets liés dans le répertoire courant..."

for link in *; do
    if [ -L "$link" ]; then
        target=$(readlink "$link")
        echo -e "\n--- Installation et construction du projet $link ---"
        if [ -f "$target/package.json" ]; then
            (cd "$target" && npm install >> ./build.log 2>&1)
            if [ $? -eq 0 ]; then
                echo "Installation réussie pour $link."
                (cd "$target" && npm run build >> ./build.log 2>&1)
                if [ $? -eq 0 ]; then
                    echo "Build réussi pour $link."
                else
                    echo "Échec du build pour $link. Voir build.log pour plus de détails."
                fi
            else
                echo "Erreur lors de l'installation des dépendances pour $link. Voir build.log pour plus de détails."
            fi
        else
            echo "Aucun package.json trouvé dans $target, build ignoré."
        fi
    fi
done
