

## 📘 `README-chatv2.md` — Interface avancée `chatv2-kortex.sh`


# 🧠 chatv2-kortex.sh

`chatv2-kortex.sh` est un script Bash interactif conçu pour lancer une session de dialogue fluide avec SMKortex, un assistant IA local alimenté par `llama.cpp`.

C’est la version la plus optimisée des interfaces disponibles, intégrant :

- 📏 un contrôle fin sur les paramètres de génération
- 🎛️ une configuration facile en début de fichier
- 🎨 des couleurs lisibles dans le terminal
- 🪵 un journal automatique de chaque session (`logs/`)

---

## ▶️ Lancer une session

Depuis la racine du projet :

```bash
./scripts/chatv2-kortex.sh
```

---

## 🔧 Paramètres configurables

En haut du fichier, les variables suivantes peuvent être modifiées facilement :

| Variable        | Description                                 | Exemple                         |
|----------------|---------------------------------------------|---------------------------------|
| `MODEL`         | Chemin du modèle `.gguf`                   | `./llama/models/vigogne.gguf`   |
| `BIN`           | Chemin du binaire `llama-cli`              | `./llama/llama.cpp/build/bin/llama-cli` |
| `N_PREDICT`     | Nombre max de tokens générés               | `200`                           |
| `TEMPERATURE`   | Température de génération (`--temp`)       | `0.5`                           |
| `TOP_P`         | Top-p sampling                             | `0.9`                           |
| `REVERSE_PROMPT`| Prompt détectant la fin de réponse         | `"Utilisateur :"`              |

---

## 🎯 Comportement

- Charge un prompt système au lancement pour “orienter” le modèle
- Affiche une invite lisible : `Utilisateur :`
- Génère une réponse propre depuis le modèle local
- Affiche la réponse **dans le terminal** ET la **log dans `logs/`**
- Utilise `tee -a` pour un affichage temps réel

---

## 🗂️ Exemple de structure de projet

```
.
├── scripts/
│   └── chatv2-kortex.sh
├── logs/
│   └── session_14-03_01-07-2025.log
├── llama/
│   ├── llama.cpp/
│   └── models/
│       └── vigogne-2-7b-chat.Q4_K_M.gguf
├── context.txt
├── setup-smkortex.sh
└── README.md
```

---

## 💡 Astuces

- Tu peux créer un alias :
  ```bash
  alias smk='./scripts/chatv2-kortex.sh'
  ```

- Pour tester sans log :
  Supprime ou commente l'appel `tee -a "$LOGFILE"` et laisse seulement `| cat`

- Pour booster les performances :
  Utilise `make -j$(nproc)` à la compilation et augmente `n_threads` dans `llama.cpp`

---

## 🧪 À venir

- Ajout d’une configuration externe (`smk.conf`)
- Commandes internes (`!reset`, `!log off`)
- Mode turbo ou créatif activable à la volée
- Affichage TUI avec `dialog`, `gum`, ou `fzf`

---

💬 En cas de souci, n’oublie pas de vérifier ton prompt, ton modèle et l’option `--temp` selon ta version de `llama-cli`.  
Et surtout : amuse-toi à le faire évoluer 🛠️💚

