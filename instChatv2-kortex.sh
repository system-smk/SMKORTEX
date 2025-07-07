#!/bin/bash

# 📁 Base absolue du projet
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"


mkdir -p "$ROOTDIR/logs"
LOGFILE="$ROOTDIR/logs/session_$(date +"%H-%M_%d-%m-%Y").log"

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
  echo -e "\n💬 KORTEX répond..."
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
    --prompt "Utilisateur : $PROMPT\nKORTEX : " | tee -a "$LOGFILE"

  echo "" >> "$LOGFILE"
done


