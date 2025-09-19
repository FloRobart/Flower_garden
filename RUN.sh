#!/bin/bash

set -euo pipefail

DETACH_FLAG=""

while [ "$#" -gt 0 ]; do
	case "$1" in
		-d|--detach)
			DETACH_FLAG="-d"
			shift
			;;
		--)
			shift
			break
			;;
		*)
			echo "Usage: $0 [-d|--detach]" >&2
			exit 2
			;;
	esac
done

echo "[info] Starting run sequence"

run_step() {
	local cmd="$1"
	local desc="$2"

	echo -n "[❕] $desc... "
	if eval "$cmd"; then
		echo "[✅] $desc succeeded."
	else
		echo "[❌] $desc failed."
		return 1
	fi
}

# 1) checkout.sh
if run_step "./checkout.sh" "Run checkout.sh"; then
	:
else
	exit 1
fi

# 2) init-env.sh
if run_step "./init-env.sh" "Run init-env.sh"; then
	:
else
	exit 1
fi

# 3) docker compose up ou docker-compose up (si docker compose indisponible)
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
	echo -n "[❕] lancement des containers Docker (docker compose up $DETACH_FLAG)... "
	docker compose up $DETACH_FLAG
	echo "[✅] Containers lancés avec 'docker compose up'."
	exit 0
elif command -v docker-compose >/dev/null 2>&1; then
	echo -n "[❕] lancement des containers Docker (docker-compose up $DETACH_FLAG)... "
	docker-compose up $DETACH_FLAG
	echo "[✅] Containers lancés avec 'docker-compose up'."
	exit 0
else
	echo "[❌] Aucune commande 'docker compose' ou 'docker-compose' disponible."
	exit 1
fi
