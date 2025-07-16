#!/bin/bash

echo -e "\n📁 Vérification du dossier de destination..."
mkdir -p llama/models

echo -e "\n📡 Téléchargement du modèle Vigogne..."
wget "https://huggingface.co/TheBloke/Vigogne-2-7B-Chat-GGUF/resolve/main/vigogne-2-7b-chat.Q4_K_M.gguf" \
  -O llama/models/model.gguf

echo -e "\n📁 Vérification du fichier téléchargé..."

if [ ! -f "llama/models/model.gguf" ]; then
  echo "❌ Téléchargement échoué ➤ fichier introuvable"
  exit 1
fi

if file "llama/models/model.gguf" | grep -qi html; then
  echo "❌ Fichier incorrect ➤ HTML reçu à la place du modèle"
  head "llama/models/model.gguf"
  exit 1
fi

echo "✅ Modèle téléchargé avec succès ➤ llama/models/model.gguf"
