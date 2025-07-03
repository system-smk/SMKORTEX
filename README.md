

## ✨ Exemple de plan révisé pour `README.md`

# 🤖 SMKortex — Assistant IA local en français

Bienvenue dans ton assistant IA 100 % local, propulsé par `llama.cpp` + Vigogne 2.  
Aucune connexion requise après installation. Juste toi, ton terminal, et ton copilote 🧠✨

---

## 🚦 Étapes d’installation

### ✅ Étape 1 — Lancer le script d’installation

```bash
./setup-smkortex.sh
```

Ce script va :

- 📁 Créer les répertoires (`scripts/`, `logs/`, `llama/models/`, etc.)
- 📦 Télécharger et compiler `llama.cpp`
- 🧠 Télécharger le modèle `vigogne-2-7b-chat.Q4_K_M.gguf` (~3.9 Go)
- 🧾 Installer les scripts dans `scripts/`

---

## 🧱 Étape 2 — Vérification de l’arborescence attendue

Avant de lancer le modèle, vérifie cette structure minimale :

```
SMKORTEX/
├── setup-smkortex.sh
├── scripts/
│   └── chatv2-kortex.sh
├── llama/
│   ├── llama.cpp/             ← Cloné automatiquement
│   │   └── build/bin/llama-cli ← Binaire compilé
│   └── models/
│       └── vigogne-2-7b-chat.Q4_K_M.gguf
├── logs/
├── context.txt (optionnel)
└── README.md / SCRIPTS.md
```

> ✅ Vérifie que le modèle `.gguf` est bien dans `llama/models/`  
> ✅ Vérifie que le script `chatv2-kortex.sh` pointe vers les bons chemins dans `MODEL` et `BIN`

---

## 🚀 Étape 3 — Lancer SMKortex

Une fois l’installation et la structure vérifiées :

```bash
./scripts/chatv2-kortex.sh
```

Tu peux maintenant dialoguer avec SMKortex directement depuis ton terminal.

---

## 🧠 En cas d’erreur (checklist rapide)

| Problème détecté                      | Vérifie…                            |
|--------------------------------------|-------------------------------------|
| `invalid argument: --temperature`    | → utilise `--temp` à la place       |
| `model not found`                    | → chemin `MODEL=./llama/models/...` |
| `llama-cli: command not found`       | → `make` lancé dans `llama.cpp/`    |
| Pas de réponse générée               | → prompt mal formé ou `tee -a` manquant |
| Fichier modèle fait quelques Ko      | → téléchargement incomplet, à refaire |

---

💚 _SMKortex est prêt quand toi tu l’es_  
_Créé avec Copilot, soin et passion par Mathieu-Karim_




