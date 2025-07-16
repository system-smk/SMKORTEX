ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"

cat > "$HOME/.local/bin/smkortex" <<EOF
#!/bin/bash
ROOTDIR="$ROOTDIR"
bash "\$ROOTDIR/scripts/instChatv2-kortex.sh" "\$@"
EOF

chmod +x "$HOME/.local/bin/smkortex"


