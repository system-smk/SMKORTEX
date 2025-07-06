#!/bin/bash

echo "🧠 Installation complète de SMKortex"
echo "------------------------------------"

### 🔍 Dépendances système ###
echo "📦 Vérification et installation des outils nécessaires..."
REQUIRED_PKGS=(git cmake g++ wget build-essential libcurl4-openssl-dev ccache cmatrix)
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

echo ""
echo "📥 Téléchargement du modèle Vigogne..."
echo "Merci pour votre patience, SMKortex prépare son esprit 🧠⏳"

touch "$LOG_PATH"

# 🌀 Lance cmatrix en arrière-plan si installé
if command -v cmatrix &> /dev/null; then
  cmatrix -u 5 -C green &
  CMATRIX_PID=$!
else
  echo "⚠️ cmatrix n'est pas installé (animation désactivée)"
fi

# 🎯 Téléchargement du modèle en arrière-plan
wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH" &
WGET_PID=$!

# 🛑 Attend la fin du téléchargement
wait $WGET_PID

# 🧼 Stoppe cmatrix proprement
if [ ! -z "$CMATRIX_PID" ]; then
  kill "$CMATRIX_PID" 2>/dev/null
  clear
fi

# 🔍 Vérification du fichier
if [ ! -f "$MODEL_PATH" ]; then
  echo "❌ Le modèle n'a pas été téléchargé ➤ Voir logs :"
  cat "$LOG_PATH"
  exit 1
fi

# 🧪 Vérifie si c’est une page HTML déguisée
if file "$MODEL_PATH" | grep -qi html; then
  echo "❌ Le fichier téléchargé semble être une page HTML (non valide)"
  head "$MODEL_PATH"
  exit 1
fi

echo "✅ Modèle téléchargé avec succès ➤ $MODEL_PATH"

### 📜 Déploiement des scripts personnalisés ###
echo "📜 Déploiement des scripts Bash..."
for script in chatv2-kortex.sh front-smkortex.sh chat-smkortex.sh; do
  if [ -f "sources/$script" ]; then
    cp "sources/$script" scripts/
    chmod +x "scripts/$script"
    echo "✅ Script installé ➤ scripts/$script"
  fi
done

### 🚀 Création du lanceur global ###
LAUNCHER="/usr/local/bin/smkortex"
SCRIPT_PATH="$(pwd)/scripts/chatv2-kortex.sh"
if [ -f "$SCRIPT_PATH" ]; then
  echo "🚀 Création du lanceur global 'smkortex'..."
  sudo ln -sf "$SCRIPT_PATH" "$LAUNCHER"
  echo "✅ Tu peux maintenant lancer SMKortex depuis n'importe où ✨"
else
  echo "⚠️ Script principal introuvable ➤ pas de lanceur créé"
fi

### 🧾 Fin du setup ###
echo ""
echo "🎉 SMKortex est prêt à réfléchir !"
echo "🧠 Utilise : smkortex \"Bonjour toi\""
