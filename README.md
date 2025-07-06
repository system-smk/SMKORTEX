## 📘 README — SMKortex : Assistant IA local en français

---

### 🤖 Présentation

SMKortex est un assistant IA **100 % local** en français, basé sur `llama.cpp` et le modèle **Vigogne 2 7B**, conçu pour fonctionner sans connexion internet après installation.

Il propose un setup **modulaire et automatisé**, avec des scripts organisés, une installation propre, et un raccourci terminal pour interagir facilement via `smkortex`.

---

### 🛠️ Prérequis

Avant de commencer :

- Linux ou macOS avec Bash
- Git, Make et wget installés
- CPU correct (ou GPU si intégré dans le futur)
- ~4 Go d’espace libre pour le modèle

---

### 🚀 Installation complète

#### ✅ Étape 1 — Cloner le dépôt

```bash
git clone https://github.com/ton-utilisateur/smkortex.git
cd smkortex
```

#### ✅ Étape 2 — Lancer le script principal

```bash
bash main-smkortex.sh
```

Ce script exécute les étapes suivantes dans cet ordre :

| Étape | Script appelé | Action réalisée |
|-------|---------------|------------------|
| 1️⃣   | `install-dependances.sh`        | Installe les paquets nécessaires |
| 2️⃣   | `clone-compile-llama.sh`        | Clone `llama.cpp` et compile `llama-cli` |
| 3️⃣   | `telecharger-modele.sh`         | Télécharge Vigogne `.gguf` dans `llama/models/` |
| 4️⃣   | `installer-chatv2.sh`           | Installe `instChatv2-kortex.sh` dans `scripts/` |
| 5️⃣   | `configurer-lanceur.sh`         | Crée le raccourci global `smkortex` |
| 6️⃣   | (option) `desinstaller-smkortex.sh` | Supprime tout proprement si choisi |

---

### 🧱 Structure attendue après installation

```
SMKORTEX/
├── main-smkortex.sh
├── scripts/
│   └── instChatv2-kortex.sh
├── llama/
│   ├── llama.cpp/
│   │   └── build/bin/llama-cli
│   └── models/
│       └── vigogne-2-7b-chat.Q4_K_M.gguf
├── logs/         ← sessions interactives ici
├── config/       ← paramètres si nécessaires
└── README.md
```

---

### 💬 Lancement de l’assistant IA

Deux méthodes pour démarrer une session :

#### 🔹 Méthode 1 — via le raccourci

```bash
smkortex "Bonjour toi"
```

#### 🔹 Méthode 2 — en lançant directement le script

```bash
bash scripts/instChatv2-kortex.sh
```

> Chaque session génère un log dans `logs/` avec horodatage complet.

---

### 🧠 Problèmes fréquents

| Message d'erreur                     | Cause probable                         | Solution recommandée                |
|-------------------------------------|----------------------------------------|-------------------------------------|
| `llama-cli: command not found`      | Binaire non compilé                    | Relance `clone-compile-llama.sh`    |
| `model not found`                   | Modèle absent ou chemin incorrect      | Vérifie dans `llama/models/`        |
| `tee: logs/...log: Aucun fichier...`| Dossier `logs/` manquant               | Crée avec `mkdir -p logs`           |
| Modèle fait quelques Ko seulement   | Téléchargement incomplet               | Relance `telecharger-modele.sh`     |

---

### 📦 Désinstallation

Si tu veux tout nettoyer :

```bash
bash scripts/desinstaller-smkortex.sh
```

---

### 💚 Auteur

Projet piloté par **Mathieu-Karim**, avec l’IA locale SMKortex 🦙  
Un assistant terminal qui rumine sans Cloud 🧠✨

---

Tu veux aussi un `USAGE.md` ou un `SCRIPTS.md` avec des explications individuelles pour chaque module ? Je peux te préparer une documentation pro niveau GitHub Stars 🌟  
Dis-moi comment tu veux le présenter au monde !

💚 _Projet piloté avec passion
By Mathieu-Karim & SMKortex




