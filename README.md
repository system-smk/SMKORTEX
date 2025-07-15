## 📘 README — SMKortex : Assistant IA local en français + Interface WebUI

---

### 🤖 Présentation

SMKortex est un assistant IA **100 % local**, conçu pour fonctionner sans connexion internet après installation. Il utilise `llama.cpp` associé au modèle **Vigogne 2 7B**, optimisé pour la conversation en français.

💡 Il propose deux modes d’interaction :
- Terminal classique (`smkortex`)
- Interface Web interactive (`WebUI`) avec champ texte, bulles et animation cosmique

---

### 🛠️ Prérequis

- Linux ou macOS avec Bash
- Git, Make, wget et Node.js installés
- ~4 Go d’espace libre pour le modèle
- Navigateur moderne pour la WebUI

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

Ce script installe automatiquement :

| Étape | Script appelé                         | Action réalisée                                          |
|-------|----------------------------------------|----------------------------------------------------------|
| 1️⃣   | `install-dependances.sh`               | Installe les paquets nécessaires                         |
| 2️⃣   | `clone-compile-llama.sh`               | Clone `llama.cpp` et compile `llama-cli`                |
| 3️⃣   | `telecharger-modele.sh`                | Télécharge Vigogne `.gguf` dans `llama/models/`         |
| 4️⃣   | `instChatv2-kortex.sh`                 | Configure l’agent IA Shell local                        |
| 5️⃣   | `configurer-lanceur.sh`                | Crée le raccourci terminal `smkortex`                   |
| 6️⃣   | `install-smkortex-webui.sh`            | Crée l’interface WebUI dans `webui/`                    |
| 7️⃣   | `configurer-lanceur-webui.sh`          | Crée le raccourci terminal `webkortex`                  |
| 🧹   | *(option)* `desinstaller-smkortex.sh`   | Supprime proprement tout le projet                     |

---

### 💬 Utilisation en ligne de commande

#### 🔹 Méthode 1 — raccourci terminal

```bash
smkortex "Quel est le sens de la vie ?"
```

#### 🔹 Méthode 2 — lancer le script directement

```bash
bash scripts/instChatv2-kortex.sh
```

> Les réponses s'affichent en direct, et chaque session est loguée dans `logs/`.

---

### 🌐 Utilisation via Interface WebUI

#### 🔹 Démarrer le serveur Web :

```bash
webkortex
```

> Lance le serveur à l'adresse : [http://localhost:3000](http://localhost:3000)

#### 🔹 Interface 

- Champ texte pour poser tes questions
- Bouton **“Parler à Kortex”**

---

### 🧱 Arborescence finale attendue

```
SMKORTEX/
├── main-smkortex.sh
├── scripts/
│   └── instChatv2-kortex.sh
│   └── install-smkortex-webui.sh
├── llama/
│   └── llama.cpp/
│   └── models/
├── webui/
│   ├── server.js
│   └── public/
│       ├── index.html
│       ├── style.css
│       └── app.js
├── logs/
└── README.md
```

---

### 🧠 Problèmes fréquents

| Message d'erreur                          | Cause probable                      | Solution recommandée              |
|------------------------------------------|-------------------------------------|-----------------------------------|
| `llama-cli: command not found`           | Binaire non compilé                 | Relancer `clone-compile-llama.sh` |
| `model not found`                        | Modèle absent ou incorrect          | Vérifier `llama/models/`          |
| `tee: logs/...log: Aucun fichier...`     | Dossier `logs/` manquant            | Créer avec `mkdir -p logs`        |
| WebUI répond mais n’affiche rien         | Script ne renvoie rien              | Vérifier `echo` dans le script IA |
| `node: command not found`                | Node.js manquant                    | Installer avec `apt install nodejs npm` |

---

### 🧹 Désinstallation

```bash
bash scripts/desinstaller-smkortex.sh
```

---

### 🧠 Attribution et citation du modèle

SMKORTEX repose sur le modèle **Vigogne** :

> Huang, B. (2023). *Vigogne: French Instruction-following and Chat Models*  
> [GitHub repository](https://github.com/bofenghuang/vigogne)

```bibtex
@misc{vigogne,
  author       = {Bofeng Huang},
  title        = {Vigogne: French Instruction-following and Chat Models},
  year         = {2023},
  publisher    = {GitHub},
  journal      = {GitHub repository},
  howpublished = {\url{https://github.com/bofenghuang/vigogne}},
}
```
> "SMKORTEX powered by Vigogne 🧠 — modèle conversationnel français par @bofenghuang"

---

### 💚 Auteur

Projet pensé, organisé et piloté par **Mathieu-Karim**,  
assisté par Copilot ✨  

