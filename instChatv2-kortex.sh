#!/bin/bash

# 📁 Base projet
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
LOGFILE="$ROOTDIR/logs/session_$(date +"%H-%M_%d-%m-%Y").log"
MODEL="$ROOTDIR/llama/models/model.gguf"
BIN="$ROOTDIR/llama/llama.cpp/build/bin/llama-cli"

mkdir -p "$ROOTDIR/logs"
echo "📅 Log : $LOGFILE"
echo "⚡ Mode session persistante KORTEX (RAM boostée)"
echo "✏️  Ctrl+C pour quitter"

# 🔍 Vérifs
if [ ! -f "$BIN" ]; then echo "❌ Binaire manquant ➤ compile-le"; exit 1; fi
if [ ! -f "$MODEL" ]; then echo "❌ Modèle manquant ➤ télécharge-le"; exit 1; fi

# 🚀 Lance llama-cli en mode STDIN interactif
"$BIN" \
  --model "$MODEL" \
  --color \
  --threads $(nproc) \
  --temp 0.7 \
  --repeat_penalty 1.1 \
  --top_k 40 \
  --top_p 0.9 \
  --n_predict 256 \
  --seed -1 \
  --prompt "La conversation suivante est entre un Utilisateur et KORTEX, un assistant IA francophone bienveillant.\nUti>  --interactive \
  --reverse-prompt "Utilisateur :" \
  | tee -a "$LOGFILE"


