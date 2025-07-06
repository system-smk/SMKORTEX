#!/bin/bash

echo -e "\n📜 Installation du script instChatv2-kortex.sh..."

SOURCE="instChatv2-kortex.sh"
DEST_DIR="scripts"
DEST="$DEST_DIR/instChatv2-kortex.sh"

# Vérifie que le fichier source existe
if [ ! -f "$SOURCE" ]; then
  echo "❌ Fichier source '$SOURCE' introuvable ➤ place-le à la racine du projet"
  exit 1
fi

# Crée le dossier scripts/ s'il n'existe pas
mkdir -p "$DEST_DIR"

# Copie ou remplace le fichier
if [ -f "$DEST" ]; then
  echo "⚠️ Le fichier '$DEST' existe déjà ➤ remplacement en cours..."
fi

cp "$SOURCE" "$DEST"
chmod +x "$DEST"
echo "✅ Script copié et activé ➤ $DEST"
