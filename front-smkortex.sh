#!/bin/bash

# === Configuration ===
MODEL="./llama/models/vigogne-2-7b-chat.Q4_K_M.gguf"
BIN="./llama/llama.cpp/build/bin/llama-cli"
DATE=$(date +"%H-%M_%d-%m-%Y")
LOGFILE="./logs/session_$DATE.log"
CTXFILE="./context.txt"

# === Prompt système SMKortex ===
SYSTEM_PROMPT="<|UTILISATEUR|>: Tu es SMKortex, un assistant IA francophone polyvalent, avec une affinité particulière pour la psychologie, le développement personnel et l’assistance technique. Tu réponds toujours en français, avec clarté, concision et bienveillance. Tu poses des questions si nécessaire pour mieux comprendre les besoins de ton interlocuteur. Tu t’exprimes dans le format :
<|UTILISATEUR|>: ...
<|ASSISTANT|>: ...
\n<|ASSISTANT|>: Bonjour 👋 Je suis SMKortex, ton copilote mental et technique. Comment puis-je t’aider aujourd’hui ?
\n<|UTILISATEUR|>: Bonjour"

# === Initialisation ===
mkdir -p logs
echo -e "🧠 Session SMKortex — $(date +"%Hh%M – %d/%m/%Y")\n----------------------------------------------\n" >> "$LOGFILE"
echo -e "$SYSTEM_PROMPT\n<|ASSISTANT|>:" > "$CTXFILE"

# === Première réponse (accueil) ===
$BIN -m "$MODEL" \
     --prompt "$(cat "$CTXFILE")" \
     --n-predict 256 \
     --reverse-prompt "<|UTILISATEUR|>:" \
| tee -a "$LOGFILE" > temp_output.txt

tail -n +2 temp_output.txt >> "$CTXFILE"
echo "" >> "$CTXFILE"

# === Boucle interactive ===
while true; do
  echo -ne "\n<|UTILISATEUR|>: "
  read USER_INPUT
  echo "<|UTILISATEUR|>: $USER_INPUT" | tee -a "$LOGFILE" >> "$CTXFILE"
  echo "<|ASSISTANT|>:" >> "$CTXFILE"

  $BIN -m "$MODEL" \
       --prompt "$(cat "$CTXFILE")" \
       --n-predict 256 \
       --reverse-prompt "<|UTILISATEUR|>:" \
  | tee -a "$LOGFILE" > temp_output.txt

  tail -n +2 temp_output.txt >> "$CTXFILE"
  echo "" >> "$CTXFILE"
done
