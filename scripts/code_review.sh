
#!/bin/bash
set -e

echo "Checking changes against rules in copilot-instructions.md..."
echo ""

# Reattach to terminal for interactive prompts
exec < /dev/tty 2>&1

if [ ! -t 0 ]; then
    echo "⚙️ Non-interactive shell detected. Skipping prompt..."
    exit 1
else
    echo "ℹ️ Interactive shell detected. You will be prompted if issues are found."
fi

# Check if copilot command is available
if ! command -v copilot &> /dev/null; then
    echo "❌ Copilot command not found. Please install GitHub Copilot CLI."
    echo "   You can install it from: https://github.com/github/gh-copilot"
    exit 1
fi

echo "✅ Copilot command found, proceeding with review..."
echo ""

# Run copilot review
review_output=$(copilot -p "review the changes done in the repo as per the rules mentioned in the copilot-instructions.md file. In the report display only the issues found during review." 2>&1)
exit_code=$?

# Display review results
echo "📋 Copilot Review Results:"
echo "=========================="
echo "$review_output"
echo ""

# Check if issues were found
if [ $exit_code -ne 0 ] || echo "$review_output" | grep -qi "error\|warning\|issue\|problem\|violation"; then
    echo "⚠️  Code review found potential issues."
    echo ""
    
    while true; do
        read -p "Do you want to proceed with the commit anyway? (y/N): " yn < /dev/tty
        case $yn in
            [Yy]* )
                echo "✅ Proceeding with commit..."
                exit 0
                ;;
            [Nn]* | "" )
                echo "❌ Commit aborted. Please address the issues and try again."
                exit 1
                ;;
            * )
                echo "Please answer yes (y) or no (n)."
                ;;
        esac
    done
else
    echo "✅ Code review passed! Proceeding with commit..."
    exit 0
fi
