#!/bin/bash
# sync_ce_to_docs.sh - Sync Context Engineering files from ApiLogicServer-src to Docs
#
# Purpose: Pull CE files for AI-assisted evaluation (Eval.md workflow)
# Source: org_git/ApiLogicServer-src/prototypes/base/
# Target: org_git/Docs/docs/Eval-*.md
#
# Run: ./sync_ce_to_docs.sh (from Docs root)

set -e  # Exit on error

# Paths
SOURCE_BASE="$HOME/dev/ApiLogicServer/ApiLogicServer-dev/org_git/ApiLogicServer-src/api_logic_server_cli/prototypes/base"
DOCS_DIR="$HOME/dev/ApiLogicServer/ApiLogicServer-dev/org_git/Docs/docs"

echo " "
echo "Sync Context Engineering (CE) files to Docs for AI-assisted evaluation"
echo " "
echo "This will:"
echo "  1. Copy bootstrap: .github/.copilot-instructions.md → Eval-copilot-instructions.md"
echo "  2. Copy 12 training files: docs/training/*.md → Eval-*.md"
echo "  3. Transform references: docs/training/*.md → Eval-*.md"
echo " "
echo "Source: $SOURCE_BASE"
echo "Target: $DOCS_DIR"
echo " "
read -p "Continue? (Ctrl-C to abort) > "
echo " "

# 1. Copy and rename bootstrap
echo "Copying bootstrap..."
cp "$SOURCE_BASE/.github/.copilot-instructions.md" "$DOCS_DIR/Eval-copilot-instructions.md"

# 2. Copy and rename training files (explicit list)
echo "Copying training files..."
cp "$SOURCE_BASE/docs/training/logic_bank_patterns.md" "$DOCS_DIR/Eval-logic_bank_patterns.md"
cp "$SOURCE_BASE/docs/training/logic_bank_api.md" "$DOCS_DIR/Eval-logic_bank_api.md"
cp "$SOURCE_BASE/docs/training/probabilistic_logic.md" "$DOCS_DIR/Eval-probabilistic_logic.md"
cp "$SOURCE_BASE/docs/training/testing.md" "$DOCS_DIR/Eval-testing.md"
cp "$SOURCE_BASE/docs/training/MCP_Copilot_Integration.md" "$DOCS_DIR/Eval-MCP_Copilot_Integration.md"
cp "$SOURCE_BASE/docs/training/genai_logic_patterns.md" "$DOCS_DIR/Eval-genai_logic_patterns.md"
cp "$SOURCE_BASE/docs/training/probabilistic_logic_guide.md" "$DOCS_DIR/Eval-probabilistic_logic_guide.md"
cp "$SOURCE_BASE/docs/training/admin_app_1_context.prompt.md" "$DOCS_DIR/Eval-admin_app_1_context.prompt.md"
cp "$SOURCE_BASE/docs/training/admin_app_2_functionality.prompt.md" "$DOCS_DIR/Eval-admin_app_2_functionality.prompt.md"
cp "$SOURCE_BASE/docs/training/admin_app_3_architecture.prompt.md" "$DOCS_DIR/Eval-admin_app_3_architecture.prompt.md"
cp "$SOURCE_BASE/docs/training/react_map.prompt.md" "$DOCS_DIR/Eval-react_map.prompt.md"
cp "$SOURCE_BASE/docs/training/react_tree.prompt.md" "$DOCS_DIR/Eval-react_tree.prompt.md"

# 3. Transform references in bootstrap (docs/training/*.md → Eval-*.md)
echo "Transforming references in bootstrap..."
sed -i '' 's|docs/training/\([^.]*\)\.md|Eval-\1.md|g' "$DOCS_DIR/Eval-copilot-instructions.md"

# 4. Verify
echo ""
echo "✅ Sync complete!"
echo ""
echo "Files created in $DOCS_DIR:"
ls -1 "$DOCS_DIR"/Eval-*.md | wc -l | xargs echo "  Total Eval-*.md files:"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff docs/"
echo "  2. Test: Open Docs in VS Code, load Eval-copilot-instructions.md"
echo "  3. Commit: git add docs/Eval-*.md && git commit -m 'Update CE files'"
