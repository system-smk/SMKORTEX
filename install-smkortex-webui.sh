#!/bin/bash

# === 💻 SMKORTEX WebUI Installer (Node.js Edition) ===

set -e

echo -e "\n🚀 Installation de l’interface WebUI SMKORTEX (Node.js)...\n"

# === Détection de l’emplacement du projet
PROJECT_DIR=$(dirname "$(dirname "$(realpath "$0")")")
WEBUI_DIR="$PROJECT_DIR/webui"

echo "📁 Projet localisé : $PROJECT_DIR"

# === Installation de Node.js & npm (si absents)
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
  echo -e "\n📦 Installation de Node.js et npm..."
  sudo apt update
  sudo apt install -y nodejs npm
else
  echo -e "✅ Node.js et npm déjà installés."
fi

# === Création du dossier webui
echo -e "\n🛠️ Création du dossier webui/..."
mkdir -p "$WEBUI_DIR"
cd "$WEBUI_DIR"

# === Initialisation projet Node.js
echo -e "\n📦 Initialisation du projet Node.js..."
npm init -y
npm install express

# === Création des fichiers de base
echo -e "\n🧠 Création des fichiers server.js et index.html..."

# --- server.js
cat > server.js <<EOF
const express = require("express");
const path = require("path");
const { exec } = require("child_process");

const app = express();
const PORT = 3000;

app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());

app.post("/chat", (req, res) => {
  const userPrompt = req.body.prompt;
  exec(\`./scripts/chatv2-kortex.sh "\${userPrompt}"\`, (err, stdout) => {
    if (err) return res.status(500).send("Erreur de SMKortex");
    res.send(stdout);
  });
});

app.listen(PORT, () => {
  console.log(\`🌐 SMKortex WebUI disponible sur http://localhost:\${PORT}\`);
});
EOF

# --- Interface web simple
mkdir -p public
cat > public/index.html <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>SMKortex WebUI</title>
  <style>
    body { font-family: monospace; padding: 2rem; background: #111; color: #0f0; }
    input, button { font-size: 1rem; margin-top: 1rem; }
    textarea { width: 100%; height: 200px; margin-top: 1rem; background: #000; color: #0f0; }
  </style>
</head>
<body>
  <h1>💻 SMKortex WebUI</h1>
  <input type="text" id="prompt" placeholder="Tape ta question..." />
  <button onclick="sendPrompt()">Envoyer</button>
  <textarea id="response" readonly></textarea>

  <script>
    async function sendPrompt() {
      const prompt = document.getElementById("prompt").value;
      const res = await fetch("/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ prompt })
      });
      const data = await res.text();
      document.getElementById("response").value = data;
    }
  </script>
</body>
</html>
EOF

# --- README
cat > README.md <<EOF
# 🌐 SMKortex WebUI (Node.js)

Interface web locale pour discuter avec SMKortex via un serveur Node.js.

## Lancement

Exécute les commandes suivantes :

cd webui  
node server.js

Puis ouvre ton navigateur sur :  
http://localhost:3000

EOF
