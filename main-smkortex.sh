#!/bin/bash

echo -e "\n🧠 Bienvenue dans SMKortex Setup"

SCRIPTS=(install-dependances.sh clone-compile-llama.sh telecharger-modele.sh instChatv2-kortex.sh configurer-lanceur.sh desinstaller-smkortex.sh)

# 🔍 Vérifie la présence des fichiers dans scripts/
for file in "${SCRIPTS[@]}"; do
  if [ ! -f "scripts/$file" ]; then
    echo "❌ Le script 'scripts/$file' est manquant"
    exit 1
  fi
done

echo -e "\n📦 Que souhaitez-vous faire ?"
echo "1. Installer SMKortex 🧠"
echo "2. Désinstaller SMKortex 🧹"
read -p "👉 Choix [1/2] : " CH

case "$CH" in
  1)
    bash scripts/install-dependances.sh
    bash scripts/clone-compile-llama.sh
    bash scripts/telecharger-modele.sh
    bash scripts/instChatv2-kortex.sh
    bash scripts/configurer-lanceur.sh
    echo -e "\n🎉 SMKortex est prêt ➤ utilise : smkortex \"Bonjour toi\" 🦙"
    ;;
  2)
    bash scripts/desinstaller-smkortex.sh
    ;;
  *)
    echo "❌ Option invalide"
    exit 1
    ;;
esac
