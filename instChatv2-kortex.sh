#!/bin/bash

echo -e "\n📜 Installation du script chatv2-kortex.sh..."

SOURCE="instChatv2-kortex.sh"
DEST="scripts/instChatv2-kortex.sh"

if [ -f "$SOURCE" ]; then
  cp "$SOURCE" "$DEST"
  chmod +x "$DEST"
  echo "✅ Script copié et activé ➤ $DEST"
else
  echo "❌ Fichier source '$SOURCE' introuvable ➤ place-le à la racine du projet"
  exit 1
fi
