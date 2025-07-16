#!/bin/bash

echo -e "\n⚙️ Installation du lanceur smkortex (nécessite sudo)"

read -p "👉 Souhaitez-vous installer le lanceur dans /usr/local/bin ? [o/n] : " OK
if [[ "$OK" =~ ^[Oo]$ ]]; then
  sudo bash -c 'cat > /usr/local/bin/smkortex' <<'EOF'
#!/bin/bash

ROOTDIR="$(dirname "$(realpath "$0")")/../.."
LOGDIR="$ROOTDIR/logs"
mkdir -p "$LOGDIR"
LOGFILE="$LOGDIR/session_$(date +"%H-%M_%d-%m-%Y").log"

MODEL="$ROOTDIR/llama/models/model.gguf"
BIN="$ROOTDIR/llama/llama.cpp/build/bin/llama-cli"

if [ ! -f "$BIN" ] || [ ! -f "$MODEL" ]; then
  echo "❌ Le binaire ou le modèle est manquant"
  exit 1
fi

echo "🧠 Lancement KORTEX ➤ $(date)"
"$BIN" \
  --model "$MODEL" \
  --interactive \
  --color \
  --threads $(nproc) \
  --temp 0.7 \
  --repeat_penalty 1.1 \
  --top_k 40 \
  --top_p 0.9 \
  --n_predict 256 \
  --seed -1 \
  --prompt "La conversation suivante est entre un Utilisateur et KORTEX, un assistant IA francophone bienveillant.\nUtilisateur :" \
  --reverse-prompt "Utilisateur :" \
  | tee -a "$LOGFILE"
EOF

  sudo chmod +x /usr/local/bin/smkortex
  echo "✅ Lanceur installé ➤ utilisez : smkortex \"Bonjour toi\""
else
  echo "❌ Installation du lanceur annulée"
fi

