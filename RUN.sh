#!/bin/bash

echo "Lancement du script checkout.sh..."
./checkout.sh
if [ $? -eq 0 ]; then
    echo "checkout.sh terminé avec succès. Lancement de build.sh..."
    ./build.sh
    if [ $? -eq 0 ]; then
        echo "build.sh terminé avec succès."
    else
        echo "Erreur lors de l'exécution de build.sh."
        exit 2
    fi
else
    echo "Erreur lors de l'exécution de checkout.sh. build.sh ne sera pas lancé."
    exit 1
fi
