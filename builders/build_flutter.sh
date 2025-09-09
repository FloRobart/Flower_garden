#!/usr/bin/env bash
# Builder for Flutter projects
# Defines function build_flutter and registers it in BUILDERS

build_flutter() {
    local dir="$1"
    if command -v flutter >/dev/null 2>&1; then
        echo "[flutter] flutter pub get in $dir" | tee -a "$LOGFILE"
        (cd "$dir" && flutter pub get) >> "$LOGFILE" 2>&1

        # Web
        echo "[flutter] flutter build web (release) in $dir" | tee -a "$LOGFILE"
        (cd "$dir" && flutter build web --release) >> "$LOGFILE" 2>&1 || true

        # Android
        echo "[flutter] flutter build apk (release) in $dir" | tee -a "$LOGFILE"
        (cd "$dir" && flutter build apk --release) >> "$LOGFILE" 2>&1 || true

        # Linux
        echo "[flutter] flutter build linux (release) in $dir" | tee -a "$LOGFILE"
        (cd "$dir" && flutter build linux --release) >> "$LOGFILE" 2>&1 || true
    else
        echo "[flutter] commande 'flutter' introuvable; installez Flutter pour builder $dir" | tee -a "$LOGFILE"
    fi
}

# Register builder if BUILDERS associative array exists
if declare -p BUILDERS >/dev/null 2>&1; then
    BUILDERS[flutter]=build_flutter
fi
