#!/bin/bash

echo -e "\n⚙️ Création du raccourci smkortex dans /usr/local/bin (sudo nécessaire)"

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
SOURCE="$ROOTDIR/scripts/instChatv2-kortex.sh"
TARGET="/usr/local/bin/smkortex"

# Vérifie la source
if [ ! -f "$SOURCE" ]; then
  echo "❌ instChatv2-kortex.sh introuvable ➤ vérifie l’installation"
  exit 1
fi

# Copie avec élévation
sudo cp "$SOURCE" "$TARGET"
sudo chmod +x "$TARGET"

echo "✅ Lanceur système 'smkortex' disponible ➤ tape simplement : smkortex"

