#!/bin/bash

echo "🧠 Setup de SMKortex — Assistant IA local"
echo "----------------------------------------"

# === Préparation de l’arborescence ===
mkdir -p llama models logs scripts sources

# === Clonage de llama.cpp si manquant ===
if [ ! -d "llama/llama.cpp" ]; then
  echo "📥 Clonage de llama.cpp..."
  git submodule add https://github.com/ggerganov/llama.cpp llama/llama.cpp
else
  echo "✅ llama.cpp déjà présent"
fi

# === Compilation de llama.cpp ===
echo "🔨 Compilation de llama.cpp..."
cd llama/llama.cpp
make
cd ../../

# === Copie des scripts depuis sources/ vers scripts/ ===
echo "📜 Installation des scripts..."
cp sources/chat-smkortex.sh scripts/
cp sources/front-smkortex.sh scripts/
chmod +x scripts/*.sh

# === Génération du fichier SCRIPTS.md ===
cat <<EOF > SCRIPTS.md
# 📜 Scripts SMKortex

## 1. chat-smkortex.sh

Lance une session interactive rapide avec :
\`\`\`bash
./scripts/chat-smkortex.sh
\`\`\`

- Utilise un prompt système SMKortex
- Crée un fichier log dans \`logs/\`
- Réponses limitées à 256 tokens

---

## 2. front-smkortex.sh

Interface conviviale ligne par ligne avec historique :

\`\`\`bash
./scripts/front-smkortex.sh
\`\`\`

- Invite utilisateur claire avec \`<|UTILISATEUR|>:\`
- Log complet des échanges
- Mémoire locale via \`context.txt\`

---

## 📁 Structure recommandée

\`\`\`
smkortex/
├── scripts/
├── models/
├── llama/llama.cpp/
├── logs/
├── sources/
├── SCRIPTS.md
└── setup-smkortex.sh
\`\`\`

EOF

echo "✅ SMKortex installé !"
echo "🧠 Tu peux maintenant lancer ./scripts/front-smkortex.sh"
