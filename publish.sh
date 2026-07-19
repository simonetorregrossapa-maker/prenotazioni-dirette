#!/bin/bash
# Pubblica il simulatore su GitHub Pages. Lancialo con:  bash ~/simulatore-bnb/publish.sh
set -e
OWNER=simonetorregrossapa-maker
REPO=prenotazioni-dirette

cd ~/simulatore-bnb

TOKEN=$(printf "protocol=https\nhost=github.com\nusername=%s\n\n" "$OWNER" | git credential fill 2>/dev/null | grep '^password=' | cut -d= -f2)
if [ -z "$TOKEN" ]; then echo "ERRORE: nessuna credenziale GitHub trovata."; exit 1; fi

echo "1/3 · creo il repo $REPO ..."
curl -s -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO\",\"private\":false,\"has_issues\":false,\"has_wiki\":false}" >/dev/null || true

echo "2/3 · collego e pusho ..."
git remote add origin "https://github.com/$OWNER/$REPO.git" 2>/dev/null || git remote set-url origin "https://github.com/$OWNER/$REPO.git"
git push -u origin main

echo "3/3 · attivo GitHub Pages ..."
curl -s -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$OWNER/$REPO/pages \
  -d '{"source":{"branch":"main","path":"/"}}' >/dev/null || true

echo ""
echo "FATTO. Tra ~1 minuto sara' online:"
echo "https://$OWNER.github.io/$REPO/sulle-vie-del-capo.html"
