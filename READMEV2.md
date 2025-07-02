
# 🧠 SMKortex — Assistant local basé sur LLaMA

SMKortex est une interface locale personnalisée autour d’un modèle LLaMA (comme Vigogne 2), intégrant des scripts Bash simples, des logs automatiques, et un sous-module `llama.cpp`.

---

## 📂 Structure du projet

```
smkortex/
├── scripts/
│   ├── chat-smkortex.sh       # Lance l'assistant de façon basique
│   └── front-smkortex.sh      # Interface ligne par ligne, avec historique
├── llama/
│   └── llama.cpp/             # Sous-module Git (llama.cpp officiel)
├── models/
│   └── vigogne-2-7b-chat.Q4_K_M.gguf   # Modèle GGUF ici
├── logs/
│   └── session_...log         # Historique de session
├── context.txt                # Mémoire de session (front-smkortex)
├── .gitignore
└── README.md
```

---

## 🔧 Installation

### 1. Cloner ce dépôt avec le sous-module

```bash
git clone https://github.com/ton-utilisateur/smkortex.git
cd smkortex
git submodule update --init --recursive
```

### 2. Compiler llama.cpp

```bash
cd llama/llama.cpp
make
cd ../../
```

L'exécutable se trouve ici :
```
llama/llama.cpp/build/bin/llama-cli
```

### 3. Placer un modèle `.gguf`

Télécharge le modèle (ex. Vigogne 2) et place-le dans :

```
models/vigogne-2-7b-chat.Q4_K_M.gguf
```

---

## 🚀 Lancer SMKortex

### ▸ Avec `chat-smkortex.sh`

```bash
./scripts/chat-smkortex.sh
```

- Démarrage rapide
- Prompt système prédéfini
- Log automatique dans `logs/`
- Réponses limitées à 256 tokens

### ▸ Avec `front-smkortex.sh`

```bash
./scripts/front-smkortex.sh
```

- Invite claire `<|UTILISATEUR|>:`
- Log complet des échanges
- Historique de session dans `context.txt` (mémoire)
- Dialogue ligne à ligne avec relance

---



## ❤️ Crédits

- Vigogne 2 : https://github.com/bigscience-workshop/vigogne
- llama.cpp : https://github.com/ggerganov/llama.cpp
```

---
