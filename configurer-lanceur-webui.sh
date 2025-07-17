#!/bin/bash

echo -e "\n🌐 Installation du lanceur WebUI 'smkortex-webui' dans ~/.local/bin"

# 📁 Détection du dossier racine KORTEX
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"

# 🔍 Chemin du script à générer
TARGET="$HOME/.local/bin/smkortex-webui"
WEBUI_PATH="$ROOTDIR/webui"

# 📦 Créer le dossier cible
mkdir -p "$HOME/.local/bin"

# 🚀 Créer le lanceur dans ~/.local/bin
cat > "$TARGET" <<EOF
#!/bin/bash
echo "🌐 Lancement de KORTEX WebUI..."
cd "$WEBUI_PATH"
KORTEX_ROOTDIR="$ROOTDIR" node serve.js
EOF

# 🔧 Rendre le lanceur exécutable
chmod +x "$TARGET"

# 🛠️ Ajouter ~/.local/bin au PATH si nécessaire
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  source "$HOME/.bashrc"
  echo "🔧 PATH mis à jour pour inclure ~/.local/bin"
fi

# ✅ Confirmation
if which smkortex-webui &>/dev/null; then
  echo -e "\n✅ Lanceur WebUI installé ➤ tape : smkortex-webui"
else
  echo -e "\n⚠️ Lanceur non reconnu ➤ redémarre ton terminal"
fi

