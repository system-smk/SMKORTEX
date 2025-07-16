#!/bin/bash

echo -e "\n⚙️ Installation du lanceur 'smkortex' dans ~/.local/bin"

# 🧭 Détection du dossier racine du projet
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"

# 📁 Script source et chemin de destination
SOURCE="$ROOTDIR/scripts/instChatv2-kortex.sh"
TARGET="$HOME/.local/bin/smkortex"

# 🔍 Vérifie que le script source existe
if [ ! -f "$SOURCE" ]; then
  echo "❌ Le script source est introuvable ➤ $SOURCE"
  exit 1
fi

# 📦 Crée le dossier bin s'il n'existe pas
mkdir -p "$HOME/.local/bin"

# 🚀 Création du script lanceur avec chemin absolu
cat > "$TARGET" <<EOF
#!/bin/bash
bash "$SOURCE" "\$@"
EOF

chmod +x "$TARGET"

# 🛠️ Vérifie et corrige le PATH si ~/.local/bin n'est pas dedans
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  source "$HOME/.bashrc"
  echo "🔧 PATH mis à jour pour inclure ~/.local/bin"
fi

# 🔎 Test final du lanceur
if which smkortex &>/dev/null; then
  echo "✅ Lanceur opérationnel ➤ tape : smkortex"
else
  echo "⚠️ Le lanceur n'est pas reconnu ➤ redémarre ton terminal ou vérifie le PATH"
fi




