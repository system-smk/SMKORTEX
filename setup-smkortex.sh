#!/bin/bash

echo "🧠 Installation de SMKortex en cours..."
echo "---------------------------------------"

# === Répertoires ===
mkdir -p llama/models
mkdir -p scripts
mkdir -p logs

# === Clonage de llama.cpp ===
if [ ! -d "llama/llama.cpp" ]; then
  echo "📥 Clonage de llama.cpp..."
  git clone https://github.com/ggerganov/llama.cpp.git llama/llama.cpp
else
  echo "✅ llama.cpp déjà présent"
fi

# === Compilation ===
echo "🔨 Compilation de llama.cpp..."
cd llama/llama.cpp
make
cd ../../

# === Téléchargement du modèle Vigogne ===
if [ ! -d "vigogne" ]; then
  echo "📁 Clonage du dépôt Vigogne (prompts, scripts)..."
  git clone https://github.com/bofenghuang/vigogne.git
else
  echo "✅ Dépôt Vigogne déjà présent"
fi

# === Téléchargement du modèle quantifié GGUF ===
MODEL_PATH="llama/models/vigogne-2-7b-chat.Q4_K_M.gguf"
if [ ! -f "$MODEL_PATH" ]; then
  echo "📦 Téléchargement du modèle GGUF (Vigogne Q4_K_M)..."
  wget -O "$MODEL_PATH" \
    "https://huggingface.co/bofenghuang/vigogne-2-7b-chat-GGUF/resolve/main/vigogne-2-7b-chat.Q4_K_M.gguf?download=true"

  if [ $? -eq 0 ]; then
    echo "✅ Modèle GGUF téléchargé ➤ $MODEL_PATH"
  else
    echo "❌ Échec du téléchargement."
    exit 1
  fi
else
  echo "✅ Modèle GGUF déjà présent"


# === Copie des scripts (depuis sources/) ===
echo "📜 Installation des scripts bash..."
for file in chat-smkortex.sh front-smkortex.sh chatv2-kortex.sh; do
  if [ -f "sources/$file" ]; then
    cp "sources/$file" scripts/
    chmod +x "scripts/$file"
  fi
done

# === Génération de la doc des scripts ===
cat <<EOF > SCRIPTS.md
# 📜 Scripts SMKortex

## ▸ chat-smkortex.sh
Session rapide avec prompt système.

## ▸ front-smkortex.sh
Dialogue ligne par ligne avec contexte.

## ▸ chatv2-kortex.sh
Nouvelle interface optimisée, plus stable et personnalisable.

## 🔁 Exécution typique

\`\`\`bash
./scripts/chatv2-kortex.sh
\`\`\`

## 📁 Structure

\`\`\`
.
├── llama/
│   ├── llama.cpp/
│   └── models/
├── scripts/
├── logs/
├── context.txt
└── README.md / SCRIPTS.md
\`\`\`

EOF

echo "✅ Installation terminée"
echo "💬 Tu peux maintenant lancer : ./scripts/chatv2-kortex.sh"


echo "✅ SMKortex installé !"
echo "🧠 Tu peux maintenant lancer ./scripts/front-smkortex.sh"
