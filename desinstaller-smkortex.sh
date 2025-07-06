#!/bin/bash

echo -e "\n🧹 Désinstallation de SMKortex..."

read -p "🛑 Es-tu sûr de vouloir tout supprimer ? [o/N] : " CONFIRM
[[ "$CONFIRM" =~ ^[oO]$ ]] || { echo "🚫 Désinstallation annulée."; exit 0; }

echo "📁 Suppression des dossiers : scripts, logs, llama..."
rm -rf scripts logs llama

echo "🗑️ Suppression du raccourci global..."
sudo rm -f /usr/local/bin/smkortex

echo -e "\n✅ SMKortex désinstallé proprement. Tu peux toujours le reconstruire 🦙"
