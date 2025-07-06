#!/bin/bash

echo "🧠 Installation complète de SMKortex"
echo "------------------------------------"

### 🔍 Dépendances système ###
echo "📦 Vérification et installation des outils nécessaires..."
REQUIRED_PKGS=(git cmake g++ wget build-essential libcurl4-openssl-dev ccache)
sudo apt update
sudo apt install -y "${REQUIRED_PKGS[@]}"

### 📁 Préparation des dossiers ###
echo "📁 Création des répertoires..."
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
  echo "❌ Erreur de compilation de llama.cpp"
  exit 1
fi
cd ../../../..

### 🦙 Téléchargement du modèle GGUF ###
MODEL_NAME="vigogne-2-7b-chat.Q4_K_M.gguf"
MODEL_PATH="llama/models/$MODEL_NAME"
MODEL_URL="https://huggingface.co/TheBloke/Vigogne-2-7B-Chat-GGUF/resolve/main/$MODEL_NAME"
LOG_PATH="logs/model_download.log"

echo "📥 Téléchargement du modèle Vigogne..."
touch "$LOG_PATH"

# 🔄 Téléchargement en arrière-plan avec redirection des erreurs
wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH" &
PID=$!

# 🎬 Spinner animé pendant le téléchargement
spinner='|/-\'
i=0
while kill -0 $PID 2>/dev/null; do
  printf "\r⏳ Téléchargement en cours... ${spinner:$i:1}"
  i=$(( (i+1) %4 ))
  sleep 0.2
done
echo -e "\r✅ Téléchargement terminé                         "

# 🔍 Vérifie si le fichier existe
if [ ! -f "$MODEL_PATH" ]; then
  echo "❌ Le fichier n'existe pas ➤ Échec du téléchargement."
  cat "$LOG_PATH"
  exit 1
fi

# 🧪 Vérifie si le fichier est une page HTML déguisée
if file "$MODEL_PATH" | grep -qi html; then
  echo "❌ Le fichier téléchargé semble être une page HTML, pas un modèle GGUF."
  head "$MODEL_PATH"
  exit 1
fi

echo "✅ Modèle téléchargé avec succès ➤ $MODEL_PATH"

### 📜 Déploiement des scripts personnalisés (optionnel) ###
echo "📜 Déploiement des scripts Bash..."
for script in chatv2-kortex.sh front-smkortex.sh chat-smkortex.sh; do
  if [ -f "sources/$script" ]; then
    cp "sources/$script" scripts/
    chmod +x "scripts/$script"
    echo "✅ Script installé ➤ scripts/$script"
  fi
done

### 🧾 Terminé ###
echo ""
echo "🎉 SMKortex est prêt à réfléchir !"
echo "🧠 Lance : ./scripts/chatv2-kortex.sh \"Bonjour toi\""
