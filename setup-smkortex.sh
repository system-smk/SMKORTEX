#!/bin/bash
cd "$(dirname "$0")"

########################################################################
### 🔸 Mode désinstallation par paramètre
if [[ "$1" == "--desinstaller" ]]; then
  echo -e "\n🧹 Désinstallation de SMKortex..."
  read -p "🛑 Êtes-vous sûr de vouloir supprimer SMKortex ? [o/N] : " CONFIRM
  [[ "$CONFIRM" =~ ^[oO]$ ]] || { echo "🚫 Désinstallation annulée."; exit 0; }

  rm -rf scripts logs llama
  sudo rm -f /usr/local/bin/smkortex
  echo -e "\n✅ SMKortex désinstallé proprement. À bientôt 🦙"
  exit 0
fi

########################################################################
### 🔸 Menu interactif de désinstallation
echo -e "\n📦 Que souhaitez-vous faire ?"
echo "1. Installer SMKortex 🧠"
echo "2. Désinstaller SMKortex 🧹"
read -p "👉 Votre choix [1/2] : " USER_ACTION

if [[ "$USER_ACTION" == "2" ]]; then
  read -p "🛑 Êtes-vous sûr de vouloir supprimer SMKortex ? [o/N] : " CONFIRM
  [[ "$CONFIRM" =~ ^[oO]$ ]] || { echo "🚫 Annulé."; exit 0; }

  rm -rf scripts logs llama
  sudo rm -f /usr/local/bin/smkortex
  echo -e "\n✅ SMKortex désinstallé avec succès. À bientôt 🦙"
  exit 0
fi

########################################################################
### 🔸 Installation
echo -e "\n\e[32m╔════════════════════════════════════╗"
echo "║         🧠 SMKORTEX INSTALL        ║"
echo -e "╚════════════════════════════════════╝\e[0m"

echo -e "\n🎛️ Choisissez votre ambiance :"
echo "1. Classique ➤ progression visible"
echo "2. Animation ➤ cmatrix uniquement"
echo "3. Mixte ➤ cmatrix + logs via tmux"
read -p "👉 Votre choix [1/2/3] : " USER_CHOICE

########################################################################
### 📦 Dépendances
echo "📦 Installation des outils nécessaires..."
sudo apt update
sudo apt install -y git cmake g++ wget build-essential libcurl4-openssl-dev ccache
[[ "$USER_CHOICE" == "2" || "$USER_CHOICE" == "3" ]] && sudo apt install -y cmatrix

if [[ "$USER_CHOICE" == "3" ]]; then
  if ! command -v tmux &> /dev/null; then
    read -p "👉 Installer tmux pour activer le mode mixte ? [o/N] : " INSTALL_TMUX
    [[ "$INSTALL_TMUX" =~ ^[oO]$ ]] && sudo apt install -y tmux || USER_CHOICE="1"
  else
    echo "✅ tmux est déjà installé"
  fi
fi

########################################################################
### 📁 Préparation
echo "📁 Création des dossiers..."
mkdir -p scripts logs llama/models

echo "📜 Installation de chatv2-kortex.sh..."
if [ -f "chatv2-kortex.sh" ]; then
  cp "chatv2-kortex.sh" scripts/
  chmod +x scripts/chatv2-kortex.sh
  echo "✅ Script installé ➤ scripts/chatv2-kortex.sh"
else
  echo "❌ Fichier 'chatv2-kortex.sh' introuvable ➤ place-le à la racine du projet"
  exit 1
fi

########################################################################
### 🧠 llama.cpp
echo "🧠 Clonage de llama.cpp..."
if [ ! -d "llama/llama.cpp" ]; then
  git clone https://github.com/ggerganov/llama.cpp.git llama/llama.cpp
else
  echo "✅ llama.cpp déjà présent"
fi

echo "🔨 Compilation..."
cd llama/llama.cpp && mkdir -p build && cd build
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
cmake .. && make -j$(nproc)
[[ $? -ne 0 ]] && echo "❌ Compilation échouée" && exit 1
cd ../../../..

########################################################################
### 📡 Téléchargement du modèle
MODEL_URL="https://huggingface.co/TheBloke/Vigogne-2-7B-Chat-GGUF/resolve/main/vigogne-2-7b-chat.Q4_K_M.gguf"
MODEL_PATH="llama/models/model.gguf"
LOG_PATH="logs/model_download.log"
touch "$LOG_PATH"

echo -e "\n📡 Téléchargement du modèle..."
case "$USER_CHOICE" in
  "1")
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    ;;
  "2")
    cmatrix -u 5 -C green & CM_PID=$!
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    kill "$CM_PID" 2>/dev/null && clear
    ;;
  "3")
    tmux new-session -d -s smkfx 'cmatrix -u 5 -C green'
    echo -e "\n🌀 Animation lancée via tmux [session : smkfx]"
    read -p "👉 Souhaitez-vous afficher la session maintenant ? [O/n] : " SHOW_CMX
    [[ "$SHOW_CMX" =~ ^[oO]$ || -z "$SHOW_CMX" ]] && tmux attach -t smkfx
    echo "⏳ Téléchargement du modèle en cours..."
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    tmux kill-session -t smkfx 2>/dev/null && clear
    ;;
  *)
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
esac

echo -e "\n📁 Vérification du modèle téléchargé..."
if [ ! -f "$MODEL_PATH" ]; then
  echo "❌ Fichier non trouvé ➤ logs :"
  cat "$LOG_PATH"
  exit 1
fi

if file "$MODEL_PATH" | grep -qi html; then
  echo "❌ Fichier incorrect ➤ HTML reçu à la place du modèle"
  head "$MODEL_PATH"
  exit 1
fi
echo "✅ Téléchargement réussi ➤ $MODEL_PATH"

########################################################################
### 🔗 Création du lanceur
LAUNCHER="/usr/local/bin/smkortex"
if [ -f "scripts/chatv2-kortex.sh" ]; then
  echo "🔗 Création du lanceur 'smkortex'..."
  sudo ln -sf "$(pwd)/scripts/chatv2-kortex.sh" "$LAUNCHER"
  echo "✅ Commande 'smkortex' disponible globalement"
fi

########################################################################
### 🎉 Fin
echo -e "\n\e[32m╔═════════════════════════════════════════╗"
echo "║      🎉 SMKortex est prêt à réfléchir ! ║"
echo "║  Lance : smkortex \"Bonjour toi\"        ║"
echo -e "╚═════════════════════════════════════════╝\e[0m"
