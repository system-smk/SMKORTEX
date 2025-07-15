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
echo -e "\n🛠 Création du dossier webui/..."
mkdir -p "$WEBUI_DIR/public"
cd "$WEBUI_DIR"

# === Initialisation projet Node.js
echo -e "\n📦 Initialisation du projet Node.js..."
npm init -y
npm install express

# === Création du fichier server.js
echo -e "\n🧠 Génération de server.js..."
cat > server.js <<_SERVER_
const express = require("express");
const path = require("path");
const { spawn } = require("child_process");

const app = express();
const PORT = 3000;

app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());

app.post("/chat", (req, res) => {
  const userPrompt = req.body.prompt?.trim();

  if (!userPrompt) {
    console.warn("❗ Aucun prompt fourni.");
    return res.status(400).send("Aucun prompt reçu.");
  }

  const scriptPath = path.join(__dirname, "..", "scripts", "instChatv2-kortex.sh");
  const kortex = spawn("bash", [scriptPath, userPrompt]);

  let output = "";
  let errorOutput = "";

  kortex.stdout.on("data", (data) => { output += data.toString(); });
  kortex.stderr.on("data", (data) => { errorOutput += data.toString(); });

  kortex.on("close", (code) => {
    if (code !== 0) {
      console.error("❌ KORTEX a échoué :", errorOutput);
      return res.status(500).send("Erreur KORTEX");
    }
    res.send(output.trim());
  });

  kortex.on("error", (err) => {
    console.error("🧨 Erreur système :", err);
    res.status(500).send("Erreur système KORTEX");
  });
});

app.listen(PORT, () => {
  console.log(\`🌐 SMKORTEX WebUI dispo sur ➤ http://localhost:\${PORT}\`);
});
_SERVER_

# === Génération de index.html
echo -e "\n🎨 Création de public/index.html..."
cat > public/index.html <<_HTML_
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SMKortex 💬 Assistant IA local</title>
  <style>/* (CSS contenu inchangé pour simplifier) */</style>
</head>
<body>
  <div class="conteneur">
    <p class="texte">Bienvenue dans <strong>SMKortex</strong> 💬</p>
    <img src="images/image.jpg" alt="Lama illustré" id="image"/>
    <video autoplay loop muted>
      <source src="videos/video.mp4" type="video/mp4" />
    </video>
    <div class="zone">
      <input type="text" id="prompt" placeholder="Pose ta question ici..."/>
      <button onclick="sendToKortex()">Parler à Kortex</button>
      <p class="reponse" id="reponse">🦙 Je suis prêt à te répondre...</p>
    </div>
  </div>

  <script>
    function sendToKortex() {
      const prompt = document.getElementById("prompt").value.trim();
      if (!prompt) return;
      document.getElementById("reponse").textContent = "⏳ Kortex réfléchit...";
      fetch("/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ prompt })
      })
      .then(res => res.text())
      .then(text => {
        document.getElementById("reponse").textContent = \`🦙 Kortex : \${text}\`;
        document.getElementById("prompt").value = "";
      })
      .catch(err => {
        document.getElementById("reponse").textContent = "❌ Erreur lors de l'appel à KORTEX";
      });
    }
  </script>
</body>
</html>
_HTML_

# === README
echo -e "\n📄 Génération de READMEWEBUI.md..."
cat > READMEWEBUI.md <<_README_
# 🌐 SMKortex WebUI (Node.js)

Interface web locale pour discuter avec SMKortex via un serveur Node.js.

## Lancement

\`\`\`bash
cd webui
node server.js
\`\`\`

Puis ouvre ton navigateur sur :  
👉 http://localhost:3000
_README_

echo -e "\n✅ Installation terminée ! SMKORTEX WebUI est prêt à l’emploi."
