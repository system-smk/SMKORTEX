# 📜 Scripts SMKortex

Ce projet utilise deux scripts principaux écrits en Bash. Ils servent d'interface entre l'utilisateur et le modèle LLaMA local, via `llama.cpp`.

---

## 1. `chat-smkortex.sh`

### 🎯 Fonction
Démarre une session IA simple avec prompt système SMKortex intégré.

### 🧪 Comportement
- Utilise un prompt système défini dans le script
- Lance le binaire `llama-cli`
- Enregistre automatiquement les logs dans le dossier `logs/`
- Les réponses sont limitées à 256 tokens

### 🖥️ Utilisation
```bash
./scripts/chat-smkortex.sh
```

---

## 2. `front-smkortex.sh`

### 🎯 Fonction
Interface utilisateur interactive ligne par ligne, avec gestion du contexte et des entrées loguées.

### 🧪 Comportement
- Invite l'utilisateur avec `<|UTILISATEUR|>:`
- Enregistre chaque ligne dans un log de session
- Gère un fichier `context.txt` (mémoire du dialogue)
- Utilise `llama-cli` pour chaque interaction
- Permet de relancer une session où tu l'avais laissée

### 🖥️ Utilisation
```bash
./scripts/front-smkortex.sh
```

---

## 📁 Dossiers utilisés

| Dossier     | Description                                |
|-------------|--------------------------------------------|
| `scripts/`  | Contient les scripts `.sh`                 |
| `models/`   | Contient les fichiers `.gguf` (modèles IA) |
| `logs/`     | Archives des sessions avec horodatage      |
| `llama/llama.cpp/` | Le backend compilé `llama.cpp`       |
| `context.txt` | Conserve l’historique de session courant |

---

## ✨ Astuces

- Tu peux relancer `front-smkortex.sh` et retrouver la mémoire du dialogue via `context.txt`
- Change la valeur de `--n-predict` si tu veux plus ou moins de texte
- Tu peux ajouter des alias dans `.bashrc` pour lancer les scripts plus vite :
```bash
alias smk="./scripts/front-smkortex.sh"
```

---

## 📚 Voir aussi

- [`README.md`](./README.md) pour l’installation complète du projet
- [`MODELES.md`](./MODELES.md) pour trouver un modèle `.gguf` compatible
```



