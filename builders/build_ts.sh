#!/usr/bin/env bash
# Builder for TypeScript projects
# Defines function build_ts and registers it in BUILDERS

build_ts() {
    local dir="$1"
    if [ -f "$dir/package.json" ]; then
        echo "[ts] npm install in $dir" | tee -a "$LOGFILE"
        (cd "$dir" && npm install) >> "$LOGFILE" 2>&1
        echo "[ts] npm run build in $dir" | tee -a "$LOGFILE"
        (cd "$dir" && npm run build) >> "$LOGFILE" 2>&1
    else
        echo "[ts] pas de package.json dans $dir, build ignoré" | tee -a "$LOGFILE"
    fi
}

# Register builder if BUILDERS associative array exists
if declare -p BUILDERS >/dev/null 2>&1; then
    BUILDERS[ts]=build_ts
fi
