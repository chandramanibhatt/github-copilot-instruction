#!/bin/bash
set -e

COPILOT_REPO_RAW="https://raw.githubusercontent.com/chandramanibhatt/github-copilot-instruction/main"
REPO_ROOT=$(git rev-parse --show-toplevel)

# 1️⃣ Sync global copilot-instructions.md only if source exists and is not empty
TARGET_COPILOT_FILE="$REPO_ROOT/.github/copilot-instructions.md"
SOURCE_COPILOT_FILE="$COPILOT_REPO_RAW/copilot-instructions.md"
mkdir -p "$(dirname "$TARGET_COPILOT_FILE")"
COPILOT_CONTENT=$(curl -s "$SOURCE_COPILOT_FILE")
if [ -n "$COPILOT_CONTENT" ]; then
  echo "$COPILOT_CONTENT" > "$TARGET_COPILOT_FILE"
  echo "✅ Updated: $TARGET_COPILOT_FILE"
else
  echo "⚠️ Source copilot-instructions.md not found or empty. Skipping."
fi

# 2️⃣ Detect language (Java or Python)
if [ -f "$REPO_ROOT/pom.xml" ]; then
    LANG="java"
elif [ -f "$REPO_ROOT/requirements.txt" ] || [ -d "$REPO_ROOT/app" ]; then
    LANG="python"
else
    LANG="java"
fi
echo "Detected language: $LANG"

# 3️⃣ Sync AGENTS.md based on language, only if source exists and is not empty
if [ "$LANG" == "java" ]; then
    echo "📘 Syncing Java AGENTS.md files..."
    BASE_PATH="$REPO_ROOT/webapp/src/main/java/com/cisco/collab/ucmgmt"
    mkdir -p "$BASE_PATH"

    # Common Java rules
    COMMON_SRC="$COPILOT_REPO_RAW/AGENTS/java/common/AGENTS.md"
    COMMON_TARGET="$BASE_PATH/AGENTS.md"
    COMMON_CONTENT=$(curl -s "$COMMON_SRC")
    if [ -n "$COMMON_CONTENT" ]; then
      echo "$COMMON_CONTENT" > "$COMMON_TARGET"
      echo "✅ $COMMON_TARGET"
    else
      echo "⚠️ $COMMON_SRC not found or empty. Skipping."
    fi

    # Layer-specific rules
    for layer in api daos models services utils; do
        TARGET="$BASE_PATH/$layer/AGENTS.md"
        mkdir -p "$(dirname "$TARGET")"
        SOURCE="$COPILOT_REPO_RAW/AGENTS/java/$layer/AGENTS.md"
        CONTENT=$(curl -s "$SOURCE")
        if [ -n "$CONTENT" ]; then
          echo "$CONTENT" > "$TARGET"
          echo "✅ $TARGET"
        else
          echo "⚠️ $SOURCE not found or empty. Skipping."
        fi
    done

elif [ "$LANG" == "python" ]; then
    echo "🐍 Syncing Python AGENTS.md files..."
    BASE_PATH="$REPO_ROOT/app"
    mkdir -p "$BASE_PATH"

    # Common Python rules
    COMMON_SRC="$COPILOT_REPO_RAW/AGENTS/python/common/AGENTS.md"
    COMMON_TARGET="$BASE_PATH/AGENTS.md"
    COMMON_CONTENT=$(curl -s "$COMMON_SRC")
    if [ -n "$COMMON_CONTENT" ]; then
      echo "$COMMON_CONTENT" > "$COMMON_TARGET"
      echo "✅ $COMMON_TARGET"
    else
      echo "⚠️ $COMMON_SRC not found or empty. Skipping."
    fi

    # Layer-specific rules
    for layer in api models services utils; do
        TARGET="$BASE_PATH/$layer/AGENTS.md"
        mkdir -p "$(dirname "$TARGET")"
        SOURCE="$COPILOT_REPO_RAW/AGENTS/python/$layer/AGENTS.md"
        CONTENT=$(curl -s "$SOURCE")
        if [ -n "$CONTENT" ]; then
          echo "$CONTENT" > "$TARGET"
          echo "✅ $TARGET"
        else
          echo "⚠️ $SOURCE not found or empty. Skipping."
        fi
    done
else
    echo "⚠️ Unknown project language. Skipping AGENTS.md sync."
fi

echo "🎉 Copilot files sync complete!"
