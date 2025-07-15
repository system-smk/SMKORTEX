#!/bin/bash

echo -e "\n🔗 Création du lanceur WebUI : webkortex"

cat > ~/.local/bin/webkortex <<'EOF'
#!/bin/bash
cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/../../webui
node server.js
EOF

chmod +x ~/.local/bin/webkortex

# Vérifie que ~/.local/bin est bien dans le PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
fi

echo "✅ Lanceur WebUI créé ➤ tape : webkortex"
