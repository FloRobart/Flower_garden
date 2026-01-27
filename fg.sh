#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

COMPOSE_FILES=(-f docker-compose.yml -f docker-compose.proxy.yml)

usage() {
	cat <<'EOF'
Usage: fg.sh <command> [options]

Commands:
	up [service...]        Start the full stack or specific services
	down [options...]      Stop and remove containers (passes extra flags to compose)
	restart [service...]   Recreate the full stack or specific services
	ps                     Show container status
	logs <service>         Follow logs for a service
	pull [service...]      Pull images for all or specific services
	exec <service> <cmd>   Run a command inside a service container
	help                   Show this help message

Examples:
	fg.sh up
	fg.sh up floraccess-server
	fg.sh restart floraccess-server
	fg.sh logs floraccess-server
EOF
}

compose() {
	docker compose "${COMPOSE_FILES[@]}" "$@"
}

cmd="${1:-help}"
shift || true

case "$cmd" in
	up)
		compose up -d "$@"
		;;
	down)
		compose down "$@"
		;;
	restart)
		compose up -d --force-recreate "$@"
		;;
	ps|status)
		compose ps "$@"
		;;
	logs)
		if [[ $# -lt 1 ]]; then
			echo "logs requires at least one service name" >&2
			exit 1
		fi
		compose logs -f "$@"
		;;
	pull)
		compose pull "$@"
		;;
	exec)
		if [[ $# -lt 2 ]]; then
			echo "exec requires a service name followed by the command" >&2
			exit 1
		fi
		service="$1"
		shift
		compose exec "$service" "$@"
		;;
	help|-h|--help)
		usage
		;;
	*)
		echo "Unknown command: $cmd" >&2
		usage
		exit 1
		;;
esac

