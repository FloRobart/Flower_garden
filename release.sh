#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

# Script de packaging pour Flower_garden
# Crée .deploy/Flower_garden.tar.gz contenant :
# - init-env.sh
# - traefik.yml
# - docker-compose.yml
# - docker-compose.proxy.yml
# - fg.sh
# - .env.example
# - tous les fichiers dans ./config dont le nom contient 'example' (insensible à la casse)
# - version

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

DEPLOY_DIR="releases"
ARCHIVE_NAME="Flower_garden.tar.gz"
ARCHIVE_PATH="$DEPLOY_DIR/$ARCHIVE_NAME"

declare -a files

# Liste de fichiers requis (on alerte si manquant mais on continue)
for f in init-env.sh traefik.yml docker-compose.yml docker-compose.proxy.yml fg.sh .env.example version; do
	if [ -e "$f" ]; then
		files+=("$f")
	else
		echo "Warning: $f introuvable, sera ignoré" >&2
	fi
done

# Cherche dans ./config les fichiers contenant 'example' (insensible à la casse)
if [ -d "config" ]; then
	while IFS= read -r -d '' cfg; do
		# ajouter le chemin relatif
		files+=("$cfg")
	done < <(find config -maxdepth 1 -type f -iname '*example*' -print0)
else
	echo "Info: dossier 'config' introuvable, aucun fichier de config ajouté" >&2
fi

if [ ${#files[@]} -eq 0 ]; then
	echo "Erreur: aucun fichier à archiver. Assurez-vous d'exécuter le script depuis la racine du projet." >&2
	exit 1
fi

mkdir -p "$DEPLOY_DIR"

echo "Création de l'archive $ARCHIVE_PATH avec ${#files[@]} fichier(s)..."

# Utiliser tar avec les chemins relatifs (déjà relatifs car on est dans ROOT_DIR)
tar -czf "$ARCHIVE_PATH" "${files[@]}"

echo "Archive créée : $ARCHIVE_PATH"

# Liste le contenu de l'archive pour vérification rapide
echo "Contenu de l'archive :"
tar -tzf "$ARCHIVE_PATH" | sed -e 's/^/  - /'

exit 0

