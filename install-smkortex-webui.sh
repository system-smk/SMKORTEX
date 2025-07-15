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
  <style>
    .texte {
    color: white;
    font-size: 28px;
    font-weight: bold;
    text-align: center;
    text-shadow: 2px 2px 4px black;
    }

    canvas#particles {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      z-index: -1;
      background: black;
      transition: background 1s ease;
    }

    body.cosmic canvas#particles {
      background: radial-gradient(ellipse at center, #001122, #000000);
    }

    .conteneur {
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      display: flex; flex-direction: column;
      align-items: center; gap: 20px;
      width: 100%;
    }

    .zone {
      display: flex;
      gap: 10px;
      margin-top: 10px;
    }

    input[type="text"] {
      padding: 10px 20px;
      width: 300px;
      border-radius: 25px;
      border: none;
      outline: none;
      font-size: 16px;
    }

    button {
      padding: 10px 20px;
      background: #00ffcc;
      border: none;
      border-radius: 25px;
      color: black;
      font-weight: bold;
      cursor: pointer;
    }

    #chatbox {
      margin-top: 20px;
      display: flex;
      flex-direction: column;
      gap: 12px;
      max-height: 350px;
      overflow-y: auto;
      padding: 10px;
      background: rgba(255,255,255,0.05);
      border-radius: 20px;
      width: 80%;
      box-shadow: 0 0 8px rgba(0,255,204,0.2);
    }

    .bubble {
      padding: 12px 18px;
      border-radius: 18px;
      max-width: 85%;
      font-size: 18px;
      word-wrap: break-word;
      animation: fadeIn 0.5s ease forwards;
    }

    .bubble.user {
      align-self: flex-end;
      background: #00ffcc;
      color: black;
    }

    .bubble.system {
      align-self: flex-start;
      background: rgba(0, 255, 204, 0.15);
      color: #00ffcc;
      border: 1px solid #00ffcc;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <canvas id="particles"></canvas>

  <div class="conteneur">
    <p class="texte">Bienvenue dans <strong>SMKortex</strong> 💬</p>
    <img src="images/image.jpg" alt="Lama illustré" id="image"/>
    <video autoplay loop muted width="250">
      <source src="videos/video.mp4" type="video/mp4" />
    </video>

    <div class="zone">
      <input type="text" id="prompt" placeholder="Pose ta question ici..." />
      <button id="askBtn">Parler à Kortex</button>
    </div>

    <div id="chatbox">
      <div class="bubble system">🦙 Kortex est prêt à t’écouter...</div>
    </div>
  </div>

  <script>
    document.getElementById("askBtn").addEventListener("click", sendToKortex);

    function sendToKortex() {
      const input = document.getElementById("prompt");
      const prompt = input.value.trim();
      if (!prompt) return;

      appendBubble("user", `🧠 Tu : ${prompt}`);
      document.body.classList.add("cosmic");
      input.value = "";

      fetch("/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ prompt })
      })
      .then(res => res.text())
      .then(text => {
        appendBubble("system", `🦙 Kortex : ${text}`);
        document.body.classList.remove("cosmic");
      })
      .catch(err => {
        appendBubble("system", "❌ Erreur lors de l'appel à KORTEX");
        document.body.classList.remove("cosmic");
      });
    }

    function appendBubble(type, content) {
      const chatbox = document.getElementById("chatbox");
      const bubble = document.createElement("div");
      bubble.className = `bubble ${type}`;
      bubble.textContent = content;
      chatbox.appendChild(bubble);
      chatbox.scrollTop = chatbox.scrollHeight;
    }
  </script>

  <script>
    const canvas = document.getElementById("particles");
    const ctx = canvas.getContext("2d");
    let mouse = { x: null, y: null };

    function resizeCanvas() {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }
    resizeCanvas();
    window.addEventListener("resize", resizeCanvas);
    window.addEventListener("mousemove", (e) => {
      mouse.x = e.clientX;
      mouse.y = e.clientY;
    });

    const particleCount = 100;
    const particles = Array.from({ length: particleCount }, () => ({
      x: Math.random() * canvas.width,
      y: Math.random() * canvas.height,
      vx: (Math.random() - 0.5) * 0.6,
      vy: (Math.random() - 0.5) * 0.6,
      size: Math.random() * 2 + 1
    }));

    function drawLine(p1, p2) {
      const dx = p1.x - p2.x;
      const dy = p1.y - p2.y;
      const dist = Math.sqrt(dx * dx + dy * dy);
      if (dist < 120) {
        ctx.strokeStyle = "rgba(0,255,204,0.3)";
        ctx.lineWidth = 0.5;
        ctx.beginPath();
        ctx.moveTo(p1.x, p1.y);
        ctx.lineTo(p2.x, p2.y);
        ctx.stroke();
      }
    }

    function drawMouseLine(p) {
      if (mouse.x === null || mouse.y === null) return;
      const dx = p.x - mouse.x;
      const dy = p.y - mouse.y;
      const dist = Math.sqrt(dx * dx + dy * dy);
      if (dist < 150) {
        ctx.strokeStyle = "rgba(255,255,255,0.2)";
        ctx.lineWidth = 0.6;
        ctx.beginPath();
        ctx.moveTo(p.x, p.y);
        ctx.lineTo(mouse.x, mouse.y);
        ctx.stroke();
      }
    }

    function animateParticles() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.fillStyle = "#00ffcc";

      for (let i = 0; i < particleCount; i++) {
        const p = particles[i];
        p.x += p.vx;
        p.y += p.vy;

        if (p.x < 0 || p.x > canvas.width) p.vx *= -1;
        if (p.y < 0 || p.y > canvas.height) p.vy *= -1;

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size, 0, 2 * Math.PI);
        ctx.fill();

        drawMouseLine(p);
        for (let j = i + 1; j < particleCount; j++) {
          drawLine(p, particles[j]);
        }
      }

      requestAnimationFrame(animateParticles);
    }

    animateParticles();
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
