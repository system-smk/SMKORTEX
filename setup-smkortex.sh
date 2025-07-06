#!/bin/bash

### 📍 Démarrer depuis le dossier du script ###
cd "$(dirname "$0")"

### 🎉 BANNIÈRE ASCII ###
echo -e "\n\e[32m"
echo "╔════════════════════════════════════╗"
echo "║         🧠  SMKORTEX INSTALL       ║"
echo "╚════════════════════════════════════╝"
echo -e "\e[0m"

### 🔍 Dépendances système ###
echo "📦 Vérification des dépendances..."
REQUIRED_PKGS=(git cmake g++ wget build-essential libcurl4-openssl-dev ccache cmatrix)
sudo apt update
sudo apt install -y "${REQUIRED_PKGS[@]}"

### 📁 Dossiers nécessaires ###
echo "📁 Préparation des répertoires..."
mkdir -p scripts logs llama/models

### 🧠 Clonage de llama.cpp ###
if [ ! -d "llama/llama.cpp" ]; then
  echo "📥 Clonage de llama.cpp..."
  git clone https://github.com/ggerganov/llama.cpp.git llama/llama.cpp
else
  echo "✅ llama.cpp déjà présent"
fi

### 🔨 Compilation ###
echo "🔨 Compilation de llama.cpp..."
cd llama/llama.cpp
mkdir -p build && cd build
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
cmake .. && make -j$(nproc)
if [ $? -ne 0 ]; then
  echo "❌ Compilation échouée"
  exit 1
fi
cd ../../../..

### 🦙 Téléchargement du modèle GGUF ###
MODEL_NAME="vigogne-2-7b-chat.Q4_K_M.gguf"
MODEL_PATH="llama/models/$MODEL_NAME"
MODEL_URL="https://huggingface.co/TheBloke/Vigogne-2-7B-Chat-GGUF/resolve/main/$MODEL_NAME"
LOG_PATH="logs/model_download.log"

echo -e "\n📡 Téléchargement du modèle Vigogne..."
echo "🧘‍♂️ Merci pour votre patience pendant que SMKortex médite..."

touch "$LOG_PATH"

# 🌀 Animation cmatrix pendant le téléchargement
if command -v cmatrix &> /dev/null; then
  cmatrix -u 5 -C green &
  CMATRIX_PID=$!
fi

wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH" &
WGET_PID=$!
wait $WGET_PID

# 🛑 Stoppe cmatrix
if [ ! -z "$CMATRIX_PID" ]; then
  kill "$CMATRIX_PID" 2>/dev/null
  clear
fi

# 📋 Vérifications
echo "📁 Fichier attendu ➤ $MODEL_PATH"
if [ ! -f "$MODEL_PATH" ]; then
  echo "❌ Modèle introuvable ➤ Voir logs :"
  cat "$LOG_PATH"
  exit 1
fi

if file "$MODEL_PATH" | grep -qi html; then
  echo "❌ Le fichier téléchargé est une page HTML, pas un modèle GGUF !"
  head "$MODEL_PATH"
  exit 1
fi

echo "✅ Modèle téléchargé avec succès ➤ $MODEL_PATH"

### 📜 Déploiement des scripts ###
echo "📜 Installation des scripts personnalisés..."
for script in chatv2-kortex.sh front-smkortex.sh chat-smkortex.sh; do
  if [ -f "sources/$script" ]; then
    cp "sources/$script" scripts/
    chmod +x "scripts/$script"
    echo "✅ $script ➤ installé dans scripts/"
  fi
done

### 🚀 Lanceur global ###
LAUNCHER="/usr/local/bin/smkortex"
SCRIPT_PATH="$(pwd)/scripts/chatv2-kortex.sh"
if [ -f "$SCRIPT_PATH" ]; then
  echo "🔗 Création du lanceur global : smkortex"
  sudo ln -sf "$SCRIPT_PATH" "$LAUNCHER"
  echo "✅ Tu peux maintenant lancer SMKortex depuis n'importe où"
else
  echo "⚠️ Script principal introuvable ➤ lanceur non créé"
fi

### 🎉 Fin de l'installation ###
echo -e "\n\e[32m"
echo "╔════════════════════════════════════╗"
echo "║     🎉 SMKortex est prêt !        ║"
echo "║  Lance : smkortex \"Bonjour toi\"  ║"
echo "╚════════════════════════════════════╝"
echo -e "\e[0m"
