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
const { spawn } = require("child_process");

const app = express();
const PORT = 3000;

// 📁 Dossier contenant index.html + assets (public/)
app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());

// 🔁 Route POST /chat pour parler à Kortex
app.post("/chat", (req, res) => {
  const userPrompt = req.body.prompt?.trim();

  if (!userPrompt) {
    console.warn("❗ Aucune requête utilisateur reçue.");
    return res.status(400).send("Prompt manquant");
  }

  const scriptPath = path.join(__dirname, "..", "scripts", "instChatv2-kortex.sh");
  const process = spawn("bash", [scriptPath, userPrompt]);

  let output = "";
  let errorOutput = "";

  process.stdout.on("data", (data) => {
    output += data.toString();
  });

  process.stderr.on("data", (data) => {
    errorOutput += data.toString();
  });

  process.on("close", (code) => {
    if (code !== 0 || errorOutput) {
      console.error("❌ Erreur dans SMKortex :", errorOutput);
      return res.status(500).send("Erreur lors de l'exécution de Kortex.");
    }

    const cleaned = output.trim();
    console.log("✅ Réponse Kortex :", cleaned);
    res.send(cleaned);
  });
});

// 🚀 Lancement du serveur
app.listen(PORT, () => {
  console.log(`🌐 SMKortex WebUI dispo sur ➤ http://localhost:${PORT}`);
});
EOF

# --- Interface web simple
mkdir -p public
cat > public/index.html <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SMKortex 💬 Assistant IA local</title>
  <style>
    body { margin: 0; overflow: hidden; background: black; font-family: 'Segoe UI', sans-serif; }
    .conteneur {
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      display: flex; flex-direction: column;
      align-items: center; gap: 20px;
    }
    img, video {
      width: 250px;
      border-radius: 15px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.5);
    }
    .texte {
      color: white;
      font-size: 26px;
      font-weight: bold;
      text-align: center;
      text-shadow: 2px 2px 6px black;
      animation: fadeIn 2s ease-in-out forwards;
    }
    .zone {
      display: flex; flex-direction: column;
      gap: 10px; align-items: center;
    }
    input[type="text"] {
      padding: 10px 20px;
      width: 300px;
      border-radius: 25px;
      border: none;
      outline: none;
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
    .reponse {
      color: #00ffcc;
      margin-top: 10px;
      text-align: center;
      max-width: 80%;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
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

  <!-- Particules -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
  <script>
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);

    const particleCount = 500;
    const geometry = new THREE.BufferGeometry();
    const positions = new Float32Array(particleCount * 3);
    for (let i = 0; i < positions.length; i++) {
      positions[i] = (Math.random() - 0.5) * 10;
    }
    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    let material = new THREE.PointsMaterial({ color: 0x00ffcc, size: 0.05 });
    const points = new THREE.Points(geometry, material);
    scene.add(points);
    camera.position.z = 5;

    const animate = () => {
      requestAnimationFrame(animate);
      points.rotation.x += 0.001;
      points.rotation.y += 0.001;
      renderer.render(scene, camera);
    };
    animate();

    document.addEventListener('mousemove', (e) => {
      const x = e.clientX / window.innerWidth - 0.5;
      const y = e.clientY / window.innerHeight - 0.5;
      points.rotation.x = y * 2;
      points.rotation.y = x * 2;
    });

    window.addEventListener('resize', () => {
      renderer.setSize(window.innerWidth, window.innerHeight);
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
    });

    document.getElementById("image").addEventListener("mouseover", () => {
      material.color.set(0x0077ff);
    });
    document.getElementById("image").addEventListener("mouseout", () => {
      material.color.set(0x00ffcc);
    });

    // Interaction fictive avec Kortex
    function sendToKortex() {
      const prompt = document.getElementById("prompt").value.trim();
      if (!prompt) return;
      document.getElementById("reponse").textContent = "⏳ Kortex réfléchit...";
      
      // Simule une réponse (tu remplaceras ça par un appel backend + TTS)
      setTimeout(() => {
        document.getElementById("reponse").textContent = `🦙 Kortex : Tu as dit « ${prompt} », c’est bien noté.`;
        document.getElementById("prompt").value = "";
      }, 800);
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
