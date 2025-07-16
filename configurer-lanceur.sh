#!/bin/bash

echo -e "\n⚙️ Ajout du lanceur 'smkortex' dans ~/.bashrc"

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
TARGET="$ROOTDIR/scripts/instChatv2-kortex.sh"

# 🔍 Vérifie que le script existe
if [ ! -f "$TARGET" ]; then
  echo "❌ Script de lancement introuvable ➤ $TARGET"
  exit 1
fi

# 🧾 Crée un alias dans .bashrc s'il n'existe pas déjà
if ! grep -q 'alias smkortex=' "$HOME/.bashrc"; then
  echo "alias smkortex='bash \"$TARGET\"'" >> "$HOME/.bashrc"
  echo "✅ Alias ajouté dans ~/.bashrc ➤ tape : smkortex"
else
  echo "🔹 Alias déjà présent ➤ rien modifié"
fi

# 🔄 Recharge le shell
source "$HOME/.bashrc"
echo -e "\n🧠 Test rapide :"
which smkortex && echo "🎉 smkortex est disponible dans le terminal"



