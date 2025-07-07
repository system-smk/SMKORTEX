#!/bin/bash

echo -e "\n📦 Clonage et compilation de llama.cpp..."

# 📁 Création du dossier parent
mkdir -p llama

# 📦 Clonage du dépôt si absent
if [ ! -d "llama/llama.cpp" ]; then
  echo "🔗 Clonage de llama.cpp depuis GitHub..."
  git clone https://github.com/ggerganov/llama.cpp.git llama/llama.cpp
else
  echo "✅ llama.cpp déjà cloné ➤ passage à la compilation"
fi

# 🛠 Compilation si le binaire est absent
if [ ! -f "llama/llama.cpp/build/bin/llama-cli" ]; then
  echo "🔨 Compilation de llama.cpp..."
  cd llama/llama.cpp
  mkdir -p build
  cd build
  cmake ..
  make -j$(nproc)
  echo "✅ Compilation réussie ➤ llama/llama.cpp/build/bin/llama-cli"
else
  echo "✅ Binaire déjà compilé ➤ rien à faire"
fi

