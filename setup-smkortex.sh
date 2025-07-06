#!/bin/bash

### 📍 Lancement depuis le dossier du script
cd "$(dirname "$0")"

######################################################################
### 🎉 1. BANNIÈRE D'ACCUEIL ###
echo -e "\n\e[32m"
echo "╔════════════════════════════════════╗"
echo "║         🧠 SMKORTEX INSTALL        ║"
echo "╚════════════════════════════════════╝"
echo -e "\e[0m"

######################################################################
### 🎛️ 2. CHOIX UTILISATEUR POUR STYLE D'INSTALLATION ###
echo -e "\n🎛️ Choisissez votre ambiance terminal :"
echo "1. Classique ➤ Téléchargement visible"
echo "2. Animation ➤ cmatrix uniquement"
echo "3. Mixte ➤ cmatrix + téléchargement loggué"
read -p "👉 Votre choix [1/2/3] : " USER_CHOICE

######################################################################
### 🔍 3. INSTALLATION DES DÉPENDANCES ###
echo "📦 Installation des dépendances principales..."
ESSENTIAL_PKGS=(git cmake g++ wget build-essential libcurl4-openssl-dev ccache)
sudo apt update
sudo apt install -y "${ESSENTIAL_PKGS[@]}"

### ➕ Dépendances visuelles (optionnelles)
if [[ "$USER_CHOICE" == "2" || "$USER_CHOICE" == "3" ]]; then
  sudo apt install -y cmatrix
fi

if [[ "$USER_CHOICE" == "3" ]]; then
  read -p "👉 Installer tmux pour le mode mixte ? [o/N] : " INSTALL_TMUX
  if [[ "$INSTALL_TMUX" =~ ^[oO]$ ]]; then
    sudo apt install -y tmux
  else
    echo "🔁 tmux non installé ➤ bascule en mode classique"
    USER_CHOICE="1"
  fi
fi

######################################################################
### 📁 4. STRUCTURE DES DOSSIERS ###
echo "📁 Création des dossiers..."
mkdir -p scripts logs llama/models sources/

######################################################################
### 📥 5. INSTALLATION DU SCRIPT chatv2-kortex.sh ###
echo "📜 Installation du script principal dans scripts/"
if [ -f "sources/chatv2-kortex.sh" ]; then
  cp "sources/chatv2-kortex.sh" scripts/
  chmod +x scripts/chatv2-kortex.sh
  echo "✅ chatv2-kortex.sh ➤ installé dans scripts/"
else
  echo "⚠️ sources/chatv2-kortex.sh introuvable ➤ installation interrompue"
  exit 1
fi

######################################################################
### 🧠 6. CLONAGE DE llama.cpp ###
if [ ! -d "llama/llama.cpp" ]; then
  echo "📥 Clonage de llama.cpp..."
  git clone https://github.com/ggerganov/llama.cpp.git llama/llama.cpp
else
  echo "✅ llama.cpp déjà présent"
fi

######################################################################
### 🔨 7. COMPILATION DE llama.cpp ###
echo "🔨 Compilation..."
cd llama/llama.cpp
mkdir -p build && cd build
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
cmake .. && make -j$(nproc)
if [ $? -ne 0 ]; then
  echo "❌ Erreur de compilation"
  exit 1
fi
cd ../../../..

######################################################################
### 📡 8. TÉLÉCHARGEMENT DU MODÈLE ###
MODEL_NAME="vigogne-2-7b-chat.Q4_K_M.gguf"
MODEL_PATH="llama/models/$MODEL_NAME"
MODEL_URL="https://huggingface.co/TheBloke/Vigogne-2-7B-Chat-GGUF/resolve/main/$MODEL_NAME"
LOG_PATH="logs/model_download.log"
touch "$LOG_PATH"

echo -e "\n📡 Téléchargement du modèle ➤ $MODEL_NAME"
echo "🧘 SMKortex prépare son esprit 🦙⏳"

case "$USER_CHOICE" in
  "1")
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    ;;
  "2")
    cmatrix -u 5 -C green &
    FX_PID=$!
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    kill "$FX_PID" 2>/dev/null && clear
    ;;
  "3")
    if command -v tmux &> /dev/null; then
      tmux new-session -d -s smkfx 'cmatrix -u 5 -C green'
      wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
      tmux kill-session -t smkfx 2>/dev/null
      clear
    else
      echo "⚠️ tmux non disponible ➤ téléchargement classique"
      wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    fi
    ;;
  *)
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    ;;
esac

######################################################################
### 🛡️ 9. VÉRIFICATIONS DU MODÈLE ###
echo "📁 Vérification ➤ $MODEL_PATH"
if [ ! -f "$MODEL_PATH" ]; then
  echo "❌ Modèle manquant ➤ voir log :"
  cat "$LOG_PATH"
  exit 1
fi

if file "$MODEL_PATH" | grep -qi html; then
  echo "❌ Fichier incorrect ➤ HTML reçu"
  head "$MODEL_PATH"
  exit 1
fi

echo "✅ Modèle téléchargé avec succès !"

######################################################################
### 🚀 10. CRÉATION DU LANCEUR GLOBAL ###
LAUNCHER="/usr/local/bin/smkortex"
SCRIPT_PATH="$(pwd)/scripts/chatv2-kortex.sh"
if [ -f "$SCRIPT_PATH" ]; then
  echo "🔗 Création du lanceur ➤ smkortex"
  sudo ln -sf "$SCRIPT_PATH" "$LAUNCHER"
  echo "✅ smkortex est disponible en ligne de commande"
fi

######################################################################
### 🎉 11. MESSAGE DE FIN ###
echo -e "\n\e[32m"
echo "╔═════════════════════════════════════════╗"
echo "║      🎉 SMKortex est prêt à réfléchir ! ║"
echo "║  Lance : smkortex \"Bonjour toi\"        ║"
echo "╚═════════════════════════════════════════╝"
echo -e "\e[0m"
