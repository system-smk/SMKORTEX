#!/bin/bash

# === Configuration utilisateur ===
MODEL="./llama/models/vigogne-2-7b-chat.Q4_K_M.gguf"
BIN="./llama/llama.cpp/build/bin/llama-cli"
N_PREDICT=200
TEMPERATURE=0.5
TOP_P=0.9
REVERSE_PROMPT="Utilisateur :"
LOGFILE="logs/session_$(date +'%H-%M_%d-%m-%Y').log"

# === Prompt système renforcé ===
PROMPT_SYSTEM="Tu es un assistant IA francophone, factuel et bienveillant.\n\nUtilisateur : bonjour\nAssista>

# === Interface ===
clear
echo -e "\n🧠 SMKortex v2 — Session interactive"
echo "📅 Log : $LOGFILE"
echo "✏  Ctrl+C pour quitter"

# === Boucle interactive ===
while true; do
  echo -ne "\n\033[1;36mUtilisateur :\033[0m "
  read -e INPUT

  echo "Utilisateur : $INPUT" >> "$LOGFILE"
  echo -e "\033[1;34m\n💬 SMKortex répond...\033[0m"

  PROMPT="$PROMPT_SYSTEM\nUtilisateur : $INPUT\nAssistant:"

  "$BIN" \
    -m "$MODEL" \
    --prompt "$PROMPT" \
    --n-predict "$N_PREDICT" \
    --temp "$TEMPERATURE" \
    --top-p "$TOP_P" \
    --reverse-prompt "$REVERSE_PROMPT" \
    --color | tee -a "$LOGFILE"
done
