#!/bin/bash

# 📁 Base absolue du projet
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"

echo -e "\n🧠 SMKortex v2 — Session interactive"
mkdir -p "$ROOTDIR/logs"

TIMESTAMP=$(date +"%H-%M_%d-%m-%Y")
LOGFILE="$ROOTDIR/logs/session_$TIMESTAMP.log"
echo "📅 Log : $LOGFILE"
echo "✏️  Ctrl+C pour quitter"

MODEL="$ROOTDIR/llama/models/model.gguf"
BIN="$ROOTDIR/llama/llama.cpp/build/bin/llama-cli"

# 🔍 Vérifications
if [ ! -f "$BIN" ]; then
  echo "❌ Binaire introuvable ➤ compile avec clone-compile-llama.sh"
  exit 1
fi

if [ ! -f "$MODEL" ]; then
  echo "❌ Modèle introuvable ➤ télécharge avec telecharger-modele.sh"
  exit 1
fi

# 🔁 Session interactive
while true; do
  read -p "Utilisateur : " PROMPT
  echo -e "\n💬 Copilot répond..."
  echo "Utilisateur : $PROMPT" | tee -a "$LOGFILE"

  "$BIN" \
    --model "$MODEL" \
    --temp 0.7 \
    --repeat_penalty 1.1 \
    --top_k 40 \
    --top_p 0.9 \
    --threads $(nproc) \
    --n_predict 256 \
    --color \
    --seed -1 \
    --prompt "Utilisateur : $PROMPT\nCopilot : " | tee -a "$LOGFILE"

  echo "" >> "$LOGFILE"
done


