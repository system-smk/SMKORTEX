#!/bin/bash

echo -e "\n🔗 Configuration du lanceur global 'smkortex'..."

SOURCE="scripts/instChatv2-kortex.sh"
TARGET="/usr/local/bin/smkortex"

if [ -f "$SOURCE" ]; then
  sudo ln -sf "$(pwd)/$SOURCE" "$TARGET"
  echo "✅ Le raccourci 'smkortex' est disponible ➤ vous pouvez le lancer de n’importe où"
else
  echo "❌ Le script source '$SOURCE' est introuvable ➤ assure-toi qu'il est bien installé"
  exit 1
fi
