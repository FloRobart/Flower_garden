#!/bin/bash

if [ ! -f ".env" ]; then
    cp .env.example .env
fi

for f in ./config/.env.example.*; do
    target="./config/.env.${f##*.}"
    if [ ! -f "$target" ]; then
        cp "$f" "$target"
    fi
done