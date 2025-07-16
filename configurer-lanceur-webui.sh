#!/bin/bash

echo -e "\n⚙️ Installation du lanceur smkortex dans ~/.local/bin"

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
SOURCE="$ROOTDIR/scripts/instChatv2-kortex.sh"
TARGET="$HOME/.local/bin/smkortex"

# Vérifie le script source
if [ ! -f "$SOURCE" ]; then
  echo "❌ Script de lancement introuvable ➤ $SOURCE"
  exit 1
fi

# Crée le dossier cible et copie le lanceur
mkdir -p "$HOME/.local/bin"
cp "$SOURCE" "$TARGET"
chmod +x "$TARGET"

# Corrige le PATH si nécessaire
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
  echo "🔧 PATH mis à jour pour inclure ~/.local/bin"
fi

echo "✅ Lanceur installé ➤ Utilisez-le avec la commande : smkortex"

