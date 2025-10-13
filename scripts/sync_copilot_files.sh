#!/bin/bash
set -e
echo "🔄 Syncing Copilot files from  test-------1111."
#exit 1
# ----------------------------
# Central Copilot repo URL
# ----------------------------
COPILOT_REPO="https://raw.githubusercontent.com/<org>/github-copilot-instruction/main"
REPO_ROOT=$(git rev-parse --show-toplevel)

echo "🔄 Syncing Copilot files from $COPILOT_REPO..."

# ----------------------------
# 1️⃣ Sync global copilot-instructions.md
# ----------------------------
TARGET_COPILOT_FILE="$REPO_ROOT/.github/copilot-instructions.md"
mkdir -p "$(dirname "$TARGET_COPILOT_FILE")"
curl -s -o "$TARGET_COPILOT_FILE" "$COPILOT_REPO/copilot-instructions.md"
echo "✅ Updated: $TARGET_COPILOT_FILE"

# ----------------------------
# 2️⃣ Detect language (Java or Python)
# ----------------------------
if [ -f "$REPO_ROOT/pom.xml" ]; then
    LANG="java"
elif [ -f "$REPO_ROOT/requirements.txt" ] || [ -d "$REPO_ROOT/app" ]; then
    LANG="python"
else
    LANG="unknown"
fi
echo "Detected language: $LANG"

# ----------------------------
# 3️⃣ Sync AGENTS.md based on language
# ----------------------------
if [ "$LANG" == "java" ]; then
    echo "📘 Syncing Java AGENTS.md files..."
    BASE_PATH="$REPO_ROOT/webapp/src/main/java/com/cisco/collab/ucmgmt"
    mkdir -p "$BASE_PATH"

    # Global Java rules
    curl -s -o "$BASE_PATH/AGENTS.md" "$COPILOT_REPO/java/AGENTS.md"
    echo "✅ $BASE_PATH/AGENTS.md"

    # Layer-specific rules
    for layer in api daos models services utils; do
        TARGET="$BASE_PATH/$layer/AGENTS.md"
        mkdir -p "$(dirname "$TARGET")"
        SOURCE="$COPILOT_REPO/java/$layer/AGENTS.md"
        if curl --output /dev/null --silent --head --fail "$SOURCE"; then
            curl -s -o "$TARGET" "$SOURCE"
            echo "✅ $TARGET"
        fi
    done

elif [ "$LANG" == "python" ]; then
    echo "🐍 Syncing Python AGENTS.md files..."
    BASE_PATH="$REPO_ROOT/app"
    mkdir -p "$BASE_PATH"

    # Common Python rules
    curl -s -o "$BASE_PATH/AGENTS.md" "$COPILOT_REPO/python/common/AGENTS.md"
    echo "✅ $BASE_PATH/AGENTS.md"

    # Layer-specific rules
    for layer in api models services utils; do
        TARGET="$BASE_PATH/$layer/AGENTS.md"
        mkdir -p "$(dirname "$TARGET")"
        SOURCE="$COPILOT_REPO/python/$layer/AGENTS.md"
        if curl --output /dev/null --silent --head --fail "$SOURCE"; then
            curl -s -o "$TARGET" "$SOURCE"
            echo "✅ $TARGET"
        fi
    done
else
    echo "⚠️ Unknown project language. Skipping AGENTS.md sync."
fi

echo "🎉 Copilot files sync complete!"
