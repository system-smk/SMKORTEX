#!/bin/bash
echo "Bienvenue dans SMKortex 🧠"
echo "1. Installer SMKortex"
echo "2. Désinstaller SMKortex"
read -p "👉 Choix : " CH

case "$CH" in
  1)
    bash scripts/install-dependances.sh
    bash scripts/clone-compile-llama.sh
    bash scripts/telecharger-modele.sh
    bash scripts/installer-chatv2.sh
    bash scripts/configurer-lanceur.sh
    ;;
  2)
    bash scripts/desinstaller-smkortex.sh
    ;;
  *)
    echo "❌ Option invalide"
esac
