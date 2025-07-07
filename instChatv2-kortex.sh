#!/bin/bash

# === 📁 Résolution robuste du chemin racine
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$DIR/$SCRIPT_SOURCE"
done
ROOTDIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")/.." >/dev/null 2>&1 && pwd)"

# === 📦 Chemins et logs
mkdir -p "$ROOTDIR/logs"
LOGFILE="$ROOTDIR/logs/session_$(date +"%H-%M_%d-%m-%Y").log"
MODEL="$ROOTDIR/llama/models/model.gguf"
BIN="$ROOTDIR/llama/llama.cpp/build/bin/llama-cli"

echo "📦 Projet : $ROOTDIR"
echo "📅 Log    : $LOGFILE"
echo "⚡ Mode session persistante KORTEX (RAM boostée)"
echo "✏️  Ctrl+C pour quitter"

# === 🧪 Vérifications
if [ ! -f "$BIN" ]; then
  echo "❌ Binaire introuvable ➤ compile avec clone-compile-llama.sh"
  exit 1
fi

if [ ! -f "$MODEL" ]; then
  echo "❌ Modèle introuvable ➤ télécharge avec telecharger-modele.sh"
  exit 1
fi

# === 🚀 Lancement de la session interactive
"$BIN" \
  --model "$MODEL" \
  --color \
  --threads 6 \
  --temp 0.6 \
  --repeat_penalty 1.15 \
  --top_k 50 \
  --top_p 0.95 \
  --n_predict 384 \
  --ctx-size 4096 \
  --no-mmap \
  --seed -1 \
  --prompt "La conversation suivante est entre un Utilisateur et KORTEX, un assistant IA francophone bienveillant.\nUtilisateur :" \
  --interactive \
  --reverse-prompt "Utilisateur :" \
  | tee -a "$LOGFILE"



