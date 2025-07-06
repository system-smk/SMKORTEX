#!/bin/bash

echo -e "\n🧠 SMKortex v2 — Session interactive"

# 📁 Préparation du dossier de logs (à la racine)
mkdir -p ../logs

# 🗓️ Horodatage pour nom de session
TIMESTAMP=$(date +"%H-%M_%d-%m-%Y")
LOGFILE="../logs/session_$TIMESTAMP.log"
echo "📅 Log : $LOGFILE"
echo "✏️  Ctrl+C pour quitter"

# 🧠 Chemins du modèle et du binaire
MODEL="../llama/models/vigogne-2-7b-chat.Q4_K_M.gguf"
BIN="../llama/llama.cpp/build/bin/llama-cli"

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
  echo -e "\n💬 SMKortex répond..."
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
    --prompt "Utilisateur : $PROMPT\nSMKortex : " | tee -a "$LOGFILE"

  echo "" >> "$LOGFILE"
done

