#!/bin/bash

echo -e "\n⚙️ Création du raccourci smkortex..."

# Demande au shell où se trouve le script
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
SOURCE="$ROOTDIR/scripts/instChatv2-kortex.sh"

# Vérifie que le script de lancement existe
if [ ! -f "$SOURCE" ]; then
  echo "❌ instChatv2-kortex.sh introuvable ➤ vérifie l’installation"
  exit 1
fi

# Copie ou lie vers /usr/local/bin ou ~/.local/bin
TARGET="/usr/local/bin/smkortex"
sudo cp "$SOURCE" "$TARGET"
sudo chmod +x "$TARGET"

echo "✅ Commande 'smkortex' disponible partout ➤ tape : smkortex"


