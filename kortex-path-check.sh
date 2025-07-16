#!/bin/bash

echo -e "\n🛡️ Vérification du PATH utilisateur…"

# ✅ Supprime les lignes corrompues dans ~/.bashrc
sed -i '/export PATH="\\$HOME/d' ~/.bashrc
sed -i '/export PATH="\$HOME/d' ~/.bashrc
sed -i '/export PATH="\$HOME.*:\\$PATH"/d' ~/.bashrc

# ✅ Ajoute un PATH propre et complet si ~/.local/bin n’est pas dedans
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> ~/.bashrc
  export PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  echo "✅ PATH corrigé et enrichi"
else
  echo "🔹 PATH déjà correct ➤ aucune modification"
fi
