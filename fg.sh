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
	update|upgrade <service>  Pull the latest image(s) for the given service(s) then restart
	ps                     Show container status
	logs <service>         Follow logs for a service
	pull [service...]      Pull images for all or specific services
	exec <service> <cmd>   Run a command inside a service container
	version                Show version (prints the contents of the file 'version' with a trailing newline)
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
	update|upgrade)
		if [[ $# -lt 1 ]]; then
			echo "update requires at least one service name" >&2
			exit 1
		fi
		# Pull latest image(s) for the specified service(s)
		compose pull "$@"
		# Restart the service(s) with force recreate
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
	version)
		if [[ -f version ]]; then
			cat version
			echo
		else
			echo "version file not found" >&2
			exit 1
		fi
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

