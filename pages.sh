#!/bin/bash
# Controlla/attiva GitHub Pages. Lancia con:  bash ~/simulatore-bnb/pages.sh
OWNER=simonetorregrossapa-maker
REPO=prenotazioni-dirette
TOKEN=$(printf "protocol=https\nhost=github.com\nusername=%s\n\n" "$OWNER" | git credential fill 2>/dev/null | grep '^password=' | cut -d= -f2)

echo "== stato attuale Pages =="
curl -s -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$OWNER/$REPO/pages" \
  | grep -oE '"(status|html_url|message)": *"[^"]*"'

echo ""
echo "== provo ad attivare (se gia' attivo, ignora) =="
curl -s -o /dev/null -w "POST pages -> HTTP %{http_code}\n" \
  -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$OWNER/$REPO/pages" \
  -d '{"source":{"branch":"main","path":"/"}}'

echo ""
echo "Aspetta ~1-2 minuti, poi apri:"
echo "https://$OWNER.github.io/$REPO/angolo83.html"
