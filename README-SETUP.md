

## 📘 `README.md` — Projet SMKortex


# 🤖 SMKortex

SMKortex est un assistant IA local, francophone, propulsé par `llama.cpp` et des modèles au format `.gguf`.  
Il fonctionne entièrement en local, sans connexion Internet une fois installé.

---

## ⚙️ Installation automatique

Lance le script suivant depuis la racine du projet :

```bash
./setup-smkortex.sh
```

Ce script :

- 📥 Clone `llama.cpp` dans `llama/llama.cpp`
- 🔨 Compile le projet avec `make`
- 📁 Crée les dossiers `scripts/`, `logs/`, `llama/models/`
- 📦 Télécharge un modèle préconfiguré (`vigogne-2-7b-chat.Q4_K_M.gguf`)
- 📜 Installe les scripts :
  - `scripts/chat-smkortex.sh`
  - `scripts/front-smkortex.sh`
  - `scripts/chatv2-kortex.sh`
- 🗂️ Génère la documentation d’usage dans `SCRIPTS.md`

---

## 🧠 Utilisation rapide

Lance l’interface interactive avec :

```bash
./scripts/chatv2-kortex.sh
```

👉 Cette version V2 est optimisée pour une génération plus fluide et moins d’hallucinations.  
Tu peux aussi tester les autres scripts (`chat-smkortex.sh`, `front-smkortex.sh`) selon ton usage.

---

## 📁 Arborescence installée

```
SMKORTEX/
├── setup-smkortex.sh         ← Script d’installation
├── SCRIPTS.md                ← Documentation des scripts
├── scripts/                  ← Tes interfaces bash
│   ├── chat-smkortex.sh
│   ├── front-smkortex.sh
│   └── chatv2-kortex.sh
├── logs/                     ← Journaux de sessions
├── context.txt               ← (optionnel) mémoire temporaire
├── llama/
│   ├── llama.cpp/            ← Code source compilé
│   └── models/
│       └── vigogne-2-7b-chat.Q4_K_M.gguf
└── README.md
```

---

## 📦 Modèle installé

| Modèle     | Format    | Taille     | Langue    |
|------------|-----------|------------|-----------|
| Vigogne 2  | GGUF Q4_K | ~3.9 Go    | Français  |

Le fichier `.gguf` est placé dans `llama/models/` et utilisé par défaut dans `chatv2-kortex.sh`.

---

## 💬 Plus d’infos

- 📜 Voir [`SCRIPTS.md`](./SCRIPTS.md) pour la documentation détaillée des scripts
- 📘 Voir [`MODELES.md`](./MODELES.md) si tu veux changer de modèle `.gguf`

---

## 🚀 À venir

- Choix interactif du modèle à installer
- Interface visuelle TUI (avec `gum` ou `dialog`)
- Support des commandes `!reset`, `!log off`, etc.

---

💚 _Projet piloté avec passion et terminal_  
_By Mathieu-Karim & SMKortex_
```

