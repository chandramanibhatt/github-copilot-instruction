#!/bin/bash
set -e

COPILOT_REPO="https://github.com/chandramanibhatt/github-copilot-instruction.git"
CACHE_DIR="${HOME}/.cache/github-copilot-instruction"
REPO_ROOT=$(git rev-parse --show-toplevel)

# Clone or pull latest with force fetch
if [ -d "$CACHE_DIR/.git" ]; then
  echo "📥 Fetching latest changes..."
  git -C "$CACHE_DIR" fetch --all --prune
  echo "📥 Resetting to latest..."
  git -C "$CACHE_DIR" reset --hard origin/main
  git -C "$CACHE_DIR" clean -fd
else
  echo "📥 Cloning repository..."
  rm -rf "$CACHE_DIR"
  git clone --depth 1 "$COPILOT_REPO" "$CACHE_DIR"
fi

echo "✅ Repository synced to: $CACHE_DIR"

# Helper function to check if file has meaningful content
has_content() {
  [ -f "$1" ] && [ -s "$1" ] && [ -n "$(grep -v '^[[:space:]]*$' "$1")" ]
}

# 1️⃣ Sync global copilot-instructions.md
TARGET_COPILOT_FILE="$REPO_ROOT/.github/copilot-instructions.md"
SOURCE_COPILOT_FILE="$CACHE_DIR/copilot-instructions.md"

if has_content "$SOURCE_COPILOT_FILE"; then
  mkdir -p "$(dirname "$TARGET_COPILOT_FILE")"
  cp "$SOURCE_COPILOT_FILE" "$TARGET_COPILOT_FILE"
  echo "✅ Updated: $TARGET_COPILOT_FILE"
else
  if [ -f "$TARGET_COPILOT_FILE" ]; then
    rm "$TARGET_COPILOT_FILE"
    echo "🗑️ Deleted: $TARGET_COPILOT_FILE (source not found or empty)"
  else
    echo "⚠️ Source copilot-instructions.md not found or empty. No target created."
  fi
fi

# 2️⃣ Detect language
if [ -f "$REPO_ROOT/pom.xml" ]; then
    LANG="java"
elif [ -f "$REPO_ROOT/requirements.txt" ] || [ -d "$REPO_ROOT/app" ]; then
    LANG="python"
else
    LANG="java"
fi
echo "Detected language: $LANG"

# 3️⃣ Sync AGENTS.md based on language
if [ "$LANG" == "java" ]; then
    echo "📘 Syncing Java AGENTS.md files..."
    BASE_PATH="$REPO_ROOT/webapp/src/main/java/com/cisco/collab/ucmgmt"

    # Common Java rules - place one level above api folder
    API_DIR="$BASE_PATH/api"
    if [ -d "$API_DIR" ]; then
      COMMON_DIR=$(dirname "$API_DIR")
      COMMON_SRC="$CACHE_DIR/AGENTS/java/common/AGENTS.md"
      COMMON_TARGET="$COMMON_DIR/AGENTS.md"
      if has_content "$COMMON_SRC"; then
        cp "$COMMON_SRC" "$COMMON_TARGET"
        echo "✅ $COMMON_TARGET"
      else
        if [ -f "$COMMON_TARGET" ]; then
          rm "$COMMON_TARGET"
          echo "🗑️ Deleted: $COMMON_TARGET (not in remote)"
        fi
      fi
    else
      echo "⚠️ API directory not found, skipping common AGENTS.md"
    fi

    # Layer-specific rules
    for layer in api daos models services utils; do
        LAYER_DIR="$BASE_PATH/$layer"
        if [ -d "$LAYER_DIR" ]; then
          SOURCE="$CACHE_DIR/AGENTS/java/$layer/AGENTS.md"
          TARGET="$LAYER_DIR/AGENTS.md"
          if has_content "$SOURCE"; then
            cp "$SOURCE" "$TARGET"
            echo "✅ $TARGET"
          else
            if [ -f "$TARGET" ]; then
              rm "$TARGET"
              echo "🗑️ Deleted: $TARGET (not in remote)"
            fi
          fi
        else
          echo "⚠️ Directory $LAYER_DIR not found, skipping $layer AGENTS.md"
        fi
    done

elif [ "$LANG" == "python" ]; then
    echo "🐍 Syncing Python AGENTS.md files..."
    BASE_PATH="$REPO_ROOT/app"

    # Common Python rules - place one level above api folder
    API_DIR="$BASE_PATH/api"
    if [ -d "$API_DIR" ]; then
      COMMON_DIR=$(dirname "$API_DIR")
      COMMON_SRC="$CACHE_DIR/AGENTS/python/common/AGENTS.md"
      COMMON_TARGET="$COMMON_DIR/AGENTS.md"
      if has_content "$COMMON_SRC"; then
        cp "$COMMON_SRC" "$COMMON_TARGET"
        echo "✅ $COMMON_TARGET"
      else
        if [ -f "$COMMON_TARGET" ]; then
          rm "$COMMON_TARGET"
          echo "🗑️ Deleted: $COMMON_TARGET (not in remote)"
        fi
      fi
    else
      echo "⚠️ API directory not found, skipping common AGENTS.md"
    fi

    # Layer-specific rules
    for layer in api models services utils; do
        LAYER_DIR="$BASE_PATH/$layer"
        if [ -d "$LAYER_DIR" ]; then
          SOURCE="$CACHE_DIR/AGENTS/python/$layer/AGENTS.md"
          TARGET="$LAYER_DIR/AGENTS.md"
          if has_content "$SOURCE"; then
            cp "$SOURCE" "$TARGET"
            echo "✅ $TARGET"
          else
            if [ -f "$TARGET" ]; then
              rm "$TARGET"
              echo "🗑️ Deleted: $TARGET (not in remote)"
            fi
          fi
        else
          echo "⚠️ Directory $LAYER_DIR not found, skipping $layer AGENTS.md"
        fi
    done
else
    echo "⚠️ Unknown project language. Skipping AGENTS.md sync."
fi

echo "🎉 Copilot files sync complete!"
