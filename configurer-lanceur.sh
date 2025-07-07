# Ajoute ce bloc dans l’installeur, à la fin ⬇️
echo -e "\n⚙️ Installation du raccourci smkortex..."
sudo tee /usr/local/bin/smkortex > /dev/null <<'EOF'
#!/bin/bash

SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$DIR/$SCRIPT_SOURCE"
done
ROOTDIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")/.." >/dev/null 2>&1 && pwd)"

mkdir -p "$ROOTDIR/logs"
LOGFILE="$ROOTDIR/logs/session_$(date +"%H-%M_%d-%m-%Y").log"
MODEL="$ROOTDIR/llama/models/model.gguf"
BIN="$ROOTDIR/llama/llama.cpp/build/bin/llama-cli"

echo "📦 Projet : $ROOTDIR"
echo "📅 Log    : $LOGFILE"
echo "⚡ KORTEX session RAM boostée"

if [ ! -f "$BIN" ]; then echo "❌ Binaire manquant ➤ compile-le"; exit 1; fi
if [ ! -f "$MODEL" ]; then echo "❌ Modèle manquant ➤ télécharge-le"; exit 1; fi

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
  --prompt "La conversation suivante est entre un Utilisateur et KORTEX, un assistant IA francophone bienveillant.\nUtilisateur :" \
  --interactive \
  --reverse-prompt "Utilisateur :" \
  | tee -a "$LOGFILE"
EOF

sudo chmod +x /usr/local/bin/smkortex

