#!/usr/bin/env bash
set -euo pipefail

echo "[deploy-builder] démarrage du processus de build de déploiement"

# 1) Build des projets (via ./build.sh ou builders connus)
#!/usr/bin/env bash
set -euo pipefail

echo "[deploy-builder] démarrage du processus de build de déploiement"

# 1) Build des projets (via ./build.sh ou ./script.sh ou builders connus)
if [ -x "./build.sh" ]; then
  echo "[deploy-builder] exécution de ./build.sh"
  ./build.sh
elif [ -x "./script.sh" ]; then
  echo "[deploy-builder] exécution de ./script.sh"
  ./script.sh
else
  echo "[deploy-builder] avertissement: aucun script de build (./build.sh ou ./script.sh) exécutable trouvé — tentative des builders"
  if [ -x "./builders/build_flutter.sh" ]; then
    echo "[deploy-builder] exécution de ./builders/build_flutter.sh"
    ./builders/build_flutter.sh
  fi
  if [ -x "./builders/build_ts.sh" ]; then
    echo "[deploy-builder] exécution de ./builders/build_ts.sh"
    ./builders/build_ts.sh
  fi
fi

# 2) Choisir la commande docker-compose (compatibilité)
DC_CMD=""
if command -v docker-compose >/dev/null 2>&1; then
  DC_CMD="docker-compose"
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  DC_CMD="docker compose"
else
  echo "[deploy-builder] erreur: ni 'docker-compose' ni 'docker compose' trouvés dans le PATH"
  exit 1
fi

echo "[deploy-builder] construction des images Docker via: $DC_CMD"
$DC_CMD build --parallel

# 3) Préparer le dossier .deploy
rm -rf .deploy
mkdir -p .deploy

# 4) Récupérer la liste des images depuis docker-compose.yml
readarray -t images < <(grep -E '^\s*image:' docker-compose.yml | sed -E 's/.*image:[[:space:]]*//g' || true)

if [ ${#images[@]} -eq 0 ]; then
  echo "[deploy-builder] aucune ligne 'image:' trouvée dans docker-compose.yml, utilisation d'un fallback via $DC_CMD"
  # fallback: extraire les lignes 'image:' depuis la config rendu par docker-compose/docker
  readarray -t images < <($DC_CMD config 2>/dev/null | grep -E '^\s*image:' | sed -E 's/.*image:[[:space:]]*//g' || true)
fi

if [ ${#images[@]} -eq 0 ]; then
  echo "[deploy-builder] erreur: aucune image détectée dans docker-compose.yml ou via $DC_CMD config"
  exit 1
fi

echo "[deploy-builder] images détectées:"
for i in "${images[@]}"; do
  img_clean=$(echo "$i" | tr -d '"' | xargs)
  echo " - $img_clean"
done

# 5) Exporter chaque image vers .deploy/<image>.tar
for i in "${images[@]}"; do
  img=$(echo "$i" | tr -d '"' | xargs)
  [ -z "$img" ] && continue
  safe_name="$(echo "$img" | tr ':/' '__')"
  out=".deploy/${safe_name}.tar"
  echo "[deploy-builder] export: $img -> $out"
  docker save "$img" -o "$out"
done

# 6) Ajouter le script de déploiement dans .deploy, le docker-compose.yml et les .env.example
if [ -f deploy.sh ]; then
  cp deploy.sh .deploy/
else
  echo "[deploy-builder] attention: deploy.sh introuvable (il devrait être créé au même niveau que ce script)"
fi

cp docker-compose.yml .deploy/
cp config/.env.example.* .deploy/

# 7) Créer l'archive finale flower_garden.tar
tar -cf flower_garden.tar -C .deploy .

# 8) Compression de l'archive (gzip)
gzip -f flower_garden.tar

# 9) Déplacement de l'archive dans le répertoire de sortie
mv flower_garden.tar.gz .deploy/

echo "[deploy-builder] terminé — archive 'flower_garden.tar.gz' prête (contenu .deploy/)"
