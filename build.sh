#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECTS_FILE="$ROOT_DIR/projects.list"
LOGFILE="$ROOT_DIR/build.log"

echo "Starting build at $(date)" | tee -a "$LOGFILE"

if [ ! -f "$PROJECTS_FILE" ]; then
    echo "projects.list introuvable dans $ROOT_DIR" | tee -a "$LOGFILE"
    exit 1
fi

declare -A BUILDERS

# Source all builder scripts in builders/ (each should register itself in BUILDERS)
BUILDER_DIR="$ROOT_DIR/builders"
if [ -d "$BUILDER_DIR" ]; then
    for f in "$BUILDER_DIR"/*.sh; do
        [ -f "$f" ] || continue
        # shellcheck disable=SC1090
        . "$f"
    done
else
    echo "Aucun dossier builders/ trouvé — aucun builder chargé" | tee -a "$LOGFILE"
fi

echo "Lecture de $PROJECTS_FILE" | tee -a "$LOGFILE"

while IFS= read -r line || [ -n "$line" ]; do
    # Trim spaces and skip empty/comment lines
    line="$(echo "$line" | sed -E 's/^\s+|\s+$//g')"
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Expect: folder_name git_link type
    folder=$(echo "$line" | awk '{print $1}')
    repo=$(echo "$line" | awk '{print $2}')
    type=$(echo "$line" | awk '{print $3}')

    if [ -z "$folder" ] || [ -z "$repo" ] || [ -z "$type" ]; then
        echo "Ligne invalide dans projects.list: '$line' (attendu: folder git_link type)" | tee -a "$LOGFILE"
        continue
    fi

    dest="$ROOT_DIR/$folder"
    echo -e "\n--- Processing $folder ($type) ---" | tee -a "$LOGFILE"

    if [ ! -d "$dest" ]; then
        echo "Dossier $dest introuvable — build ignoré (le script n'effectue pas de git)." | tee -a "$LOGFILE"
        continue
    fi

    # Run builder if available
    builder_fn="${BUILDERS[$type]:-}"
    if [ -n "$builder_fn" ]; then
        echo "Lancement du builder pour type='$type' ($builder_fn) dans $dest" | tee -a "$LOGFILE"
        if $builder_fn "$dest"; then
            echo "Build succeed for $folder" | tee -a "$LOGFILE"
        else
            echo "Build failed for $folder (see $LOGFILE)" | tee -a "$LOGFILE"
        fi
    else
        echo "Aucun builder enregistré pour type='$type' - build ignoré pour $folder" | tee -a "$LOGFILE"
    fi
done < "$PROJECTS_FILE"

echo "Build finished at $(date)" | tee -a "$LOGFILE"

exit 0
