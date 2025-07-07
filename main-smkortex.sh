#!/bin/bash

echo -e "\n📁 Organisation des fichiers…"

# Crée le dossier s'il n'existe pas
mkdir -p scripts

# Déplace les scripts dans le dossier scripts sauf ceux déjà dedans
for FILE in *.sh; do
  [[ "$FILE" == "main-smkortex.sh" ]] && continue
  [[ -f "scripts/$FILE" ]] && continue
  mv "$FILE" scripts/
done

echo "✅ Tous les scripts ont été déplacés dans ➤ ./scripts/"

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

    # 🧪 Vérifie et compile llama.cpp si absent
    if [ ! -d "llama/llama.cpp" ]; then
      echo -e "\n📦 Dépôt llama.cpp manquant ➤ lancement automatique du clonage + compilation"
      bash scripts/clone-compile-llama.sh
    else
      echo -e "\n✅ Dépôt llama.cpp déjà présent ➤ compilation ignorée"
    fi

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
