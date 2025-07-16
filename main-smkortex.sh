#!/bin/bash

echo -e "\n📁 Organisation des fichiers…"

# Crée le dossier s'il n'existe pas
mkdir -p scripts

# Déplace les scripts dans le dossier scripts sauf ceux déjà dedans
for FILE in *.sh; do
  [[ "$FILE" == "main-smkortex.sh" ]] && continue
  [[ -f "scripts/$FILE" ]] && continue
  mv "$FILE" scripts/
done

echo "✅ Tous les scripts ont été déplacés dans ➤ ./scripts/"

echo -e "\n🧠 Bienvenue dans Copilot Setup"

SCRIPTS=(
  install-dependances.sh
  clone-compile-llama.sh
  telecharger-modele.sh
  instChatv2-kortex.sh
  configurer-lanceur.sh
  configurer-lanceur-webui.sh
  install-smkortex-webui.sh
  desinstaller-smkortex.sh
)
# 🔍 Vérifie la présence des fichiers dans scripts/
for file in "${SCRIPTS[@]}"; do
  if [ ! -f "scripts/$file" ]; then
    echo "❌ Le script 'scripts/$file' est manquant"
    exit 1
  fi
done
# 🛡️ Vérification et correction du PATH
bash scripts/kortex-path-check.sh

mkdir -p ~/.local/bin
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  export PATH="$HOME/.local/bin:$PATH"
fi

echo -e "\n📦 Que souhaitez-vous faire ?"
echo "1. Installer KORTEX local 🧠"
echo "2. Désinstaller KORTEX 🧹"
read -p "👉 Choix [1/2] : " CH

case "$CH" in
  1)
    bash scripts/install-dependances.sh
    echo -e "\n📦 Vérification des outils shell visuels..."
    
    for pkg in tmux cmatrix; do
      if ! command -v "$pkg" &>/dev/null; then
        echo "🔧 $pkg non détecté ➤ installation via apt..."
        sudo apt install -y "$pkg"
      else
        echo "✅ $pkg est déjà installé"
      fi
    done


    # 🧪 Vérifie et compile llama.cpp si absent
    if [ ! -d "llama/llama.cpp" ]; then
      echo -e "\n📦 Dépôt llama.cpp manquant ➤ lancement automatique du clonage + compilation"
      bash scripts/clone-compile-llama.sh
    else
      echo -e "\n✅ Dépôt llama.cpp déjà présent ➤ compilation ignorée"
    fi

    # 🧪 Vérifie si le modèle est présent
    MODEL_PATH="llama/models/vigogne-2-7b-chat.Q4_K_M.gguf"
    if [ ! -f "$MODEL_PATH" ]; then
      echo -e "\n📡 Modèle Vigogne manquant ➤ téléchargement automatique"
      bash scripts/telecharger-modele.sh
    else
      echo "✅ Modèle déjà présent ➤ pas de téléchargement nécessaire"
    fi

    bash scripts/instChatv2-kortex.sh
    bash scripts/configurer-lanceur.sh
    bash scripts/configurer-lanceur-webui.sh
    bash scripts/install-smkortex-webui.sh
    
    # 🧾 Vérifie que les lanceurs sont bien exécutables
    chmod +x ~/.local/bin/smkortex 2>/dev/null || echo "⚠️ Lanceur smkortex introuvable ou non créé"
    chmod +x ~/.local/bin/webkortex 2>/dev/null || echo "⚠️ Lanceur webkortex introuvable ou non créé"

    echo -e "\n🎉 KORTEX est installé ➤ commandes disponibles :"
    echo "🔹 smkortex \"Bonjour toi\"      ← pour le shell"
    echo "🔹 webkortex                   ← pour l’interface WebUI"
    ;;
  2)
    bash scripts/desinstaller-smkortex.sh
    ;;
  *)
    echo "❌ Option invalide"
    exit 1
    ;;
esac

