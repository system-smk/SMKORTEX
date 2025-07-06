echo -e "\n📁 Vérification du dossier de destination..."
mkdir -p llama/models
touch logs/model_download.log

echo -e "\n📡 Téléchargement du modèle Vigogne..."
MODEL_URL="https://huggingface.co/TheBloke/Vigogne-2-7B-Chat-GGUF/resolve/main/vigogne-2-7b-chat.Q4_K_M.gguf"
MODEL_PATH="llama/models/model.gguf"
LOG_PATH="logs/model_download.log"

case "$USER_CHOICE" in
  "1")
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    ;;
  "2")
    cmatrix -u 5 -C green & CM_PID=$!
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    kill "$CM_PID" 2>/dev/null && clear
    ;;
  "3")
    tmux new-session -d -s smkfx 'cmatrix -u 5 -C green'
    echo -e "\n🌀 Animation lancée via tmux [session : smkfx]"
    read -p "👉 Souhaitez-vous afficher la session maintenant ? [O/n] : " SHOW_CMX
    [[ "$SHOW_CMX" =~ ^[oO]$ || -z "$SHOW_CMX" ]] && tmux attach -t smkfx
    echo "⏳ Téléchargement du modèle en cours..."
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
    tmux kill-session -t smkfx 2>/dev/null && clear
    ;;
  *)
    wget "$MODEL_URL" -O "$MODEL_PATH" 2> "$LOG_PATH"
esac

echo -e "\n📁 Vérification du fichier téléchargé..."
if [ -f "$MODEL_PATH" ]; then
  if file "$MODEL_PATH" | grep -qi html; then
    echo "⚠️ Fichier reçu semble être du HTML ➤ probable redirection ou erreur"
    head "$MODEL_PATH"
    exit 1
  fi
  echo "✅ Téléchargement réussi ➤ $MODEL_PATH"
else
  echo "❌ Échec du téléchargement ➤ fichier introuvable"
  exit 1
fi
